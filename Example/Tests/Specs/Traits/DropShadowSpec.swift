//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Quick
import Nimble
import ObjectMapper

@testable import Traits

class DropShadowSpec: QuickSpec {
    override func spec() {
        describe("DropShadow") {
            var sut: DropShadow?
            let configuration = (offset: CGSize(width: 1, height: 2), color: UIColor(colorLiteralRed: 1.0, green: 0, blue: 0, alpha: 1), opacity: Float(2.0))

            beforeEach {
                sut = DropShadow(offset: configuration.offset, color: configuration.color, opacity: configuration.opacity)
            }

            afterEach {
                sut = nil
            }

            it("initializes properties correctly") {
                expect(sut?.offset).to(equal(configuration.offset))
                expect(sut?.color).to(equal(configuration.color))
                expect(sut?.opacity).to(equal(configuration.opacity))
            }

            it("serializes correctly with JSON") {
                let deserialized = verifySerialization(sut)

                expect(deserialized?.offset).to(equal(configuration.offset))
                expect(deserialized?.color).to(equal(configuration.color))
                expect(deserialized?.opacity).to(equal(configuration.opacity))
            }

            it("applies correctly") {
                let views = (target: UIView(), base: UIView())
                [views.base, views.target].forEach {    //! so we know it doesn't just nil out old values, but actually reverse them
                    $0.layer.shadowOffset = CGSize(width: 23, height: 21)
                    $0.layer.shadowColor = UIColor.blue.cgColor
                    $0.layer.opacity = 23.0
                }

                var reverse: Trait.RemoveClosure = {}
                guard let _ = try? sut?.apply(to: views.target, remove: &reverse) else { return fail() }

                expect(views.target.layer.shadowOffset).to(equal(configuration.offset))
                //swiftlint:disable:next force_unwrapping
                expect(UIColor(cgColor: views.target.layer.shadowColor!)).to(equal(configuration.color))
                expect(views.target.layer.shadowOpacity).to(equal(configuration.opacity))

                reverse()

                expect(views.target.layer.shadowOffset).to(equal(views.base.layer.shadowOffset))
                //swiftlint:disable:next force_unwrapping
                expect(UIColor(cgColor: views.target.layer.shadowColor!)).to(equal(UIColor(cgColor: views.base.layer.shadowColor!)))
                expect(views.target.layer.shadowOpacity).to(equal(views.base.layer.shadowOpacity))
            }
        }
    }
}
