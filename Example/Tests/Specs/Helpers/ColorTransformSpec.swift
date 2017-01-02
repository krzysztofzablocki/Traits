//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Quick
import Nimble

@testable import Traits

class ColorTransformSpec: QuickSpec {
    override func spec() {
        describe("ColorTransform") {
            var sut: ColorTransform?

            beforeEach {
                sut = ColorTransform()
            }

            afterEach {
                sut = nil
            }

            describe("mapping from json") {
                it("returns UIColor from hex string") {
                    expect(sut?.transformFromJSON("#ff0000")).to(equal(UIColor(colorLiteralRed: 1.0, green: 0, blue: 0, alpha: 1)))
                }

                it("returns nil on invalid object type") {
                    expect(sut?.transformFromJSON(2)).to(beNil())
                }
            }

            describe("mapping to JSON") {

                it("returns hex string from color") {
                    expect(sut?.transformToJSON(UIColor(colorLiteralRed: 1.0, green: 0, blue: 0, alpha: 1))).to(equal("#ff0000"))
                }

                it("returns nil when passed it nil color") {
                    expect(sut?.transformToJSON(nil)).to(beNil())
                }
            }
        }
    }
}
