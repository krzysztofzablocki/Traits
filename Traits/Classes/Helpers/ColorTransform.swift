//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import protocol ObjectMapper.TransformType

private extension UIColor {

    /**
     Creates `UIColor` based on hex string.

     - parameter hexString: Hex string to use.
     */
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    /**
     Converts `UIColor` to hex string.

     - returns: Color as a hex string, prepended by # sign.
     */
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format:"#%06x", rgb)
    }
}

/**
 SizeTransform allows you to serialize `UIColor`.
 */
open class ColorTransform: TransformType {
    public typealias Object = UIColor
    public typealias JSON = String

    open func transformFromJSON(_ value: Any?) -> Object? {
        return value.flatMap { $0 as? String }.flatMap { UIColor(hexString: $0) }
    }

    open func transformToJSON(_ value: Object?) -> JSON? {
        return value.flatMap { $0.toHexString() }
    }
}
