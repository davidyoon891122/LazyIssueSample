//
//  BoardView.swift
//  LazyIssue
//
//  Created by Davidyoon on 7/4/24.
//

import SwiftUI

struct BoardView<Model>: View where Model: BoardViewModel {
    
    @StateObject private var viewModel: Model
    @State private var selectedCommentID: String? // 선택된 댓글의 ID를 저장
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
                
                // 레이지하게 생성된 CommetView 비정상(하지만 이게 정상적인 사용 방식이다)
                LazyVStack {
                    ForEach(viewModel.comments) { comment in
                        CommentView(comment: comment, isOptionViewOpened: selectedCommentID == comment.id, onOptionTap: {
                            selectedCommentID = comment.id
                            isCommentOptionViewOpened = true
                        })
                            .onAppear {
                                if comment == viewModel.comments.last {
                                    viewModel.requestComment(needReset: false)
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
        .confirmationDialog("CommentMoreButton", isPresented: $isCommentOptionViewOpened) {
            if let selectedComment = viewModel.comments.first(where: { $0.id == selectedCommentID }) {
                if selectedComment.isUserCreate {
                    Button("Modify") {
                        print("did tap modify button")
                        print(selectedComment.isUserCreate)
                        print(selectedComment.id)
                    }
                    
                    Button("Delete") {
                        print("did tap delete button")
                        print(selectedComment.isUserCreate)
                        print(selectedComment.id)
                    }
                } else {
                    Button("Report") {
                        print("did tap report Button")
                        print(selectedComment.isUserCreate)
                        print(selectedComment.id)
                    }
                }
            }
        }
    }
    
}

#Preview {
    BoardView(viewModel: BoardViewModel())
}

struct CommentView: View {
    
    let comment: BoardComment
    let isOptionViewOpened: Bool
    let onOptionTap: () -> Void
    
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
                            onOptionTap()
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
