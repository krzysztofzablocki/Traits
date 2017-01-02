//
//  Traits
//
//  Created by Krzysztof Zabłocki on 29/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ObjectMapper

@testable import Traits

class ConstraintSpec: QuickSpec {
    override func spec() {
        describe("Constraint") {
            var sut: Constraint?
            let configured = CGFloat(10)

            beforeEach {
                sut = Constraint(constant: configured)
            }

            afterEach {
                sut = nil
            }

            it("initializes properties correctly") {
                expect(sut?.constant).to(equal(configured))
            }

            it("serializes correctly with JSON") {
                let deserialized = verifySerialization(sut)

                expect(deserialized?.constant).to(equal(configured))
            }

            it("throws an error if passed in wrong type") {
                guard let sut = sut else { return fail() }

                //! quick has issues resolving throwing function with return param, this workarounds it
                let throwingClosure: () throws -> Void = { _ = try sut.verifyTypeRequirements(UIView()) }

                expect { try throwingClosure() }.to(throwError(closure: { error in
                    var properType = false
                    //swiftlint:disable:next force_cast
                    if case .incorrectTarget = (error as! Trait.Error) { properType = true }
                    expect(properType).to(beTrue())
                }))
            }

            it("applies correctly") {
                let constraints = (target: NSLayoutConstraint(), base: NSLayoutConstraint())
                [constraints.base, constraints.target].forEach { $0.constant = 123 } //! so we know it doesn't just nil out old values, but actually reverse them

                var reverse: Trait.RemoveClosure = {}
                guard let _ = try? sut?.apply(to: constraints.target, remove: &reverse) else { return fail() }

                expect(constraints.target.constant).to(equal(configured))

                reverse()

                expect(constraints.target.constant).to(equal(constraints.base.constant))
            }
        }
    }
}
