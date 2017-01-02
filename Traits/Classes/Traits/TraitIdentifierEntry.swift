//
//  Traits
//
//  Created by Krzysztof Zabłocki on 09/09/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

public struct TraitIdentifierEntry: Hashable {
    public let identifier: String
    public let classes: [AnyClass]

    public init(_ identifier: String, classes: [AnyClass]) {
        self.identifier = identifier
        self.classes = classes
    }

    public var hashValue: Int {
        return identifier.hashValue
    }
}

public func == (lhs: TraitIdentifierEntry, rhs: TraitIdentifierEntry) -> Bool {
    return lhs.identifier == rhs.identifier
}
