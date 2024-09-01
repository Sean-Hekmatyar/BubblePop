//
//  BubbleGameViewController.swift
//  BubblePop
//
//  Created by Yue Yin on 2022/4/18.
//

import UIKit
import AVFoundation

class BubbleGameViewController: UIViewController {
    
    var viewWidth = UInt32(UIScreen.main.bounds.width);
    var viewHeight = UInt32(UIScreen.main.bounds.height);
    
    var playerScores = [Player]();
    var newPlayer: Player?;
    var timer = Timer();
    var bubble = Bubble();
    var bubbles = [Bubble]();
    var countDownTime = 60;
    var maxBubble = 15;
    var score: Double = 0.0;
    var previousBubblePoint: Double = 0.0;
    let ptsMutiplier = 1.5;
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("leaderboard.plist");
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Apply user settings
        countDownTime = newPlayer?.time ?? 60;
        maxBubble = newPlayer?.maxBubble ?? 15;
        
        //Get and display highscore from leaderboard
        getLeaderboard();
        highScoreLabel.text = String(getHighest());
        
        //Timer to update time, remove and generate new bubbles every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.updateTimer();
            self.removeBubble();
            self.generateBubbles();
        }
    }
    
    //Update countdown timer
    @objc func updateTimer() {
        if(countDownTime != 0) {
            timeLeftLabel.text = String(countDownTime);
            countDownTime -= 1;
        } else {
            timer.invalidate();
            newPlayer?.setScore(finalScore: score);
            saveScore();
            self.performSegue(withIdentifier: "goToLeaderboard", sender: self);
        }
    }
    
    //Generate bubbles
    @objc func generateBubbles() {
        var xCons = UInt32(8);
        var yCons = UInt32(160);
        var positionConstX = UInt32(20);
        var positionConstY = UInt32(160);
        var temp: UInt32;
        
        //Adjust if the screen orientation is landscape
        if(viewHeight < viewWidth) {
            temp = xCons;
            xCons = yCons;
            yCons = temp;
            temp = positionConstX;
            positionConstX = positionConstY;
            positionConstY = positionConstX;
        }
        
        //Generate random number of bubbles
        let numOfBubbles = Int.random(in: 1..<(maxBubble - bubbles.count));
        var i = 0;
        
        while(i < numOfBubbles) {
            bubble = Bubble();
            //Create circle in random x, y position within the boundary
            bubble.frame = CGRect(x: CGFloat(xCons + arc4random_uniform(viewWidth - 2 * bubble.radius - positionConstX)), y: CGFloat(yCons + arc4random_uniform(viewHeight - 2 * bubble.radius - positionConstY)), width: CGFloat(2 * bubble.radius), height: CGFloat(2 * bubble.radius));
            //Create bubble subview only if it does not intercept other bubble
            if(!bubble.checkIntersect(currentBubble: bubble, bubbles: bubbles)) {
                bubble.addTarget(self, action: #selector(popBubble), for: UIControl.Event.touchUpInside);
                view.addSubview(bubble);
                i += 1;
                //Add bubble into array
                bubbles += [bubble];
            }
        }
    }
    
    //Tapping bubbles
    @IBAction func popBubble(_ sender: Bubble) {
        //Remove from superview
        sender.removeFromSuperview();
        //Check if previous bubble is the same color
        if(previousBubblePoint == sender.points) {
            score += (sender.points * ptsMutiplier);
        } else {
            //Add points to existing score
            score += sender.points;
        }
        
        //Update score label and previous bubble
        scoreLabel.text = "\(String(score))";
        previousBubblePoint = sender.points;
    }
    
    //Remove bubbles
    func removeBubble() {
        let i = 0;
        
        //Avoid remove all the bubbles
        while(i < bubbles.count) {
            if(Int.random(in: 1...100) < 20) {
                bubbles[i].removeFromSuperview();
                bubbles.remove(at: i);
            }
        }
    }
    
    //Get current leaderboard and populate playScore array
    func getLeaderboard() {
        if let data = try? Data(contentsOf: filePath!) {
            let decoder = PropertyListDecoder();
            do {
                playerScores = try decoder.decode([Player].self, from: data);
            } catch {
                print("Error Decoding: \(error)");
            }
        }
    }
    
    //Get the highest score
    func getHighest() -> Double {
        var highScore = 0.0;
        //Compare scores for each player in playScore
        for player in playerScores {
            //change the highest score
            if(player.score > highScore) {
                highScore = player.score;
            }
        }
        return highScore;
    }
    
    //Save score board
    func saveScore() {
        //Append the newPlayer score to the array
        playerScores.append(newPlayer!);
        //Encode the updated playerScores to the plist file
        let encoder = PropertyListEncoder();
        do {
            let data = try encoder.encode(playerScores);
            try data.write(to: filePath!);
        } catch {
            print("Error Encoding Data \(error)");
        }
    }
}
