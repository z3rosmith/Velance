//
//  UIButton+Extension.swift
//  Velance
//
//  Created by Kevin Kim on 2021/09/11.
//

import UIKit

extension UIButton {
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font!
        ])
        
        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
    
    func addBounceAnimation() {
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUpFailed(_:)), for: [.touchCancel, .touchUpOutside, .touchDragExit])
        addTarget(self, action: #selector(touchUpSucceeded(_:)), for: .touchUpInside)
    }
    
    func addBounceAnimationWithNoFeedback() {
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUpFailed(_:)), for: [.touchCancel, .touchUpOutside, .touchDragExit])
        addTarget(self, action: #selector(touchUpSucceededWithoutFeedback(_:)), for: .touchUpInside)
    }
    
    @objc func touchDown(_ sender: UIButton) {
        animate {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc func touchUpFailed(_ sender: UIButton) {
        animate {
            sender.transform = .identity
        }
    }
    
    @objc func touchUpSucceeded(_ sender: UIButton) {
        animate {
            sender.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } completion: { _ in
            self.animate {
                sender.transform = .identity
            }
        }
    }
    
    @objc func touchUpSucceededWithoutFeedback(_ sender: UIButton) {
        animate {
            sender.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            self.animate {
                sender.transform = .identity
            }
        }
    }
    
    func animate(reaction: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: reaction, completion: completion)
    }
    
    func showLoadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    func addGradientLayer(with colors: [UIColor]) -> CAGradientLayer {
        
        let buttonGradient = CAGradientLayer()
        buttonGradient.frame = self.bounds
        buttonGradient.cornerRadius = buttonGradient.frame.height / 2
        buttonGradient.colors = colors.compactMap { $0.cgColor }
//        buttonGradient.colors = [UIColor(named: Colors.ovalButtonGradientLeft)!.cgColor, UIColor(named: Colors.ovalButtonGradientRight)!.cgColor]
        buttonGradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        buttonGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        buttonGradient.frame = self.bounds
        return buttonGradient
    }
    
    func removeGradient(_ view: UIView, layerIndex index: Int) {
     
        guard let sublayers = view.layer.sublayers else {
            print("The view does not have any sublayers.")
            return
        }
        if sublayers.count > index {
            view.layer.sublayers!.remove(at: index)
        } else {
            print("There are not enough sublayers to remove that index.")
        }
        
        
  
    }

}


