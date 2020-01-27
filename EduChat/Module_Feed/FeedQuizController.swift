//
//  FeedQuizController.swift
//  EduChat
//
//  Created by Tom Knighton on 19/01/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class FeedQuizController: UIViewController {

    //MARK: Global
    var currentQuiz : FeedQuiz?
    var answeredCorrectly = 0
    var currentQuestion : FeedQuizQuestion?
    var currentQuestionIndex = 0
    
    var playingQuiz = false; var secsElapsed = 0;
    
    //MARK: UI
    @IBOutlet weak var answersStackView: UIStackView!
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var quitQuizButton : UIButton!
    
    //MARK: Results
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var finishQuizButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultsView.isHidden = true
        self.finishQuizButton.backgroundColor = .flatBlue
        self.resultsTableView.delegate = self; self.resultsTableView.dataSource = self;
        self.lockAndDisplayActivityIndicator(enable: true) //Locks display temporarily
        FeedMethods.GetFullQuizPost(for: currentQuiz?.PostId ?? 0) { (returnQuiz) in
            // ^ Gets the full quiz object with questions, answers and results
            self.currentQuiz = returnQuiz //Sets the global currentQuiz to the returned quiz
            self.loadStartTimer() //Calls the loadStartTimer() function
            self.quizTitleLabel.text = self.currentQuiz?.QuizTitle ?? "Quiz"
            // ^ Sets the title to the quiz's title
            self.lockAndDisplayActivityIndicator(enable: false) //Unlocks view
        }
    }
    
    func loadCurrentQuestion() {
        self.answersStackView.removeAllArrangedSubviews() // Remove everything from stack
        if currentQuestionIndex >= currentQuiz?.Questions?.count ?? 0 { self.finishQuiz(); return; }
        // ^ If we have finished the questions...
        self.currentQuestion = self.currentQuiz?.Questions?[currentQuestionIndex] //Gets question object
        self.quizTitleLabel.text = currentQuiz?.QuizTitle ?? "Quiz" //Sets the title to the quiz title
        self.currentQuestionLabel.text = "Question \(self.currentQuestionIndex+1): "+(currentQuestion?.Question ?? "")
        //^ Sets the question label to the question number and the question itself
        for answer in self.currentQuestion?.Answers ?? [] { //For each answer in the question
            if answer != "" {
                let button = UIButton(frame: .zero) //Create a button
                button.setTitle(answer, for: .normal) //Sets the title to the answer
                button.cornerRadius = 15 //Round the corners
                button.backgroundColor = .flatBlue //Set background to blue
                button.heightAnchor.constraint(equalToConstant: 50).isActive = true
                //^ Set height of button to 50
                button.addTarget(self, action: #selector(answerButtonPressed(_:)), for: .touchUpInside)
                self.answersStackView.addArrangedSubview(button) //Add button to stack
            }
        }
        self.answersStackView.addArrangedSubview(UILabel()) //Add label to fill rest of stack, to avoid drawing issues
    }
    func startQuiz() {
        self.currentQuestionIndex = 0 //Sets currentIndex to 0
        self.answersStackView.removeAllArrangedSubviews() //Removes everything from stack
        self.loadCurrentQuestion() //Calls loadCurrentQuestion
        self.playingQuiz = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.secsElapsed += 1;
            self.timerLabel.text = "Time Elapsed: \(self.secsElapsed) seconds"
            if !self.playingQuiz { timer.invalidate(); }
        }
    }
    
    
    func loadStartTimer() { //Counts down from 3
        let timerLabel = UILabel(frame: .zero) //Creates a label
        var secsToStart = 3 //Set 3 seconds to start
        timerLabel.text = "3" //Sets text to 3
        timerLabel.textAlignment = .center //Drawing label with font and center
        timerLabel.font = UIFont(name: "Montserrat-Bold", size: 30)
        self.answersStackView.addArrangedSubview(timerLabel) //Adds label to stack view
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            secsToStart -= 1; // ^ Each second, run this code
            timerLabel.text = String(describing: secsToStart) // <^ decrease secsToStart and set the text
            // to the new seconds
            if (secsToStart <= 0) { timer.invalidate(); self.startQuiz(); } //If we reach 0, call startQuiz()
        }
    }
    
    func finishQuiz() {
        self.playingQuiz = false; //Invalidates timer
        self.currentQuestionLabel.text = "" //Clears question label
        
        let finishLabel : UILabel = { //Creates large label saying Well done
            let finishLabel = UILabel(frame: .zero)
            finishLabel.font = UIFont(name: "Montserrat-Bold", size: 30)
            finishLabel.text = "Well done!"
            finishLabel.textAlignment = .center
            return finishLabel
        }()
        let scoreLabel : UILabel = { //Creates smaller label saying the users total score
            let scoreLabel = UILabel(frame: .zero)
            scoreLabel.font = UIFont(name: "Montserrat-Regular", size: 17)
            scoreLabel.textAlignment = .center; scoreLabel.text = "You scored \(self.answeredCorrectly)/\(self.currentQuiz?.Questions?.count ?? 0)"
            return scoreLabel
        }()
        self.answersStackView.addArrangedSubview(finishLabel)
        self.answersStackView.addArrangedSubview(scoreLabel) //Adds the two labels to the stack view
        self.quitQuizButton.backgroundColor = .flatBlue; self.quitQuizButton.setTitleColor(.white, for: .normal)
        self.quitQuizButton.setTitle("Finish  ➡️", for: .normal)
        // ^ Sets the quitQuizButton to a blue background and 'finish' text
        
       
    }
    
    
    @objc func answerButtonPressed(_ sender : UIButton) {
        if sender.titleLabel?.text ?? "" == currentQuestion?.CorrectAnswer {
            //If the answer was correct, show the current button as green and increment
            //answeredCorrectly
            sender.backgroundColor = .flatGreen
            self.answeredCorrectly += 1
        }
        else { //IF the user chose the wrong answer:
            for view in self.answersStackView.arrangedSubviews { //For each view in the stack
                if view is UIButton { //If the view is a button
                    if (view as! UIButton).titleLabel?.text == self.currentQuestion?.CorrectAnswer { view.backgroundColor = .flatGreen }
                    else { view.backgroundColor = .flatRed } //Set the correct answer to green and all others to red
                }
            }
        }
        currentQuestionIndex += 1 //Increment the currentQuestionIndex
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { //Wait 1 second and call loadCurrentQuestion()
            self.loadCurrentQuestion()
        }
    }

    @IBAction func quitQuizPressed(_ sender: Any) {
        if self.playingQuiz == true { //IF user is playing quiz
            self.dismiss(animated: true, completion: nil) //Just quit
        }
        else { //Otherwise if quiz is finished
            self.lockAndDisplayActivityIndicator(enable: true) //Lock
            let result = FeedQuizResult(PostId: self.currentQuiz?.PostId ?? 0, UserId: EduChat.currentUser?.UserId ?? 0, OverallScore: self.answeredCorrectly, DatePosted: Date().toString()) //Create Result object with answers
            result?.User = nil //Set user to nothing
            FeedMethods.CreateQuizResult(result: result!) { (returnResult) in //Call CreateQuizResult
                self.lockAndDisplayActivityIndicator(enable: false) //On return, unlock
                self.currentQuiz?.Results?.append(returnResult!)
                self.resultsView.isHidden = false
                self.resultsTableView.reloadData()
            }
        }
    }
}


extension FeedQuizController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentQuiz?.Results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.resultsTableView.dequeueReusableCell(withIdentifier: "quizResultCell", for: indexPath) as? FeedQuizResultCell else { return UITableViewCell() }
        cell.populate(with: self.currentQuiz?.Results?[indexPath.row], and: self.currentQuiz)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    @IBAction func finalFinishQuiz(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
