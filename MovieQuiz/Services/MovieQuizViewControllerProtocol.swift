//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Александр Гарипов on 12.02.2023.
//

import UIKit

protocol MovieQuizViewControllerProtocol: UIViewController, AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func buttonsEnabled()
    
} 
