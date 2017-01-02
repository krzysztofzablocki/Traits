//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Quick
import Nimble
import class ObjectMapper.Map
@testable import Traits

class TestTrait: Trait {}

class TraitSpec: QuickSpec {
    override func spec() {
        describe("Trait") {
            var sut: Trait?

            beforeEach {
                sut = TestTrait()
            }

            afterEach {
                sut = nil
            }

            it("throws an error if subclass doesn't override apply") {
                guard let sut = sut else { return fail() }
                var reverse: Trait.RemoveClosure = {}

                //! quick has issues resolving throwing function with return param, this workarounds it
                let throwingClosure: () throws -> Void = { _ = try sut.apply(to: UIView(), remove: &reverse) }

                expect { try throwingClosure() }.to(throwError(Trait.Error.requiresOverride))
            }

            it("generates correct typeName") {
                expect(TestTrait.typeName).to(equal("TestTrait"))
            }

            it("contains factory for new type") {
                expect(Trait.factories.keys).to(contain("TestTrait"))
            }

            describe("when mapping") {
                it("resolves to correct Type from json") {
                    let map = Map(mappingType: .fromJSON, JSON: [ "type": "TestTrait"])

                    expect((Trait.objectForMapping(map: map) as? NSObject)).to(beAKindOf(TestTrait.self))
                }

                it("saves Type name to json") {
                    let map = Map(mappingType: .toJSON, JSON: [:])

                    sut?.mapping(map: map)

                    expect(map.JSON["type"] as? String).to(equal("TestTrait"))
                }
            }
        }
    }
}
