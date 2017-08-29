//
//  Encryptor.swift
//  Cypher
//
//  Created by Robbie Cravens on 8/3/17.
//  Copyright © 2017 Robbie Cravens. All rights reserved.
//

import Foundation
import AVFoundation

class Encryptor {

    var encryptionDictionary = [String: String]()
    var decryptionDictionary = [String : String]()
    let characters = [ "a", "b", "c", "d", "c", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "!", "@", "#", "$", "%", " ", "&", ":", "?", "-", ",", ".", "/"]
    
//  Preset decryption messages:
//  "CTiOaiOapasfOs*" = "This is a test" Seed: [1, 3, 1]
//  ".,wZKs,$P*" = "A hind D?" Seed: [1, 4, 1, 1, 2]
//  "TmcFnx//zmkFGGG*" = "Rare footage..." Seed: [6, 1, 9]
//  "?&mw*" = "NERV" Seed: [6, 7, 8]
//  ".vX%LZnjH%Zr%XByx*" = "The sound of evil" Seed: [1, 9, 9]
//  "oMuMi$/Mhk#.-kO.LiLn*" = "Colorado, why there?" Seed: [9, 3, 9]
//  "ev?mvmWnTDYWurjttxs*" = "Kansas City Shuffle" Seed: [7, 3, 4]
//  "LYD%lsYU*" = "Reported" Seed: [3, 2, 4]
//  "gWlCC-ua#SSCoufi-:zVu@SZ*" = "Pretty smooth flyin Fox" Seed: [4, 5, 1]

       init() {
    }
    
    func seed(_ seed: Int = 0) {
        buildEncryptionDictionary(seed: seed)
        buildDecryptionDictionary()
    }
    
    private func buildEncryptionDictionary(seed: Int) {
        print("seeding with \(seed)")
        srand48(seed)
        
        var values = characters
        
        for key in characters {
            let index = Int((drand48() * Double(values.count)).rounded(.down))
            encryptionDictionary[key] = values[index]
            values.remove(at: index)
        }
        
        assert(values.count == 0)
    }
    
    private func buildDecryptionDictionary() {
        for (key, value) in encryptionDictionary {
            decryptionDictionary[value] = key
        }
    }
    
    func encrypt(input: String) -> String {
        var result = ""
        for character in input.characters {
            let key = String(character)
            result += (encryptionDictionary[key] ?? "missing character")
        }
        result += "*"
        print(result)
        return result
    }
    
    func decrypt(input: String) -> String? {
        if !input.hasSuffix("*") {
            return nil
        }
        
        var result = ""
        for character in input.characters.dropLast() {
            let key = String(character)
            result += (decryptionDictionary[key] ?? "missing character")
        }
        return result
   }
}
