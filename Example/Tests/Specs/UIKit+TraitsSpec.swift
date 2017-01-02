//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Quick
import Nimble
@testable import Traits

class NSObjectTraitsSpec: QuickSpec {
    override func spec() {
        describe("NSObject+Trait") {
            var sut: UIView?

            beforeEach {
                sut = UIView()
            }

            afterEach {
                sut = nil
            }

            it("sets traitSpecification correctly") {
                sut?.traitSpec = "test"

                expect(sut?.traitSpec).to(equal("test"))
            }

            it("applies traits from the Loader") {
                TraitsProvider.reloadSpec(TraitsProvider.Specification(specs: ["something.with.color": [BackgroundColor(color: UIColor.green)]]))
                sut?.traitSpec = "something.with.color"

                expect(sut?.backgroundColor).to(equal(UIColor.green))
            }
        }
    }
}
