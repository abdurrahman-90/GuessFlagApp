//
//  ViewController.swift
//  GuessFlagApp
//
//  Created by Akdag on 19.02.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var QuestionLAbel: UILabel!
    
    var timer = Timer()
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsCounter = 0
    var highScore = 0
    let questionsLimit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        
        countries += [
            "estonia", "france", "germany",
            "ireland", "italy", "monaco",
            "nigeria", "poland", "russia",
            "spain", "uk", "us"
        ]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(_ action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
       
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        for button in [button1, button2 ,button3]{
            button?.alpha = 0.0
            button?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        
        UIView.animate(withDuration: 0.7){
            for button in [self.button1 , self.button2 , self.button3]{
                button?.alpha = 1.0
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
        QuestionLAbel.text = "Which is right flag \(countries[correctAnswer].uppercased()) ?"
        title = "Score = \(score)"
        QuestionLAbel.backgroundColor = .systemTeal
       
    }
    
    func resetGame(_ action: UIAlertAction!) {
        score = 0
        questionsCounter = 0
        askQuestion(action)
    }
    
    @objc @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { (finish) in
            sender.isHidden = false
        }

        
        questionsCounter += 1
        
        if sender.tag == correctAnswer {
           
            title = "Correct!"
            message = "Your score is \(score)"
            score += 1
            QuestionLAbel.backgroundColor = .green
            
        } else {
            title = "Wrong!"
            message = "That's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
            QuestionLAbel.backgroundColor = .red
            
        }
        
        let ac: UIAlertController!
       
        if questionsCounter == questionsLimit {
            var message = " You have answered \(questionsCounter) questions"
            if score > highScore {
                message += "\nYou have beaten your best result! 🎉"
                highScore = score
               
                let defaults = UserDefaults.standard
                 defaults.set(highScore, forKey: "highScore")
            }else{
                message += "\nHighest score \(highScore)"
            }
            
            ac = UIAlertController(title: "Your final score is \(score)",
                message: message,
                preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart Game", style: .default, handler: resetGame))
        } else {
            ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        }
        
        present(ac, animated: true)
        
    }
    
    
    
    @IBAction func showScore(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Your score is \(score)!",
            message: "You have answered \(questionsCounter) of \(questionsLimit) questions",
            preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
}


