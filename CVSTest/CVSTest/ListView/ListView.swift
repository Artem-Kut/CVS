import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewModel(networkService: NetworkService())
    @State private var searchWord = ""
    @State private var showingActionSheet = false
    let columns = [
        GridItem(.adaptive(minimum: 150))
       ]
    
    var body: some View {
        NavigationStack {
            if viewModel.viewState == .loading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.items, id: \.self) { item in
                            NavigationLink {
                                DetailsView(item: item)
                            } label: {
                                VStack {
                                    VStack {
                                        AsyncImage(url: URL(string: item.media.m)) { phase in
                                            switch phase {
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .font(.largeTitle)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            default:
                                                ProgressView()
                                            }
                                        }
                                        .clipShape(.rect(cornerRadius: 10))
                                    }
                                    Text(item.tags)
                                        .frame(height: 25)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .searchable(text: $searchWord)
        .onSubmit(of: .search) {
            startSearch()
        }
        .onChange(of: searchWord, perform: { _ in
            if searchWord.isEmpty {
                viewModel.cleanItems()
            }
            guard searchWord.count > 2 else {
                return
            }
            viewModel.fetchItems(for: searchWord)
        })
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Search word should contain at least 3 symbols"),
                buttons: [
                    .default(Text("Ok")) {
                        showingActionSheet = false
                    }
                ]
            )
        }
    }
    
    private func startSearch() {
        guard searchWord.count > 2 else {
            showingActionSheet = true
            return
        }
        
        viewModel.fetchItems(for: searchWord)
    }
       
}

#Preview {
    ListView()
}
