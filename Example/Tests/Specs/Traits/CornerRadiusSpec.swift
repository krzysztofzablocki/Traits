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

class CornerRadiusSpec: QuickSpec {
    override func spec() {
        describe("CornerRadius") {
            var sut: CornerRadius?
            let configuredRadius: CGFloat = 8

            beforeEach {
                sut = CornerRadius(radius: configuredRadius)
            }

            afterEach {
                sut = nil
            }

            it("initializes properties correctly") {
                expect(sut?.radius).to(equal(configuredRadius))
            }

            it("serializes correctly with JSON") {
                let deserialized = verifySerialization(sut)

                expect(deserialized?.radius).to(equal(configuredRadius))
            }

            it("applies correctly") {
                let views = (target: UIView(), base: UIView())
                [views.base, views.target].forEach { $0.layer.cornerRadius = 61 }    //! so we know it doesn't just nil out old values, but actually reverse them

                var reverse: Trait.RemoveClosure = {}
                guard let _ = try? sut?.apply(to: views.target, remove: &reverse) else { return fail() }

                expect(views.target.layer.cornerRadius).to(equal(configuredRadius))

                reverse()

                expect(views.target.layer.cornerRadius).to(equal(views.base.layer.cornerRadius))
            }
        }
    }
}
