import UIKit
import InputBarAccessoryView

final class VelanceInputBar: InputBarAccessoryView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        inputTextView.backgroundColor = .white
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        
        inputTextView.layer.cornerRadius = 16.0
        
        inputTextView.clipsToBounds = true
        inputTextView.layer.masksToBounds = false
        inputTextView.layer.shadowRadius = 3
        inputTextView.layer.shadowOpacity = 0.3
        inputTextView.layer.shadowOffset = CGSize(width: 0, height: 3)
        inputTextView.layer.shadowColor = UIColor.darkGray.cgColor
        
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        setRightStackViewWidthConstant(to: 38, animated: false)
        setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = UIImage(named: "SendButton")
        sendButton.title = nil
        sendButton.imageView?.layer.cornerRadius = 16
        sendButton.backgroundColor = .clear
        middleContentViewPadding.right = -38
        separatorLine.isHidden = true
    }
    
}
