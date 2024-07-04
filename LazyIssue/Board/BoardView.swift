//
//  BoardView.swift
//  LazyIssue
//
//  Created by Davidyoon on 7/4/24.
//

import SwiftUI

struct BoardView<Model>: View where Model: BoardViewModel {
    
    @StateObject private var viewModel: Model
    @State private var selectedCommentID: String?
    @State private var isCommentOptionViewOpened: Bool = false
    
    init(viewModel: Model) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Profile
                BoardProfile()
                
                // Content
                BoardContent()
                
                VStack {
                    Divider()
                }
                .padding(.vertical)
                
                LazyVStack {
                    ForEach(viewModel.comments) { comment in
                        CommentView(comment: comment, isSelected: selectedCommentID == comment.id) {
                            selectedCommentID = comment.id
                            isCommentOptionViewOpened.toggle()
                        }
                            .onAppear {
                                if comment == viewModel.comments.last {
                                    viewModel.requestComment(needReset: false)
                                }
                            }
                            .confirmationDialog("CommentMoreButton", isPresented: $isCommentOptionViewOpened) {
                                if comment.isUserCreate {
                                    Button("Modify") {
                                        print("did tap modify button")
                                    }
                                    
                                    Button("Delete") {
                                        print("did tap delete button")
                                    }
                                } else {
                                    Button("Report") {
                                        print("did tap report Button")
                                    }
                                }
                            }
                    }
                }
                
                
                
            }
        }
        .onAppear {
            viewModel.requestBoard()
            viewModel.requestComment(needReset: true)
        }
    }
    
}

#Preview {
    BoardView(viewModel: BoardViewModel())
}

struct CommentView: View {
    
    let comment: BoardComment
    let isSelected: Bool
    let onMoreTapped: () -> Void
    
    @State private var isCommentOptionViewOpened: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(comment.writer)
                            .bold()
                        Spacer()
                        Button(action: {
                            onMoreTapped()
                        }, label: {
                            Image(systemName: "ellipsis")
                                .tint(.gray)
                        })
                    }
                    Text(comment.pubDate)
                }
            }
            Text(comment.comment)
                .padding()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct BoardContent: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .bold()
                .font(.system(size: 20))
                .padding(.vertical)
            Text("ContentContentContentContentContentContentContentContent")
                .bold()
        }
        .padding(.horizontal)
    }
}

struct BoardProfile: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                HStack {
                    Text("Writer")
                    Spacer()
                    Text("2024.07.04")
                }
                Text("Writer rank")
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding()
    }
}
