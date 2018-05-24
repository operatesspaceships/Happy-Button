//
//  HappyButton.swift
//  Happy Button
//
//  Created by Pierre Liebenberg on 5/21/18.
//  Copyright © 2018 The Seahorse Company. All rights reserved.
//

import UIKit

class CheckImageView: UIView {
    
    var resizingBehavior: SeahorseStyleKit.ResizingBehavior? = .center
    var checkColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        
        if let resizingBehavior = self.resizingBehavior {
            SeahorseStyleKit.drawCheck(frame: rect, resizing: resizingBehavior, color: self.checkColor)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(resizingBehavior: SeahorseStyleKit.ResizingBehavior, color: UIColor) {
        self.init()
        self.checkColor = color
        self.resizingBehavior = resizingBehavior
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@IBDesignable class HappyButton: UIButton {

    // MARK: - Animation Actions
    public enum Action {
        case showSuccessAnimation
        case showResetAnimation
    }
    
    // MARK: - IBInspectables
    @IBInspectable var cornerRadius:CGFloat = 8 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var progressIndicatorBorderWidth: CGFloat = 4
    @IBInspectable var inactiveProgressIndicatorColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0).cgColor
    @IBInspectable var activeProgressIndicatorColor = UIColor(red:1.00, green:0.23, blue:0.18, alpha:1.0).cgColor
    @IBInspectable var buttonIconStrokeColor: UIColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
    /**
     If true, the animation will loop until it receives an instruction from .perform(action: ). By default, this property is set to false.
     */
    @IBInspectable public var animationShouldLoop: Bool = false
    
    // MARK: - Variables
    private var activeProgressIndicatorLayer : CAShapeLayer!
    private var inactiveProgressIndicatorLayer: CAShapeLayer!
    private var checkImage = CheckImageView()
    private var savedFrame: CGRect = CGRect.zero
    
    
    var completion: ()->() = {}
    
    
    // MARK: - Lifecycle
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.applyAccessibility()
    }
    
    private final func applyAccessibility() {
        self.isAccessibilityElement = true
        self.accessibilityHint = "Tap to confirm"
        self.accessibilityLabel = "Submit Button"
        self.accessibilityActivate()
    }
    
    // MARK: - Interactions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateButtonTransition()
    }
    
    // MARK: - Set up check image
    private func setUpCheckImage() {
        
        self.checkImage = CheckImageView(resizingBehavior: .center, color: self.buttonIconStrokeColor)
        
        let height = self.frame.height
        let width = height
        
        self.checkImage.frame = CGRect(x: self.bounds.midX - (width / 2), y: self.bounds.midY - (height / 2), width: width, height: height)
        self.checkImage.backgroundColor = .clear
        self.checkImage.alpha = 0
        self.addSubview(checkImage)
        self.bringSubview(toFront: checkImage)
        self.checkImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    // MARK: - Set up inactive progress indicator
    private func insertInActiveProgressIndicator() {
        
        let inactiveLayer = CAShapeLayer()
        
        inactiveLayer.bounds = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        inactiveLayer.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        inactiveLayer.lineWidth = self.progressIndicatorBorderWidth
        
        inactiveLayer.fillColor = UIColor.clear.cgColor
        inactiveLayer.strokeColor = self.inactiveProgressIndicatorColor
        
        let bezierPath = UIBezierPath(ovalIn: inactiveLayer.frame.insetBy(dx: inactiveLayer.lineWidth / 2, dy: inactiveLayer.lineWidth / 2))
        inactiveLayer.path = bezierPath.cgPath
        
        self.layer.insertSublayer(inactiveLayer, at: 0)
        self.inactiveProgressIndicatorLayer = inactiveLayer
    }
    
    // MARK: - Set up active progress indicator
    private func insertActiveProgressIndicator() {
        
        let activeLayer = CAShapeLayer()
        
        activeLayer.bounds = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        activeLayer.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        activeLayer.lineWidth = self.progressIndicatorBorderWidth
        activeLayer.fillColor = UIColor.clear.cgColor
        activeLayer.strokeColor = self.activeProgressIndicatorColor
        
        let bezierPath = UIBezierPath(ovalIn: activeLayer.frame.insetBy(dx: activeLayer.lineWidth / 2, dy: activeLayer.lineWidth / 2))
        activeLayer.path = bezierPath.cgPath
        
        self.layer.insertSublayer(activeLayer, above: self.inactiveProgressIndicatorLayer)
        
        // Set strokeEnd to 0 so that we can animate its drawing later
        activeLayer.strokeEnd = 0
        
        // Rotate layer so that, duration animation, we draw clockwise from the 12 o'clock position.
        layer.setAffineTransform(CGAffineTransform(rotationAngle: -.pi/2.0))
        self.activeProgressIndicatorLayer = activeLayer
    }
    
    // MARK: - Animations
    private func animateButtonTransition() {
        
        // Disabled user interaction to avoid double taps
        self.isUserInteractionEnabled = false
        
        // Store button's original
        self.savedFrame = self.frame
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            
            // Adjust height and width to form a square
            let width: CGFloat = self.savedFrame.height
            let height: CGFloat = self.savedFrame.height
            
            // Center button in screen
            let xPosition = self.savedFrame.midX - (width / 2)
            let yPosition = self.savedFrame.minY
            
            self.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            
            // Apply cornerRadius to form a circl
            self.layer.cornerRadius = width / 2
            
            // Reduce button's label's scale
            self.titleLabel?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
            
            self.backgroundColor = UIColor.clear
            self.layer.borderColor = self.inactiveProgressIndicatorColor
            self.layer.borderWidth = self.progressIndicatorBorderWidth
            self.layer.frame = self.frame
            
        }, completion: { (Bool) in
            
            // Add progress indicators
            self.insertInActiveProgressIndicator()
            self.insertActiveProgressIndicator()
            self.layer.borderColor = UIColor.white.withAlphaComponent(0.0).cgColor
            
            self.animateActiveProgressIndicator(andRepeatUntilStopped: self.animationShouldLoop)
        })
    }
    
    private func animateActiveProgressIndicator(andRepeatUntilStopped: Bool) {
        
        if andRepeatUntilStopped {
            
            // Loop animation until callback received
            let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
            strokeEndAnimation.values = [0,1]
            strokeEndAnimation.keyTimes = [0,1]
            strokeEndAnimation.duration = 1
            strokeEndAnimation.repeatCount = .infinity
            self.activeProgressIndicatorLayer.strokeEnd = 1
            
            let strokeStartAnimation = CAKeyframeAnimation(keyPath: "strokeStart")
            strokeStartAnimation.values = [0,1]
            strokeStartAnimation.keyTimes = [0.25,1]
            strokeStartAnimation.duration = 1
            strokeStartAnimation.repeatCount = .infinity
            self.activeProgressIndicatorLayer.strokeStart = 1
            
            CATransaction.begin()
            self.activeProgressIndicatorLayer.add(strokeEndAnimation, forKey: strokeEndAnimation.keyPath)
            self.activeProgressIndicatorLayer.add(strokeStartAnimation, forKey: strokeStartAnimation.keyPath)
            CATransaction.commit()
            
        } else {
            
            // Run animation once and show success animation
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            self.activeProgressIndicatorLayer.strokeEnd = 1.0
            animation.toValue = 1
            animation.isRemovedOnCompletion = true
            
            CATransaction.setAnimationDuration(0.7)
            CATransaction.setCompletionBlock({
                self.showSuccessAnimation()
            })
            
            CATransaction.begin()
            self.activeProgressIndicatorLayer.add(animation, forKey: animation.keyPath)
            CATransaction.commit()
            CATransaction.completionBlock()
        }
        
    }
    
    private func resetAnimation() {
        
        // Restore rotation to pre-animated state
        self.transform = .identity
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.inactiveProgressIndicatorLayer.opacity = 0
            self.activeProgressIndicatorLayer.opacity = 0
            self.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.18, alpha:1.0)
            self.layer.borderWidth = 0
            
            self.frame = self.savedFrame
            self.titleLabel?.transform = .identity
            
            self.layer.cornerRadius = self.cornerRadius
            
        }, completion: {_  in
            self.completion()
            self.isUserInteractionEnabled = true
        })
    }
    
    private func showSuccessAnimation() {
        
        // Restore rotation to pre-animated state
        self.transform = .identity
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.inactiveProgressIndicatorLayer.opacity = 0
            self.activeProgressIndicatorLayer.opacity = 0
            self.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.18, alpha:1.0)
            self.layer.borderWidth = 0
            
            self.frame = self.savedFrame
            self.setUpCheckImage()
            
            self.layer.cornerRadius = self.cornerRadius
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: -15, options: [], animations: {
        
            self.checkImage.alpha = 1
            self.checkImage.transform = .identity
            
        }, completion: {_ in self.completion() })
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Usage example: once you receive a result from the server, you can interrupt the animation based on the result. Optionally, you can pass in a completion handler in a trailing closure to be called at the end of the interruption action.
     
     For example:
     
     button.perform(action: .showSuccessAnimation) {
        print("Success."
     }
     
     - Parameter action: Options are .showSuccessAnimation and .showResetAnimation
     - Parameter completionHandler: Pass in any non-returning function in a trailing closure. For example, in the event of a server error, you can pass an alert as the completion handler.
     
    */
    public func perform(action: Action, andCall completionHandler: @escaping () -> Void = { return } ) {
        
        switch action {
            
        case .showSuccessAnimation:
            self.activeProgressIndicatorLayer.removeAllAnimations()
            self.completion = completionHandler
            self.showSuccessAnimation()
        
        case .showResetAnimation:
            self.activeProgressIndicatorLayer.removeAllAnimations()
            self.completion = completionHandler
            self.resetAnimation()
            
        }
    }
}




































