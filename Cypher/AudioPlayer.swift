//
//  Audio Player.swift
//  Cypher
//
//  Created by Robbie Cravens on 8/8/17.
//  Copyright © 2017 Robbie Cravens. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = AudioPlayer()
    
    private var players = [AVAudioPlayer]()
    
    var audioFadeTimer: Timer?

    var volume: Float = 0.5 {
        didSet {
            print("volume:",volume)
            for player in players {
                player.volume = max(0, volume)
            }
        }
    }
    
    enum Sound: String {
        case cypherSongPlay = "cypherSong"
        case centerButtonRelease = "centerButtonRelease"
        case buttonTap = "tapSound"
        static var all: [Sound] {
            return [.centerButtonRelease, .buttonTap, cypherSongPlay]
        }
        
        var url: URL {
            return URL.init(fileURLWithPath: Bundle.main.path(forResource: self.rawValue, ofType: "mp3")!)
        }
    }
    
    func play(sound: Sound) {
        do {
            let player = try AVAudioPlayer(contentsOf: sound.url)
            player.volume = volume
            player.delegate = self
            player.play()
            players.append(player)
        } catch {
            print("cannot create AVAudioPlayer for \(sound.url)")
        }
    }
    
    func stop() {
        for player in players {
            player.stop()
        }
    }
    
   func fadeOutVolume() {
        self.audioFadeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            self.volume -= 0.02
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = players.index(of: player) {
            players.remove(at: index)
        }
    }
    
}
