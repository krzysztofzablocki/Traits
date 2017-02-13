//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol FontModifiable: class {
    var font: UIFont! { get set }
    var textColor: UIColor! { get set }
}

extension UILabel: FontModifiable {}

/// Font is a trait allowing to change fontSize, name and color.
public final class Font: TypedTrait<FontModifiable> {
    private(set) var fontSize: CGFloat?
    private(set) var fontName: String = ""
    private(set) var fontColor: UIColor = .white

    open override func applyTyped(to target: FontModifiable, remove: inout RemoveClosure) throws {
        remove = { [weak target, font = target.font, fontColor = target.textColor] in
            guard let target = target else { return }
            target.font = font
            target.textColor = fontColor
        }

        if let font = UIFont(name: fontName, size: fontSize ?? target.font.pointSize) {
            target.font = font
        } else {
            let allFonts = UIFont.familyNames.map(UIFont.fontNames(forFamilyName:))
            throw Error.unsupportedValue(info: "font \(fontName) unavailable, try any of \(allFonts)")
        }
        target.textColor = fontColor
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
