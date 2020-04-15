//
//  ViewController.swift
//  Legend
//
//  Created by Daniel Castro on 2/8/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayRunningImage()
        navigationController?.isNavigationBarHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func displayRunningImage() {
        let welcomeImage = Player(playerType: "knight_m_run")
        imageView.animationImages = welcomeImage.idleAnimation()
        imageView.animationDuration = 0.5
        imageView.startAnimating()
    }

}

