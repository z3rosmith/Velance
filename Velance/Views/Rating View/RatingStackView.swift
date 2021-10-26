import UIKit

class RatingStackView: UIStackView {
    
    var starsRating = 3                                             // 기본 별점은 3점으로 시작
    var withLargeImage: Bool = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let starButtons = self.subviews.filter { $0 is UIButton }
        var starTag = 1
        for button in starButtons {
            if let button = button as? UIButton {
                let buttonImage =  UIImage(named: withLargeImage ? Images.starUnfilledLarge : Images.starUnfilled)
                button.setImage(buttonImage, for: .normal)
                button.addTarget(
                    self,
                    action: #selector(self.pressed(sender:)),
                    for: .touchUpInside
                )
                button.tag = starTag
                starTag = starTag + 1
            }
        }
        setStarsRating(rating: starsRating)
    }
    
    func setStarsRating(rating: Int) {
        self.starsRating = rating
        let stackSubViews = self.subviews.filter { $0 is UIButton }
        for subView in stackSubViews {
            if let button = subView as? UIButton {
                
                if button.tag > starsRating {
                    button.setImage(
                        UIImage(named: withLargeImage ? Images.starUnfilledLarge : Images.starUnfilled) ,
                        for: .normal
                    )
                } else {
                    button.setImage(
                        UIImage(named: withLargeImage ? Images.starFilledLarge : Images.starFilled),
                        for: .normal
                    )
                }
            }
        }
    }
    
    
    
    @objc func pressed(sender: UIButton) {
        setStarsRating(rating: sender.tag)
    }
    
}
