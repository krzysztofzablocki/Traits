//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import protocol ObjectMapper.TransformType

/**
 * SizeTransform allows you to serialize `CGSize`.
 */
open class SizeTransform: TransformType {
    public typealias Object = CGSize
    public typealias JSON = [String: CGFloat]

    open func transformFromJSON(_ value: Any?) -> Object? {
        return value.flatMap { $0 as? [String: CGFloat] }.flatMap { dictionary in
            guard let width = dictionary["width"], let height = dictionary["height"] else { return nil }
            return CGSize(width: width, height: height)
        }
    }

    open func transformToJSON(_ value: Object?) -> JSON? {
        return value.flatMap { size in
            return ["width": size.width, "height": size.height]
        }
    }
}
