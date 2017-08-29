//
//  ViewController.swift
//  Cypher
//
//  Created by Robbie Cravens on 8/2/17.
//  Copyright © 2017 Robbie Cravens. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var cypherImageOne: UIImageView!
    @IBOutlet weak var cypherImageTwo: UIImageView!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var clearSeedButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var fadeView: UIView!
    
    private var cypherOneTimer: Timer?
    private var cypherTwoTimer: Timer?
    private var fadeToWhiteTimer: Timer?
    private var fadeFromWhiteTimer: Timer?
    private var hueChangeTimer: Timer?
    private var brightnessChangeTimer: Timer?
    private var cypherImageOneTimer: Timer?
    private var cypherImageTwoTimer: Timer?

    private var viewOriginalBackgroundColor: UIColor!
    
    private var seedArray = [Int]() {
        didSet {
            print(seedArray)
        }
    }
    
    public var displaySeed: Int = 1 {
        didSet {
            if displaySeed > 9 {
                displaySeed = 1
            }
            if displaySeed < 1 {
                displaySeed = 9
            }
            if displaySeed == 1 {
                centerButton.setImage(#imageLiteral(resourceName: "runeOne"), for: .normal)
            }
            if displaySeed == 2 {
                centerButton.setImage(#imageLiteral(resourceName: "runeTwo"), for: .normal)
            }
            if displaySeed == 3 {
                centerButton.setImage(#imageLiteral(resourceName: "runeThree"), for: .normal)
            }
            if displaySeed == 4 {
                centerButton.setImage(#imageLiteral(resourceName: "runeFour"), for: .normal)
            }
            if displaySeed == 5 {
                centerButton.setImage(#imageLiteral(resourceName: "runeFive"), for: .normal)
            }
            if displaySeed == 6 {
                centerButton.setImage(#imageLiteral(resourceName: "runeSix"), for: .normal)
            }
            if displaySeed == 7 {
                centerButton.setImage(#imageLiteral(resourceName: "runeSeven"), for: .normal)
            }
            if displaySeed == 8 {
                centerButton.setImage(#imageLiteral(resourceName: "runeEight"), for: .normal)
            }
            if displaySeed == 9 {
                centerButton.setImage(#imageLiteral(resourceName: "runeNine"), for: .normal)
            }
        }
    }
    
    var seedInt = 0
    
    let encryptor = Encryptor()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewOriginalBackgroundColor = view.backgroundColor
        
        inputField.delegate = self   //necessary to close keyboard

        //AudioPlayer.sharedInstance.setPlayerVolume()
        displaySeed = 1
        redoButton.isEnabled = false
        redoButton.isHidden = true
        fadeView.alpha = 0
    }
    
    //sets sets the encrypt text = to the inputText and then encrypts it
    @IBAction private func textFieldDoneEditing(_ sender: UITextField) {
        let inputText = sender.text!
        let isEncrypted = inputText.hasSuffix("*")
        
        encryptor.seed(seedInt)
        
        if !isEncrypted {
            outputLabel.text = encryptor.encrypt(input: inputText)
        } else {
            if let decryptedString = encryptor.decrypt(input: inputText) {
                outputLabel.text = decryptedString
            } else {
                print("invalid input string")
            }
        }
        
        func successfulDecrypt() {
            AudioPlayer.sharedInstance.play(sound: .cypherSongPlay)
            rotateCypherImageOne()
            rotateCypherImageTwo()
            redoButton.isEnabled = true
            redoButton.isHidden = false
            clearSeedButton.setTitle("", for: .normal)
            lowerBackgroundBrightness()
            cycleImageOneHue()
            cycleImageTwoHue()
        }
        
        //Toggles the visibility of the clearSeedButton
        if seedArray == [] {
            self.clearSeedButton.setTitle("", for: .normal)
        } else {
            self.clearSeedButton.setTitle("Clear", for: .normal)
        }
        if inputText == "" {
            self.outputLabel.text = ""
        }
        
        // List of answers
        //
        // "A hind D?"
          if inputText == ".,wZKs,$P*" && seedArray == [1, 4, 1, 1, 2] {
            successfulDecrypt()
        }
        
        // "Rare footage..."
        if inputText == "TmcFnx//zmkFGGG*" && seedArray == [6, 1, 9] {
            successfulDecrypt()
        }
        // "NERV"
        if inputText == "?&mw*" && seedArray == [6, 7, 8] {
            successfulDecrypt()
        }
        // "https://www."
        if inputText == "!JJ.sMvvAAAj*" && seedArray == [4, 2, 2] {
            successfulDecrypt()
        }
        // "Colorado, why there?"
        if inputText == "@w-wVLcwiuJCzuvCKVK.*" && seedArray == [1, 9, 8] {
            successfulDecrypt()
        }
    }
    
    //closes the keyboard when the "done" key is pressed
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        self.view.endEditing (true)
        return false
    }
    
    func rotateCypherImageOne() {
        cypherOneTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (Timer) in
            self.cypherImageOne.transform = self.cypherImageOne.transform.rotated (by: 0.002)
        }
    }
    
    func rotateCypherImageTwo() {
        cypherTwoTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (Timer) in
            self.cypherImageTwo.transform = self.cypherImageTwo.transform.rotated (by: -0.002)
        }
    }
    
    func fadeToWhite() {
        fadeToWhiteTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (Timer) in
            self.fadeView.alpha = min(1.0, self.fadeView.alpha + 0.05);
        }
    }
    
    func fadeFromWhite() {
        fadeFromWhiteTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (Timer) in
            self.fadeView.alpha = max(0, self.fadeView.alpha - 0.05);
        }
    }

    
    func lowerBackgroundBrightness() {
        self.brightnessChangeTimer = view.lowerBrightness(timeInterval: 0.05, deltaBrightness: 0.005)
    }
    
    func cycleImageOneHue() {
        #if false
        cypherImageOne.image = cypherImageOne.image!.withRenderingMode(.alwaysTemplate)
        cypherImageOneTimer = cypherImageOne.cycleTintHue(timeInterval: 0.01, deltaHue: 0.0005, onStop: { (Timer) in
            self.cypherImageOne.tintColor = UIColor.white
        })
        #else
        cypherImageOne.image = cypherImageOne.image!.withRenderingMode(.alwaysTemplate)
        cypherImageOne.tintColor = UIColor.white
        cypherImageOneTimer = cypherImageOne.adjust(timeInterval: 0.01,
            onAdjustment: { (timer) in
                let saturation = min(1, self.cypherImageOne.tintColor.saturation + 0.001)
                self.cypherImageOne.tintColor = UIColor.yellow.set(saturation: saturation)
            },
            onStop: { (Timer) in
                self.cypherImageOne.tintColor = UIColor.white
            })
        #endif
    }
    
    func cycleImageTwoHue() {
        #if false
        cypherImageTwo.image = cypherImageTwo.image!.withRenderingMode(.alwaysTemplate)
            cypherImageTwoTimer = cypherImageTwo.cycleTintHue(timeInterval: 0.01, deltaHue: 0.0005, onStop: { (Timer) in
                self.cypherImageOne.tintColor = UIColor.white
            })
        #else
        cypherImageTwo.image = cypherImageTwo.image!.withRenderingMode(.alwaysTemplate)
        cypherImageTwo.tintColor = UIColor.white
        cypherImageTwoTimer = cypherImageTwo.adjust(timeInterval: 0.01,
            onAdjustment: { (timer) in
                let saturation = min(1, self.cypherImageTwo.tintColor.saturation + 0.001)
                self.cypherImageTwo.tintColor = UIColor.yellow.set(saturation: saturation)
            },
            onStop: { (Timer) in
                self.cypherImageTwo.tintColor = UIColor.white
            })
        #endif
   }
    
    func renewView() {
        self.fadeFromWhiteTimer?.stop()
        self.fadeFromWhiteTimer = nil
        fadeToWhite()
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (Timer) in
            
            self.fadeToWhiteTimer?.stop()
            self.fadeToWhiteTimer = nil
            
            self.cypherOneTimer?.stop()
            self.cypherOneTimer = nil
            
            self.cypherTwoTimer?.stop()
            self.cypherTwoTimer = nil
            
            self.brightnessChangeTimer?.stop()
            self.brightnessChangeTimer = nil
            
            self.cypherImageOneTimer?.stop()
            self.cypherImageOneTimer = nil
            
            self.cypherImageTwoTimer?.stop()
            self.cypherImageTwoTimer = nil
            
            self.displaySeed = 1
            self.seedArray = []
            
            self.inputField.text = ""
            self.outputLabel.text = ""
            
            self.redoButton.isEnabled = false
            self.redoButton.isHidden = true
            
            AudioPlayer.sharedInstance.stop()
            AudioPlayer.sharedInstance.audioFadeTimer?.stop()
            AudioPlayer.sharedInstance.volume = 0.5
            
            
            self.view.backgroundColor = self.viewOriginalBackgroundColor

            self.fadeFromWhite()
        }
    }

    @IBAction func refreshPressed(_ sender: Any) {
        renewView()
        AudioPlayer.sharedInstance.fadeOutVolume()

    }

    @IBAction func clearSeedButton(_ sender: Any) {
        seedArray = []
        self.clearSeedButton.setTitle("", for: .normal)
    }

    @IBAction func rightButtonTouched(_ sender: Any) {
        displaySeed += 1
        AudioPlayer.sharedInstance.play(sound: .buttonTap)
    }
    
    @IBAction func leftButtonTouched(_ sender: Any) {
        displaySeed -= 1
        AudioPlayer.sharedInstance.play(sound: .buttonTap)
    }
    
    @IBAction func centerButtonTouched(_ sender: Any) {
        self.clearSeedButton.setTitle("Clear", for: .normal)
        AudioPlayer.sharedInstance.play(sound: .centerButtonRelease)
    }
    
    @IBAction func centerButtonTouchedTwo(_ sender: Any) {
        AudioPlayer.sharedInstance.play(sound: .buttonTap)
        seedArray.append(displaySeed)
        
        let numberStrings = seedArray.map {
            return "\($0)"
        }
        
        let combinedStrings = numberStrings.joined()
        seedInt = Int(combinedStrings)!
    }
}
