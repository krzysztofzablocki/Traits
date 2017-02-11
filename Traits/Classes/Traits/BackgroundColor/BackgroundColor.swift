//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol BackgroundColorModifiable: class {
    var backgroundColor: UIColor? { get set }
}

extension UIView: BackgroundColorModifiable {}

public final class BackgroundColor: TypedTrait<BackgroundColorModifiable> {
    private(set) var color: UIColor?

    open override func applyTyped(to target: BackgroundColorModifiable, remove: inout RemoveClosure) throws {
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
