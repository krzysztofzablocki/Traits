//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Quick
import Nimble
@testable import Traits

class TraitsProviderSpec: QuickSpec {
    override func spec() {
        describe("TraitsProvider") {

            var view: UIView?
            let configuredColor = UIColor.red

            beforeEach {
                view = UIView()
                view?.backgroundColor = configuredColor
            }

            afterEach {
                view = nil
            }

            it("re-applies traits on existing views when they change") {
                view?.traitSpec = "something.with.color"

                TraitsProvider.reloadSpec(TraitsProvider.Specification(specs: ["something.with.color": [BackgroundColor(color: UIColor.green)]]))

                expect(view?.backgroundColor).to(equal(UIColor.green))
            }

            it("calls log function with error for incorrectly typed trait") {
                view?.traitSpec = "something.with.color"

                var received: Bool?
                TraitsProvider.reloadSpec(TraitsProvider.Specification(specs: ["something.with.color": [Font(fontName: "ArielMT", fontSize: 12, fontColor: .red)]]), log: { _ in received = true })

                expect(received).toEventually(beTrue())
            }

            it("can load spec from serialized data") {
                view?.traitSpec = "something.with.color"

                guard let serialized = TraitsProvider.Specification(specs: ["something.with.color": [BackgroundColor(color: UIColor.green)]]).toJSONString()?.data(using: String.Encoding.utf8),
                let _ = try? TraitsProvider.reloadSpec(serialized) else { return fail() }

                expect(view?.backgroundColor).to(equal(UIColor.green))
            }

            it("throw error if trying to load malformed data") {
                view?.traitSpec = "something.with.color"

                //! quick has issues resolving throwing function with return param, this workarounds it
                let throwingClosure: () throws -> Void = { _ = try TraitsProvider.reloadSpec(NSData() as Data) }

                expect { try throwingClosure() }.to(throwError(TraitsProvider.Error.malformedData))
            }

            it("restores view to original state when reloading with empty spec") {
                TraitsProvider.reloadSpec(TraitsProvider.Specification(specs: ["something.with.color": [BackgroundColor(color: UIColor.green)]]))
                view?.traitSpec = "something.with.color"

                TraitsProvider.reloadSpec(TraitsProvider.Specification(specs: [:] as [String: [Trait]]))

                expect(view?.backgroundColor).to(equal(configuredColor))
            }
        }
    }
}
