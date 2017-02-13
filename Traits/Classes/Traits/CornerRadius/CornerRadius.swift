//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import ObjectMapper

/// Corner Radius trait
public final class CornerRadius: TypedTrait<UIView> {
    private(set) var radius: CGFloat?

    override open func applyTyped(to target: UIView, remove: inout RemoveClosure) throws {
        remove = { [weak target, oldCornerRadius = target.layer.cornerRadius, oldMaskToBounds = target.layer.masksToBounds] in
            target?.layer.cornerRadius = oldCornerRadius
            target?.layer.masksToBounds = oldMaskToBounds
        }

        target.layer.cornerRadius = radius ?? 0
        target.layer.masksToBounds = true
    }

    public init(radius: CGFloat) {
        super.init()
        self.radius = radius
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    override open func mapping(map: Map) {
        super.mapping(map: map)
        radius <- (map["radius"])
    }
}
