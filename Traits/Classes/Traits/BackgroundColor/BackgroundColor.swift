//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

/// BackgroundColor is a trait allowing to change `UIView` backgroundColor.
public final class BackgroundColor: Trait {
    private(set) var color: UIColor?

    open override class var restrictedTypes: [AnyClass]? { return [UIView.self] }

    open override func apply(to target: Trait.Target, remove: inout RemoveClosure) throws {
        let target = target as! UIView

        remove = { [weak target, oldColor = target.backgroundColor] in
            target?.backgroundColor = oldColor
        }

        target.backgroundColor = color
    }

    public init(color: UIColor) {
        super.init()
        self.color = color
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    open override func mapping(map: Map) {
        super.mapping(map: map)
        color <- (map["color"], ColorTransform())
    }
}
