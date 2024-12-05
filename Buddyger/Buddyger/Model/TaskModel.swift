//
//  TaskModel.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 3.12.24.
//

import Foundation

struct TaskModel : Codable {
    
    var task : String?
    var title : String?
    var descriptionTask : String?
    var colorCode : String?
    
    enum CodingKeys: String, CodingKey {
        case task
        case title
        case descriptionTask = "description"
        case colorCode
    }
}
