// ActionButton.swift
//
//  theParker
//
//  Created by Ketan Choyal on 19/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

public enum Type {
    case Circle
    case Rectangle
}

public enum Position {
    case BottomRight
    case BottomLeft
}

public typealias ActionButtonAction = (ActionButton) -> Void

open class ActionButton: NSObject {
    
    /// The action the button should perform when tapped
    open var action: ActionButtonAction?
    var type = Type.Circle
    var position = Position.BottomRight

    /// The button's background color : set default color and selected color
    open var backgroundColor: UIColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0) {
        willSet {
            floatButton.backgroundColor = newValue
            backgroundColorSelected = newValue
        }
    }
    
    /// The button's background color : set default color
    open var backgroundColorSelected: UIColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
    
    /// Indicates if the buttons is active (showing its items)
    fileprivate(set) open var active: Bool = false
    
    /// An array of items that the button will present
    internal var items: [ActionButtonItem]? {
        willSet {
            for abi in self.items! {
                abi.view.removeFromSuperview()
            }
        }
        didSet {
            placeButtonItems()
            showActive(true)
        }
    }
    
    /// The button that will be presented to the user
    fileprivate var floatButton: UIButton!
    
    /// View that will hold the placement of the button's actions
    fileprivate var contentView: UIView!
    
    /// View where the *floatButton* will be displayed
    fileprivate var parentView: UIView!
    
    /// Blur effect that will be presented when the button is active
    fileprivate var blurVisualEffect: UIVisualEffectView!
    
    // Distance between each item action
    fileprivate let itemOffset = -55
    
    /// the float button's radius
    fileprivate var floatButtonHeight = 50
    private var width : CGFloat = 50
    private var bottomSpacing = 35
    
    public init(attachedToView view: UIView, items: [ActionButtonItem]?, buttonHeight : Int?, buttonWidth : CGFloat?, buttonType : Type, position : Position) {
        super.init()
        
        if buttonHeight != nil {
            self.floatButtonHeight = buttonHeight!
        }
        self.type = buttonType
        self.position = position
        
        if buttonWidth != nil {
            self.width = buttonWidth!
        }
        
        self.parentView = view
        self.items = items
        let bounds = self.parentView.bounds
        
        self.floatButton = UIButton(type: .custom)
        self.floatButton.layer.cornerRadius = CGFloat(5)
        self.floatButton.layer.shadowOpacity = 1
        self.floatButton.layer.shadowRadius = 2
        
        self.floatButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.floatButton.layer.shadowColor = UIColor.gray.cgColor
        self.floatButton.setTitle("+", for: UIControl.State())
        self.floatButton.setTitleColor(#colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1), for: UIControl.State())
        self.floatButton.setImage(nil, for: UIControl.State())
        self.floatButton.backgroundColor = self.backgroundColor
        self.floatButton.contentHorizontalAlignment = .center
        self.floatButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        self.floatButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.floatButton.isUserInteractionEnabled = true
        self.floatButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.floatButton.addTarget(self, action: #selector(ActionButton.buttonTapped(_:)), for: .touchUpInside)
        self.floatButton.addTarget(self, action: #selector(ActionButton.buttonTouchDown(_:)), for: .touchDown)
        self.parentView.addSubview(self.floatButton)

        self.contentView = UIView(frame: bounds)
        self.blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        self.blurVisualEffect.frame = self.contentView.frame
        self.contentView.addSubview(self.blurVisualEffect)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ActionButton.backgroundTapped(_:)))
        self.contentView.addGestureRecognizer(tap)
        
        if type == .Circle {
            self.cornerRadius(radius: CGFloat(floatButtonHeight/2))
        }
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fontColor(color : UIColor,forState state: UIControl.State) {
        floatButton.setTitleColor(color, for: state)
    }
    
    func cornerRadius(radius : CGFloat) {
        self.floatButton.layer.cornerRadius = CGFloat(radius)
    }
    
    //MARK: - Set Methods
    open func setTitle(_ title: String?, fontsize : CGFloat, forState state: UIControl.State) {
        floatButton.setImage(nil, for: state)
        floatButton.setTitle(title, for: state)
        floatButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: fontsize)
        floatButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func border(color : UIColor, width : CGFloat) {
        floatButton.layer.borderColor = color.cgColor
        floatButton.layer.borderWidth = width
    }
    
    func bottomSpacing(space : Int) {
        self.bottomSpacing = space
    }
    
    open func setImage(_ image: UIImage?, forState state: UIControl.State) {
        setTitle(nil, fontsize: 5 ,forState: state)
        floatButton.setImage(image, for: state)
        floatButton.adjustsImageWhenHighlighted = false
        floatButton.contentEdgeInsets = UIEdgeInsets.zero
    }
    
    //MARK: - Auto Layout Methods
    /**
        Install all the necessary constraints for the button. By the default the button will be placed at 15pts from the bottom and the 15pts from the right of its *parentView*
    */
    func show() {
        let views: [String: UIView] = ["floatButton":self.floatButton, "parentView":self.parentView]
        
        var width_ : CGFloat = 0.0
        
        if self.width == self.parentView.frame.width {
            width_ = self.width - 30
        } else {
            width_ = self.width
        }
        
        let width = NSLayoutConstraint.constraints(withVisualFormat: "H:[floatButton(\(width_))]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        let height = NSLayoutConstraint.constraints(withVisualFormat: "V:[floatButton(\(floatButtonHeight))]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        self.floatButton.addConstraints(width)
        self.floatButton.addConstraints(height)
        
        if position == .BottomRight {
            let bottomSpacing = NSLayoutConstraint.constraints(withVisualFormat: "V:[floatButton]-\(self.bottomSpacing)-|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
            let trailingSpacing = NSLayoutConstraint.constraints(withVisualFormat: "H:[floatButton]-15-|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
            self.parentView.addConstraints(trailingSpacing)
            self.parentView.addConstraints(bottomSpacing)
        } else if position == .BottomLeft {
            let bottomSpacing = NSLayoutConstraint.constraints(withVisualFormat: "V:[floatButton]-\(self.bottomSpacing)-|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
            let leadingSpacing = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[floatButton]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
            self.parentView.addConstraints(leadingSpacing)
            self.parentView.addConstraints(bottomSpacing)
        }
        
    }
    
    //MARK: - Button Actions Methods
    @objc func buttonTapped(_ sender: UIControl) {
        animatePressingWithScale(1)
        
        if let unwrappedAction = self.action {
            unwrappedAction(self)
        }
    }
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        animatePressingWithScale(0.9)
    }
    
    //MARK: - Gesture Recognizer Methods
    @objc func backgroundTapped(_ gesture: UIGestureRecognizer) {
        if self.active {
            self.toggle()
        }
    }
    
    @objc func longTapped(_ gesture : UILongPressGestureRecognizer) {
        animatePressingWithScale(1)
        
        if let unwrappedAction = self.action {
            unwrappedAction(self)
        }
    }
    
    //MARK: - Custom Methods
    /**
        Presents or hides all the ActionButton's actions
    */
    open func toggleMenu() {
        self.placeButtonItems()
        self.toggle()
    }
    
    //MARK: - Action Button Items Placement
    /**
        Defines the position of all the ActionButton's actions
    */
    fileprivate func placeButtonItems() {
        if let optionalItems = self.items {
            for item in optionalItems {
                item.view.center = CGPoint(x: self.parentView.frame.width - 150, y: self.floatButton.center.y - 10)
                item.view.removeFromSuperview()
                
                self.contentView.addSubview(item.view)
            }
        }
    }
    
    //MARK - Float Menu Methods
    /**
        Presents or hides all the ActionButton's actions and changes the *active* state
    */
    fileprivate func toggle() {
        self.animateMenu()
        self.showBlur()
        
        self.active = !self.active
        self.floatButton.backgroundColor = self.active ? backgroundColorSelected : backgroundColor
        self.floatButton.isSelected = self.active
    }
    
    fileprivate func animateMenu() {
        let rotation = self.active ? 0 : CGFloat(Double.pi/4)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            
            if self.floatButton.imageView?.image == nil {
                if self.type == .Circle {
                    self.floatButton.transform = CGAffineTransform(rotationAngle: rotation)
                }
            }
    
            self.showActive(false)
        }, completion: {completed in
            if self.active == false {
                self.hideBlur()
            }
        })
    }
    
    fileprivate func showActive(_ active: Bool) {
        if self.active == active {
            self.contentView.alpha = 1.0
            
            if let optionalItems = self.items {
                for (index, item) in optionalItems.enumerated() {
                    let offset = index + 1
                    let translation = self.itemOffset * offset
                    item.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(translation))
                    item.view.alpha = 1
                }
            }
        } else {
            self.contentView.alpha = 0.0
            
            if let optionalItems = self.items {
                for item in optionalItems {
                    item.view.transform = CGAffineTransform(translationX: 0, y: 0)
                    item.view.alpha = 0
                }
            }
        }
    }
    
    fileprivate func showBlur() {
        self.parentView.insertSubview(self.contentView, belowSubview: self.floatButton)
    }
    
    fileprivate func hideBlur() {
        self.contentView.removeFromSuperview()
    }
    
    /**
        Animates the button pressing, by the default this method just scales the button down when it's pressed and returns to its normal size when the button is no longer pressed
    
        - parameter scale: how much the button should be scaled
    */
    fileprivate func animatePressingWithScale(_ scale: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            self.floatButton.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
}
