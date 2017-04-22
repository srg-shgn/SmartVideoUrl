//
//  OverlayView.swift
//  Dealership
//
//  Created by Sztanyi Szabolcs on 05/01/16.
//  Copyright © 2016 Zappdesigntemplates. All rights reserved.
//

import UIKit

/// Custom view that displays when a user adds a Car to the Garage (Saves it locally)
class OverlayView: UIView {
    
    var delegate: OverlayViewDelegate?
    
    /// Label to show the empty text
    @IBOutlet weak var titleLabel: UILabel!


    @IBAction func pressPausePlay(_ sender: Any) {
        print("AAAAAAAA")
        delegate?.pressBtn_overlayView()
    }
    
    @IBAction func pressBtn2(_ sender: Any) {
        print("PRESS BTN 2 !")
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

        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: onView, attribute: .centerY, multiplier: 1.0, constant: 0.0)) // move it a bit upwards
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: onView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
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

//        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 170.0))
//        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200.0))
        
        let superViewWidth = delegate?.getDeviceViewWidth_overlayView()
        let superViewHeight = delegate?.getDeviceViewHeight_overlayView()
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: superViewHeight!))
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: superViewWidth!))
        
        addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
    }

}

protocol OverlayViewDelegate {
    func pressBtn_overlayView()
    func getDeviceViewWidth_overlayView() -> CGFloat
    func getDeviceViewHeight_overlayView() -> CGFloat
}

