//
//  ChallengeViewController.swift
//  Legend
//
//  Created by Daniel Castro on 4/2/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import SpriteKit
import UIKit

class ChallengeViewController: UIViewController {
    
    var enemy: Enemy?
    var player: Player?
    var user: User?
    var enemyOriginalHealth: Float = 0
    var opponentHpBar: ProgressBar?
    var playerHpBar: ProgressBar?
    var statusLabel: SKLabelNode?
    var playerCanAttack:Bool = true
    
    let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
    
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var gameView: SKView!
    
    override func viewWillAppear(_ animated: Bool) {
        playerCanAttack = true
        
        enemyOriginalHealth = Float(enemy!.health)
        
        // Animate the player
        playerImageView.animationImages = player!.idleAnimation()
        playerImageView.animationDuration = 0.5
        playerImageView.startAnimating()
        
        // Animate the enemy
        enemyImageView.animationImages = enemy!.idleAnimation()
        enemyImageView.animationDuration = 0.5
        enemyImageView.startAnimating()
        
        // Create the game scene
        let scene = SKScene(size: gameView.bounds.size)
        scene.backgroundColor = .white
        
        
        let backgroundForest = SKSpriteNode(imageNamed: "forest")
        backgroundForest.position = CGPoint(x: gameView.bounds.width / 2, y: gameView.bounds.height / 2)
        scene.addChild(backgroundForest)
        
        
        // Create the status label
        statusLabel = SKLabelNode(fontNamed: "AmericanTypewriter-bold")
        statusLabel!.fontColor = .black
        statusLabel!.fontSize = 19
        statusLabel!.position = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY - 30)
        
        scene.addChild(statusLabel!)
        
        
        // Create opponent HP Bar
        let opponentHpBackground = SKShapeNode(rectOf: CGSize(width: 180, height: 11), cornerRadius: 5)
        opponentHpBackground.position = CGPoint(x: 140, y: 560)
        opponentHpBackground.zPosition = 2
        opponentHpBackground.strokeColor = .black
        opponentHpBackground.fillColor = .black
        scene.addChild(opponentHpBackground)
        
        let opponentHpContainer = SKShapeNode(rectOf: CGSize(width: 150, height: 10), cornerRadius: 5)
        opponentHpContainer.position = CGPoint(x: 156, y: 560)
        opponentHpContainer.zPosition = 4
        opponentHpContainer.strokeColor = .lightGray
        opponentHpContainer.lineWidth = 2
        scene.addChild(opponentHpContainer)
        
        let opponentHpLabel = SKLabelNode(text: "HP")
        opponentHpLabel.horizontalAlignmentMode = .center
        opponentHpLabel.position = CGPoint(x: 66, y: 555)
        opponentHpLabel.fontColor = .orange
        opponentHpLabel.fontName = "AmericanTypewriter-bold"
        opponentHpLabel.fontSize = 12
        opponentHpLabel.zPosition = 3
        
        scene.addChild(opponentHpLabel)
        
        opponentHpBar = {
            let progressBar = ProgressBar(color: .green, size: CGSize(width: 150, height: 8))
            progressBar.position = CGPoint(x: 156, y: 560)
            progressBar.progress = 1.0
            return progressBar
        }()
        
        scene.addChild(opponentHpBar!)
        
        // Create player HP Bar
        let playerHpBackground = SKShapeNode(rectOf: CGSize(width: 180, height: 11), cornerRadius: 5)
        playerHpBackground.position = CGPoint(x: playerImageView.bounds.maxX + 140, y: playerImageView.bounds.maxY)
        playerHpBackground.zPosition = 2
        playerHpBackground.strokeColor = .black
        playerHpBackground.fillColor = .black
        scene.addChild(playerHpBackground)
        
        let playerHpContainer = SKShapeNode(rectOf: CGSize(width: 150, height: 10), cornerRadius: 5)
        playerHpContainer.position = CGPoint(x:  playerImageView.bounds.maxX + 156, y: playerImageView.bounds.maxY)
        playerHpContainer.zPosition = 4
        playerHpContainer.strokeColor = .lightGray
        playerHpContainer.lineWidth = 2
        scene.addChild(playerHpContainer)
        

        let playerHpLabel = SKLabelNode(text: "HP")
        playerHpLabel.horizontalAlignmentMode = .center
        playerHpLabel.position = CGPoint(x: playerImageView.bounds.maxX + 66, y: playerImageView.bounds.maxY - 5)
        playerHpLabel.fontColor = .orange
        playerHpLabel.fontName = "AmericanTypewriter-bold"
        playerHpLabel.fontSize = 12
        playerHpLabel.zPosition = 3

        scene.addChild(playerHpLabel)
        
        playerHpBar = {
            let progressBar = ProgressBar(color: .green, size: CGSize(width: 150, height: 8))
            progressBar.position = CGPoint(x: playerImageView.bounds.maxX + 156, y: playerImageView.bounds.maxY)
            progressBar.progress = 1.0
            return progressBar
        }()
        
        scene.addChild(playerHpBar!)
        
        
        gameView.presentScene(scene)
        
        // Start battle
        battle()
    }
    
    func updateEnemyHpBar() {
        opponentHpBar?.progress = CGFloat(Float(enemy!.health) / enemyOriginalHealth)
    }
    
    func updatePlayerHpBar() {
        playerHpBar?.progress = CGFloat(Float(player!.health) / 100)
    }
    
    
    @IBAction func punchButtonPressed(_ sender: Any) {
        if(playerCanAttack) {
            enemy!.takeDamage(damage: 20)
            statusLabel!.text = "You punch the enemy!"
            updateEnemyHpBar()
            playerCanAttack = false
        }

   
    }
    
    @IBAction func kickButtonPressed(_ sender: Any) {
        if(playerCanAttack) {
            enemy!.takeDamage(damage: 120)
            statusLabel!.text = "You kick the enemy!"
            updateEnemyHpBar()
            playerCanAttack = false
        }
    }
    
    @IBAction func dodgeButtonPressed(_ sender: Any) {
        player!.setDodgeNextAttack(true)
        playerCanAttack = false
    }
    
    @IBAction func runAwayButtonPressed(_ sender: Any) {
        print("Successfully ran away!")
    }
    
    
    func battle() {
        dispatchQueue.async {
            while(true) {
                // Player goes first
                while(self.playerCanAttack) {
                    self.playerTurn()
                }
                sleep(2)
                if (self.enemy!.health <= 0) {
                    self.endBattle(victoryStatus: true)
                    break
                }
                // Enemy goes next
                self.enemyTurn()
                if (self.player!.health <= 0) {
                    self.endBattle(victoryStatus: false)
                    break
                }
            }
        }
    }
    
    func endBattle(victoryStatus: Bool) {
        playerCanAttack = false
        // If player won
        if (victoryStatus) {
            statusLabel!.text = "You defeated the \(enemy!.name)!"
            sleep(1)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "challengeToVictory", sender: self)
            }
 
        } else {
            // If enemy won
            statusLabel!.text = "You were defeated! You run away!"
            sleep(2)
            DispatchQueue.main.async {
                let vcs = self.navigationController?.viewControllers
                let tabBar = vcs![vcs!.count - 2] as! TabBarController
                self.navigationController?.popViewController(animated: false)
                tabBar.selectedIndex = 1
            }
        }
    }
    
    func playerTurn() {
        
    }
    
    func enemyTurn() {
        let enemyDamage = enemy!.attack()
        if(!player!.dodgedNextAttack) {
            player!.takeDamage(damage: enemyDamage)
            statusLabel!.text = "Enemy attacks you for \(enemyDamage)!"
            updatePlayerHpBar()
        } else {
            statusLabel!.text = "You dodged the attack!"
            player!.setDodgeNextAttack(false)
        }
        playerCanAttack = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "challengeToVictory" {
            let vc = segue.destination as! VictoryViewController
            vc.user = user
        }
    }
}

class ProgressBar:SKNode {
    var bar:SKSpriteNode?
    var _progress:CGFloat = 0
    var progress:CGFloat {
        get {
            return _progress
        }
        set {
            let value = max(min(newValue, 1.0), 0.0)
            if let bar = bar {
                bar.xScale = value
                _progress = value
            }
        }
    }
    
    convenience init(color: SKColor, size: CGSize) {
        self.init()
        bar = SKSpriteNode(color: color, size: size)
        if let bar = bar {
            bar.xScale = 0
            bar.zPosition = 3
            bar.position = CGPoint(x: -size.width / 2, y: 0)
            bar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            addChild(bar)
        }
    }
}

