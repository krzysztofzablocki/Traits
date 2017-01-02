//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import UIKit
import Traits

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        reloadTraits()
        TraitsProvider.setupDesktopDaemon()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func reloadTraits() {
        TraitsProvider.reloadSpec(TraitsProvider.Specification(typedSpec: [
            .containerView: [ CornerRadius(radius: 88) ],
            .backgroundView: [BackgroundColor(color: UIColor.red)],
            .childView: [
                CornerRadius(radius: 8)
            ],
            .titleLabel: [Font(fontName: "IowanOldStyle-Italic", fontSize: 20, fontColor: .blue)],
            .titleLabelLeading: [Constraint(constant: 10)],
            .titleLabelTop: [Constraint(constant: 10)],
            .childViewWidth: [Constraint(constant: 100)],
            .childViewHeight: [Constraint(constant: 100)]
            ] as [TraitIdentifier: [Trait]]))
    }

    func injected() {
        reloadTraits()
    }

}
