//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Александр Гарипов on 08.01.2023.
//

import Foundation


struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}
