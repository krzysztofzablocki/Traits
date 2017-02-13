//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import ObjectMapper

/// DropShadow is a trait allowing to change `UIView` shadowOpacity, offset and color.
public final class DropShadow: TypedTrait<UIView> {
    private(set) var offset: CGSize = .zero
    private(set) var color: UIColor = .clear
    private(set) var opacity: Float = 0

    open override func applyTyped(to target: UIView, remove: inout RemoveClosure) throws {
        remove = { [weak target, opacity = target.layer.shadowOpacity, offset = target.layer.shadowOffset, color = target.layer.shadowColor] in
            guard let strongView = target else { return }
            strongView.layer.shadowOpacity = opacity
            strongView.layer.shadowOffset = offset
            strongView.layer.shadowColor = color
        }

        target.layer.shadowOpacity = opacity
        target.layer.shadowOffset = offset
        target.layer.shadowColor = color.cgColor
    }

    public init(offset: CGSize, color: UIColor, opacity: Float) {
        super.init()
        self.offset = offset
        self.color = color
        self.opacity = opacity
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    open override func mapping(map: Map) {
        super.mapping(map: map)
        color <- (map["color"], ColorTransform())
        offset <- (map["offset"], SizeTransform())
        opacity <- map["opacity"]
    }
}
