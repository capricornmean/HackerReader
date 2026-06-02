//
//  ContainerConstruction.swift
//  HackerReader
//
//  Created by mai on 6/2/26.
//

import Foundation
import SwiftData

struct ContainerConstruction {
    static func getModelConfiguration() -> ModelConfiguration {
        guard let baseURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mai.HackerReader") else {
            fatalError("Entitlement isn't applied")
        }
        let fileURL = baseURL.appending(path: "HackerReader.sqlite")
        return ModelConfiguration(url: fileURL)
    }
}
