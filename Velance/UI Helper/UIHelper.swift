import UIKit
import Segmentio

class UIHelper {
    
    static func createActionSheet(with actions: [UIAlertAction], title: String?) -> UIAlertController {
        
        let actionSheet = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        actionSheet.view.tintColor = .black
        
        actions.forEach { actionSheet.addAction($0) }
        
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil
        )
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
    
    static func createAlertController(with actions: [UIAlertAction], title: String?, message: String?) -> UIAlertController {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.view.tintColor = .black
        
        actions.forEach { alert.addAction($0) }
        return alert
    }
    
    static func configureSegmentioStates() -> SegmentioStates {
        
        let segmentioStates = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 16, weight: .medium),
                titleTextColor: .lightGray
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 16, weight: .medium),
                titleTextColor: .black
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .darkGray
            )
        )
        return segmentioStates
    }
    
    static func configureSegmentioIems() -> [SegmentioItem] {
        
        var contents = [SegmentioItem]()
        
        UserOptions.productCategory.forEach { categoryName in
            contents.append(SegmentioItem(title: categoryName, image: nil))
        }
        return contents
    }
    
    static func configureSegmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        let horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions(
            type: .none,
            height: 0,
            color: .gray
        )
        return horizontalSeparatorOptions
    }
    
    static func configureSegmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        
        let verticalSeparatorOptions = SegmentioVerticalSeparatorOptions(
            ratio: 0.1, // from 0.1 to 1
            color: .clear
        )
        return verticalSeparatorOptions
    }
    
    static func configureSegmentioOptions() -> SegmentioOptions {
        
        let options = SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: .dynamic,
            scrollEnabled: true,
            indicatorOptions: SegmentioIndicatorOptions(
                type: .bottom,
                ratio: 1,
                height: 2,
                color: UIColor(named: Colors.tabBarSelectedColor)!
            ),
            horizontalSeparatorOptions: configureSegmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: configureSegmentioVerticalSeparatorOptions(),
            imageContentMode: .center,
            labelTextAlignment: .center,
            segmentStates: configureSegmentioStates()
        )
    
        return options
    }
    
    static func createSpinnerFooterView(in view: UIView) -> UIView {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    static func decimalWon(value: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))! + "원"
        return result
    }
}
