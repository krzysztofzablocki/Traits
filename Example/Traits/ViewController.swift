//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import UIKit
import Traits

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.traitSpec = TraitIdentifier.containerView.identifier
    }
}
