//
//  MenuViewController.swift
//  BubblePop
//
//  Created by Yue Yin on 2022/4/16.
//

import UIKit

class MenuViewController: UIViewController {
    
    var newPlayer = Player();
    var timeVal = 60; //Set game time
    var maxBubbleVal = 15; //Set number of bubbles
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxBubbleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //UISlider to set the game time
    @IBAction func timeSlider(_ sender: UISlider) {
        let time = Int(sender.value);
        //Visualize the slider value in the label
        timeLabel.text = String(time);
        timeVal = time;
    }
    
    //UISlider to set the number of bubbles
    @IBAction func maxBubbleSlider(_ sender: UISlider) {
        let maxBubble = Int(sender.value);
        //Visualize the slider value in the label
        maxBubbleLabel.text = String(maxBubble);
        maxBubbleVal = maxBubble;
    }
    
    //Press start button to move to the countdown screen
    @IBAction func startButtonPressed(_ sender: UIButton) {
        //Validate and set player name
        newPlayer.setName(playerName: nameTextField.text!);
        //Set Settings
        newPlayer.setSettings(timeVal: timeVal, maxBubbleVal: maxBubbleVal)
        //Pass newPlayer obj with settings and player info
        self.performSegue(withIdentifier: "goToCountDown", sender:self)
    }
    
    //Press leaderboard button to move to the leaderboard
    @IBAction func leaderboardButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCheckLeaderboard", sender:self);
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If segue is countdown segue
        if(segue.identifier == "goToCountDown") {
            let destinationVC = segue.destination as! CountDownViewController;
            //Pass player obj to new segue
            destinationVC.newPlayer = newPlayer;
        }
    }
}
