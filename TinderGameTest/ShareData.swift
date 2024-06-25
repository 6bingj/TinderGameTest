//
//  ShareData.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/25/24.
//

import UIKit

class ShareData {
    fileprivate let rest = RestManager()
    fileprivate func getDeviceInfo() -> String {
        return """
Device Type: \(UIDevice.modelName.components(separatedBy: " "))
App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0")
iOS Version: \(UIDevice.current.systemVersion)
Language: \(Locale.current.languageCode ?? "")
Timezone: \(TimeZone.current.abbreviation() ?? "")
"""
    }
    
    func shareOnTrello() {
 
        let filename = URL(string: "https://picsum.photos/200/300")
        let fileInfo = RestManager.FileInfo(withFileURL: filename, filename: "image.png", name: "fileSource", mimetype: "text/plain")

                rest.httpBodyParameters.add(value: "f5e3cfd1d9351f1ba6455066546acde3", forKey: "key")
                rest.httpBodyParameters.add(value: "271ad62919d8c81f51b3d3b591545532c07a30fb60f658f631917a848a14216f", forKey: "token")
                rest.httpBodyParameters.add(value: "6175cd54e8dbbc4004046b9e", forKey: "idList")
                rest.httpBodyParameters.add(value: "TinderDemo Launched", forKey: "name")
                rest.httpBodyParameters.add(value: getDeviceInfo(), forKey: "desc")

        rest.upload(files: [fileInfo], toURL: URL(string: "https://api.trello.com/1/cards")!, withHttpMethod: .post) { (_, _) in
            print("SHARE ON TRELLO")
        }
    }
}
