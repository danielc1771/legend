//
//  ChallengeSelectEnemyViewController.swift
//  Legend
//
//  Created by Daniel Castro on 4/6/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

class ChallengeSelectViewController: UIViewController {
    var player: Player?
    var user: User?
    @IBOutlet weak var enemyTableView: UITableView!
    
    var enemies: [Enemy] = []
    var enemyToChallenge:Enemy?
    
    override func viewWillAppear(_ animated: Bool) {
        enemies = [Ogre()]
    }
    
    override func viewDidLoad() {
        enemyTableView.delegate = self
        enemyTableView.dataSource = self
    }
    
    func challengeEnemy(enemy: Enemy) {
        if(user!.strengthLevel >= enemy.strRequirement && user!.agilityLevel >= enemy.agiRequirement) {
            enemyToChallenge = enemy
            performSegue(withIdentifier: "selectToChallenge", sender: self)
        } else {
            let alert = UIAlertController(title: "Your STR or AGI is not at the required level.", message: "Go train!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectToChallenge" {
            let vc = segue.destination as! ChallengeViewController
            vc.enemy = enemyToChallenge
            vc.user = user
            vc.player = player
        }
    }
}

extension ChallengeSelectViewController: UITableViewDataSource, UITableViewDelegate {
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enemies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"EnemyCell", for: indexPath) as! EnemyCell
        
        let enemy = enemies[indexPath.row]
        cell.enemyNameTextLabel.text = enemy.name
        cell.levelRequirementsTextLabel.text = "STR:\(enemy.strRequirement) AGI: \(enemy.agiRequirement)"
        cell.enemyImageView.image = UIImage(named: enemy.defaultPicString)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let enemy = enemies[indexPath.row]
        challengeEnemy(enemy: enemy)
    }

}

