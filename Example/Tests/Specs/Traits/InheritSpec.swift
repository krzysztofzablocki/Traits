//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ObjectMapper

@testable import Traits

class InheritSpec: QuickSpec {
    override func spec() {
        describe("Inherit") {
            var sut: Inherit?
            let configuredTraits = ["colorTrait"]

            beforeEach {
                sut = Inherit(traits: configuredTraits)
            }

            afterEach {
                sut = nil
            }

            it("initializes properties correctly") {
                expect(sut?.traits).to(equal(configuredTraits))
            }

            it("serializes correctly with JSON") {
                let deserialized = verifySerialization(sut)

                expect(deserialized?.traits).to(equal(configuredTraits))
            }

            it("applies correctly") {
                let views = (target: UIView(), base: UIView())
                [views.base, views.target].forEach { $0.backgroundColor = UIColor.green }    //! so we know it doesn't just nil out old values, but actually reverse them

                var reverse: Trait.RemoveClosure = {}
                guard let _ = try? sut?.apply(to: views.target, allTraits: ["colorTrait": [BackgroundColor(color: UIColor.blue)]], remove: &reverse) else { return fail() }

                expect(views.target.backgroundColor).to(equal(UIColor.blue))

                reverse()

                expect(views.target.backgroundColor).to(equal(views.base.backgroundColor))
            }
        }
    }
}
