//
//  ViewController.swift
//  FantasyDuel
//
//  Created by William L. Marr III on 3/9/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var playerNameLabel: UITextField!
    @IBOutlet weak var potionStackView: UIStackView!
    @IBOutlet weak var playerOneButton: UIButton!
    @IBOutlet weak var playerTwoButton: UIButton!
    

    // MARK: - Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Action methods
    
    @IBAction func playerOneButtonTapped(sender: AnyObject) {
    }

    @IBAction func playerTwoButtonTapped(sender: AnyObject) {
    }

    @IBAction func healthPotionTapped(sender: AnyObject) {
    }
    
    @IBAction func armorPotionTapped(sender: AnyObject) {
    }
    
    @IBAction func attackPotionTapped(sender: AnyObject) {
    }
}

