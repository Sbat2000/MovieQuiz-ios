//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Гарипов on 07.01.2023.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: MovieQuizProtocolDelegate?
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
            
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {_ in
            alertModel.completion()
        }
        alert.addAction(action)
        delegate?.presentAlert(alert: alert)
    }
    
    init (delegate: MovieQuizProtocolDelegate) {
        self.delegate = delegate
    }
    
}

