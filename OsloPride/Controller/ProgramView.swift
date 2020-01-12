//
//  ProgramView.swift
//  OsloPride
//
//  Created by Adrian Evensen on 01/01/2020.
//  Copyright © 2020 Adrian Evensen. All rights reserved.
//

import SwiftUI

struct ProgramEvent: Identifiable {
    var id: Int
    var text: String
    var favourite: Bool
}

struct ProgramView: View {
    @State var showFav: Bool = false
    
    @State var events: [Event] = []
    
    let data = [
        ProgramEvent(id: 0, text: "hei", favourite: true),
        ProgramEvent(id: 1, text: "på", favourite: false),
        ProgramEvent(id: 2, text: "deg", favourite: true),
    ]
    
    func loadEvents() {
        CoreDataManager.shared.getAllEvents { (e) in
            self.events = e
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
            List {
                Toggle(isOn: $showFav) {
                    Text("Favourites Only")
                }
                ForEach(events, id: \.id) { event in
                    NavigationLink(destination: ProgramDetail(text: event.title ?? "")) {
                        Text(event.title ?? "")
                    }
                }
            }
            .navigationBarTitle(Text("Program"))
            }
        }.onAppear(perform: loadEvents)
    }
    
}

struct ProgramDetail: View {
    var text: String
    
    var body: some View {
        VStack {
            Text(text)
        }
    }
}

struct ProgramRow: View {
    
    let text: String
    
    var body: some View {
        HStack {
            Text(text).font(.title)
        }
    }
}
struct ProgramView_Preview: PreviewProvider {
    static var previews: some View {
        ProgramView(showFav: true)
    }
}
