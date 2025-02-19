// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Combine

extension Publisher {
    func sinkHandledCompletion(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        return self.sink(receiveCompletion: { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                switch error {
                case let healEatError as HealEatError:
                    print(healEatError.description)
                    fallthrough
                default:
                    print(error.localizedDescription)
                }
            }
        }, receiveValue: receiveValue)
    }
    
    func manageThread() -> AnyPublisher<Output, Failure> {
        return self
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
