//
//  GameController.swift
//  FantasyDuel
//
//  Created by William L. Marr III on 3/16/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

// **********************************************************
// Credits & Attributions for audio files used in this app //
// **********************************************************
//
// I downloaded all of the audio files from http://freesound.org
//
// I renamed them as appropriate for this iOS app; the first line is the name
// of the file as used in this app, along with the link to the page for the
// audio file, and then any credit requirements as specified by the author.
//
//
// snd_duels_music.wav - http://freesound.org/people/dingo1/sounds/243979/
//      Track Name: "Dragon Warrior (Loopable).wav"
//      Composed by: Marcus Dellicompagni
//      Website: www.PoundSound.co.uk
//
// snd_fanfare.wav - http://freesound.org/people/chripei/sounds/165492/
//      Track name: "VICTORY CRY REVERB 1.wav"
//      Author: chripei
//
// snd_fight.wav - http://freesound.org/people/manuts/sounds/320000/
//      Track name: "FIGHT!.wav"
//      Author: manuts
//
// snd_goblin_death.wav - http://freesound.org/people/spookymodem/sounds/249813/
//      Track name: "Goblin Death.wav"
//      Author: spookymodem
//
// snd_human_death.wav - http://freesound.org/people/Replix/sounds/173126/
//      Track name: "Death sound (male)"
//      Author: Replix
//
// snd_player_setup.wav - http://freesound.org/people/zagi2/sounds/204196/
//      Track name: "military march intro 3.wav"
//      Author: zagi2
//
// snd_potion-effect.wav - http://freesound.org/people/Jamius/sounds/41529/
//      Track name: "PotionDrinkLONG.wav"
//      Author: Jamius
//
// snd_sword_attack.wav - http://freesound.org/people/audione/sounds/52458/
//      Track name: "sword-01.wav"
//      Author: audione
//
// snd_missed.wav - http://freesound.org/people/PorkMuncher/sounds/263595/
//      Track name: "swoosh.wav"
//      Author: PorkMuncher
//
// snd_victory_cry.wav - http://freesound.org/people/zagi2/sounds/193934/
//      Track name: "fanfare announcement.wav"
//      Author: zagi2
//
// **********************************************************


import Foundation
import UIKit
import AVFoundation


// MARK: - Game phases enumeration

enum GamePhase {
    case NewGame
    case PlayerSetup
    case Combat
    case BetweenRounds
}

enum PlayerPosition {
    case Left
    case Right
}


// MARK: - GameController class

class GameController {

    
    // MARK: - Properties - private
    
    private var leftPlayer: Player!
    private var rightPlayer: Player!

    private var audioBattleMusic: AVAudioPlayer!
    private var audioFanfare: AVAudioPlayer!
    private var audioFight: AVAudioPlayer!
    private var audioGoblinDeath: AVAudioPlayer!
    private var audioHumanDeath: AVAudioPlayer!
    private var audioPlayerSetupMusic: AVAudioPlayer!
    private var audioPotionEffect: AVAudioPlayer!
    private var audioSwordAttack: AVAudioPlayer!
    private var audioAttackMissed: AVAudioPlayer!
    private var audioVictoryCry: AVAudioPlayer!
    
    private var audioDictionary: [String: String] = [
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

    
    // MARK: Properties - public
    
    var leftPlayerName = "Left player"
    var leftPlayerCreatureType: CreatureType = .Goblin
    var leftPlayerPotion: PotionType = .None
    var leftPlayerRoundsWon = 0
    var leftPlayerHitPoints: Int { return leftPlayer.hitPoints }
    var leftPlayerAttackPower: Int { return leftPlayer.attackPower }
    var leftPlayerArmorRating: Int { return leftPlayer.armorRating }
    var leftPlayerSetupComplete = false
    
    var rightPlayerName = "Right player"
    var rightPlayerCreatureType: CreatureType = .Human
    var rightPlayerPotion: PotionType = .None
    var rightPlayerRoundsWon = 0
    var rightPlayerHitPoints: Int { return rightPlayer.hitPoints }
    var rightPlayerAttackPower: Int { return rightPlayer.attackPower }
    var rightPlayerArmorRating: Int { return rightPlayer.armorRating }
    var rightPlayerSetupComplete = false
    
    var gamePhase: GamePhase = .NewGame
    var whichPlayerHasInitiative: PlayerPosition = .Left
    var whichPlayerIsUp: PlayerPosition = .Left
    var playerSetupPhaseComplete = false
    var roundNumber = 0
    
    
    // MARK: - Methods - private
    
    private func setupAudioPlayers() {
        print("gc: setupAudioPlayers()")
        
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

    private func determineInitiative() -> PlayerPosition {
        print("gc: determineInitiative()")
        
        let random = Int(arc4random_uniform(20)) + 1

        if random % 2 == 0 {
            return .Left
        } else {
            return .Right
        }
    }
    
    
    // MARK: Methods - public
    
    init() {
        print("gc: init()")
        
        setupAudioPlayers()
        
        // Loop the "setup background" music indefinitely until explicitly stopped.
        audioBattleMusic.numberOfLoops = -1
        audioBattleMusic.play()
    }

    func startNewGame() {
        print("gc: startNewGame()")

        gamePhase = .PlayerSetup
        leftPlayerSetupComplete = false
        rightPlayerSetupComplete = false
        leftPlayerPotion = .None
        rightPlayerPotion = .None
        leftPlayerRoundsWon = 0
        rightPlayerRoundsWon = 0
        playerSetupPhaseComplete = false
        roundNumber = 0
        
        whichPlayerHasInitiative = determineInitiative()
        whichPlayerIsUp = whichPlayerHasInitiative
        
        if audioVictoryCry.playing {
            audioVictoryCry.stop()
            audioVictoryCry.currentTime = NSTimeInterval(0)
            audioVictoryCry.prepareToPlay()
        }
        
        if audioBattleMusic.playing {
            audioBattleMusic.stop()
            audioBattleMusic.currentTime = NSTimeInterval(0)
            audioBattleMusic.prepareToPlay()
        }

        // Loop the "player setup" music indefinitely until explicitly stopped.
        audioPlayerSetupMusic.numberOfLoops = -1
        audioPlayerSetupMusic.play()
    }
    
    func startNextCombatRound() {
        print("gc: startNextCombatRound")
        
        gamePhase = .Combat
        roundNumber += 1
        
        // To be fair, the player who was not first on
        // the first combat round gets to go first on
        // the second combat round.
        if roundNumber == 2 {
            switch whichPlayerHasInitiative {
            case .Left: whichPlayerHasInitiative = .Right
            case .Right: whichPlayerHasInitiative = .Left
            }
        } else if roundNumber == 3 {
            // Randomly decide who's first on the third combat round.
            whichPlayerHasInitiative = determineInitiative()
        }

        whichPlayerIsUp = whichPlayerHasInitiative

        if audioPlayerSetupMusic.playing {
            audioPlayerSetupMusic.stop()
            audioPlayerSetupMusic.currentTime = NSTimeInterval(0)
            audioPlayerSetupMusic.prepareToPlay()
        }
        
        var delay: NSTimeInterval = 1.5
        var now: NSTimeInterval = audioFight.deviceCurrentTime
        audioFight.playAtTime(NSTimeInterval(now + delay))
        
        delay = 2.75
        now = audioBattleMusic.deviceCurrentTime
        audioBattleMusic.playAtTime(NSTimeInterval(now + delay))
    }
    
    func nextPlayerIsUp() {
        print("gc: nextPlayerIsUp()")
        
        if whichPlayerIsUp == .Left {
            whichPlayerIsUp = .Right
        } else {
            whichPlayerIsUp = .Left
        }
    }
    
    func pickNewPotions() {
        print("gc: pickNewPotions()")
        
        // Let the player who went second on the last combat
        // round be the first to pick potions this turn.
        switch whichPlayerHasInitiative {
        case .Left: whichPlayerIsUp = .Right
        case .Right: whichPlayerIsUp = .Left
        }
    }
    
    func setPlayerName(name: String) {
        print("gc: setPlayerName()")
        
        switch whichPlayerIsUp {
        case .Left: leftPlayerName = name
        case .Right: rightPlayerName = name
        }
    }
    
    func setPlayerCreatureType(type: CreatureType) {
        print("gc: setPlayerCreatureType()")
        
        switch whichPlayerIsUp {
        case .Left: leftPlayerCreatureType = type
        case .Right: rightPlayerCreatureType = type
        }
    }
    
    func setPlayerPotionSelection(potion: PotionType) {
        print("gc: setPlayerPotionSelection()")
        
        switch whichPlayerIsUp {
        case .Left:
            leftPlayerPotion = potion
            leftPlayerSetupComplete = true
        case .Right:
            rightPlayerPotion = potion
            rightPlayerSetupComplete = true
        }
        
        audioPotionEffect.play()
        
        if leftPlayerSetupComplete && rightPlayerSetupComplete {
            gamePhase = .Combat
            playerSetupPhaseComplete = true
            
            leftPlayer = Player(name: leftPlayerName, creatureType: leftPlayerCreatureType, potion: leftPlayerPotion)
            rightPlayer = Player(name: rightPlayerName, creatureType: rightPlayerCreatureType, potion: rightPlayerPotion)

            // Since the player setup phase is finished,
            // the player that has not yet selected their potion
            // in between combat rounds can now do so.
            // If both players have selected their potions,
            // proceed to the combat phase.
            if (leftPlayerPotion == .None) || (rightPlayerPotion == .None)
            {
                gamePhase = .PlayerSetup
                nextPlayerIsUp()
            }
            
        } else {
            nextPlayerIsUp()
        }
    }
    
    func usePotion() {
        print("gc: usePotion()")
        
        switch whichPlayerIsUp {
        case .Left:
            leftPlayer.usePotion()
            leftPlayerPotion = .None
        case .Right:
            rightPlayer.usePotion()
            rightPlayerPotion = .None
        }
        
        audioPotionEffect.play()
        
        nextPlayerIsUp()
    }
    
    func isAttackSuccessful() -> Bool {
        print("gc: isAttackSuccessful()")
        
        let attackSuccessful: Bool
        
        switch whichPlayerIsUp {
        case .Left: attackSuccessful = leftPlayer.isAttackSuccessfulAgainst(rightPlayer)
        case .Right: attackSuccessful = rightPlayer.isAttackSuccessfulAgainst(leftPlayer)
        }
        
        if attackSuccessful {
            if audioSwordAttack.playing {
                audioSwordAttack.stop()
                audioSwordAttack.currentTime = NSTimeInterval(0)
                audioSwordAttack.prepareToPlay()
            }
            audioSwordAttack.play()
            
        } else {
            
            if audioAttackMissed.playing {
                audioAttackMissed.stop()
                audioAttackMissed.currentTime = NSTimeInterval(0)
                audioAttackMissed.prepareToPlay()
            }
            audioAttackMissed.play()
        }
        
        return attackSuccessful
    }
    
    func calculateDamage() -> Int {
        print("gc: calculateDamage()")
        
        switch whichPlayerIsUp {
        case .Left: return leftPlayer.attackPower - rightPlayer.armorRating
        case .Right: return rightPlayer.attackPower - leftPlayer.armorRating
        }
    }

    func playerWonCombatRound() -> Bool {
        print("gc: playerWonCombatRound()")
        
        var wonCombatRound: Bool
        
        switch whichPlayerIsUp {
        case .Left:
            wonCombatRound = rightPlayer.isPlayerDefeated()
            
            if wonCombatRound {
                leftPlayerRoundsWon += 1

                switch rightPlayerCreatureType {
                case .Goblin: audioGoblinDeath.play()
                case .Human: audioHumanDeath.play()
                }
            }
        case .Right:
            wonCombatRound = leftPlayer.isPlayerDefeated()

            if wonCombatRound {
                rightPlayerRoundsWon += 1
                
                switch leftPlayerCreatureType {
                case .Goblin: audioGoblinDeath.play()
                case .Human: audioHumanDeath.play()
                }
            }
        }
        
        // Reset the potions for the next combat round.
        if wonCombatRound {
            gamePhase = .BetweenRounds
            leftPlayerPotion = .None
            leftPlayerSetupComplete = false
            rightPlayerPotion = .None
            rightPlayerSetupComplete = false
            
            let delay: NSTimeInterval = 2.0
            let now: NSTimeInterval = audioFanfare.deviceCurrentTime
            audioFanfare.playAtTime(NSTimeInterval(now + delay))
        }
        
        return wonCombatRound
    }
    
    func playerWonGame() -> Bool {
        print("gc: playerWonGame()")
        
        var wonGame = false
        
        switch whichPlayerIsUp {
        case .Left:
            if leftPlayerRoundsWon >= 2 {
                wonGame = true
            }
        case .Right:
            if rightPlayerRoundsWon >= 2 {
                wonGame = true
            }
        }
        
        if wonGame {
            gamePhase = .NewGame
            
            var delay: NSTimeInterval
            var now: NSTimeInterval

            delay = 1.5
            now = audioVictoryCry.deviceCurrentTime
            audioVictoryCry.playAtTime(NSTimeInterval(now + delay))

            delay = 2.5
            now = audioFanfare.deviceCurrentTime
            audioFanfare.playAtTime(NSTimeInterval(now + delay))
        }
        
        return wonGame
    }
}

