//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Quick
import Nimble

@testable import Traits

class SizeTransformSpec: QuickSpec {
    override func spec() {
        describe("SizeTransform") {
            let size = CGSize(width: 1.0, height: 2.0)
            let serialized: [String: CGFloat] = ["width": 1.0, "height": 2.0]

            var sut: SizeTransform?

            beforeEach {
                sut = SizeTransform()
            }

            afterEach {
                sut = nil
            }

            describe("mapping from json") {

                it("returns CGSize from dictionary") {
                    expect(sut?.transformFromJSON(serialized)).to(equal(size))
                }

                it("returns nil on invalid object type") {
                    expect(sut?.transformFromJSON(2)).to(beNil())
                }
            }

            describe("mapping to JSON") {

                it("returns dictionary from size") {
                    guard let json = sut?.transformToJSON(size) else { return fail() }

                    expect(json).to(equal(serialized))
                }

                it("returns nil when passed it nil color") {
                    expect(sut?.transformToJSON(nil)).to(beNil())
                }
            }
        }
    }
}
