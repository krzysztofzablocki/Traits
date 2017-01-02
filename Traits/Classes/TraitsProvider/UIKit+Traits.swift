//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import UIKit

private enum Keys {
    static var specKey: UInt8 = 1
    static var reverseKey: UInt8 = 2
}

@objc internal class RemoveClosureWrapper: NSObject {
    let block: Trait.RemoveClosure
    init(block: @escaping Trait.RemoveClosure) {
        self.block = block
    }
}

public extension NSObject {
    /**
     * Defines an identifier for trait specification.
     */
    var traitSpec: String? {
        get {
            return objc_getAssociatedObject(self, &Keys.specKey) as? String
        }

        set {
            if let key = newValue {
                TraitsProvider.loadSpecForKey(key, target: self)
            }

            objc_setAssociatedObject(self, &Keys.specKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    internal var traitsReversal: [ RemoveClosureWrapper ]? {
        get {
            return objc_getAssociatedObject(self, &Keys.reverseKey) as? [RemoveClosureWrapper]
        }

        set {
            objc_setAssociatedObject(self, &Keys.reverseKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    /**
     Removes all traits from the object.
     */
    internal func removeAllTraits() {
        traitsReversal?.forEach { $0.block() }
        traitsReversal = nil
    }
}

public extension UIView {
    /**
     * Defines an identifier for trait specification.
     */
    @IBInspectable override var traitSpec: String? { get { return super.traitSpec } set { super.traitSpec = newValue } }
}

public extension NSLayoutConstraint {
    /**
     * Defines an identifier for trait specification.
     */
    @IBInspectable override var traitSpec: String? { get { return super.traitSpec } set { super.traitSpec = newValue } }
}
