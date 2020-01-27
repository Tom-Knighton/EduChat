//
//  FeedCreateQuizQuestionController.swift
//  EduChat
//
//  Created by Tom Knighton on 21/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class FeedCreateQuizQuestionController: UITableViewController {
    
    @IBOutlet weak var questionTitleField: UITextField!
    @IBOutlet weak var correctAnswerField: UITextField!
    @IBOutlet weak var answer2Field: UITextField!
    @IBOutlet weak var answer3Field: UITextField!
    @IBOutlet weak var answer4Field: UITextField!
    @IBOutlet weak var difficultyField: UITextField!
    
    var questionDifficulties = ["Easy", "Medium", "Hard", "Extreme"]
    var currentQuestion : FeedQuizQuestion?
    var delegate : FeedQuizUpdater?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createDifficultyPicker(); self.dismissPickerView()
        self.endEditingWhenViewTapped()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Question", style: .plain, target: self, action: #selector(addQuestion(_:)))
        if currentQuestion != nil { loadValues(); }
    }
    
    
    
    @objc func addQuestion(_ sender: UIBarButtonItem) { //when addQuestion button tapped
        let question = questionTitleField.text?.trim() ?? "" // < And below get values of fields
        let correctAnswer = correctAnswerField.text?.trim() ?? ""
        let answer2 = answer2Field.text?.trim() ?? ""
        let answer3 = answer3Field.text?.trim() ?? ""
        let answer4 = answer4Field.text?.trim() ?? ""
        let difficulty = difficultyField.text?.trim() ?? ""
        
        if (question == "" || correctAnswer == "" || difficulty == "") { //IF anything not present, show error
            self.displayBasicError(title: "Error", message: "Please fill out all required fields (Title, Correct Answer, Difficulty)")
            return;
        }
        if currentQuestion == nil { //IF we are making a new question
            let questionObject = FeedQuizQuestion(QuestionId: UUID().hashValue, PostId: 1, Answers: [correctAnswer, answer2, answer3, answer4], CorrectAnswer: correctAnswer, Question: question, Difficulty: 1) //Create new Question object
            if difficulty == "Easy" { questionObject?.DifficultyLevel = 1 } //Change difficulty to selected one
            else if difficulty == "Medium" { questionObject?.DifficultyLevel = 2 }
            else if difficulty == "Hard" { questionObject?.DifficultyLevel = 3 }
            delegate?.addQuestion(question: questionObject) //Call addQuestion delegate method
            self.navigationController?.popViewController(animated: true) //pop controller
        }
        else { //If we are editing question
            currentQuestion?.Question = question //Set the old question values to our new ones
            currentQuestion?.CorrectAnswer = correctAnswer
            currentQuestion?.Answers = [correctAnswer, answer2, answer3, answer4]
            if difficulty == "Easy" { currentQuestion?.DifficultyLevel = 1 }
            else if difficulty == "Medium" { currentQuestion?.DifficultyLevel = 2 }
            else if difficulty == "Hard" { currentQuestion?.DifficultyLevel = 3 }
            delegate?.updateQuestion(question: currentQuestion) //Call updateQuestion delegate method and pop controller
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loadValues() {
        self.questionTitleField.text = currentQuestion?.Question ?? ""
        self.correctAnswerField.text = currentQuestion?.CorrectAnswer ?? ""
        self.answer2Field.text = currentQuestion?.Answers?[1] ?? ""
        self.answer3Field.text = currentQuestion?.Answers?[2] ?? ""
        self.answer4Field.text = currentQuestion?.Answers?[3] ?? ""
        self.difficultyField.text = currentQuestion?.DifficultyString ?? ""
    }

}

extension FeedCreateQuizQuestionController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func createDifficultyPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.difficultyField.inputView = pickerView
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.questionDifficulties.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.questionDifficulties[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.difficultyField.text = self.questionDifficulties[row]
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.difficultyField.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }
    
}
