//
//  TaskModel.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 3.12.24.
//

import Foundation

struct TaskModel : Codable, Equatable {
    var task : String?
    var title : String?
    var description : String?
    var colorCode : String?
}
