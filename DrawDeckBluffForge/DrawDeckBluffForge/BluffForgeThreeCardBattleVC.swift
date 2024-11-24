//
//  ThreeCardBattleVC.swift
//  DrawDeckBluffForge
//
//  Created by jin fu on 2024/11/24.
//


import UIKit

class BluffForgeThreeCardBattleVC: UIViewController {
    
    // MARK: - Declare IBOutlets
    @IBOutlet weak var pointSlider: UISlider!
    @IBOutlet var playerOneCardImages: [UIImageView]!
    @IBOutlet var playerTwoCardImages: [UIImageView]!
    @IBOutlet weak var diceImageViewPlayerOne: UIImageView!
    @IBOutlet weak var diceImageViewPlayerTwo: UIImageView!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var totalTurnStepper: UIStepper!
    @IBOutlet weak var stapperCounterLabel: UILabel!
    @IBOutlet weak var showTurnLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var sliderValue: UILabel!
    
    // MARK: - Declare Variables
    var playerOneDiceValue = Int()
    var playerTwoDiceValue = Int()
    
    var totalTurns: Int = 1
    var currentTurn: Int = 1
    var playerOnePoints: Int = 0
    var playerTwoPoints: Int = 0
    
    let cardSuits = ["♠️", "♥️", "♦️", "♣️"]
    let cardValues = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setupGame()
        }
        
    }
    
    // MARK: - Functions
    private func setupGame() {
        pointSlider.minimumValue = 1
        pointSlider.maximumValue = 100
        pointSlider.value = 50
        stapperCounterLabel.text = "Turns: \(totalTurns)"
        showTurnLabel.text = "Turn: \(currentTurn)"
        resultLabel.text = "Result will show here"
        sliderValue.text = "\(Int(pointSlider.value))"
        playerOnePoints = 0
        playerTwoPoints = 0
        currentTurn = 1
        for cardImage in playerOneCardImages {
            cardImage.image = UIImage(named: "backCard")
        }
        for cardImage in playerTwoCardImages {
            cardImage.image = UIImage(named: "backCard")
        }
        diceImageViewPlayerOne.image = UIImage(named: "dice")
        diceImageViewPlayerTwo.image = UIImage(named: "dice")
    }
    
    private func randomCard() -> (UIImage?, String, String) {
        let randomSuit = cardSuits.randomElement()!
        let randomValue = cardValues.randomElement()!
        let cardName = "\(randomValue)\(randomSuit)"
        return (UIImage(named: cardName), randomValue, randomSuit)
    }
    
    private func randomDiceValue() -> Int {
        return Int.random(in: 1...6)
    }
    
    // Helper to rank cards for comparison
    
    
    // MARK: - Hand Evaluation
    private func evaluateHand(cardValues: [String], cardSuits: [String]) -> [String: String] {
        let ranks = cardValues.map { cardRank($0) }
        let sortedRanks = ranks.sorted()
        let suitCounts = Dictionary(grouping: cardSuits, by: { $0 }).mapValues { $0.count }
        
        // Determine Hand Ranking
        if sortedRanks == [10, 11, 12, 13, 14], suitCounts.values.contains(3) {
            return ["hand": "Royal Flush"]
        }
        if sortedRanks == [11, 12, 13, 14], suitCounts.values.contains(3) {
            return ["hand": "Mini Royal Flush"]
        }
        if sortedRanks[2] - sortedRanks[0] == 2, suitCounts.values.contains(3) {
            return ["hand": "Straight Flush"]
        }
        if ranks[0] == ranks[1] && ranks[1] == ranks[2] {
            return ["hand": "Three of a Kind"]
        }
        if suitCounts.values.contains(3) {
            return ["hand": "Flush"]
        }
        if sortedRanks[2] - sortedRanks[0] == 2 {
            return ["hand": "Straight"]
        }
        if ranks[0] == ranks[1] || ranks[1] == ranks[2] {
            return ["hand": "Pair"]
        }
        
        // High Card: Highest rank card wins
        let highestCardRank = sortedRanks.last!
        let highestCardValue = cardValues[ranks.firstIndex(of: highestCardRank)!]
        return ["hand": "High Card", "highCard": highestCardValue]
    }
    
    // Function to compare two hands
    func compareHands(playerOneCards: [String], playerTwoCards: [String], playerOneSuits: [String], playerTwoSuits: [String]) -> String {
        let playerOneHand = evaluateHand(cardValues: playerOneCards, cardSuits: playerOneSuits)
        let playerTwoHand = evaluateHand(cardValues: playerTwoCards, cardSuits: playerTwoSuits)
        
        // Compare hands
        let playerOneRank = playerOneHand["hand"]!
        let playerTwoRank = playerTwoHand["hand"]!
        
        if playerOneRank == playerTwoRank {
            // If both have the same rank, compare high cards
            let playerOneHighCard = playerOneHand["highCard"]!
            let playerTwoHighCard = playerTwoHand["highCard"]!
            
            // Compare highest card values
            if cardRank(playerOneHighCard) > cardRank(playerTwoHighCard) {
                return "Player One Wins with \(playerOneHighCard)"
            } else if cardRank(playerOneHighCard) < cardRank(playerTwoHighCard) {
                return "Player Two Wins with \(playerTwoHighCard)"
            } else {
                return "It's a Tie!"
            }
        } else {
            // If one hand rank is better, declare the winner
            if handRankValue(playerOneRank) > handRankValue(playerTwoRank) {
                return "Player One Wins with \(playerOneRank)"
            } else {
                return "Player Two Wins with \(playerTwoRank)"
            }
        }
    }
    
    private func determineRoundWinner(playerOneCardValues: [String], playerOneCardSuits: [String], playerTwoCardValues: [String], playerTwoCardSuits: [String]) -> String {
        // Evaluate the hands for both players
        let playerOneHand = evaluateHand(cardValues: playerOneCardValues, cardSuits: playerOneCardSuits)
        let playerTwoHand = evaluateHand(cardValues: playerTwoCardValues, cardSuits: playerTwoCardSuits)
        
        // Extract the hand type from the dictionaries
        let playerOneHandType = playerOneHand["hand"]!
        let playerTwoHandType = playerTwoHand["hand"]!
        
        // If both hands are of the same type, compare their high cards (and subsequent cards if necessary)
        if playerOneHandType == playerTwoHandType {
            let playerOneHighCards = playerOneCardValues.sorted { cardRank($0) > cardRank($1) }
            let playerTwoHighCards = playerTwoCardValues.sorted { cardRank($0) > cardRank($1) }
            let playerOneDice = randomDiceValue()
            let playerTwoDice = randomDiceValue()
            let winnerDiceValue = playerOneDice > playerTwoDice ? playerOneDice : playerTwoDice
            // Compare the cards one by one
            for i in 0..<min(playerOneHighCards.count, playerTwoHighCards.count) {
                let playerOneCard = playerOneHighCards[i]
                let playerTwoCard = playerTwoHighCards[i]
                
                if cardRank(playerOneCard) > cardRank(playerTwoCard) {
                    updateSliderAndPoints( winner: "Player One")
                    return "Player One Wins"
                } else if cardRank(playerOneCard) < cardRank(playerTwoCard) {
                    updateSliderAndPoints(winner: "Player Two")
                    return "Player Two Wins"
                }
            }
            
            
            return "It's a tie!"
        }
        
        // List of hand rankings, from lowest to highest
        let handStrengths = ["High Card", "Pair", "Flush", "Straight", "Three of a Kind", "Straight Flush", "Mini Royal Flush", "Royal Flush"]
        
        // Get the indices of hand types for comparison
        if let playerOneStrengthIndex = handStrengths.firstIndex(of: playerOneHandType),
           let playerTwoStrengthIndex = handStrengths.firstIndex(of: playerTwoHandType) {
            if playerOneStrengthIndex > playerTwoStrengthIndex{
                updateSliderAndPoints( winner: "Player One")
            } else {
                updateSliderAndPoints(winner: "Player Two")
            }
            return playerOneStrengthIndex > playerTwoStrengthIndex ? "Player One Wins" : "Player Two Wins"
        }
        
        return "It's a tie!"
    }
    
    // Helper function to get the rank of a card value (A = 14, K = 13, etc.)
    func cardRank(_ card: String) -> Int {
        switch card {
        case "A": return 14
        case "K": return 13
        case "Q": return 12
        case "J": return 11
        case "10": return 10
        case "9": return 9
        case "8": return 8
        case "7": return 7
        case "6": return 6
        case "5": return 5
        case "4": return 4
        case "3": return 3
        case "2": return 2
        default: return 0
        }
    }
    
    
    // Helper function to convert hand ranking to value (e.g. Royal Flush > Straight)
    func handRankValue(_ rank: String) -> Int {
        switch rank {
        case "Royal Flush": return 10
        case "Mini Royal Flush": return 9
        case "Straight Flush": return 8
        case "Three of a Kind": return 7
        case "Flush": return 6
        case "Straight": return 5
        case "Pair": return 4
        case "High Card": return 3
        default: return 0
        }
    }
    
    private func updateSliderAndPoints(winner: String) {
        if winner == "Player One" {
            
            pointSlider.value -= Float(playerOneDiceValue)
            playerTwoPoints -= playerOneDiceValue
        } else if winner == "Player Two" {
            pointSlider.value += Float(Int(playerTwoDiceValue))
            playerTwoPoints += playerTwoDiceValue
        }
        
        sliderValue.text = "\(Int(pointSlider.value))"
        resultLabel.text = "\(winner) wins this round!"
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
        playerOneDiceValue = randomDiceValue()
        playerTwoDiceValue = randomDiceValue()
        
        diceImageViewPlayerOne.image = UIImage(named: "dice\(playerOneDiceValue)")
        diceImageViewPlayerTwo.image = UIImage(named: "dice\(playerTwoDiceValue)")
        
        // Array to track the cards in the deck
        var usedCards: Set<String> = []
        var playerOneCardValues: [String] = []
        var playerOneCardSuits: [String] = []
        var playerTwoCardValues: [String] = []
        var playerTwoCardSuits: [String] = []
        
        // Function to get a unique card
        func getUniqueCard() -> (UIImage?, String, String) {
            var card: (UIImage?, String, String)
            repeat {
                card = randomCard()
            } while usedCards.contains(card.1 + card.2) // Ensure card is unique
            
            // Add the card to the used set to prevent it from being used again
            usedCards.insert(card.1 + card.2)
            return card
        }
        
        for i in 0..<3 {
            // Get unique cards for both players
            let playerOneCard = getUniqueCard()
            let playerTwoCard = getUniqueCard()
            
            // Assign cards to players
            playerOneCardValues.append(playerOneCard.1)
            playerOneCardSuits.append(playerOneCard.2)
            playerTwoCardValues.append(playerTwoCard.1)
            playerTwoCardSuits.append(playerTwoCard.2)
            
            // Update card images
            playerOneCardImages[i].image = playerOneCard.0
            playerTwoCardImages[i].image = playerTwoCard.0
        }
        
        // Compare hands after cards are dealt
        let roundResult = determineRoundWinner(
            playerOneCardValues: playerOneCardValues,
            playerOneCardSuits: playerOneCardSuits,
            playerTwoCardValues: playerTwoCardValues,
            playerTwoCardSuits: playerTwoCardSuits
        )
        
        // Update UI with round result
        showTurnLabel.text = "Turn: \(currentTurn)"
        resultLabel.text = roundResult
        currentTurn += 1
        
        // Check if the game is over (total turns reached)
        if currentTurn > totalTurns {
            showGameOverAlert()
        }
    }

    
    @IBAction func totalTurnStepperValueChanged(_ sender: UIStepper) {
        totalTurns = Int(sender.value)
        stapperCounterLabel.text = "Turns: \(totalTurns)"
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue.text = "\(Int(sender.value))"
    }
}
