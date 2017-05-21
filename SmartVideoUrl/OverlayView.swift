//
//  OverlayView.swift
//  Dealership
//
//  Created by Sztanyi Szabolcs on 05/01/16.
//  Copyright © 2016 Zappdesigntemplates. All rights reserved.
//

import UIKit
import CoreMedia

/// Custom view that displays when a user adds a Car to the Garage (Saves it locally)
class OverlayView: UIView {
    
    var delegate: OverlayViewDelegate?
    
    @IBOutlet var videoContainerView: UIView!
    @IBOutlet weak var videoControlPanel: UIView!
    
    /// Label to show the empty text
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playPauseBtnLbl: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var chapterLabel: UILabel!
    
    @IBOutlet weak var btnView1: UIView!
    @IBOutlet weak var btnView2: UIView!
    @IBOutlet weak var btnView3: UIView!
    
    @IBOutlet weak var svBtn_4_5_6: UIStackView!
    @IBOutlet weak var btnView4: UIView!
    @IBOutlet weak var btnView5: UIView!
    @IBOutlet weak var btnView6: UIView!
    
    @IBOutlet weak var svBtn_7_8_9: UIStackView!
    @IBOutlet weak var btnView7: UIView!
    @IBOutlet weak var btnView8: UIView!
    @IBOutlet weak var btnView9: UIView!
    
    @IBOutlet weak var svBtn_10_11_12: UIStackView!
    @IBOutlet weak var btnView10: UIView!
    @IBOutlet weak var btnView11: UIView!
    @IBOutlet weak var btnView12: UIView!
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    @IBOutlet weak var btn12: UIButton!

    
    var destBtn1: Double?
    var destBtn2: Double?
    var destBtn3: Double?
    var destBtn4: Double?
    var destBtn5: Double?
    var destBtn6: Double?
    var destBtn7: Double?
    var destBtn8: Double?
    var destBtn9: Double?
    var destBtn10: Double?
    var destBtn11: Double?
    var destBtn12: Double?
    
    var jumpToVideoName1: String?
    var jumpToVideoName2: String?
    var jumpToVideoName3: String?
    var jumpToVideoName4: String?
    var jumpToVideoName5: String?
    var jumpToVideoName6: String?
    var jumpToVideoName7: String?
    var jumpToVideoName8: String?
    var jumpToVideoName9: String?
    var jumpToVideoName10: String?
    var jumpToVideoName11: String?
    var jumpToVideoName12: String?
    
    @IBAction func pressPausePlay(_ sender: Any) {
        let playerIsPlaying = delegate?.playPause_overlayView()
        if playerIsPlaying == false {
            playPauseBtnLbl.setTitle("Play", for: .normal)
        } else {
            playPauseBtnLbl.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func pressGoBack15(_ sender: Any) {
        delegate?.goBckFwd_overlayView(type: .goBack, value: 15)
    }
    
    @IBAction func pressGoFwd15(_ sender: Any) {
        delegate?.goBckFwd_overlayView(type: .goForward, value: 15)
    }
    
    @IBAction func pressRestart(_ sender: Any) {
        delegate?.restart_overlayView()
    }
    
    @IBAction func pressBtn1(_ sender: Any) {
        let destBtn = destBtn1
        manageDestination(dest: destBtn, jumpToVideoName: jumpToVideoName1)
    }
    
    @IBAction func pressBtn2(_ sender: Any) {
        if let destBtn = destBtn2 {
            manageDestination(dest: destBtn, jumpToVideoName: jumpToVideoName2)
        }
    }
    
    @IBAction func pressBtn3(_ sender: Any) {
        if let destBtn = destBtn3 {
            manageDestination(dest: destBtn, jumpToVideoName: jumpToVideoName3)
        }
    }
    
    @IBAction func pressBtn4(_ sender: Any) {
    }
    
    @IBAction func pressBtn5(_ sender: Any) {
    }
    
    @IBAction func pressBtn6(_ sender: Any) {
    }
    
    @IBAction func pressBtn7(_ sender: Any) {
    }
    
    @IBAction func pressBtn8(_ sender: Any) {
    }
    
    @IBAction func pressBtn9(_ sender: Any) {
    }
    
    @IBAction func pressBtn10(_ sender: Any) {
    }
    
    @IBAction func pressBtn11(_ sender: Any) {
    }
    
    @IBAction func pressBtn12(_ sender: Any) {
    }
    
    // Our custom view from the XIB file
    var view: UIView!

    /**
     Initialiser method

     - parameter frame: frame to use for the view
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    /**
     Initialiser method

     - parameter aDecoder: aDecoder
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    /**
     Loads a view instance from the xib file

     - returns: loaded view
     */
    func loadViewFromXibFile() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OverlayView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
    func setupView() {
        view = loadViewFromXibFile()
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        self.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Saved successfully"
    }
    
    /**
     Displays the overlayView on the passed in view

     - parameter onView: the view that will display the overlayView
     */
    func displayView(_ onView: UIView) {
        self.alpha = 0.0
        onView.addSubview(self)

        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: onView, attribute: .centerY, multiplier: 1.0, constant: 0.0)) // position vertical de l'overlay
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: onView, attribute: .centerX, multiplier: 1.0, constant: 0.0)) // position horizontal de l'overlay
        onView.needsUpdateConstraints()

        // display the view
        //transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.alpha = 1.0
        //self.transform = CGAffineTransform.identity
    
    }

    /**
     Updates constraints for the view. Specifies the height and width for the view
     */
    override func updateConstraints() {
        super.updateConstraints()
        
        let superViewWidth = delegate?.getDeviceViewWidth_overlayView()
        let superViewHeight = delegate?.getDeviceViewHeight_overlayView()
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: superViewHeight!)) // height de l'overlay
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: superViewWidth!)) // width de l'overlay
        
        addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
    }
    
    func manageDestination(dest: Double?, jumpToVideoName: String?) {
        
        if jumpToVideoName == nil {
            //on reste sur la même video
            if let destBtn = dest {
                let newTime = CMTime.init(seconds: destBtn, preferredTimescale: CMTimeScale.init(1))
                delegate?.videoSeekTo_overlayView(to: newTime)
            }
        } else {
            //on load une nouvelle vidéo
            if let videoName = jumpToVideoName {
                delegate?.loadNewVideo_overlayView(videoNameId: videoName, destTime: dest)
            }
        }
    }
}

protocol OverlayViewDelegate {
    func playPause_overlayView() -> Bool
    func videoSeekTo_overlayView(to: CMTime)
    func goBckFwd_overlayView(type: OperatorType, value: Double)
    func loadNewVideo_overlayView(videoNameId: String, destTime: Double?)
    func restart_overlayView()
    func getDeviceViewWidth_overlayView() -> CGFloat
    func getDeviceViewHeight_overlayView() -> CGFloat
}

