//
//  ColorManager.swift
//  Cypher
//
//  Created by Robbie on 8/16/17.
//  Copyright © 2017 Robbie Cravens. All rights reserved.
//

import UIKit



extension UIColor {
    
    var hue: CGFloat {
        var hue: CGFloat = 0.0
        getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }
    
    
    func set(hue newHue: CGFloat) -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: newHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    var saturation: CGFloat {
        var saturation: CGFloat = 0.0
        getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
        return saturation
    }
        
    func set(saturation newSaturation: CGFloat) -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
    }

    var brightness: CGFloat {
        var brightness: CGFloat = 0.0
        getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
        
    func set(brightness newBrightness: CGFloat) -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    
    var alpha: CGFloat {
        var alpha: CGFloat = 0.0
        getHue(nil, saturation: nil, brightness: nil, alpha: &alpha)
        return alpha
    }
        
    func set(alpha newAlpha: CGFloat) -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: newAlpha)
    }
}


extension Timer {
    
    // Should be implemented as associated properties instead of a static dictionary. This mechanism leaks.
    private static var stopMethods = [Timer: (timer: Timer) -> Void]()
    
    var onStop:((_ timer: Timer) -> Void)? {
        get {
            return Timer.stopMethods[self]
        }
        
        set(newValue) {
            Timer.stopMethods[self] = newValue
        }
    }
    
    func stop() {
        invalidate()
        onStop?(self)
    }
}

extension UIView {
    
    func adjust(timeInterval: TimeInterval, onAdjustment: @escaping (Timer) -> Void, onStop: ((Timer) -> Void)? = nil) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (timer: Timer) in
            onAdjustment(timer)
        }
        
        timer.onStop = onStop
        
        return timer
    }
    
    func lowerBrightness(timeInterval: TimeInterval, deltaBrightness: CGFloat) -> Timer {
        return adjust(timeInterval: timeInterval, onAdjustment: { (timer) in
            self.backgroundColor = self.backgroundColor!.set(brightness: self.backgroundColor!.brightness - deltaBrightness)
        })
    }
    
//    func cycleBackgroundHue() {
//        var hue: CGFloat = 0.0
//        var saturation: CGFloat = 0.0
//        var brightness: CGFloat = 0.0
//        var alpha: CGFloat = 0.0
//        view.backgroundColor!.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
//        self.hueChangeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (Timer) in
//            hue += 0.005
//            if hue > 1 {
//                hue = 0
//            }
//
//            self.view.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
//        }
//    }
}

extension UIImageView {
    
    // NOTE: This call requires you are using template rendering mode before calling this
    // method. For example:
    //     someImageView.image = someImageView.image!.withRenderingMode(.alwaysTemplate)
    //     let _ = someImageView.cycleTintHue(timeInterval: 0.05, deltaHue: 0.01)
    func cycleTintHue(timeInterval: TimeInterval, deltaHue: CGFloat, onStop: ((Timer) -> Void)? = nil) -> Timer {
        return adjust(timeInterval: timeInterval, onAdjustment: { (timer) in
            var hue = self.tintColor.hue + deltaHue
            if hue > 1 {
                hue = 0
            }
            self.tintColor = self.tintColor.set(hue: hue)
        }, onStop: onStop)
    }
    
    func cycleTintSaturation(timeInterval: TimeInterval, deltaSaturation: CGFloat, onStop: ((Timer) -> Void)? = nil) -> Timer {
        return adjust(timeInterval: timeInterval, onAdjustment: { (timer) in
            var saturation = self.tintColor.saturation + deltaSaturation
            if saturation > 1 {
                saturation = 0
            } else if saturation < 0 {
                saturation = 1
            }
            self.tintColor = self.tintColor.set(saturation: saturation)
        }, onStop: onStop)
    }
    
}
