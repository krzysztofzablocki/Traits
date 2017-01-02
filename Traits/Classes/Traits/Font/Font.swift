//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

/// Font is a trait allowing to change fontSize, name and color.
public final class Font: Trait {
    private(set) var fontSize: CGFloat?
    private(set) var fontName: String = ""
    private(set) var fontColor: UIColor = .white

    open override class var restrictedTypes: [AnyClass]? { return [UILabel.self] }

    open override func apply(to target: Trait.Target, remove: inout RemoveClosure) throws {
        let label = target as! UILabel

        remove = { [weak label, font = label.font, fontColor = label.textColor] in
            guard let label = label else { return }
            label.font = font
            label.textColor = fontColor
        }

        if let font = UIFont(name: fontName, size: fontSize ?? label.font.pointSize) {
            label.font = font
        } else {
            let allFonts = UIFont.familyNames.map(UIFont.fontNames(forFamilyName:))
            throw Error.unsupportedValue(info: "font \(fontName) unavailable, try any of \(allFonts)")
        }
        label.textColor = fontColor
    }

    public init(fontName: String, fontSize: CGFloat, fontColor: UIColor) {
        super.init()
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    open override func mapping(map: Map) {
        super.mapping(map: map)
        fontSize <- map["size"]
        fontName <- map["name"]
        fontColor <- (map["color"], ColorTransform())
    }
}
