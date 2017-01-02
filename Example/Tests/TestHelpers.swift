//
//  Traits
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import ObjectMapper

func verifySerialization<T: Mappable>(_ sut: T?) -> T? {
    guard let sut = sut else { return nil }

    let serialized = Mapper().toJSONString(sut)
    let deserialized = Mapper<T>().map(JSONString: serialized ?? "")
    return deserialized
}
