//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Inherit trait allows you to do trait inheritance, e.g. article.cell might inherit article traits
 */
@objc public final class Inherit: Trait, AdvancedTrait {
    private(set) var traits = [String]()

    open override class var restrictedTypes: [AnyClass]? { return nil }

    open override func apply(to target: Trait.Target, remove: inout RemoveClosure) throws {
    }

    open func apply(to target: Trait.Target, allTraits: [String: [Trait]], remove: inout RemoveClosure) throws {
        var removals = [RemoveClosure]()
        for identifier in traits {
            guard let traits = allTraits[identifier] else { throw Trait.Error.unsupportedValue(info: "Identifier \(identifier) couldn't be found") }

            for trait in traits {
                var innerRemove: RemoveClosure = {}
                try trait.apply(to: target, remove: &innerRemove)
                removals.append(innerRemove)
            }
        }

        remove = { removals.reversed().forEach { $0() } }
    }

    public init(traits: [String]) {
        super.init()
        self.traits = traits
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    open override func mapping(map: Map) {
        super.mapping(map: map)
        traits <- map["traits"]
    }

}
