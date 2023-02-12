

import UIKit


final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticsService: StatisticService!
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    
    init(viewCotroller: MovieQuizViewController) {
        self.viewController = viewCotroller
        
        statisticsService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewCotroller.showLoadingIndicator()
    }
    
    //MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    //MARK: - methods
    
    func makeResultMessage() -> String {
        statisticsService.store(correct: correctAnswers, total: questionsAmount)
        let bestGame = statisticsService.bestGame
        
        let totalPLaysCountLine = "Количество сыгранных квизов: \(statisticsService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total)" + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticsService.totalAccuracy))%"
        
        
        let resultMessage = [currentGameResultLine, totalPLaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        
        return resultMessage
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
    }
    

    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            // показать результат квиза
            let text = "Ваш  результат: \(correctAnswers)/\(questionsAmount)"
            let viewModel = QuizResultsViewModel (title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            viewController?.show(quiz: viewModel)
            
        } else {
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func nuButtoneClicked() {
        didAnswer(isYes: false)
    }
}
    

