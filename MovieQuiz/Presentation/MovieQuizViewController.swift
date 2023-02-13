import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, MovieQuizProtocolDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    
    private lazy var presenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
    }
    
    // MARK: - MovieQuizProtocolDelegate
    
    func presentAlert(alert: UIAlertController) {
        self.present(alert,animated: true, completion: nil)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        if isCorrect == true {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
            correctAnswer += 1
        } else { imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // показать результат квиза
            let text = "Ваш  результат: \(correctAnswer)/10"
            let viewModel = QuizResultsViewModel (title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
            
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            // показать следующий вопрос
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 0
            noButton.isEnabled = true
            yesButton.isEnabled = true
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        statisticService?.store(correct: correctAnswer, total: questionsAmount)
        let totalQuizCount = statisticService?.gamesCount ?? 0
        let recordCorrectAnswer = statisticService?.bestGame.correct ?? 0
        let recordTotalAnsweer = statisticService?.bestGame.total ?? 0
        let totalAccuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? 0)
        let date = statisticService?.bestGame.date ?? Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.YY HH:mm"
        let dateFormated = dateFormater.string(from: date)
        let alertModel = AlertModel(title: result.title, message: ("\(result.text) \n Количество сыгранных квизов: \(totalQuizCount) \n Рекорд: \(recordCorrectAnswer)/\(recordTotalAnsweer) (\(dateFormated)) \n Средняя точность: \(totalAccuracy)%") , buttonText: result.buttonText) {[weak self] in
            guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 00
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.questionFactory?.requestNextQuestion()
        }
        presenter.showAlert(alertModel: alertModel)
    }
    
    @IBAction private func nuButtoneClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
}

