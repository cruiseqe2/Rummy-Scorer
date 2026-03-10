//
//  Model.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 17/02/2026.
//

import Foundation
import SwiftUI

@Observable
class Model {
    
    struct DealerOption: Identifiable, Hashable {
        let id = UUID()
        let name: String
    }
    
    struct scoreEntry: Identifiable {
        var id: UUID = UUID()
        var scoreLine: Int
        var playerNumber: Int
        var credits: Int?
        var debits: Int?
        var total: Int
    }
    
    var players = ["Elaine", "Mark"]
    
    var gameFinished = false
    var winnerIs: Int? = nil
    
    var dealerOptions: [DealerOption] {
        players.map { DealerOption(name: $0) }
    }
    
    var firstDealer: DealerOption? = nil
    
    var player0DealsFirst: Bool? {
        if let firstDealer {
            if firstDealer.name == players[0] {
                return true
            } else {
                return false
            }
        } else {
            return nil
        }
    }
    
    var useJokers: Bool = true
    var jokerValue: Int = 10
    var playUpTo: Int = 500
    
    var p0TotalRightEdge: CGFloat = 0
    var p1TotalRightEdge: CGFloat = 0
    
    var stackPath: [String] = []
    
    var lineNumber: Int = 1
    var p0EntryMade: Bool = false
    var p1EntryMade: Bool = false
    
    var scoreSheet: [scoreEntry] = []
    
    var p0Total: Int {
        scoreSheet
            .filter { $0.playerNumber == 0 }
            .reduce(0) { $0 + $1.total }
    }
    
    var p1Total: Int {
        scoreSheet
            .filter { $0.playerNumber == 1 }
            .reduce(0) { $0 + $1.total }
    }
    
    func addScoreEntry(scoreLine: Int, playerNumber: Int, credits: Int, debits: Int) {
        scoreSheet.append(scoreEntry(scoreLine: scoreLine, playerNumber: playerNumber, credits: credits, debits: debits, total: credits - debits))
        sortOutTheButtons(forPlayer: playerNumber)
        checkForWinner()
    }
    
    func addScoreEntry(scoreLine: Int, playerNumber: Int, total: Int) {
        scoreSheet.append(scoreEntry(scoreLine: scoreLine, playerNumber: playerNumber, credits: nil, debits: nil, total: total))
        sortOutTheButtons(forPlayer: playerNumber)
        checkForWinner()
    }
    
    func sortOutTheButtons(forPlayer: Int) {
        if forPlayer == 0 { p0EntryMade = true }
        if forPlayer == 1 { p1EntryMade = true }
        if p0EntryMade && p1EntryMade {
            lineNumber += 1
            p0EntryMade = false
            p1EntryMade = false
        }
    }
    
    func checkForWinner() {
        if p0EntryMade == p1EntryMade {
            if p0Total >= playUpTo && p1Total >= playUpTo {
                if p0Total == p1Total {
                    gameFinished = true
                    winnerIs = 2
                } else {
                    if p0Total >= p1Total {
                        gameFinished = true
                        winnerIs = 0
                    } else {
                        gameFinished = true
                        winnerIs = 1
                    }
                }
            } else {
                if p0Total >= playUpTo {
                    gameFinished = true
                    winnerIs = 0
                }
                if p1Total >= playUpTo {
                    gameFinished = true
                    winnerIs = 1
                }
            }
        }
    }
    
    func getFigures(forLine line: Int, andPlayer player: Int) -> (found: Bool, credits: Int?, debits: Int?, total: Int) {
        if let entry = scoreSheet.first(where: { $0.scoreLine == line && $0.playerNumber == player }) {
            return (true, entry.credits ?? nil, entry.debits ?? nil, entry.total)
        } else {
            return (false, nil, nil, 0)
        }
    }
    
}
