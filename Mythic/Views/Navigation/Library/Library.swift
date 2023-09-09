//
//  Library.swift
//  Mythic
//
//  Created by Esiayo Alegbe on 12/9/2023.
//

import SwiftUI
import SwiftyJSON

struct LibraryView: View {
    
    @State private var addGameModalPresented = false
    @State private var legendaryStatus: JSON = JSON()
    
    var body: some View {
        
        GameListView()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        addGameModalPresented.toggle()
                    }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
        
            .sheet(isPresented: $addGameModalPresented) {
                LibraryView.AddGameView(isPresented: $addGameModalPresented)
                    .fixedSize()
            }
        
            .onAppear {
                DispatchQueue.global().async {
                    let status = try! JSON(
                        data: Legendary.command(args: ["status","--json"]).stdout.data
                    )
                    DispatchQueue.main.async {
                        legendaryStatus = status
                    }
                }
            }
        
        //Text("Games available: \(String(describing: legendaryStatus["games_available"])), Games installed: \(String(describing: legendaryStatus["games_installed"]))")
    }
}

#Preview {
    LibraryView()
}
