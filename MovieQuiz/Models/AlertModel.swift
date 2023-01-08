//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Гарипов on 07.01.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> ()
}