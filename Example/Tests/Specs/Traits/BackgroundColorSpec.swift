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

class BackgroundColorSpec: QuickSpec {
    override func spec() {
        describe("BackgroundColor") {
            var sut: BackgroundColor?
            let configuredColor = UIColor.red

            beforeEach {
                sut = BackgroundColor(color: configuredColor)
            }

            afterEach {
                sut = nil
            }

            it("initializes properties correctly") {
                expect(sut?.color).to(equal(configuredColor))
            }

            it("serializes correctly with JSON") {
                let deserialized = verifySerialization(sut)

                expect(deserialized?.color).to(equal(configuredColor))
            }

            it("applies correctly") {
                let views = (target: UIView(), base: UIView())
                [views.base, views.target].forEach { $0.backgroundColor = UIColor.green }    //! so we know it doesn't just nil out old values, but actually reverse them

                var reverse: Trait.RemoveClosure = {}
                guard let _ = try? sut?.apply(to: views.target, remove: &reverse) else { return fail() }

                expect(views.target.backgroundColor).to(equal(configuredColor))

                reverse()

                expect(views.target.backgroundColor).to(equal(views.base.backgroundColor))
            }
        }
    }
}
