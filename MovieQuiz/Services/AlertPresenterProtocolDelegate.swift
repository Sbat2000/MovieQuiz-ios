//
//  AlertPresenterProtocolDelegate.swift
//  MovieQuiz
//
//  Created by Александр Гарипов on 14.02.2023.
//

import UIKit

protocol AlertPresenterProtocolDelegate: AnyObject {
    func presentAlert(alert: UIAlertController)
}
