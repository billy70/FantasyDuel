//
//  ViewController.swift
//  FantasyDuel
//
//  Created by William L. Marr III on 3/9/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

// **********************************************************
// Credits & Attributions for image files used in this app //
// **********************************************************
//
// All of the following are from the same author, found at: http://opengameart.org/content/handpainted-rpg-icons
//      Author: LudicArts
//      Copyright/Attribution Notice:  http://ludicarts.com/free-rpg-icons/ (note that the site seemed to be down,
//          as I could not connect to it as of March 23, 2016)
//
//      AppIcon.png (the orange, "fiery" sword)
//      potion_armor.png (the green potion)
//      potion_attack.png (the purple potion)
//      potion_health.png (the red potion)
//
// parchment - http://opengameart.org/content/parchment
//
// All of the following were provided by Mark Price (which he acquired from cartoonsmart.com) in the Udemy.com
// course "iOS9 and Swift 2: From Beginner to Paid Professional", and are allowed to be used for educational
// purposes (I used these to build this iOS app as I am going through Mark's course learning iOS and Swift programming):
//
//      bg.png
//      goblin.png
//      ground.png
//      human.png
//      player1attackbtn.png
//      player2attackbtn.png
//      text-holder.png
//
// **********************************************************

import UIKit
import AVFoundation


// MARK: - ViewController class

class ViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: - Outlets
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var statusTextBackground: UIImageView!
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var acceptNameButton: UIButton!
    @IBOutlet weak var potionStackView: UIStackView!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var leftCreatureButton: UIButton!
    @IBOutlet weak var leftPlayerAttackButton: UIButton!
    @IBOutlet weak var leftParchment: UIImageView!
    @IBOutlet weak var leftStackViewStats: UIStackView!
    @IBOutlet weak var leftPlayerPotion: UIButton!
    @IBOutlet weak var leftPlayerHPStat: UILabel!
    @IBOutlet weak var leftPlayerATKStat: UILabel!
    @IBOutlet weak var leftPlayerDEFStat: UILabel!
    
    @IBOutlet weak var rightCreatureButton: UIButton!
    @IBOutlet weak var rightPlayerAttackButton: UIButton!
    @IBOutlet weak var rightParchment: UIImageView!
    @IBOutlet weak var rightStackViewStats: UIStackView!
    @IBOutlet weak var rightPlayerPotion: UIButton!
    @IBOutlet weak var rightPlayerHPStat: UILabel!
    @IBOutlet weak var rightPlayerATKStat: UILabel!
    @IBOutlet weak var rightPlayerDEFStat: UILabel!
    

    // MARK: - Properties - public

    var gameController = GameController()

    
    // MARK: - Delegate methods
    
    // Delegate method for the player name text field, which
    // is used to dismiss the keyboard when 'Return' is tapped.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        gameTitle.hidden = false
        continueButton.setTitle("New Game", forState: .Normal)
        continueButton.hidden = false

        // The delegate for the player's name label is set to
        // the view controller so that the keyboard can be
        // dismissed when the 'Return' button is tapped via
        // the textFieldShouldReturn() delegate method.
        playerNameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action methods
    
    @IBAction func continueButtonTapped(sender: AnyObject) {
        print("vc: continueButtonTapped()")
        
        switch gameController.gamePhase {
        case .NewGame:
            startNewGame()
        case .PlayerSetup:
            setupPlayers()
        case .Combat:
            startCombatRound()
        case .BetweenRounds:
            pickNewPotions()
        }
        
        continueButton.hidden = true
    }
    
    @IBAction func acceptNameButtonTapped(sender: AnyObject) {
        print("vc: acceptNameButtonTapped()")
        
        playerNameEntered()
    }
    
    // The buttons representing the creatures are only
    // used for the player to make their creature selection.
    @IBAction func leftCreatureButtonTapped(sender: AnyObject) {
        print("vc: leftCreatureButtonTapped()")
        
        creatureTypeSelected(.Goblin)
    }

    // The buttons representing the creatures are only
    // used for the player to make their creature selection.
    @IBAction func rightCreatureButtonTapped(sender: AnyObject) {
        print("vc: rightCreatureButtonTapped()")
        
        creatureTypeSelected(.Human)
    }

    @IBAction func healthPotionTapped(sender: AnyObject) {
        print("vc: healthPotionTapped()")
        
        potionSelected(.Health)
    }
    
    @IBAction func armorPotionTapped(sender: AnyObject) {
        print("vc: armorPotionTapped()")
        
        potionSelected(.Armor)
    }
    
    @IBAction func attackPotionTapped(sender: AnyObject) {
        print("vc: attackPotionTapped()")
        
        potionSelected(.Attack)
    }
    
    @IBAction func leftPlayerAttackButtonTapped(sender: AnyObject) {
        print("vc: leftPlayerAttackButtonTapped()")
        
        makeAttack()
    }
    
    @IBAction func rightPlayerAttackButtonTapped(sender: AnyObject) {
        print("vc: rightPlayerAttackButtonTapped()")
        
        makeAttack()
    }
    
    @IBAction func leftPlayerPotionTapped(sender: AnyObject) {
        print("vc: leftPlayerPotionTapped()")
        
        drinkPotion()
    }
    
    @IBAction func rightPlayerPotionTapped(sender: AnyObject) {
        print("vc: rightPlayerPotionTapped()")
        
        drinkPotion()
    }
    
    
    // MARK: - Methods
    
    func initializeView() {
        print("vc: initializeView()\n")
        
        gameTitle.hidden = true
        continueButton.hidden = true
        statusText.text = ""
        statusText.hidden = true
        statusTextBackground.hidden = true
        playerNameTextField.hidden = true
        acceptNameButton.hidden = true
        potionStackView.hidden = true
        
        leftCreatureButton.hidden = true
        leftCreatureButton.userInteractionEnabled = false
        leftCreatureButton.adjustsImageWhenDisabled = false
        leftPlayerAttackButton.hidden = true
        leftParchment.hidden = true
        leftStackViewStats.hidden = true
        leftPlayerPotion.adjustsImageWhenDisabled = false
        
        rightCreatureButton.hidden = true
        rightCreatureButton.userInteractionEnabled = false
        rightCreatureButton.adjustsImageWhenDisabled = false
        rightPlayerAttackButton.hidden = true
        rightParchment.hidden = true
        rightStackViewStats.hidden = true
        rightPlayerPotion.adjustsImageWhenDisabled = false
    }
    
    func startNewGame() {
        print("vc: startNewGame()")
        
        gameController.startNewGame()
        prepareViewForPlayerSetup()


        // This is to make sure that the creature selection
        // screen is reset back to the right-facing goblin
        // on the left side of the screen, and the left-facing
        // human on the right side of the screen (they can be
        // changed depending on player selection during setup).
        var creatureFileName: String
        var creatureImage: UIImage
        
        creatureFileName = getCreatureImageFileName(.Goblin)
        creatureImage = UIImage(named: creatureFileName)!
        leftCreatureButton.setImage(creatureImage, forState: UIControlState.Normal)
        
        creatureFileName = getCreatureImageFileName(.Human)
        creatureImage = UIImage(named: creatureFileName)!
        rightCreatureButton.setImage(creatureImage, forState: UIControlState.Normal)
    }
    
    func setupPlayers() {
        print("vc: setupPlayers()")
        
        prepareViewForPlayerSetup()
    }
    
    func startCombatRound() {
        print("vc: startCombatRound()")
        
        gameController.startNextCombatRound()
        
        if gameController.leftPlayerPotion == .None  || gameController.rightPlayerPotion == .None {
            prepareViewForPotionSelection()
        } else {
            prepareViewForCombatRound()
        }
    }
    
    func pickNewPotions() {
        print("vc: pickNewPotions()")
        
        gameController.pickNewPotions()
        prepareViewForPotionSelection()
    }
    
    func prepareViewForPlayerSetup() {
        print("vc: prepareViewForPlayerSetup()")
        
        if gameController.playerSetupPhaseComplete {
            continueButton.setTitle("Ready...", forState: .Normal)
            pauseForCombatRound()
        } else {
            switch gameController.gamePhase {
            case .PlayerSetup:
                prepareViewForPlayerName()
            case .BetweenRounds:
                prepareViewForPotionSelection()
            default:
                initializeView()
            }
        }
    }

    func prepareViewForPlayerName() {
        print("vc: prepareViewForPlayerName()")

        initializeView()
        
        let text: String
        
        switch gameController.whichPlayerIsUp {
        case .Left: text = "Left player - enter your name:"
        case .Right: text = "Right player - enter your name:"
        }
        
        statusText.text = text
        statusText.hidden = false
        statusTextBackground.hidden = false
        playerNameTextField.text = ""
        playerNameTextField.hidden = false
        acceptNameButton.hidden = false
        
        // This puts the focus on the player name text
        // field and automatically brings up the keyboard.
        playerNameTextField.becomeFirstResponder()
    }
    
    func prepareViewForCreatureSelection() {
        print("vc: prepareViewForCreatureSelection()")
        
        initializeView()

        switch gameController.whichPlayerIsUp {
        case .Left:
            statusText.text = "\(gameController.leftPlayerName) - select a creature:"
            print("left player - selecting a creature")
        case .Right:
            statusText.text = "\(gameController.rightPlayerName) - select a creature:"
            print("right player - selecting a creature")
        }
        
        statusText.hidden = false
        statusTextBackground.hidden = false
        
        leftCreatureButton.hidden = false
        leftCreatureButton.userInteractionEnabled = true
        leftCreatureButton.enabled = true
        
        rightCreatureButton.hidden = false
        rightCreatureButton.userInteractionEnabled = true
        rightCreatureButton.enabled = true
    }
    
    func prepareViewForPotionSelection() {
        print("vc: prepareViewForPotionSelection()")
        
        initializeView()
        
        switch gameController.whichPlayerIsUp {
        case .Left:
            statusText.text = "\(gameController.leftPlayerName), select a potion:"
        case .Right:
            statusText.text = "\(gameController.rightPlayerName), select a potion:"
        }

        statusText.hidden = false
        statusTextBackground.hidden = false
        potionStackView.hidden = false
    }
    
    func prepareViewForCombatRound() {
        print("vc: prepareViewForCombatRound()")
        
        initializeView()
        updatePlayerStats()
        
        let playerNameWithInitiative: String
        
        switch gameController.whichPlayerHasInitiative {
        case .Left:
            playerNameWithInitiative = gameController.leftPlayerName
        case .Right:
            playerNameWithInitiative = gameController.rightPlayerName
        }

        statusText.text = playerNameWithInitiative + " has initiative."
        statusText.hidden = false
        statusTextBackground.hidden = false
        
        setupLeftPlayerCombatViews()
        setupRightPlayerCombatViews()
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ViewController.setStatusToFight), userInfo:  nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ViewController.enablePlayerAttack), userInfo: nil, repeats: false)
    }
    
    func setupLeftPlayerCombatViews() {
        print("vc: setupLeftPlayerCombatViews()")
        
        leftCreatureButton.hidden = false
        leftCreatureButton.enabled = false
        leftCreatureButton.userInteractionEnabled = false
        leftCreatureButton.adjustsImageWhenDisabled = false
        leftParchment.hidden = false
        leftStackViewStats.hidden = false
        
        if gameController.leftPlayerPotion == .None {
            leftPlayerPotion.hidden = true
        } else {
            let potion = getPotionImageFileName(gameController.leftPlayerPotion)
            leftPlayerPotion.setImage(UIImage(named: potion), forState: UIControlState.Normal)
            leftPlayerPotion.hidden = false
        }
        
        // Flip the human image if the left player picked the human creature type
        // (this is because the asset catalog includes only a single, left-facing human image).
        let creatureFileName = getCreatureImageFileName(gameController.leftPlayerCreatureType)
        var creatureImage: UIImage
        
        creatureImage = UIImage(named: creatureFileName)!
        if gameController.leftPlayerCreatureType == .Human {
            creatureImage = UIImage(CGImage: creatureImage.CGImage!, scale: creatureImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        leftCreatureButton.setImage(creatureImage, forState: UIControlState.Normal)
    }
    
    func setupRightPlayerCombatViews() {
        print("vc: setupRightPlayerCombatViews()")
        
        rightCreatureButton.hidden = false
        rightCreatureButton.enabled = false
        rightCreatureButton.userInteractionEnabled = false
        rightCreatureButton.adjustsImageWhenDisabled = false
        rightParchment.hidden = false
        rightStackViewStats.hidden = false
        
        if gameController.rightPlayerPotion == .None {
            rightPlayerPotion.hidden = true
        } else {
            let potion = getPotionImageFileName(gameController.rightPlayerPotion)
            rightPlayerPotion.setImage(UIImage(named: potion), forState: UIControlState.Normal)
            rightPlayerPotion.hidden = false
        }
        
        // Flip the goblin image if the right player picked the goblin creature type
        // (this is because the asset catalog includes only a single, right-facing goblin image).
        let creatureFileName = getCreatureImageFileName(gameController.rightPlayerCreatureType)
        var creatureImage: UIImage
        
        creatureImage = UIImage(named: creatureFileName)!
        if gameController.rightPlayerCreatureType == .Goblin {
            creatureImage = UIImage(CGImage: creatureImage.CGImage!, scale: creatureImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        rightCreatureButton.setImage(creatureImage, forState: UIControlState.Normal)
    }
    
    func getPotionImageFileName(potionType: PotionType) -> String {
        print("vc: getPotionImageFileName()")
        
        switch potionType {
        case .None: return ""
        case .Health: return "potion_health.png"
        case .Attack: return "potion_attack.png"
        case .Armor: return "potion_armor.png"
        }
    }
    
    func getCreatureImageFileName(creatureType: CreatureType) -> String {
        print("vc: getCreatureImageFileName()")
        
        switch creatureType {
        case .Human: return "human.png"
        case .Goblin: return "goblin.png"
        }
    }
    
    func playerNameEntered() {
        print("vc: playerNameEntered()")
        
        var playerName: String
        
        if let name = playerNameTextField.text {
            playerName = name
        } else {
            switch gameController.whichPlayerIsUp {
            case .Left:
                playerName = "Left player"
            case .Right:
                playerName = "Right player"
            }
        }

        gameController.setPlayerName(playerName)

        prepareViewForCreatureSelection()
    }

    func creatureTypeSelected(type: CreatureType) {
        print("vc: creatureTypeSelected()")
        
        gameController.setPlayerCreatureType(type)
        
        prepareViewForPotionSelection()
    }
    
    func potionSelected(potion: PotionType) {
        print("vc: potionSelected()")
        
        gameController.setPlayerPotionSelection(potion)
        
        // There are three conditions which lead to two possible branches after a
        // player has selected a potion:
        //
        // 1) if this is the player setup phase, and only one player has selected
        //    their name, creature, and potion, then go back to the first step of
        //    the player setup, so that the second player can setup their fighter;
        //
        // 2) if this is the start of a combat phase (i.e., both players are done
        //    with the player setup phase, and are ready to start a round of combat),
        //    "pause" the game by displaying the "continue" button;
        //
        // 2) if this is in-between combat rounds, check if either player still
        //    needs to select their potion for the next combat round; otherwise,
        //    if they have both selected their potions, prepare the view for combat.
        //
        switch gameController.gamePhase {
        case .PlayerSetup:
            if gameController.playerSetupPhaseComplete == false {
                prepareViewForPlayerSetup()
            }
            return

        case .Combat:
            continueButton.setTitle("Ready...", forState: .Normal)
            pauseForCombatRound()
            return
        
        case .BetweenRounds:
            if gameController.leftPlayerPotion == .None || gameController.rightPlayerPotion == .None {
                prepareViewForPotionSelection()
            } else {
                prepareViewForCombatRound()
            }
            return
        
        default:
            break
        }
        
        // The code should never get to this point - if it does, then there is a logic bug,
        // so just restart the game and print a debug message.
        initializeView()
        continueButton.setTitle("GAME BUG", forState: .Normal)
        print("*** GAME BUG IN potionSelected(), ViewController.swift")
    }
    
    func drinkPotion() {
        print("vc: drinkPotion()")
        
        // You forfeit your attack if you use your potion.
        disablePlayerAttack()
        
        let playerName: String
        let playerPotion: PotionType
        let potionText: String
        
        switch gameController.whichPlayerIsUp {
        case .Left:
            playerName = gameController.leftPlayerName
            playerPotion = gameController.leftPlayerPotion
            leftPlayerPotion.hidden = true
        case .Right:
            playerName = gameController.rightPlayerName
            playerPotion = gameController.rightPlayerPotion
            rightPlayerPotion.hidden = true
        }
        
        switch playerPotion {
        case .None:
            potionText = ""
        case .Health:
            potionText = "a health"
        case .Attack:
            potionText = "an attack"
        case .Armor:
            potionText = "an armor"
        }
        
        statusText.text = "\(playerName) drank \(potionText) potion."
        
        gameController.usePotion()
        
        updatePlayerStats()
        enablePlayerAttack()
    }
    
    func makeAttack() {
        print("vc: makeAttack()")
        
        let name: String
        
        switch gameController.whichPlayerIsUp {
        case .Left:
            name = gameController.leftPlayerName
        case .Right:
            name = gameController.rightPlayerName
        }
        
        disablePlayerAttack()
        
        if gameController.isAttackSuccessful() {
            
            if gameController.playerWonCombatRound() {
                
                switch gameController.whichPlayerIsUp {
                case .Left:
                    rightCreatureButton.hidden = true
                case .Right:
                    leftCreatureButton.hidden = true
                }

                if gameController.playerWonGame() {
                    statusText.text = "\(name) has won the game!"
                    NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(ViewController.pauseForNextGame), userInfo: nil, repeats: false)
                } else {
                    statusText.text = "\(name) has won round \(gameController.roundNumber)."
                    continueButton.setTitle("Round \(gameController.roundNumber + 1)", forState: .Normal)
                    NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(ViewController.pauseForCombatRound), userInfo: nil, repeats: false)
                }
                
            } else {  // !gameController.playerWonCombatRound()
                
                let damage = gameController.calculateDamage()
                var pointText = "point"
                
                if damage > 1 {
                    pointText += "s"
                }
                
                statusText.text = "\(name) hit for \(damage) \(pointText)!"
                gameController.nextPlayerIsUp()
                NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ViewController.enablePlayerAttack), userInfo: nil, repeats: false)
            }
            
        } else {  // !gameController.isAttackSuccessful()
            statusText.text = "\(name) missed!"
            gameController.nextPlayerIsUp()
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ViewController.enablePlayerAttack), userInfo: nil, repeats: false)
        }
        
        updatePlayerStats()
    }
    
    func setStatusToFight() {
        print("vc: setStatusToFight()")
        
        statusText.text = "FIGHT!"
    }

    func disablePlayerAttack() {
        print("vc: disablePlayerAttack()")
        
        switch gameController.whichPlayerIsUp {
        case .Left:
            leftPlayerAttackButton.hidden = true
            leftPlayerPotion.enabled = false
        case .Right:
            rightPlayerAttackButton.hidden = true
            rightPlayerPotion.enabled = false
        }
    }
    
    func enablePlayerAttack() {
        print("vc: enablePlayerAttack()")
        
        switch gameController.whichPlayerIsUp {
        case .Left:
            leftPlayerAttackButton.hidden = false
            if gameController.leftPlayerPotion == .None {
                leftPlayerPotion.hidden = true
            } else {
                leftPlayerPotion.hidden = false
                leftPlayerPotion.enabled = true
                rightPlayerPotion.enabled = false
            }
        case .Right:
            rightPlayerAttackButton.hidden = false
            if gameController.rightPlayerPotion == .None {
                rightPlayerPotion.hidden = true
            } else {
                rightPlayerPotion.hidden = false
                rightPlayerPotion.enabled = true
                leftPlayerPotion.enabled = false
            }
        }
    }
    
    func updatePlayerStats() {
        print("vc: updatePlayerStats()")
        
        leftPlayerHPStat.text = "HP:  \(gameController.leftPlayerHitPoints)"
        leftPlayerATKStat.text = "ATK: \(gameController.leftPlayerAttackPower)"
        leftPlayerDEFStat.text = "DEF: \(gameController.leftPlayerArmorRating)"

        rightPlayerHPStat.text = "HP:  \(gameController.rightPlayerHitPoints)"
        rightPlayerATKStat.text = "ATK: \(gameController.rightPlayerAttackPower)"
        rightPlayerDEFStat.text = "DEF: \(gameController.rightPlayerArmorRating)"
    }
    
    func pauseForCombatRound() {
        print("vc: pauseForCombatRound()")
        
        initializeView()
        continueButton.hidden = false
    }
    
    func pauseForNextGame() {
        print("vc: pauseForNextGame()")
        
        initializeView()
        gameTitle.hidden = false
        continueButton.setTitle("New Game", forState: .Normal)
        continueButton.hidden = false
    }
}

