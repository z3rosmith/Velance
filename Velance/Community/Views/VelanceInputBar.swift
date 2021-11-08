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
        inputTextView.backgroundColor = .systemGray6
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        inputTextView.placeholder = "댓글을 남겨보세요:)"
        inputTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        inputTextView.placeholderTextColor = UIColor(named: "B1B1B1")
        inputTextView.layer.cornerRadius = 10.0
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
