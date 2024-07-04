//
//  BoardModel.swift
//  LazyIssue
//
//  Created by Davidyoon on 7/4/24.
//

import Foundation

struct BoardModel {
    
    let boardId: String
    let title: String
    let contens: String
    
}

struct BoardComment: Identifiable {

    let commentId: String
    let writer: String
    let comment: String
    let pubDate: String
    let replies: [BoardReply]
    let isUserCreate: Bool
    
    var id: String {
        self.commentId
    }
    
}

extension BoardComment: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: BoardComment, rhs: BoardComment) -> Bool {
        lhs.id == rhs.id
    }
    
}

struct BoardReply: Identifiable {
    
    let replyId: String
    let writer: String
    let title: String
    let reply: String
    let pubDate: String
    
    var id: String {
        self.replyId
    }
    
}

extension BoardModel {

    // Generate mock boards
    static var mockBoard: Self {
        .init(boardId: "board1", title: "First Board", contens: "Contents of the first board.")
    }
                
}

extension BoardComment {
    
    static let items: [Self] = Self.generateComments(page: 0, displayCount: 15)
    
    static func randomDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let randomTimeInterval = TimeInterval(arc4random_uniform(100000000))
        return formatter.string(from: Date(timeIntervalSince1970: randomTimeInterval))
    }

    // Generate mock replies
    static func generateReplies() -> [BoardReply] {
        let numberOfReplies = Int.random(in: 1...2)
        var replies = [BoardReply]()
        for i in 1...numberOfReplies {
            let reply = BoardReply(replyId: "reply\(i)", writer: "UserReply\(i)", title: "Re: Topic", reply: "This is reply \(i) to the comment.", pubDate: randomDate())
            replies.append(reply)
        }
        return replies
    }

    // Generate mock comments
    static func generateComments(page: Int, displayCount: Int = 15) -> [BoardComment] {
        var comments = [BoardComment]()
        for i in ((page * displayCount) + 1)...((page * displayCount) + displayCount) {
            let comment = BoardComment(commentId: "comment\(i)", writer: "User\(i)", comment: "This is comment \(i) on the board.", pubDate: randomDate(), replies: generateReplies(), isUserCreate: i % 2 == 0)
            comments.append(comment)
        }
        
        print(comments)
        return comments
    }

    
}

