//
//  DetailsView.swift
//  Interview
//
//  Created by Artem Kutasevych on 12/7/24.
//


import SwiftUI

struct DetailsView: View {
    let item: Item
    
    var body: some View {
            ScrollView {
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
                    .frame(width: 300, height: 300)
                    Text(item.title)
                        .padding()
                        .font(.system(size: 24))
                        .bold()
                        .multilineTextAlignment(.center)
                    Text(item.description)
                        .padding(16)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                    Text("Author: \(item.author)")
                        .padding()
                        .font(.system(size: 20))
                        .bold()
                        .multilineTextAlignment(.center)
                    Text(item.date_taken, style: .date)
                        .padding()
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                }
            }
        }
}
