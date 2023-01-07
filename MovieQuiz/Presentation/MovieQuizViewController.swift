import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var allowAnswer: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
        
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
          let text = "Ваш раунд результат: \(correctAnswer) из 10"
          let viewModel = QuizResultsViewModel (title: "Этот раунд окончен", text: text, buttonText: "Сыграть еще раз")
          show(quiz: viewModel)
          
      } else {
        currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
        // показать следующий вопрос
          imageView.layer.masksToBounds = true
          imageView.layer.borderWidth = 0
          allowAnswer = true
          
          self.questionFactory?.requestNextQuestion()
      }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
            
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default) {[weak self]_ in
                guard let self = self else {return}
                
                self.currentQuestionIndex = 0
                self.correctAnswer = 0
                self.imageView.layer.masksToBounds = true
                self.imageView.layer.borderWidth = 0
                self.allowAnswer = true
                
                self.questionFactory?.requestNextQuestion()
            }
        alert.addAction(action)
        
        self.present(alert,animated: true, completion: nil)
    }
    
    @IBAction private func nuButtoneClicked(_ sender: UIButton) {
        if allowAnswer == true {
            guard let currentQuestion = currentQuestion else {return}
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            allowAnswer = false
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if allowAnswer == true {
            guard let currentQuestion = currentQuestion else {return}
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            allowAnswer = false
        }
    }
}
