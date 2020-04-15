//
//  userData.swift
//  Legend
//
//  Created by Daniel Castro on 3/8/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import Firebase
import Darwin

struct User {
    let firstName: String
    let lastName: String
    let birthDate: String
    let creationDate: Double
    let email: String
    let character: [String: Any]
    let strengthXP: Int
    let agilityXP:Int
    let id: String
    var strengthLevel: Int = 0
    var agilityLevel: Int = 0
    var equippedItems: [String] = []
    var gender: String = ""
    
    init(firstName: String, lastName: String, birthDate: String, creationDate: Double, email: String, character: [String: Any], strengthXP: Int, agilityXP: Int, id: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.creationDate = creationDate
        self.email = email
        self.character = character
        self.strengthXP = strengthXP
        self.agilityXP = agilityXP
        self.id = id
        
        if let gender = character["gender"] as? String, let equippedItems = character["equipped"] as? [String] {
            self.gender = gender
            self.equippedItems = equippedItems
        }
        
        strengthLevel = calculateLevel(exp: strengthXP)
        agilityLevel = calculateLevel(exp: agilityXP)
        
    }
    
    func calculateLevel(exp: Int) -> Int{
        let level = (sqrt(Float(625 + (100 * exp))) - 25 ) / 50
        return Int(level)
    }
    
    func getUserImage() -> String {
        // If user is wearing no items
        if equippedItems.count == 0 {
            if gender == "Male" {
                return "m_elf"
            } else if gender == "Female" {
                return "f_elf"
            }
        } else {
            if equippedItems.contains("armor") {
                return "armored_elf"
            }
        }
        return ""
    }
    
}

