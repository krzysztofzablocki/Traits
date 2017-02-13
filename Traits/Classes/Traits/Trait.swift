//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 *  If your trait adheres to Advanced Trait protocol, it will get access to other traits associated with the target, this is useful for implementing functionality like trait inheritance.
 */
protocol AdvancedTrait: class {
    /**
     Adds trait behaviour to the selected target

     - parameter target: An object that should receive this trait.
     - parameter allTraits: All registered traits.

     - throws: `Trait.Error`

     - returns: `RemoveClosure` that will remove the trait from the target.
     */
    func apply(to target: Trait.Target, allTraits: [String: [Trait]], remove: inout Trait.RemoveClosure) throws
}

open class TypedTrait<TraitModifiable>: Trait {
    internal override func verifyTypeRequirements(_ target: Trait.Target) throws {
        guard target is TraitModifiable else {
            throw Error.incorrectTarget(expected: [], received: type(of: target))
        }
    }

    open func applyTyped(to target: TraitModifiable, remove: inout RemoveClosure) throws {
        throw Error.requiresOverride
    }

    open override func apply(to target: NSObject, remove: inout RemoveClosure) throws {
        guard let typedTarget = target as? TraitModifiable else {
            throw Error.incorrectTarget(expected: [], received: type(of: target))
        }

        try applyTyped(to: typedTarget, remove: &remove)
    }
}

/**
 * Base class for any Trait supported in the system.
 */
@objc open class Trait: NSObject {
    public typealias Target = NSObject

    public enum Error: Swift.Error {
        /**
         Trait has unsupported value.

         - parameter info: Extra information about the issue.
         */
        case unsupportedValue(info: String)

        /**
         Trait received unsupported type of the target.
         */
        case incorrectTarget(expected: [AnyClass], received: AnyClass)

        /**
         A subclass didn't override required function.
         */
        case requiresOverride
    }

    public typealias RemoveClosure = () -> Void

    /**
     Adds trait behaviour to the selected target

     - parameter target: An object that should receive this trait.

     - throws: `Trait.Error`

     - returns: `RemoveClosure` that will remove the trait from the target.
     */
    open func apply(to target: NSObject, remove: inout RemoveClosure) throws {
        throw Error.requiresOverride
    }

    /**
     Verifies whether this trait can be applied to target, it's based on `restrictedTypes`

     - parameter target: Target to test.

     - throws: throws Error.incorrectTarget if unsupported
     */
    internal func verifyTypeRequirements(_ target: Trait.Target) throws {
        guard let types = type(of: self).restrictedTypes else { return } //! this means that it supports any type

        let supportedType = types.contains { type in target.isKind(of: type) }

        guard supportedType else {
            throw Error.incorrectTarget(expected: types, received: type(of: target))
        }
    }

    /**
     List of types supported by this trait, empty list means no type is supported, nil list means everything is.
     */
    open class var restrictedTypes: [AnyClass]? { return [] }

    /**
     Type name of the trait as a String.
     */
    class var typeName: String {
        return NSStringFromClass(self)

    }

    public override init() {}

// MARK: - Conformance to Mappable that is required in the base declaration due to type system limits

    /**
     Required initializer for ObjectMapper, unfortunately this can't be declared in the extension.

     - parameter map: Mapping object.
     */
    public required init?(map: Map) {}

    /**
     Mapping function for ObjectMapper, unfortunately this can't be declared in the extension.

     - parameter map: Mapping object.
     */
    open func mapping(map: Map) {
        var typeName = type(of: self).typeName
        typeName <- map[Trait.typeKey]
    }
}

// MARK: - Conformance to Mappable
extension Trait: Mappable, StaticMappable {
    fileprivate static let typeKey = "type"

    /**
     Resolves proper object type for the given mapping.

     - parameter map: Mapping to use.

     - returns: A new instance of a Trait to use.
     */
    public class func objectForMapping(map: Map) -> BaseMappable? {

        if let type: String = map[Trait.typeKey].value() {
            if let traitClass = NSClassFromString(type).flatMap({ $0 as? Trait.Type }) {
                return traitClass.init(map: map)
            }

            print("Unknown Trait type for key \(type)")
            return nil
        }

        print("Definition is missing `type` property")
        return nil
    }
}
