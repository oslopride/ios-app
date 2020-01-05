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
}

struct ProgramView: View {

    let data = [
        ProgramEvent(id: 0, text: "hei"),
        ProgramEvent(id: 1, text: "på"),
        ProgramEvent(id: 2, text: "deg"),
    ]

    var body: some View {
        NavigationView {
            List(data) { d in
                NavigationLink(destination: ProgramDetail(text: d.text)) {
                    ProgramRow(text: d.text)
                }
            }
            .navigationBarTitle(Text("Program"))
        }
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
        ProgramView()
    }
}
