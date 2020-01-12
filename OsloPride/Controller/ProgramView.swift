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
                        ProgramRow(event: event)
                    }
                }
            }
            .navigationBarTitle(Text("Program"))
            }
        }.onAppear(perform: loadEvents)
    }
    
}

struct ProgramRow: View {
    var event: Event
    
    var body: some View {
        HStack {
//            event.image.map { (imageData) in
//                UIImage(data: imageData).map { (img) in
//                    Image(uiImage: img).resizable().frame(width: 100, height: 100)
//                }
//            }
//
            Image(uiImage: UIImage(data: event.image ?? Data()) ?? UIImage(named: "trekanter")!)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()

            
            Text(event.title ?? "")
        }
    }
}

struct ProgramView_Preview: PreviewProvider {
    static var previews: some View {
        ProgramView(showFav: true)
    }
}
