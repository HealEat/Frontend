// Copyright © 2025 HealEat. All rights reserved.

import Foundation

extension Bundle {
    
    var naverConsumerKey: String? {
        guard let file = self.path(forResource: "Secret", ofType: "plist") else { return nil }
        guard let resource = NSDictionary(contentsOfFile: file) else { return nil }
        
        guard let key = resource["naver_consumer_key"] as? String else { return nil }
        return key
    }
    var naverConsumerSecret: String? {
        guard let file = self.path(forResource: "Secret", ofType: "plist") else { return nil }
        guard let resource = NSDictionary(contentsOfFile: file) else { return nil }
        
        guard let key = resource["naver_consumer_secret"] as? String else { return nil }
        return key
    }
}
