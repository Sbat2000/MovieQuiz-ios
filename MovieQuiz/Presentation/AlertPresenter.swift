//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Гарипов on 13.02.2023.
//

import UIKit

final class AlertPresenter {
    
    weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
    }
    
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {_ in
            alertModel.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
        alert.view.accessibilityIdentifier = "Result alert"
    }
}
