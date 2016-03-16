//
//  ViewController.swift
//  FantasyDuel
//
//  Created by William L. Marr III on 3/9/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Game phases enumeration

enum GamePhase {
    case CharacterSelection
    case CharacterName
    case PotionSelection
    case AttackRound
    case Victory
}


// MARK: - ViewController class

class ViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: - Outlets
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var playerNameLabel: UITextField!
    @IBOutlet weak var potionStackView: UIStackView!
    @IBOutlet weak var leftPlayerButton: UIButton!
    @IBOutlet weak var rightPlayerButton: UIButton!
    @IBOutlet weak var acceptNameButton: UIButton!
    @IBOutlet weak var leftPlayerAttackButton: UIButton!
    @IBOutlet weak var rightPlayerAttackButton: UIButton!
    @IBOutlet weak var leftParchment: UIImageView!
    @IBOutlet weak var leftStackViewStats: UIStackView!
    @IBOutlet weak var leftPlayerHPStat: UILabel!
    @IBOutlet weak var leftPlayerATKStat: UILabel!
    @IBOutlet weak var leftPlayerDEFStat: UILabel!
    @IBOutlet weak var leftPlayerPotion: UIButton!
    @IBOutlet weak var rightParchment: UIImageView!
    @IBOutlet weak var rightStackViewStats: UIStackView!
    @IBOutlet weak var rightPlayerHPStat: UILabel!
    @IBOutlet weak var rightPlayerATKStat: UILabel!
    @IBOutlet weak var rightPlayerDEFStat: UILabel!
    @IBOutlet weak var rightPlayerPotion: UIButton!
    
    // MARK: - Properties
    
    var leftPlayer: Player!
    var leftPlayerCreatureType: CreatureType!
    var leftPlayerName = "Left player"
    var leftPlayerPotionSelection: PotionType!
    var leftPlayerRoundsWon = 0

    var rightPlayer: Player!
    var rightPlayerCreatureType: CreatureType!
    var rightPlayerName = "Right player"
    var rightPlayerPotionSelection: PotionType!
    var rightPlayerRoundsWon = 0
    
    var gamePhase: GamePhase = .CharacterSelection
    var leftPlayerIsChoosingOptions = true
    var playerSetupComplete = false
    var whichPlayerHasInitiative = "left"
    var roundNumber = 1
    
    var audioBattleMusic: AVAudioPlayer!
    var audioFanfare: AVAudioPlayer!
    var audioFight: AVAudioPlayer!
    var audioGoblinDeath: AVAudioPlayer!
    var audioHumanDeath: AVAudioPlayer!
    var audioPlayerSetupMusic: AVAudioPlayer!
    var audioPotionEffect: AVAudioPlayer!
    var audioSwordAttack: AVAudioPlayer!
    var audioAttackMissed: AVAudioPlayer!
    var audioVictoryCry: AVAudioPlayer!
    
    var audioDictionary: [String: String] = [
        "audioBattleMusic": "snd_duels_music",
        "audioFanfare": "snd_fanfare",
        "audioFight": "snd_fight",
        "audioGoblinDeath": "snd_goblin_death",
        "audioHumanDeath": "snd_human_death",
        "audioPlayerSetupMusic": "snd_player_setup",
        "audioPotionEffect": "snd_potion-effect",
        "audioSwordAttack": "snd_sword_attack",
        "audioAttackMissed": "snd_missed",
        "audioVictoryCry": "snd_victory_cry"
    ]

    // MARK: - Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action methods
    
    @IBAction func leftPlayerButtonTapped(sender: AnyObject) {
    
        // The buttons representing the creatures is only
        // used for the player to make their creature selection.
        if gamePhase == .CharacterSelection {
            
            setPlayerCreatureType(CreatureType.Goblin)
            proceedToCharacterNamePhase()
        }
    }

    @IBAction func rightPlayerButtonTapped(sender: AnyObject) {

        // The buttons representing the creatures is only
        // used for the player to make their creature selection.
        if gamePhase == .CharacterSelection {
            
            setPlayerCreatureType(CreatureType.Human)
            proceedToCharacterNamePhase()
        }
    }

    @IBAction func acceptNameButtonTapped(sender: AnyObject) {
        if playerNameLabel.text != nil {
            setPlayerName()
            proceedToPotionSelectionPhase()
        }
    }
    
    @IBAction func healthPotionTapped(sender: AnyObject) {
        setPlayerPotionSelection(PotionType.Health)
        
        leftPlayerIsChoosingOptions = false
        
        // Players get to select a new potion in between rounds,
        // so, if this is still the first round, the players
        // are still in the player setup phase at the start
        // of a 3-round game.
        if !playerSetupComplete && roundNumber == 1 {
            
            if leftPlayerIsChoosingOptions == false {
                proceedToCharacterSelectionPhase()
            }
            
        } else {
            
            if rightPlayerPotionSelection == PotionType.None {
                proceedToPotionSelectionPhase()
            } else {
                proceedToAttackPhase()
            }
        }
    }
    
    @IBAction func armorPotionTapped(sender: AnyObject) {
        setPlayerPotionSelection(PotionType.Armor)

        leftPlayerIsChoosingOptions = false
        
        // Players get to select a new potion in between rounds,
        // so, if this is still the first round, the players
        // are still in the player setup phase at the start
        // of a 3-round game.
        if !playerSetupComplete && roundNumber == 1 {
            
            if leftPlayerIsChoosingOptions == false {
                proceedToCharacterSelectionPhase()
            }
            
        } else {
            
            if rightPlayerPotionSelection == PotionType.None {
                proceedToPotionSelectionPhase()
            } else {
                proceedToAttackPhase()
            }
        }
    }
    
    @IBAction func attackPotionTapped(sender: AnyObject) {
        setPlayerPotionSelection(PotionType.Attack)

        leftPlayerIsChoosingOptions = false
        
        // Players get to select a new potion in between rounds,
        // so, if this is still the first round, the players
        // are still in the player setup phase at the start
        // of a 3-round game.
        if !playerSetupComplete && roundNumber == 1 {
            
            if leftPlayerIsChoosingOptions == false {
                proceedToCharacterSelectionPhase()
            }
            
        } else {
            
            if rightPlayerPotionSelection == PotionType.None {
                proceedToPotionSelectionPhase()
            } else {
                proceedToAttackPhase()
            }
        }
    }
    
    @IBAction func leftPlayerAttackButtonTapped(sender: AnyObject) {
        leftPlayerAttackButton.hidden = true
        leftPlayerPotion.enabled = false
        
        if leftPlayer.isAttackSuccessfulAgainst(rightPlayer) {
            let damage = leftPlayer.attackPower - rightPlayer.armorRating
            let pointText = (damage == 1 ? "point" : "points")
            statusText.text = "\(leftPlayer.name) hit for \(damage) \(pointText)!"
            
            playHitOrMissSound("hit")
            updateRightPlayerStats()

        } else {
            statusText.text = "\(leftPlayer.name) missed!"

            playHitOrMissSound("miss")
        }

        if rightPlayer.isPlayerDefeated() {
            
            if rightPlayer.creatureType == CreatureType.Human {
                audioHumanDeath.play()
            } else {
                audioGoblinDeath.play()
            }
            
            rightPlayerButton.hidden = true
            
            playerRoundVictory()
        } else {
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableRightPlayerAttack", userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func rightPlayerAttackButtonTapped(sender: AnyObject) {
        rightPlayerAttackButton.hidden = true
        rightPlayerPotion.enabled = false

        if rightPlayer.isAttackSuccessfulAgainst(leftPlayer) {
            let damage = rightPlayer.attackPower - leftPlayer.armorRating
            let pointText = (damage == 1 ? "point" : "points")
            statusText.text = "\(rightPlayer.name) hit for \(damage) \(pointText)!"
            
            playHitOrMissSound("hit")
            updateLeftPlayerStats()
            
        } else {
            statusText.text = "\(rightPlayer.name) missed!"
            
            playHitOrMissSound("miss")
        }
        
        if leftPlayer.isPlayerDefeated() {

            if leftPlayer.creatureType == CreatureType.Human {
                audioHumanDeath.play()
            } else {
                audioGoblinDeath.play()
            }
            
            leftPlayerButton.hidden = true
            
            playerRoundVictory()
        } else {
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableLeftPlayerAttack", userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func leftPlayerPotionTapped(sender: AnyObject) {
        let potion: String
        switch leftPlayer.potion {
        case .None: potion = ""
        case .Health: potion = "a health"
        case .Attack: potion = "an attack"
        case .Armor: potion = "an armor"
        }
        
        if leftPlayerPotion != .None {
            statusText.text = "\(leftPlayer.name) drank \(potion) potion."
        }
        
        // You forfeit your attack if you use your potion.
        leftPlayer.usePotion()
        audioPotionEffect.play()
        leftPlayerAttackButton.hidden = true
        leftPlayerPotion.hidden = true
        updateLeftPlayerStats()
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableRightPlayerAttack", userInfo: nil, repeats: false)
    }
    
    @IBAction func rightPlayerPotionTapped(sender: AnyObject) {
        let potion: String
        switch rightPlayer.potion {
        case .None: potion = ""
        case .Health: potion = "a health"
        case .Attack: potion = "an attack"
        case .Armor: potion = "an armor"
        }
        
        if rightPlayerPotion != .None {
            statusText.text = "\(rightPlayer.name) drank \(potion) potion."
        }
        
        // You forfeit your attack if you use your potion.
        rightPlayer.usePotion()
        audioPotionEffect.play()
        rightPlayerAttackButton.hidden = true
        rightPlayerPotion.hidden = true
        updateRightPlayerStats()
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableLeftPlayerAttack", userInfo: nil, repeats: false)
    }
    
    
    // MARK: - Methods
    
    func initializeGame() {
        gamePhase = .CharacterSelection
        playerNameLabel.delegate = self
        statusText.text = "Left player - Select a creature type:"
        playerNameLabel.text = ""
        playerNameLabel.hidden = true
        potionStackView.hidden = true
        leftPlayerButton.hidden = false
        rightPlayerButton.hidden = false
        acceptNameButton.hidden = true
        leftPlayerAttackButton.hidden = true
        rightPlayerAttackButton.hidden = true
        leftStackViewStats.hidden = true
        leftParchment.hidden = true
        rightStackViewStats.hidden = true
        rightParchment.hidden = true
        playerSetupComplete = false
        leftPlayerIsChoosingOptions = true
        leftPlayerButton.setImage(UIImage(named: "goblin.png"), forState: UIControlState.Normal)
        rightPlayerButton.setImage(UIImage(named: "human.png"), forState: UIControlState.Normal)
        leftPlayerRoundsWon = 0
        rightPlayerRoundsWon = 0
        roundNumber = 1

        whichPlayerHasInitiative = determineInitiative()
        
        setupAudioPlayers()

        // Loop the "setup background" music indefinitely until explicitly stopped.
        audioPlayerSetupMusic.numberOfLoops = -1
        audioPlayerSetupMusic.play()
    }
    
    func determineInitiative() -> String {
        let random = Int(arc4random_uniform(2)) + 1
        
        if random == 1 {
            return "left"
        } else {
            return "right"
        }
    }
    
    func setupAudioPlayers() {
        
        for (player, file) in audioDictionary {
            
            let path = NSBundle.mainBundle().pathForResource(file, ofType: ".wav")
            let soundURL = NSURL(fileURLWithPath: path!)
            
            do {
                
                let sound = try AVAudioPlayer(contentsOfURL: soundURL)
                sound.prepareToPlay()
                
                switch player {
                case "audioBattleMusic": audioBattleMusic = sound
                case "audioFanfare": audioFanfare = sound
                case "audioFight": audioFight = sound
                case "audioGoblinDeath": audioGoblinDeath = sound
                case "audioHumanDeath": audioHumanDeath = sound
                case "audioPlayerSetupMusic": audioPlayerSetupMusic = sound
                case "audioPotionEffect": audioPotionEffect = sound
                case "audioSwordAttack": audioSwordAttack = sound
                case "audioAttackMissed": audioAttackMissed = sound
                case "audioVictoryCry": audioVictoryCry = sound
                default: break
                }
                
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func initializePlayers() {
        var potion: String
        var creatureName: String
        var creatureImage: UIImage

        // Setup the left player.
        leftPlayer = Player(name: leftPlayerName, creatureType: leftPlayerCreatureType, potion: leftPlayerPotionSelection)
        
        switch leftPlayer.potion {
        case .None: potion = ""
        case .Health: potion = "potion_health.png"
        case .Attack: potion = "potion_attack.png"
        case .Armor: potion = "potion_armor.png"
        }
        
        updateLeftPlayerStats()
        
        if leftPlayerPotion == .None {
            leftPlayerPotion.hidden = true
        } else {
            leftPlayerPotion.setImage(UIImage(named: potion), forState: UIControlState.Normal)
        }
        
        switch leftPlayerCreatureType! {
        case CreatureType.Human: creatureName = "human.png"
        case CreatureType.Goblin: creatureName = "goblin.png"
        }
        
        creatureImage = UIImage(named: creatureName)!
        if leftPlayerCreatureType! == CreatureType.Human {
            creatureImage = UIImage(CGImage: creatureImage.CGImage!, scale: creatureImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        leftPlayerButton.setImage(creatureImage, forState: UIControlState.Normal)
        
        
        // Setup the right player.
        rightPlayer = Player(name: rightPlayerName, creatureType: rightPlayerCreatureType, potion: rightPlayerPotionSelection)
        
        switch rightPlayer.potion {
        case .None: potion = ""
        case .Health: potion = "potion_health.png"
        case .Attack: potion = "potion_attack.png"
        case .Armor: potion = "potion_armor.png"
        }
        
        updateRightPlayerStats()
        
        if rightPlayerPotion == .None {
            rightPlayerPotion.hidden = true
        } else {
            rightPlayerPotion.setImage(UIImage(named: potion), forState: UIControlState.Normal)
        }

        switch rightPlayerCreatureType! {
        case CreatureType.Human: creatureName = "human.png"
        case CreatureType.Goblin: creatureName = "goblin.png"
        }

        creatureImage = UIImage(named: creatureName)!
        if rightPlayerCreatureType! == CreatureType.Goblin {
            creatureImage = UIImage(CGImage: creatureImage.CGImage!, scale: creatureImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        rightPlayerButton.setImage(creatureImage, forState: UIControlState.Normal)
    }
    
    func playHitOrMissSound(attack: String) {
        if attack == "hit" {
        
            if audioSwordAttack.playing {
                audioSwordAttack.stop()
                audioSwordAttack.prepareToPlay()
            }
            audioSwordAttack.play()
            
        } else {
            
            if audioAttackMissed.playing {
                audioAttackMissed.stop()
                audioAttackMissed.prepareToPlay()
            }
            audioAttackMissed.play()
        }
    }
    
    func initializeAttackRound() {
        
        leftParchment.hidden = false
        leftPlayerPotion.hidden = false
        leftStackViewStats.hidden = false
        
        rightParchment.hidden = false
        rightPlayerPotion.hidden = false
        rightStackViewStats.hidden = false

        if whichPlayerHasInitiative == "left" {
            leftPlayerAttackButton.hidden = false
            leftPlayerPotion.enabled = true
            rightPlayerPotion.enabled = false
        } else {
            rightPlayerAttackButton.hidden = false
            rightPlayerPotion.enabled = true
            leftPlayerPotion.enabled = false
        }

        statusText.text = "Round \(roundNumber): FIGHT!"
        audioFight.play()
    }
    
    func setPlayerCreatureType(type: CreatureType) {
        if leftPlayerIsChoosingOptions {
            
            leftPlayerCreatureType = type
            
        } else {
            
            rightPlayerCreatureType = type
        }
    }
    
    func setPlayerName() {
        if leftPlayerIsChoosingOptions {
            
            leftPlayerName = playerNameLabel.text ?? "Left"

        } else {
            
            rightPlayerName = playerNameLabel.text ?? "Right"
        }
        
        playerNameLabel.text = ""
    }
    
    func setPlayerPotionSelection(potion: PotionType) {
        audioPotionEffect.play()
        
        if leftPlayerIsChoosingOptions {
            
            leftPlayerPotionSelection = potion
//            leftPlayerIsChoosingOptions = false
            
        } else {
            
            rightPlayerPotionSelection = potion
            playerSetupComplete = true
        }
    }
    
    func proceedToCharacterSelectionPhase() {
        
        if playerSetupComplete {

            proceedToAttackPhase()

        } else {
            
            gamePhase = .CharacterSelection
            
            if leftPlayerIsChoosingOptions {
                statusText.text = "Left player - Select a creature type:"
            } else {
                statusText.text = "Right player - Select a creature type:"
            }

            potionStackView.hidden = true
            leftPlayerButton.hidden = false
            rightPlayerButton.hidden = false
            
        }
    }
    
    func proceedToCharacterNamePhase() {
        gamePhase = .CharacterName
        statusText.text = "Enter your name:"
        leftPlayerButton.hidden = true
        rightPlayerButton.hidden = true
        playerNameLabel.hidden = false
        acceptNameButton.hidden = false
    }
    
    func proceedToPotionSelectionPhase() {
        gamePhase = .PotionSelection
        
        if leftPlayerIsChoosingOptions {
            statusText.text = "Select a potion, \(leftPlayerName):"
        } else {
            statusText.text = "Select a potion, \(rightPlayerName):"
            playerSetupComplete = true
        }
        
        playerNameLabel.hidden = true
        acceptNameButton.hidden = true
        potionStackView.hidden = false
    }
    
    func proceedToAttackPhase() {
        gamePhase = .AttackRound
        
        if audioPlayerSetupMusic.playing {
            audioPlayerSetupMusic.stop()
        }
        
        potionStackView.hidden = true
        leftPlayerButton.hidden = false
        rightPlayerButton.hidden = false

        initializePlayers()
        
        let firstPlayer = whichPlayerHasInitiative == "left" ? "\(leftPlayer.name)" : "\(rightPlayer.name)"
        statusText.text = "\(firstPlayer) has initiative."

        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "initializeAttackRound", userInfo: nil, repeats: false)
        
        let delay: NSTimeInterval = 3.0
        let now: NSTimeInterval = audioBattleMusic.deviceCurrentTime
        audioBattleMusic.numberOfLoops = -1
        audioBattleMusic.playAtTime(NSTimeInterval(now + delay))
    }
    
    func enableLeftPlayerAttack() {
        leftPlayerAttackButton.hidden = false
        leftPlayerPotion.enabled = true
    }
    
    func enableRightPlayerAttack() {
        rightPlayerAttackButton.hidden = false
        rightPlayerPotion.enabled = true
    }
    
    func updateLeftPlayerStats() {
        leftPlayerHPStat.text = "HP:  \(leftPlayer.hitPoints)"
        leftPlayerATKStat.text = "ATK: \(leftPlayer.attackPower)"
        leftPlayerDEFStat.text = "DEF: \(leftPlayer.armorRating)"
    }
    
    func updateRightPlayerStats() {
        rightPlayerHPStat.text = "HP:  \(rightPlayer.hitPoints)"
        rightPlayerATKStat.text = "ATK: \(rightPlayer.attackPower)"
        rightPlayerDEFStat.text = "DEF: \(rightPlayer.armorRating)"
    }
    
    func playerRoundVictory() {
        
        if leftPlayer.isPlayerDefeated() {
            statusText.text = "\(rightPlayer.name) has won round \(roundNumber)."
            leftPlayerRoundsWon += 1
        } else {
            statusText.text = "\(leftPlayer.name) has won round \(roundNumber)."
            rightPlayerRoundsWon += 1
        }

        if leftPlayerRoundsWon < 2 && rightPlayerRoundsWon < 2 {
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "setupNextRound", userInfo: nil, repeats: false)
        } else {
            NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "setupGameVictory", userInfo: nil, repeats: false)
        }
    }
    
    func setupNextRound() {
        
        roundNumber += 1
        
        if roundNumber == 2 {
            if whichPlayerHasInitiative == "left" {
                whichPlayerHasInitiative = "right"
            } else {
                whichPlayerHasInitiative = "left"
            }
        }
        
        // Randomize who is first on the third round if each
        // player has won one round each so far.
        if roundNumber == 3 {
            whichPlayerHasInitiative = determineInitiative()
        }
        
        leftPlayerButton.hidden = true
        leftStackViewStats.hidden = true
        leftParchment.hidden = true
        leftPlayerPotionSelection = PotionType.None
        
        rightPlayerButton.hidden = true
        rightStackViewStats.hidden = true
        rightParchment.hidden = true
        rightPlayerPotionSelection = PotionType.None
        
        leftPlayerIsChoosingOptions = true
        proceedToPotionSelectionPhase()
    }
    
    func setupGameVictory() {
        audioVictoryCry.play()
        
        leftParchment.hidden = true
        leftStackViewStats.hidden = true
        rightParchment.hidden = true
        rightStackViewStats.hidden = true

        if leftPlayer.isPlayerDefeated() {
            statusText.text = "\(rightPlayer.name) is Victorious!"
        } else {
            statusText.text = "\(leftPlayer.name) is Victorious!"
        }

        NSTimer.scheduledTimerWithTimeInterval(7.0, target: self, selector: "initializeGame", userInfo: nil, repeats: false)
    }
}

