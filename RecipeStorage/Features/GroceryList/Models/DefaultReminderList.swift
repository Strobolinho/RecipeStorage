//
//  DefaultReminderList.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 13.02.26.
//

import Foundation
import SwiftData

@Model
final class DefaultReminderList {
    // optional: feste ID, damit du “genau eins” hast
    var key: String = "singleton"
    var listID: String = ""

    init(key: String = "singleton", listID: String = "") {
        self.key = key
        self.listID = listID
    }
}
