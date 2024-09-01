//
//  CountDownViewController.swift
//  BubblePop
//
//  Created by Yue Yin on 2022/4/16.
//

import UIKit

class CountDownViewController: UIViewController {
    
    var newPlayer: Player?;
    var countDownTime = 5;
    var hint = Hint();
    var timer = Timer();
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var hintContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load greetings with player name
        greetingLabel.text = "Welcome, \(newPlayer?.name ?? "Unknown")";
        //Countdown label is set to start from 5
        counterLabel.text = String(countDownTime);
        //Starts timer and selects update timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true);
        //Load hint content
        hintContentLabel.text = hint.generateHint();
    }
    
    //Update the counterLabel every 1 second to make it count down
    @objc func updateTimer() {
        if(countDownTime != -1) {
            counterLabel.text = String(countDownTime);
            countDownTime -= 1;
        } else {
            //Once done perform segues
            self.performSegue(withIdentifier: "goToBubbleGame", sender: self);
            timer.invalidate();
        }
    }
    
    //Pass newPlayer obj to the Bubble Game View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If Segue is countdown segue
        if(segue.identifier == "goToBubbleGame") {
            let destinationVC = segue.destination as! BubbleGameViewController;
            //Pass player obj to new segue
            destinationVC.newPlayer = newPlayer;
        }
    }
}
