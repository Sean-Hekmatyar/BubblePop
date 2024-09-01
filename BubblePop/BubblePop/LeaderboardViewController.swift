//
//  LeaderboardViewController.swift
//  BubblePop
//
//  Created by Yue Yin on 2022/4/19.
//

import UIKit

class LeaderboardViewController: UITableViewController {
    
    var playerScores = [Player]();
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("leaderboard.plist");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLeaderboard()
    }
    
    //Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerScores.count;
    }
    
    //Set Cells in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = playerScores[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath);
        cell.textLabel?.text = "\(player.name): \(player.score)";
        return cell;
    }
    
    //Load leaderboard from plist file
    func loadLeaderboard() {
        if let data = try? Data(contentsOf: filePath!) {
            //Decode data from the plist file and put it in the array as Player obj
            let decoder = PropertyListDecoder();
            do {
                playerScores = try decoder.decode([Player].self, from: data)
            } catch {
                print("Error Decoding: \(error)");
            }
        }
    }
    
    //Press menu button to return to the menu
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        //Perform segues to the menu
        self.performSegue(withIdentifier: "goToMenu", sender: self);
    }
}
