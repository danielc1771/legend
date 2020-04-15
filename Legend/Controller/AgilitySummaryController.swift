//
//  AgilitySummaryController.swift
//  Legend
//
//  Created by Daniel Castro on 3/30/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

class AgilitySummaryController: UIViewController {
    var expGained:Int = 0
    var activityText = ""
    var durationText = ""
    var distanceText = ""
    
    @IBOutlet weak var activityTextLabel: UILabel!
    @IBOutlet weak var durationTextLabel: UILabel!
    @IBOutlet weak var distanceTextLabel: UILabel!
    @IBOutlet weak var expGainedTextLabel: UILabel!
    
    override func viewDidLoad() {
        activityTextLabel.text! += " \(activityText)"
        durationTextLabel.text! += " \(durationText)"
        distanceTextLabel.text! += " \(distanceText)"
        expGainedTextLabel.text! += " \(expGained)XP"
    }
    
    @IBAction func finishedButtonPressed(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
