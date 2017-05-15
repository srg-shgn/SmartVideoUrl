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
    
    var controlPanelTimer: Timer?
    var controlPanelDelegate: TimerVideoControlPanelDelegate?
    
    func timerStart() {
        //print("START TIMER TICK !")
        myTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true, block: { (Timer) in
            self.delegate?.timerVideoTick()
        })
    }
    
    func timerStop() {
        self.myTimer?.invalidate()
    }
    
    func timerControlPanelRestart() {
        print("RESTART TIMER CONTROL PANEL !")
        self.controlPanelTimer?.invalidate()
        controlPanelTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (Timer) in
            self.controlPanelDelegate?.timerVideoControlPanelEnd()
        })
    }
    
}

protocol TimerVideoDelegate {
    func timerVideoTick()
}

protocol TimerVideoControlPanelDelegate {
    func timerVideoControlPanelEnd()
}
