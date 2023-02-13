import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol  {

    // MARK: - Lifecycle
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }

    func highlightImageBorder(isCorrectAnswer isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
    }

    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) {[weak self] in
            guard let self = self else {return}
            
            self.presenter.restartGame()
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 00
            self.buttonsEnabled()
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
            self.buttonsEnabled()
        }
        
        alertPresenter.showAlert(alertModel: model)
    }
    
    @IBAction private func nuButtoneClicked(_ sender: UIButton) {
        presenter.nuButtoneClicked()
        buttonsDisabled()

    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        buttonsDisabled()
        

    }
    
    func buttonsDisabled() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func buttonsEnabled() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
}

