//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 * TraitsProvider class used for coordinating `Trait` behaviours.
 */
public final class TraitsProvider {
    enum Error: Swift.Error {
        /**
         *  Data was malformed.
         */
        case malformedData
    }

    /**
     Function to use for logging messages from the TraitsProvider.
     */
    public typealias LogFunction = (String) -> Void

    /**
     *  Specification containing all mapping between `Trait` identifiers and the corresponding traits.
     */
    public struct Specification: Mappable {
        fileprivate var specs = [String: [Trait]]()

        public init(specs: [String: [Trait]]) {
            self.specs = specs
        }

        public init?(map: Map) {
        }

        public mutating func mapping(map: Map) {
            specs <- map["specs"]
        }
    }

    fileprivate static var registeredObjects = NSHashTable<AnyObject>.weakObjects()
    internal static var currentSpec = Specification(specs: [:] as [String: [Trait]])

    /**
     Reloads specification using serialized NSData that contains `Specification`.

     - parameter serialized: Serialized data.

     - throws: `TraitsProvider`
     */
    public static func reloadSpec(_ serialized: Data) throws {
        guard let string = String(data: serialized, encoding: String.Encoding.utf8), let newSpec = Mapper<Specification>().map(JSONString: string) else { throw Error.malformedData }
        reloadSpec(newSpec)
    }

    /**
     Reload specification.

     - parameter newSpecification: New specification to load.
     - parameter log: `LogFunction` to use for logging messages from the system.
     */
    public static func reloadSpec(_ newSpecification: Specification, log: @escaping LogFunction = { print($0) }) {
        currentSpec = newSpecification

        let objects = registeredObjects.objectEnumerator().flatMap { $0 as? Trait.Target }
        for target in objects {
            target.removeAllTraits()
            if let key = target.traitSpec {
                loadSpecForKey(key, target: target, log: log)
            }
        }
    }

    internal static func loadSpecForKey(_ key: String, target: Trait.Target, log aLog: @escaping LogFunction = { print($0) }) {
        let log: LogFunction = { message in
            aLog("[Traits]: \(message)")
        }

        registeredObjects.add(target)

        guard let traits = currentSpec.specs[key] else {
            log("unknown traits for key \(key)")
            return
        }

        traits.forEach {
            do {
                try $0.verifyTypeRequirements(target)
                var removeClosure = {}
                try $0.apply(to: target, remove: &removeClosure)

                var stack = target.traitsReversal ?? Array<RemoveClosureWrapper>()
                stack.append(RemoveClosureWrapper(block: removeClosure))
                target.traitsReversal = stack

            } catch Trait.Error.requiresOverride {
                log("apply function requires override")
            } catch let Trait.Error.unsupportedValue(info) {
                log("received unsupported value \(info)")
            } catch let Trait.Error.incorrectTarget(expected, received) {
                log("trait \(type(of: $0).typeName) doesn't support target \(received), supported types are: \(expected)")
            } catch {
                log("something went really wrong: \(error)")
            }
        }
    }
}
