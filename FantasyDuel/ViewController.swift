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

class ViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var playerNameLabel: UITextField!
    @IBOutlet weak var potionStackView: UIStackView!
    @IBOutlet weak var leftPlayerButton: UIButton!
    @IBOutlet weak var rightPlayerButton: UIButton!
    @IBOutlet weak var acceptNameButton: UIButton!
    @IBOutlet weak var leftPlayerAttackButton: UIButton!
    @IBOutlet weak var rightPlayerAttackButton: UIButton!
    
    
    // MARK: - Properties
    
    var leftPlayer: Player!
    var leftPlayerCreatureType: CreatureType!
    var leftPlayerName = ""
    var leftPlayerPotionSelection: PotionType!

    var rightPlayer: Player!
    var rightPlayerCreatureType: CreatureType!
    var rightPlayerName = ""
    var rightPlayerPotionSelection: PotionType!
    
    var gamePhase: GamePhase = .CharacterSelection
    var leftPlayerIsChoosingOptions = true
    var playerSetupComplete = false
    var whichPlayerIsFirst = 1
    
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
        proceedToCharacterSelectionPhase()
    }
    
    @IBAction func armorPotionTapped(sender: AnyObject) {
        setPlayerPotionSelection(PotionType.Armor)
        proceedToCharacterSelectionPhase()
    }
    
    @IBAction func attackPotionTapped(sender: AnyObject) {
        setPlayerPotionSelection(PotionType.Attack)
        proceedToCharacterSelectionPhase()
    }
    
    @IBAction func leftPlayerAttackButtonTapped(sender: AnyObject) {
        leftPlayerAttackButton.hidden = true
        print("left attack")
        
        if leftPlayer.isAttackSuccessfulAgainst(rightPlayer) {
            statusText.text = "\(leftPlayer.name) hit \(rightPlayer.name)!"
            
            playHitOrMissSound("hit")

        } else {
            statusText.text = "\(leftPlayer.name) missed!"

            playHitOrMissSound("miss")
        }

        if rightPlayer.isPlayerDefeated() {
            playerVictory()
        } else {
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableRightPlayerAttack", userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func rightPlayerAttackButtonTapped(sender: AnyObject) {
        rightPlayerAttackButton.hidden = true
        print("right attack")

        if rightPlayer.isAttackSuccessfulAgainst(leftPlayer) {
            statusText.text = "\(rightPlayer.name) hit \(leftPlayer.name)!"
            
            playHitOrMissSound("hit")
            
        } else {
            statusText.text = "\(rightPlayer.name) missed!"
            
            playHitOrMissSound("miss")
        }
        
        if leftPlayer.isPlayerDefeated() {
            playerVictory()
        } else {
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableLeftPlayerAttack", userInfo: nil, repeats: false)
        }
    }
    
    
    // MARK: - Methods
    
    func initializeGame() {
        gamePhase = .CharacterSelection
        statusText.text = "Select a creature type:"
        playerNameLabel.text = ""
        playerNameLabel.hidden = true
        potionStackView.hidden = true
        leftPlayerButton.hidden = false
        rightPlayerButton.hidden = false
        acceptNameButton.hidden = true
        leftPlayerAttackButton.hidden = true
        rightPlayerAttackButton.hidden = true
        playerSetupComplete = false
        leftPlayerIsChoosingOptions = true
        
        whichPlayerIsFirst = Int(arc4random_uniform(2)) + 1
        
        setupAudioPlayers()

        // Loop the "setup background" music indefinitely until explicitly stopped.
        audioPlayerSetupMusic.numberOfLoops = -1
        audioPlayerSetupMusic.play()
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
    
    func initializePlayers() {
        leftPlayer = Player(name: leftPlayerName, creatureType: leftPlayerCreatureType, potion: leftPlayerPotionSelection)
        rightPlayer = Player(name: rightPlayerName, creatureType: rightPlayerCreatureType, potion: rightPlayerPotionSelection)
    }
    
    func playHitOrMissSound(attack: String) {
        if attack == "hit" {
        
            if audioSwordAttack.playing {
                print("playing: attack")
                audioSwordAttack.stop()
                audioSwordAttack.prepareToPlay()
            }
            audioSwordAttack.play()
            
        } else {
            
            if audioAttackMissed.playing {
                print("playing: missed")
                audioAttackMissed.stop()
                audioAttackMissed.prepareToPlay()
            }
            audioAttackMissed.play()
        }
    }
    
    func initializeAttackRound() {
        if whichPlayerIsFirst == 1 {
            leftPlayerAttackButton.hidden = false
        } else {
            rightPlayerAttackButton.hidden = false
        }
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
            leftPlayerIsChoosingOptions = false
            
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
            statusText.text = "Select a creature type:"
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
        statusText.text = "Select a potion:"
        playerNameLabel.hidden = true
        acceptNameButton.hidden = true
        potionStackView.hidden = false
    }
    
    func proceedToAttackPhase() {
        gamePhase = .AttackRound
        statusText.text = "Players ready to fight..."
        potionStackView.hidden = true
        leftPlayerButton.hidden = false
        rightPlayerButton.hidden = false

        initializePlayers()
        audioPlayerSetupMusic.stop()

        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "initializeAttackRound", userInfo: nil, repeats: false)
        
        statusText.text = "FIGHT!"
        audioFight.play()

        let delay: NSTimeInterval = 1.0
        let now: NSTimeInterval = audioBattleMusic.deviceCurrentTime
        audioBattleMusic.numberOfLoops = -1
        audioBattleMusic.playAtTime(NSTimeInterval(now + delay))
    }
    
    func enableLeftPlayerAttack() {
        leftPlayerAttackButton.hidden = false
    }
    
    func enableRightPlayerAttack() {
        rightPlayerAttackButton.hidden = false
    }
    
    func playerVictory() {
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "setupVictory", userInfo: nil, repeats: false)
    }
    
    func setupVictory() {
        audioVictoryCry.play()

        if leftPlayer.isPlayerDefeated() {
            statusText.text = "\(rightPlayer.name) is Victorious!"
        } else {
            statusText.text = "\(leftPlayer.name) is Victorious!"
        }

        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "initializeGame", userInfo: nil, repeats: false)
    }
}

