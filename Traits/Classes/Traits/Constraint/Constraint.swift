//
//  Traits
//
//  Created by Krzysztof Zabłocki on 29/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

/// Font is a trait allowing to change fontSize, name and color.
public final class Constraint: TypedTrait<NSLayoutConstraint> {
    private(set) var constant: CGFloat?

    open override func applyTyped(to target: NSLayoutConstraint, remove: inout RemoveClosure) throws {
        remove = { [weak target, constant = target.constant] in
            guard let target = target else { return }
            target.constant = constant
        }

        if let constant = constant {
            target.constant = constant
        }
    }

    public init(constant: CGFloat) {
        super.init()
        self.constant = constant
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    open override func mapping(map: Map) {
        super.mapping(map: map)
        constant <- map["constant"]
    }
}
