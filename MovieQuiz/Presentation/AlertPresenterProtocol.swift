//
//  AlertPresenter.swift
//  MovieQuiz
//


import Foundation

protocol AlertPresenterProtocol {
    func showAlert (alertModel: AlertModel) -> Void
    var delegate: MovieQuizProtocolDelegate? {get}
}
