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

var initialVideo: Video? //video de départ
var currentVideo: Video? //video en cours

class ViewController: UIViewController {
    
    var timerTick: VideoTimerModel?
    var timerPanelControl: VideoTimerModel?
    
    //if -1 no interaction is displayed
    var interactionIdInCourse:Int = -1
    var interactionTypeInCourse: Interaction.InteractionType = .none
    
    var loadingNewVideo: Bool = false
    var startTimeNewVideo: Double?
    
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
        
        //stockage de la video initial pour le relancemnet de la video
        initialVideo = tableVideos[0]
        currentVideo = tableVideos[0]
        self.player.url = initialVideo?.url
        
        self.player.playbackLoops = true
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        
        //GESTION DE L'OVERLAYVIEW
        self.player.overlayView.displayView(view)
        self.player.overlayView.delegate = self
        hideInteraction()
        
        //Détection d'un clic sur la view videoContainerView de OverlayView.xib
        let tapVideoContainer = UITapGestureRecognizer(target: self, action: #selector(self.displayControlPanel))
        self.player.overlayView.videoContainerView.isUserInteractionEnabled = true
        self.player.overlayView.videoContainerView.addGestureRecognizer(tapVideoContainer)
        self.player.overlayView.videoControlPanel.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.player.playFromBeginning()
    }
    
    //gestion du click sur la view videoContainerView de OverlayView.xib
    func displayControlPanel(sender:UITapGestureRecognizer) {
        print("AZERTY !!!!")
        self.player.overlayView.videoControlPanel.isHidden = false
        timerPanelControl?.timerControlPanelRestart()
    }
    
    func displayCurrentTime() {

        let currentTime = "\(self.player.currentTime)"
        //let currentTimeDouble = Double(currentTime)?.roundTo(places: 2)
        
        self.player.overlayView.currentTimeLabel.text = currentTime
        
        //timeLbl.text = String(currentTimeDouble!)
        //timeLbl.text = convertToInt(currentTime: currentTime)
        
        
        let currentTimeFloat = Float(currentTime)!
        
        //Affichage du chapitre si existe
        self.player.overlayView.chapterLabel.text = ""
        var currentChapter: Chapitre? = nil
        if(tableChapitres.count > 0) {
            for chapitre in tableChapitres {
                if currentTimeFloat >= chapitre.start && currentTimeFloat < chapitre.end {
                    self.player.overlayView.chapterLabel.text = chapitre.chapterName
                    currentChapter = chapitre
                }
            }
        }
        
        for interaction in tableInteractions {
           // if let currentTimeFloat = Float(currentTime) {
                
                switch interaction.type {
                case .loop:
                    if let loopInter = interaction as? LoopInter {
                        if loopInter.loopActivated == true {
                            if let chapterToLoop = loopInter.chapterToLoop {
                                if let currentChapter = currentChapter {
                                    if currentChapter.chapterName == chapterToLoop {
                                        
                                        let startBtnLoopDisplay = currentChapter.end - 5
                                        if currentTimeFloat > startBtnLoopDisplay {
                                            //display button 1
                                            if let loopMsg = loopInter.msg {
                                                self.player.overlayView.titleLabel.text = loopMsg
                                                self.player.overlayView.titleLabel.isHidden = false
                                            }
                                            if let interBtn1 = loopInter.interBtn1 {
                                                self.player.overlayView.btn1.setTitle(interBtn1.label, for: .normal)
                                                self.player.overlayView.jumpToVideoName1 = nil
                                                //print("*** \(currentChapter.end) ***")
                                                self.player.overlayView.destBtn1 = Double(currentChapter.end + 1)
                                                self.player.overlayView.btnView1.isHidden = false
                                            }
                                        }
                                        
                                        //retourne au début du chapitre
                                        if currentTimeFloat >= currentChapter.end - 0.1 {
                                            self.player.overlayView.manageDestination(dest: Double(currentChapter.start), jumpToVideoName: nil)
                                        }
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                    break
                case .pause:
                    if let pauseInter = interaction as? PauseInter {
                        if let interactionDisplayStart = pauseInter.displayStart {
                            if currentTimeFloat >= interactionDisplayStart && currentTimeFloat < interactionDisplayStart + 0.05 {
                                interactionIdInCourse = pauseInter.id
                                interactionTypeInCourse = .pause
                                self.player.pause()
                                self.player.overlayView.playPauseBtnLbl.setTitle("Play", for: .normal)
                                
                                if let pauseMsg = pauseInter.msg {
                                    self.player.overlayView.titleLabel.text = pauseMsg
                                    self.player.overlayView.titleLabel.isHidden = false
                                }
                                if let interBtn1 = pauseInter.interBtn1 {
                                    self.player.overlayView.btn1.setTitle(interBtn1.label, for: .normal)
                                    self.player.overlayView.jumpToVideoName1 = interBtn1.jumpToVideoNameId
                                    self.player.overlayView.destBtn1 = interBtn1.goto
                                    self.player.overlayView.btnView1.isHidden = false
                                }
                                if let interBtn2 = pauseInter.interBtn2 {
                                    self.player.overlayView.btn2.setTitle(interBtn2.label, for: .normal)
                                    self.player.overlayView.jumpToVideoName2 = interBtn2.jumpToVideoNameId
                                    self.player.overlayView.destBtn2 = interBtn2.goto
                                    self.player.overlayView.btnView2.isHidden = false
                                }
                                if let interBtn3 = pauseInter.interBtn3 {
                                    self.player.overlayView.btn3.setTitle(interBtn3.label, for: .normal)
                                    self.player.overlayView.jumpToVideoName3 = interBtn3.jumpToVideoNameId
                                    self.player.overlayView.destBtn3 = interBtn3.goto
                                    self.player.overlayView.btnView3.isHidden = false
                                }
                            }
                        }
                    }
                    break
                case .display:
                    if let displayInter = interaction as? DisplayInter {
                        if let interactionDisplayStart = displayInter.displayStart {
                            if let displayEnd = displayInter.displayEnd {
                                if currentTimeFloat >= interactionDisplayStart && currentTimeFloat <= displayEnd {
                                    interactionIdInCourse = interaction.id
                                    interactionTypeInCourse = .display
                                    if let displayMsg = displayInter.msg {
                                        self.player.overlayView.titleLabel.text = displayMsg
                                        self.player.overlayView.titleLabel.isHidden = false
                                    }
                                    if let interBtn1 = displayInter.interBtn1 {
                                        self.player.overlayView.btn1.setTitle(interBtn1.label, for: .normal)
                                        self.player.overlayView.jumpToVideoName1 = interBtn1.jumpToVideoNameId
                                        self.player.overlayView.destBtn1 = interBtn1.goto
                                        self.player.overlayView.btnView1.isHidden = false
                                    }
                                    if let interBtn2 = displayInter.interBtn2 {
                                        self.player.overlayView.btn2.setTitle(interBtn2.label, for: .normal)
                                        self.player.overlayView.jumpToVideoName2 = interBtn2.jumpToVideoNameId
                                        self.player.overlayView.destBtn2 = interBtn2.goto
                                        self.player.overlayView.btnView2.isHidden = false
                                    }
                                    if let interBtn3 = displayInter.interBtn3 {
                                        self.player.overlayView.btn3.setTitle(interBtn3.label, for: .normal)
                                        self.player.overlayView.jumpToVideoName3 = interBtn3.jumpToVideoNameId
                                        self.player.overlayView.destBtn3 = interBtn3.goto
                                        self.player.overlayView.btnView3.isHidden = false
                                    }
                                } else {
                                    if interactionIdInCourse == displayInter.id {
                                        hideInteraction()
                                    }
                                }
                            }
                        }
                    }
                    break
                case .sumary:
                    if let sumaryInter = interaction as? SumaryInter {
                        if let interactionDisplayStart = sumaryInter.displayStart {
                            if currentTimeFloat >= interactionDisplayStart && currentTimeFloat < interactionDisplayStart + 0.05 {
                                interactionIdInCourse = sumaryInter.id
                                interactionTypeInCourse = .pause
                                self.player.pause()
                                self.player.overlayView.playPauseBtnLbl.setTitle("Play", for: .normal)
                                
                                if let sumaryMsg = sumaryInter.msg {
                                    self.player.overlayView.titleLabel.text = sumaryMsg
                                    self.player.overlayView.titleLabel.isHidden = false
                                }
                                if let interBtn1 = sumaryInter.interBtn1 {
                                    self.player.overlayView.btn1.setTitle(interBtn1.label, for: .normal)
                                    self.player.overlayView.jumpToVideoName1 = interBtn1.jumpToVideoNameId
                                    self.player.overlayView.destBtn1 = interBtn1.goto
                                    self.player.overlayView.btnView1.isHidden = false
                                }
                                if let interBtn2 = sumaryInter.interBtn2 {
                                    self.player.overlayView.btn2.setTitle(interBtn2.label, for: .normal)
                                    self.player.overlayView.jumpToVideoName2 = interBtn2.jumpToVideoNameId
                                    self.player.overlayView.destBtn2 = interBtn2.goto
                                    self.player.overlayView.btnView2.isHidden = false
                                }
                                if let interBtn3 = sumaryInter.interBtn3 {
                                    self.player.overlayView.btn3.setTitle(interBtn3.label, for: .normal)
                                    self.player.overlayView.jumpToVideoName3 = interBtn3.jumpToVideoNameId
                                    self.player.overlayView.destBtn3 = interBtn3.goto
                                    self.player.overlayView.btnView3.isHidden = false
                                }
                            }
                        }
                    }
                    break
                case .none:
                    break
                }
                
            //}
        }
    }
    
    
    func hideInteraction() {
        interactionIdInCourse = -1
        interactionTypeInCourse = .none
        self.player.overlayView.titleLabel.isHidden = true
        self.player.overlayView.btnView1.isHidden = true
        self.player.overlayView.btnView2.isHidden = true
        self.player.overlayView.btnView3.isHidden = true
        
        self.player.overlayView.btnView4.isHidden = true
        self.player.overlayView.btnView5.isHidden = true
        self.player.overlayView.btnView6.isHidden = true
        self.player.overlayView.svBtn_4_5_6.isHidden = true
        
        self.player.overlayView.btnView7.isHidden = true
        self.player.overlayView.btnView8.isHidden = true
        self.player.overlayView.btnView9.isHidden = true
        self.player.overlayView.svBtn_7_8_9.isHidden = true
        
        self.player.overlayView.btnView10.isHidden = true
        self.player.overlayView.btnView11.isHidden = true
        self.player.overlayView.btnView12.isHidden = true
        self.player.overlayView.svBtn_10_11_12.isHidden = true
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
        //si on charge une nouvelle vidéo on doit vérifier qu'elle est chargé avant de déplacer la tête de lecture
        if loadingNewVideo == true {
            if let startTime = startTimeNewVideo {
                let newTime = CMTime.init(seconds: startTime, preferredTimescale: CMTimeScale.init(1))
                self.player.seek(to: newTime)
            }
            self.player.playFromCurrentTime()
            loadingNewVideo = false
            self.player.view.isHidden = false    
        }
        
        //GESTION DU VideoTimerModel
        timerTick = VideoTimerModel()
        timerTick?.delegate = self
        timerTick?.timerStart()
        
        //GESTION DU VIDEO CONTROL PANEL
        timerPanelControl = VideoTimerModel()
        timerPanelControl?.controlPanelDelegate = self
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
        timerPanelControl?.timerControlPanelRestart()
        var playerIsPlaying = false
        
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.paused.rawValue:
            if interactionTypeInCourse == .pause {
                interactionTypeInCourse = .none
                hideInteraction()
                
                let destTime = self.player.currentTime + 1
                    
                //on ajoute 1s pour sortir du range de la pause
                let newTime = CMTime.init(seconds: destTime, preferredTimescale: CMTimeScale.init(100))
                //print("***** \(newTime) *****")
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
    
    func goBckFwd_overlayView(type: OperatorType, value: Double) {
        timerPanelControl?.timerControlPanelRestart()
        let destTime = Double(self.player.currentTime)
        var newTime: CMTime
        switch type {
        case .goBack:
            newTime = CMTime.init(seconds: destTime - value, preferredTimescale: CMTimeScale.init(1))
            break
        case .goForward:
            newTime = CMTime.init(seconds: destTime + value, preferredTimescale: CMTimeScale.init(1))
            break
        }
        self.player.seek(to: newTime)
    }
    
    
    func restart_overlayView() {
        if currentVideo?.name == initialVideo?.name {
            let newTime = CMTime.init(seconds: 0, preferredTimescale: CMTimeScale.init(100))
            videoSeekTo_overlayView(to: newTime)
        } else {
            loadNewVideo_overlayView(videoNameId: (initialVideo?.nameId)!, destTime: 0)
        }
    }
    
    func loadNewVideo_overlayView(videoNameId: String, destTime: Double?) {
        //je vide les tables
        //avant d'ajouter les scripts de récupérations des infos concernant
        //la nouvelle vidéo, en base
        tableInteractions = []
        tableChapitres = []
        self.player.view.isHidden = true
        
        //on passe loadingNewVideo à true pour que la tête de lecture se positionne et se lance quand la vidéo est chargé
        //le test de loadingNewVideo se fait dans func playerReady
        loadingNewVideo = true
        startTimeNewVideo = destTime
        
        for video in tableVideos {
            if video.nameId == videoNameId {
                self.player.url = video.url
                hideInteraction()
                self.player.overlayView.playPauseBtnLbl.setTitle("Pause", for: .normal)
                currentVideo = video
                break
            }
        }
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

extension ViewController: TimerVideoControlPanelDelegate {
    func timerVideoControlPanelEnd() {
        print("CLOSE PANEL !!!!!!")
        self.player.overlayView.videoControlPanel.isHidden = true
    }
}


