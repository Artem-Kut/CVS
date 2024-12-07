//
//  NetworkServiceMock.swift
//  CVSTest
//
//  Created by Artem Kutasevych on 12/7/24.
//

import Foundation
import Combine
@testable import CVSTest

class NetworkServiceMock: NetworkServiceProtocol {
    
    
    var getItemsCallsCount = 0
    var getItemsCalled: Bool {
        return getItemsCallsCount > 0
    }
    
    var itemsReturnValue = Items(items: [])
    var error: APIError?
    var closure: (() -> Void)?
    
    func getItems(for searchWord: String) -> AnyPublisher<Items, any Error> {
        closure?()
        getItemsCallsCount += 1
        if let error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        return Just(itemsReturnValue)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
