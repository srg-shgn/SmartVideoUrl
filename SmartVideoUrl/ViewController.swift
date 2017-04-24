//  ViewController.swift
//
//  Created by patrick piemonte on 11/26/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-present patrick piemonte (http://patrickpiemonte.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import CoreMedia

let videoUrl = URL(string: "http://www.schlum.com/myr/arte.mp4")!

class ViewController: UIViewController {
    
    var timerTick: VideoTimerModel?
    
    //if -1 no interaction is displayed
    var interactionIdInCourse:Int = -1
    var interactionTypeInCourse: Interaction.InteractionType = .none
    
    fileprivate var player: Player
    
    // MARK: object lifecycle
    
    convenience init() {
        self.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.player = Player()
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.player = Player()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    deinit {
        self.player.willMove(toParentViewController: self)
        self.player.view.removeFromSuperview()
        self.player.removeFromParentViewController()
    }
    
    // MARK: view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view.bounds
        
        self.addChildViewController(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMove(toParentViewController: self)
        
        self.player.url = videoUrl
        
        self.player.playbackLoops = true
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        
        //GESTION DE L'OVERLAYVIEW
        self.player.overlayView.displayView(view)
        self.player.overlayView.delegate = self
        hideInteraction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.player.playFromBeginning()
    }
    
    
    
    func displayCurrentTime() {

        let currentTime = "\(self.player.currentTime)"
        //let currentTimeDouble = Double(currentTime)?.roundTo(places: 2)
        
        self.player.overlayView.currentTimeLabel.text = currentTime
        
        //timeLbl.text = String(currentTimeDouble!)
        //timeLbl.text = convertToInt(currentTime: currentTime)
        
        
        for interaction in tableInteraction {
            if let currentTimeFloat = Float(currentTime) {
                
                switch interaction.interactionType {
                case .pause:
                    if currentTimeFloat >= interaction.displayStart && currentTimeFloat < interaction.displayStart + 0.05 {
                        interactionIdInCourse = interaction.id
                        interactionTypeInCourse = .pause
                        self.player.pause()
                        self.player.overlayView.playPauseBtnLbl.setTitle("Play", for: .normal)
                        
                        if let pauseMsg = interaction.msg {
                            self.player.overlayView.titleLabel.text = pauseMsg
                            self.player.overlayView.titleLabel.isHidden = false
                        }
                        if let interBtn1 = interaction.interBtn1 {
                            self.player.overlayView.btn1.setTitle(interBtn1.label, for: .normal)
                            self.player.overlayView.destBtn1 = interBtn1.goto
                            self.player.overlayView.btnView1.isHidden = false
                        }
                        if let interBtn2 = interaction.interBtn2 {
                            self.player.overlayView.btn2.setTitle(interBtn2.label, for: .normal)
                            self.player.overlayView.destBtn2 = interBtn2.goto
                            self.player.overlayView.btnView2.isHidden = false
                        }
                        if let interBtn3 = interaction.interBtn3 {
                            self.player.overlayView.btn3.setTitle(interBtn3.label, for: .normal)
                            self.player.overlayView.destBtn3 = interBtn3.goto
                            self.player.overlayView.btnView3.isHidden = false
                        }
                    }
                    break
                case .display:
                    if let displayEnd = interaction.displayEnd {
                        if currentTimeFloat >= interaction.displayStart && currentTimeFloat <= displayEnd {
                            interactionIdInCourse = interaction.id
                            interactionTypeInCourse = .display
                            if let displayMsg = interaction.msg {
                                self.player.overlayView.titleLabel.text = displayMsg
                                self.player.overlayView.titleLabel.isHidden = false
                            }
                            if let interBtn1 = interaction.interBtn1 {
                                self.player.overlayView.btn1.setTitle(interBtn1.label, for: .normal)
                                self.player.overlayView.destBtn1 = interBtn1.goto
                                self.player.overlayView.btnView1.isHidden = false
                            }
                            if let interBtn2 = interaction.interBtn2 {
                                self.player.overlayView.btn2.setTitle(interBtn2.label, for: .normal)
                                self.player.overlayView.destBtn2 = interBtn2.goto
                                self.player.overlayView.btnView2.isHidden = false
                            }
                            if let interBtn3 = interaction.interBtn3 {
                                self.player.overlayView.btn3.setTitle(interBtn3.label, for: .normal)
                                self.player.overlayView.destBtn3 = interBtn3.goto
                                self.player.overlayView.btnView3.isHidden = false
                            }
                        } else {
                            if interactionIdInCourse == interaction.id {
                                hideInteraction()
                            }
                        }
                    }
                    break
                case .none:
                    break
                }
                
            }
        }
    }
    
    
    func hideInteraction() {
        interactionIdInCourse = -1
        interactionTypeInCourse = .none
        self.player.overlayView.btnView1.isHidden = true
        self.player.overlayView.btnView2.isHidden = true
        self.player.overlayView.btnView3.isHidden = true
        self.player.overlayView.titleLabel.isHidden = true
    }
    
}

// MARK: - UIGestureRecognizer

extension ViewController {
    
    func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.stopped.rawValue:
            self.player.playFromBeginning()
        case PlaybackState.paused.rawValue:
            self.player.playFromCurrentTime()
        case PlaybackState.playing.rawValue:
            self.player.pause()
        case PlaybackState.failed.rawValue:
            self.player.pause()
        default:
            self.player.pause()
        }
    }
    
}

// MARK: - PlayerDelegate

extension ViewController: PlayerDelegate {
    
    func playerReady(_ player: Player) {
        //GESTION DU VideoTimerModel
        timerTick = VideoTimerModel()
        timerTick?.delegate = self
        timerTick?.timerStart()
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
    }
    
}

// MARK: - PlayerPlaybackDelegate

extension ViewController: PlayerPlaybackDelegate {
    
    func playerCurrentTimeDidChange(_ player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
    }
    
}


extension ViewController: OverlayViewDelegate {
    func playPause_overlayView() -> Bool {
        var playerIsPlaying = false
        
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.paused.rawValue:
            if interactionTypeInCourse == .pause {
                interactionTypeInCourse = .none
                hideInteraction()
                
                let destTime = self.player.currentTime + 1
                    
                //on ajoute 0,05 ms pour sortir du range de la pause
                let newTime = CMTime.init(seconds: destTime, preferredTimescale: CMTimeScale.init(100))
                print("***** \(newTime) *****")
                videoSeekTo_overlayView(to: newTime)
                
                
            } else {
                self.player.playFromCurrentTime()
            }
            playerIsPlaying = true
        case PlaybackState.playing.rawValue:
            self.player.pause()
            playerIsPlaying = false
        case PlaybackState.failed.rawValue:
            self.player.pause()
            playerIsPlaying = false
        default:
            self.player.pause()
            playerIsPlaying = false
        }
        
        if playerIsPlaying == false {
            timerTick?.timerStop()
        } else {
            timerTick?.timerStart()
        }
        
        return playerIsPlaying
    }
    
    func videoSeekTo_overlayView(to: CMTime) {
        hideInteraction()
        self.player.seek(to: to)
        self.player.playFromCurrentTime()
        self.player.overlayView.playPauseBtnLbl.setTitle("Pause", for: .normal)
    }
    
    func getDeviceViewWidth_overlayView() -> CGFloat {
        //récupération du width de la superView
        return view.frame.width
    }
    
    func getDeviceViewHeight_overlayView() -> CGFloat {
        //récupération du height de la superView
        return view.frame.height
    }
}

extension ViewController: TimerVideoDelegate {
    func timerVideoTick() {
        displayCurrentTime()
    }
}


