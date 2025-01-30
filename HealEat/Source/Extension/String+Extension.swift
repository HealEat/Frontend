// Copyright © 2025 HealEat. All rights reserved.

import UIKit

extension String {
    /// 문자열에서 숫자만 추출하여 Int로 변환
    var extractNumber: Int? {
        let numberString = self.filter { $0.isNumber }  // 숫자만 남기기
        return Int(numberString)  // Int로 변환
    }
}

