//
//  FeedCreateQuizController.swift
//  EduChat
//
//  Created by Tom Knighton on 21/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

protocol FeedQuizUpdater {
    func addQuestion(question: FeedQuizQuestion?)
    func removeQuestion(question: FeedQuizQuestion?)
    func updateQuestion(question: FeedQuizQuestion?)
}
class FeedCreateQuizController: UIViewController {

    @IBOutlet weak var quizTitleField: UITextField!
    @IBOutlet weak var quizDifficultyField: UITextField!
    @IBOutlet weak var questionsTable: UITableView!
    @IBOutlet weak var questionsCountLabel: UILabel!
    var selectedSubject = 1
    
    var difficulties = ["Very Easy", "Easy", "Medium", "Hard-ish", "Hard", "Very Hard", "Extreme"]
    var addedQuestions : [FeedQuizQuestion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createDifficultyPicker(); self.dismissPickerView()
        self.endEditingWhenViewTapped()
        self.questionsTable.delegate = self; self.questionsTable.dataSource = self;
    }
   
    @IBAction func createQuizPressed(_ sender: UIButton) {
        let quizTitle = self.quizTitleField.text?.trim() ?? "" //Gets the title field text
        let quizDifficulty = self.quizDifficultyField.text?.trim() ?? "" //Gets difficulty field text
        let quizQuestions = self.addedQuestions //Gets questions array
        if (quizTitle == "" || quizDifficulty == "" || quizQuestions.count <= 0) { self.displayBasicError(title: "Error", message: "Please enter a title, difficulty and at least one question"); return; } //If not all filled in, show error
        self.lockAndDisplayActivityIndicator(enable: true) //Lock display
        let quiz = FeedQuiz(PostId: 0, PosterId: EduChat.currentUser?.UserId ?? 0, SubjectId: self.selectedSubject, PostType: "quiz", DatePosted: Date().toString(), IsAnnouncement: false, IsDeleted: false, quizTitle: quizTitle, difficulty: quizDifficulty)
        quiz?.Questions = quizQuestions
        //^ Create FeedQuiz object and add questions
        FeedMethods.UploadQuiz(quiz: quiz!) { (returnQuiz) in //Call uploadQuiz API method
            if returnQuiz != nil { self.navigationController?.popViewController(animated: true) } //if something was returned, pop controller
            else { self.displayBasicError(title: "Error", message: "An error occurred uploading this poll") }
            //^ Else, display error
            self.lockAndDisplayActivityIndicator(enable: false) //UNlock view
        }
    }

}

extension FeedCreateQuizController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addedQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = self.addedQuestions[indexPath.row]
        let cell = self.questionsTable.dequeueReusableCell(withIdentifier: "quizAddQuestionCell", for: indexPath)
        cell.textLabel?.text = question.Question ?? ""
        cell.detailTextLabel?.text = question.CorrectAnswer ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            let q = self.addedQuestions[indexPath.row]
            self.removeQuestion(question: q)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedQuizAddQuestion") as? FeedCreateQuizQuestionController else { return; }
            vc.currentQuestion = self.addedQuestions[indexPath.row]
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        edit.backgroundColor = .flatBlue
        return [remove, edit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedQuizAddQuestion") as? FeedCreateQuizQuestionController else { return; }
        vc.currentQuestion = self.addedQuestions[indexPath.row]
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedCreateQuizController : FeedQuizUpdater {
    func addQuestion(question: FeedQuizQuestion?) {// onAddQuestion
        if question != nil { self.addedQuestions.append(question!) }
        //^ If an object was passed, add it to table
        self.questionsTable.reloadData() //Reload table
        self.questionsCountLabel.text = "Questions: (\(self.addedQuestions.count))"
        //^ Update question counter label
    }
    //Same below but for remove() and update()
    func removeQuestion(question: FeedQuizQuestion?) {
        if question != nil { self.addedQuestions.removeAll(where: {$0.QuestionId == question?.QuestionId})}
        self.questionsTable.reloadData()
        self.questionsCountLabel.text = "Questions: (\(self.addedQuestions.count))"
    }
    
    func updateQuestion(question: FeedQuizQuestion?) {
        if question != nil {
            let index = self.addedQuestions.firstIndex(where: {$0.QuestionId == question?.QuestionId}) ?? 0
            self.addedQuestions[index] = question!
            self.questionsTable.reloadData()
            self.questionsCountLabel.text = "Questions: (\(self.addedQuestions.count))"
        }
    }
    
    @IBAction func addQuizQuestion(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedQuizAddQuestion") as? FeedCreateQuizQuestionController else { return; }
        vc.currentQuestion = nil
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedCreateQuizController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func createDifficultyPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.quizDifficultyField.inputView = pickerView
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.difficulties.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.difficulties[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.quizDifficultyField.text = self.difficulties[row]
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.quizDifficultyField.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }
    
}
