//
//  ListViewModel.swift
//  Interview
//
//  Created by Artem Kutasevych on 12/6/24.
//

import Foundation
import Combine

enum ViewState {
    case loading
    case success
}

class ListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    private let debouncer = Debouncer(delay: 0.5)
    @Published var items: [Item] = []
    @Published var viewState: ViewState = .success
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchItems(for searchWord: String) {
        debouncer.debounce { [weak self] in
            guard let self else { return }
            viewState = .loading
            networkService.getItems(for: searchWord)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] response in
                    guard let self else { return }
                    self.viewState = .success
                    self.items = response.items
                    viewState = .success
                })
                .store(in: &cancellables)
        }
    }
    
    func cleanItems() {
        items.removeAll()
    }
}
