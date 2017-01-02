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

class FontSpec: QuickSpec {
    override func spec() {
        describe("Font") {
            var sut: Font?
            let configuration = (name: "Arial", size: CGFloat(12), color: UIColor(colorLiteralRed: 1.0, green: 0, blue: 0, alpha: 1))

            beforeEach {
                sut = Font(fontName: configuration.name, fontSize: configuration.size, fontColor: configuration.color)
            }

            afterEach {
                sut = nil
            }

            it("initializes properties correctly") {
                expect(sut?.fontName).to(equal(configuration.name))
                expect(sut?.fontSize).to(equal(configuration.size))
                expect(sut?.fontColor).to(equal(configuration.color))
            }

            it("serializes correctly with JSON") {
                let deserialized = verifySerialization(sut)

                expect(deserialized?.fontName).to(equal(configuration.name))
                expect(deserialized?.fontSize).to(equal(configuration.size))
                expect(deserialized?.fontColor).to(equal(configuration.color))
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
                let views = (target: UILabel(), base: UILabel())
                [views.base, views.target].forEach { $0.font = UIFont.systemFont(ofSize: 53) } //! so we know it doesn't just nil out old values, but actually reverse them

                var reverse: Trait.RemoveClosure = {}
                guard let _ = try? sut?.apply(to: views.target, remove: &reverse) else { return fail() }

                expect(views.target.font.familyName).to(equal(configuration.name))
                expect(views.target.font.pointSize).to(equal(configuration.size))

                reverse()

                expect(views.target.font).to(equal(views.base.font))
            }
        }
    }
}
