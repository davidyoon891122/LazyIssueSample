//
//  BoardViewModel.swift
//  LazyIssue
//
//  Created by Davidyoon on 7/4/24.
//

import Foundation

protocol BoardViewModelProtocol: ObservableObject {
    
    var boardModel: BoardModel { get set }
    var comments: [BoardComment] { get set }
    var isLoading: Bool { get }
    
    func requestBoard()
    func requestComment(needReset: Bool)
    
}

final class BoardViewModel {
    
    @Published var boardModel: BoardModel = .mockBoard
    @Published var comments: [BoardComment] = []
    
    @Published var isLoading: Bool = false
    
    private var currentPage: Int = 0
    private let displayCount: Int = 10
    
}

extension BoardViewModel: BoardViewModelProtocol {
    
    func requestBoard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.boardModel = .mockBoard
        }
    }
    
    func requestComment(needReset: Bool) {
        
        if needReset {
            self.comments = []
        }
        
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.comments += BoardComment.generateComments(page: self.currentPage, displayCount: self.displayCount)
                self.isLoading = false
                self.currentPage += 1
            }
        }
    }
    
}

private extension BoardViewModel {
    
    func reset() {
        self.comments = []
    }
    
}
