//
//  DiceAndCardBattleVC.swift
//  DrawDeckBluffForge
//
//  Created by jin fu on 2024/11/24.
//


import UIKit

class BluffForgeDiceAndCardBattleVC: UIViewController {

    // MARK: - Declare IBOutlets
    @IBOutlet weak var pointSlider: UISlider!
    @IBOutlet weak var playerOneCardImage: UIImageView!
    @IBOutlet weak var playerTwoCardImage: UIImageView!
    @IBOutlet weak var diceImageViewPlayerOne: UIImageView!
    @IBOutlet weak var diceImageViewPlayerTwo: UIImageView!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var totalTurnStepper: UIStepper!
    @IBOutlet weak var stapperCounterLabel: UILabel!
    @IBOutlet weak var showTurnLabel: UILabel!
    @IBOutlet weak var reultLabel: UILabel!
    @IBOutlet weak var sliderValue: UILabel!
    
    // MARK: - Declare Variables
    var totalTurns: Int = 1
    var currentTurn: Int = 1
    var playerOnePoints: Int = 0
    var playerTwoPoints: Int = 0

    let cardSuits = ["♠️", "♥️", "♦️", "♣️"]
    let cardValues = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }

    // MARK: - Functions
    private func setupGame() {
        pointSlider.minimumValue = 1
        pointSlider.maximumValue = 100
        pointSlider.value = 50
        stapperCounterLabel.text = "Turns: \(totalTurns)"
        showTurnLabel.text = "Turn: \(currentTurn)"
        reultLabel.text = "Result will show here"
        sliderValue.text = "\(Int(pointSlider.value))"
        playerOnePoints = 0
        playerTwoPoints = 0
        currentTurn = 1
        playerOneCardImage.image = UIImage(named: "backCard")
        playerTwoCardImage.image = UIImage(named: "backCard")
        diceImageViewPlayerOne.image = UIImage(named: "dice")
        diceImageViewPlayerTwo.image = UIImage(named: "dice")
    }

    private func randomCard() -> (UIImage?, Int) {
        let randomSuit = cardSuits.randomElement()!
        let randomValue = cardValues.randomElement()!
        let cardName = "\(randomValue)\(randomSuit)"
        let cardValueIndex = cardValues.firstIndex(of: randomValue)!  // Get index as card value
        return (UIImage(named: cardName), cardValueIndex)
    }
    
    private func randomDiceValue() -> Int {
        return Int.random(in: 1...6)
    }

    private func updateSliderAndPoints(winnerDiceValue: Int, winner: String) {
        if winner == "Player One" {
            pointSlider.value -= Float(winnerDiceValue)  // Deduct points from Player Two
            playerTwoPoints -= winnerDiceValue  // Update Player Two points
        } else if winner == "Player Two" {
            pointSlider.value += Float(winnerDiceValue)  // Add points for Player Two
            playerTwoPoints += winnerDiceValue  // Update Player Two points
        }
        
        sliderValue.text = "\(Int(pointSlider.value))"
        reultLabel.text = "\(winner) wins this round!"
    }


    private func showGameOverAlert() {
        let winner: String
        
        if pointSlider.value > 50 {
            winner = "Player Two"
        } else if pointSlider.value < 50 {
            winner = "Player One"
        } else {
            winner = "It's a Tie"
        }
        
        let alert = UIAlertController(title: "Game Over", message: "\(winner) wins the game!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.setupGame()
        }))
        
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Declare IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDealCard(_ sender: Any) {
        guard currentTurn <= totalTurns else {
            showGameOverAlert()
            return
        }
        
        // Show random cards and get their values
        let (playerOneCard, playerOneCardValue) = randomCard()
        let (playerTwoCard, playerTwoCardValue) = randomCard()
        
        playerOneCardImage.image = playerOneCard
        playerTwoCardImage.image = playerTwoCard
        
        // Roll dice for both players
        let playerOneDiceValue = randomDiceValue()
        let playerTwoDiceValue = randomDiceValue()
        
        diceImageViewPlayerOne.image = UIImage(named: "dice\(playerOneDiceValue)")
        diceImageViewPlayerTwo.image = UIImage(named: "dice\(playerTwoDiceValue)")
        
        // Determine winner based on card values and update points
        if playerOneCardValue > playerTwoCardValue {
            playerOnePoints += playerOneDiceValue
            updateSliderAndPoints(winnerDiceValue: playerOneDiceValue, winner: "Player One")
        } else if playerTwoCardValue > playerOneCardValue {
            playerTwoPoints += playerTwoDiceValue
            updateSliderAndPoints(winnerDiceValue: playerTwoDiceValue, winner: "Player Two")
        } else {
            reultLabel.text = "It's a tie!"
        }
        
        // Move to the next turn
        currentTurn += 1
        showTurnLabel.text = "Turn: \(currentTurn)"
        
        // Check if game is over after this turn
        if currentTurn > totalTurns {
            showGameOverAlert()
        }
    }

    @IBAction func btnStepper(_ sender: UIStepper) {
        totalTurns = Int(sender.value)
        stapperCounterLabel.text = "Turns: \(totalTurns)"
    }
    
    @IBAction func pointSlider(_ sender: UISlider) {
        sliderValue.text = "\(Int(pointSlider.value))"
    }
}
