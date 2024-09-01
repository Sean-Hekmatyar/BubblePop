//
//  Player.swift
//  BubblePop
//
//  Created by Yue Yin on 2022/4/16.
//

import Foundation

struct Player: Codable {
    var name: String = "Unknown Player";
    var score: Double = 0;
    var time: Int = 60;
    var maxBubble: Int = 15;
    
    mutating func setName(playerName: String) {
        //if name is empty, then "Unknown Player" is used by default
        if(name.isEmpty || name == "") {
            name = "Unknown Player";
        } else {
            name = playerName;
        }
    }
    
    mutating func setSettings(timeVal: Int, maxBubbleVal: Int) {
        time = timeVal;
        maxBubble = maxBubbleVal;
    }
    
    mutating func setScore(finalScore: Double) {
        score = finalScore;
    }
}
