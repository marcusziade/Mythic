//
//  GameListEvo.swift
//  Mythic
//
//  Created by Esiayo Alegbe on 6/3/2024.
//

import SwiftUI

struct GameListEvo: View {
    @State private var searchString: String = .init()
    @State private var refresh: Bool = false
    
    @State private var isGameImportViewPresented: Bool = false
    
    private var games: [Game] {
        let unifiedGames = (LocalGames.library ?? []) + ((try? Legendary.getInstallable()) ?? [])
        return unifiedGames
            .filter {
                searchString.isEmpty ||
                $0.title.localizedCaseInsensitiveContains(searchString)
            }
            .sorted(by: { $0.title < $1.title })
            .sorted(by: { $0.isFavourited && !$1.isFavourited })
    }
    
    var body: some View {
        if !games.isEmpty {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(games) { game in
                        GameCard(game: .constant(game))
                            .padding()
                    }
                }
                .searchable(text: $searchString, placement: .toolbar)
            }
        } else {
            Text("No games can be shown.")
                .font(.bold(.title)())
            
            Button {
                
            } label: {
                Label("Import game", systemImage: "plus.app")
                    .padding(5)
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $isGameImportViewPresented) {
                LibraryView.GameImportView(
                    isPresented: $isGameImportViewPresented,
                    isGameListRefreshCalled: .constant(false) // FIXME: refactor gameimport
                )
                .fixedSize()
            }
            
        }
    }
}

#Preview {
    GameListEvo()
        .environmentObject(NetworkMonitor())
}