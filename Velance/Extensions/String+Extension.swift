import UIKit

extension String {
    
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: color,
                range: range
            )
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(
            NSAttributedString.Key.kern,
            value: characterSpacing,
            range: NSRange(location: 0, length: attributedString.length)
        )

        return attributedString
    }
    
    func getFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        
        guard let convertedDate = dateFormatter.date(from: self) else {
            return "날짜 표시 에러"
        }
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(convertedDate) {
            return "오늘"
        } else if calendar.isDateInYesterday(convertedDate) {
            return "어제"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let finalDate = dateFormatter.string(from: convertedDate)
            return finalDate
        }
    }
}
