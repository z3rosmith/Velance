import UIKit

class VLSocialButton: UIButton {
    
    private var outLayer: CAShapeLayer!
    private var leftGradientCircleLayer: CAGradientLayer!
    private var imageLayer: CALayer!
    private var textLayer: CATextLayer!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setLeftBackgroudColors(cgColors: [UIColor(named: "OvalButtonGradientLeft2")!.cgColor,
                                                  UIColor(named: "OvalButtonGradientRight2")!.cgColor],
                                       gradient: true)
                setRightBackgroundColor(cgColor: UIColor(named: "E3EFDB")!.cgColor)
                setTextColor(cgColor: UIColor(named: "388203")!.cgColor)
            } else {
                setLeftBackgroudColors(cgColors: [UIColor(named: "9E9E9E")!.cgColor], gradient: false)
                setRightBackgroundColor(cgColor: UIColor(named: "CCCCCC")!.cgColor)
                setTextColor(cgColor: UIColor(named: "606060")!.cgColor)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPaths()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPaths()
    }
    
    private func setupPaths() {
        let outPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.height/2)
        outLayer = CAShapeLayer()
        outLayer.path = outPath.cgPath
        outLayer.lineWidth = 0.0
        layer.addSublayer(outLayer)
        
        let radius = self.frame.height/2
        leftGradientCircleLayer = CAGradientLayer()
        leftGradientCircleLayer.frame = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        leftGradientCircleLayer.cornerRadius = leftGradientCircleLayer.frame.height / 2
        leftGradientCircleLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        leftGradientCircleLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.addSublayer(leftGradientCircleLayer)
        
        imageLayer = CALayer()
        let quarterSide = self.frame.height/4
        imageLayer.frame = CGRect(origin: CGPoint(x: quarterSide, y: quarterSide), size: CGSize(width: quarterSide*2, height: quarterSide*2))
        imageLayer.contentsGravity = .resizeAspectFill
        layer.addSublayer(imageLayer)
        
        textLayer = CATextLayer()
        let textLayerY = self.frame.height/4
        let textLayerHeight = self.frame.height*2/3
        textLayer.frame = CGRect(origin: CGPoint(x: radius*3, y: textLayerY), size: CGSize(width: 30, height: textLayerHeight))
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.fontSize = 12
        textLayer.contentsGravity = .resizeAspect
        layer.addSublayer(textLayer)
        
        setLeftBackgroudColors(cgColors: [UIColor(named: "9E9E9E")!.cgColor], gradient: false)
        setRightBackgroundColor(cgColor: UIColor(named: "CCCCCC")!.cgColor)
        setTextColor(cgColor: UIColor(named: "606060")!.cgColor)
    }
}

extension VLSocialButton {
    
    func setRightBackgroundColor(cgColor: CGColor) {
        outLayer.fillColor = cgColor
    }
    
    /// gradient를 false로 줄 경우 cgColors는 1개만 전달
    func setLeftBackgroudColors(cgColors: [CGColor], gradient: Bool) {
        if gradient {
            leftGradientCircleLayer.colors = cgColors
        } else {
            leftGradientCircleLayer.colors = [cgColors[0], cgColors[0]]
        }
    }
    
    func setTextColor(cgColor: CGColor) {
        textLayer.foregroundColor = cgColor
    }
    
    func setLeftImage(image: UIImage) {
        imageLayer.contents = image.cgImage
    }
    
    func setRightText(text: String) {
        textLayer.string = text
    }
}
