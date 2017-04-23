//
//  VideoTimerModel.swift
//  SmartVideo
//
//  Created by Serge Sahaguian on 06/04/2017.
//  Copyright © 2017 Serge Sahaguian. All rights reserved.
//

import Foundation

class VideoTimerModel {
    
    var myTimer: Timer?
    var delegate: TimerVideoDelegate?
    
    func timerStart() {
        //print("START TIMER TICK !")
        myTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true, block: { (Timer) in
            self.delegate?.timerVideoTick()
        })
    }
    
    func timerStop() {
        self.myTimer?.invalidate()
    }
}

protocol TimerVideoDelegate {
    func timerVideoTick()
}
