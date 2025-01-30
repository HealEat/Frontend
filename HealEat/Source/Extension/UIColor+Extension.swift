// Copyright © 2024 HealEat. All rights reserved

import UIKit

extension UIColor {
    // HEX 문자열을 UIColor로 변환하는 초기화 메서드
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count

        let r, g, b, a: CGFloat
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    func toHex() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            return String(format: "#%06x", rgb)
        }
        return nil
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: alpha
        )
    }
    
    // HealEat Color Styles
    // Assets에 넣는게 더 좋은 것 같아서 일단 보류
//    static let healeatGreen1: UIColor       = UIColor(rgb: 0x009459)
//    static let healeatGreen2: UIColor       = UIColor(rgb: 0xC4E9BE)
//    static let healeatLightGreen: UIColor   = UIColor(rgb: 0xE0F1EA)
//    static let healeatLightGreen2: UIColor  = UIColor(rgb: 0xEEFAF5)
//    static let healeatLightGreen3: UIColor  = UIColor(rgb: 0xF3FFF1)
//    static let healeatDarkGreen1: UIColor   = UIColor(rgb: 0x99BB94)
//    static let healeatDarkGreen2: UIColor   = UIColor(rgb: 0x99BB94)
//    static let healeatDarkGreen3: UIColor   = UIColor(rgb: 0x759487)
//    static let healeatDarkGreen4: UIColor   = UIColor(rgb: 0x0A5F3D)
//    static let healeatGray1: UIColor        = UIColor(rgb: 0xFDFDFD)
//    static let healeatGray2: UIColor        = UIColor(rgb: 0xF8F8F8)
//    static let healeatGray2h: UIColor       = UIColor(rgb: 0xF0F0F0)
//    static let healeatGray3: UIColor        = UIColor(rgb: 0xE3E3E3)
//    static let healeatGray3h: UIColor       = UIColor(rgb: 0xD9D9D9)
//    static let healeatGray4: UIColor        = UIColor(rgb: 0xCFCFCF)
//    static let healeatGray4h: UIColor       = UIColor(rgb: 0xA3A3A3)
//    static let healeatGray5: UIColor        = UIColor(rgb: 0x858585)
//    static let healeatGray6: UIColor        = UIColor(rgb: 0x5A5A5A)
//    static let healeatBlack: UIColor        = UIColor(rgb: 0x1E1E1E)
//    static let healeatBlack65: UIColor      = UIColor(rgb: 0x1E1E1E, alpha: 0.65)
//    static let healeatRed: UIColor          = UIColor(rgb: 0xFF0000)
//    static let healeatYellow: UIColor       = UIColor(rgb: 0xFFCF30)
//    static let healeatLightRed: UIColor     = UIColor(rgb: 0xFFF5F5)
}
