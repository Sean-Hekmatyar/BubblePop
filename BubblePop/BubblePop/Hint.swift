//
//  Hint.swift
//  BubblePop
//
//  Created by Yue Yin on 2022/4/16.
//

import Foundation

struct Hint {
    let hintCollection = ["Black Bubble has 10 pts!", "Black Bubble has only 5% chance", "Blue Bubble has 8 pts", "Blue Bubble has 10% chance", "Green Bubble has 5 pts", "Green Bubble has 15%", "Pink Bubble has 2 pts", "Pink Bubble has 30% chance", "Red Buuble has 1 pts", "Red Bubble has 40% chance", "Get bonus pts by tapping same color!"];
    
    func generateHint() -> String {
        let randomInt = Int.random(in: 1..<hintCollection.count);
        return hintCollection[randomInt];
    }
}
