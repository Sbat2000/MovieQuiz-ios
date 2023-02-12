import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizProtocolDelegate {

    // MARK: - Lifecycle
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
//    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        presenter = MovieQuizPresenter(viewCotroller: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        
    }
    
    // MARK: - MovieQuizProtocolDelegate
    
    func presentAlert(alert: UIAlertController) {
        present(alert,animated: true, completion: nil)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        
    }
    

    
    func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
 
            self.presenter.showNextQuestionOrResults()
        }
    }

    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultMessage()
        
        let alertModel = AlertModel(title: result.title, message: message, buttonText: result.buttonText) {[weak self] in
            guard let self = self else {return}
            
            self.presenter.restartGame()
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 00
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
        alertPresenter.showAlert(alertModel: alertModel)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            
            self.presenter.restartGame()
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 00
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
        
        alertPresenter.showAlert(alertModel: model)
    }
    
    @IBAction private func nuButtoneClicked(_ sender: UIButton) {
        presenter.nuButtoneClicked()
//        noButton.isEnabled = false
//        yesButton.isEnabled = false
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
//        yesButton.isEnabled = false
//        noButton.isEnabled = false
    }
}

