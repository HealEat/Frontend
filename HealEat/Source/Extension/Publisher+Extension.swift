// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Combine

extension Publisher {
    func sinkHandledCompletion(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        return self.sink(receiveCompletion: handleCompletion, receiveValue: receiveValue)
    }
    
    private func handleCompletion(completion: Subscribers.Completion<Self.Failure>) {
        switch completion {
        case .finished: break
        case .failure(let error):
            switch error {
            case let healEatError as HealEatError:
                NSLog(healEatError.description)
                fallthrough
            default:
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func manageThread() -> AnyPublisher<Output, Failure> {
        return self
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
