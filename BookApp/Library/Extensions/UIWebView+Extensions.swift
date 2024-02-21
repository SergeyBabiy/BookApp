//
//  import WebKit.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import WebKit

extension WKWebView {
    func clean() {
        guard #available(iOS 9.0, *) else {return}

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("WKWebsiteDataStore record deleted:", record)
            }
        }
    }
}

