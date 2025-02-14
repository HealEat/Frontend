// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Combine

extension Publisher {
    func sinkHandledCompletion(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        self.sink(receiveCompletion: { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                switch error {
                case let healEatError as HealEatError:
                    print(healEatError.description)
                default:
                    print(error.localizedDescription)
                }
            }
        }, receiveValue: receiveValue)
    }
}
