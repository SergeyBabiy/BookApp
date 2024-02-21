//
//  TapticEngineManager.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift
import AVFoundation

final class TapticEngineManager {
    static let shared = TapticEngineManager()
    private let notificationFeedBack = UINotificationFeedbackGenerator()
    
    private init() {}
    
    func toggle(delay: Double = 0, notificationType: UINotificationFeedbackGenerator.FeedbackType = .warning) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {[weak self] in
            self?.notificationFeedBack.notificationOccurred(notificationType)
        }
    }
    
    
    func toggle(delay: Double = 0, notificationType: UINotificationFeedbackGenerator.FeedbackType = .warning) -> Completable {
        return Completable.create { (completable) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {[weak self] in
                if UIDevice().screenType == .iPhone5 {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                } else {
                self?.notificationFeedBack.notificationOccurred(notificationType)
                }
                completable(.completed)
            }
            return Disposables.create()
        }
    }
    
    func toggleButtonVibration(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func toggleVibration(style: UIImpactFeedbackGenerator.FeedbackStyle) -> Completable {
        return Completable.create { (completable) -> Disposable in
            DispatchQueue.main.async {
                if UIDevice().screenType == .iPhone5 {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                } else {
                    let generator = UIImpactFeedbackGenerator(style: style)
                    generator.impactOccurred()
                }
                
                completable(.completed)
            }
            return Disposables.create()
        }
    }
}

