//
//  PermissionManager.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Photos
import CoreLocation
import UIKit

typealias PermissionCompletion = (AuthorizationStatus) -> Void

enum AuthorizationStatus {
    case authorized
    case notAuthorized
}

enum LocationUsage {
    case whenInUse
    case always
}

class PermissionManager: NSObject {

    fileprivate lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self

        return locationManager
    }()

    fileprivate var locationCompletion: PermissionCompletion?

    fileprivate var permissionManager: PermissionManager?

    fileprivate lazy var toSettingAction: ()->Void = {
        return {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
    }()

    var isMicrophoneGranted: Bool {
        return AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.granted
    }

    func requestCameraPermission(with completion: PermissionCompletion?) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            self.p_requestCameraPermission(with: completion)
        } else {
            DispatchQueue.main.async {
                self.showNoCameraAlert()
                completion?(.notAuthorized)
            }
        }
    }

    func requestGaleryPermission(with completion: PermissionCompletion?) {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
            case .denied, .restricted:
                DispatchQueue.main.async {

                    AlertManager.alertOK(title: nil,
                                       message: "Please allow pesmission for gallety.",
                                       completion: self.toSettingAction)
                    completion?(.notAuthorized)
                }
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    DispatchQueue.main.async {
                        let authoriationStatus: AuthorizationStatus = status == .authorized ? .authorized : .notAuthorized
                        completion?(authoriationStatus)
                    }
                }
            case .authorized:
                DispatchQueue.main.async {
                    completion?(.authorized)
                }
                
            default: print("PermissionManager: permission status \(status)")
        }
    }

    func requestLocationPermission(with locationUsage: LocationUsage, completion: @escaping PermissionCompletion) {
        self.permissionManager = self
        self.locationCompletion = completion
        let status = CLLocationManager.authorizationStatus()

        switch status {
            case .denied, .restricted:
                DispatchQueue.main.async {
                    AlertManager.alertOK(title: nil,
                                       message: "Please allow pesmission for location.",
                                       completion: self.toSettingAction)
                    self.callLocationCompletion(with: .notAuthorized)
                }
            case .notDetermined:
                self.requestLocationPermision(with: locationUsage)
                
            case .authorizedAlways, .authorizedWhenInUse:
                DispatchQueue.main.async {
                    self.callLocationCompletion(with: .authorized)
                }
                
            default: print("PermissionManager: permission status \(status)")
        }
    }

    func requestMicrophonePermission(with completion: PermissionCompletion?) {
        let session = AVAudioSession.sharedInstance()

        let status = session.recordPermission

        switch status {
        case AVAudioSession.RecordPermission.granted:
                DispatchQueue.main.async {
                    completion?(.authorized)
                }
                
        case AVAudioSession.RecordPermission.denied:
                DispatchQueue.main.async {
                    AlertManager.alertOK(title: nil,
                                       message: "Please allow pesmission for microphone.",
                                       completion: self.toSettingAction)
                    completion?(.notAuthorized)
                }
                
        case AVAudioSession.RecordPermission.undetermined:
                session.requestRecordPermission { (result) in
                    DispatchQueue.main.async {
                        let authorizationStatis: AuthorizationStatus = result ? .authorized : .notAuthorized
                        completion?(authorizationStatis)
                    }
                }
                
            default: print("PermissionManager: permission status \(status)")
        }
    }

}

// MARK: Private methods
fileprivate extension PermissionManager {

    func p_requestCameraPermission(with completion: PermissionCompletion?) {
        let mediaType = AVMediaType.video

        let status = AVCaptureDevice.authorizationStatus(for: mediaType)

        switch status {
            case .denied, .restricted:
                DispatchQueue.main.async {
                    AlertManager.alertOK(title: nil,
                                       message: "Please allow pesmission for camera.",
                                       completion: self.toSettingAction)
                    completion?(.notAuthorized)
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: mediaType) { (result) in
                    DispatchQueue.main.async {
                        let status: AuthorizationStatus = result ? .authorized : .notAuthorized
                        completion?(status)
                    }
                }
            case .authorized:
                DispatchQueue.main.async {
                    completion?(.authorized)
                }
                
            default: print("PermissionManager: permission status \(status)")
        }
    }

    func showNoCameraAlert() {

        AlertManager.alertOK(title: "No camera", message: "Sorry, this device has no camera.", completion: nil)
    }

    func requestLocationPermision(with locationUsage: LocationUsage) {
        switch locationUsage {
        case .always:
            self.locationManager.requestAlwaysAuthorization()
        case .whenInUse:
            self.locationManager.requestWhenInUseAuthorization()
        }
    }

    func callLocationCompletion(with status: AuthorizationStatus) {
        self.locationCompletion?(status)
        self.locationCompletion = nil
        self.permissionManager = nil
    }

}

// MARK: CLLocationManagerDelegate
extension PermissionManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            DispatchQueue.main.async {
                let authorizationStatus: AuthorizationStatus = status == .authorizedWhenInUse || status == .authorizedAlways ? .authorized : .notAuthorized

                self.callLocationCompletion(with: authorizationStatus)
            }
        }
    }

}

