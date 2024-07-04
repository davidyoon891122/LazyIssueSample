//
//  ContentView.swift
//  LazyIssue
//
//  Created by Davidyoon on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        BoardView(viewModel: BoardViewModel())
    }
}

#Preview {
    ContentView()
}
