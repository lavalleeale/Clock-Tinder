import Foundation
import SwiftUI

public class TimeModel: ObservableObject {
    @Published var votes: [Int: vote]
    @Published var exportText: String = ""
    @Published var unused: [Int] = []
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    init() {
        if let loaded = UserDefaults.standard.data(forKey: "votes") {
            votes = try! decoder.decode([Int: vote].self, from: loaded)
        } else {
            votes = [:]
        }
        generateExportText()
        populateUnused()
    }
    
    func populateUnused() {
        for i in 60 ... 779 {
            if votes[i] == nil {
                unused.append(i)
            }
        }
    }
    
    func removeVote(time: Int) {
        votes.removeValue(forKey: time)
        unused.append(time)
        UserDefaults.standard.set(try! encoder.encode(votes), forKey: "votes")
        generateExportText()
    }
    
    func generateExportText() {
        var toExport: [vote: [Int]] = [:]
        for vote in [vote.like, vote.neutral, vote.dislike] {
            toExport[vote] = votes.filter { $0.value == vote }.map { $0.key }
        }
        exportText = String(data: try! encoder.encode(toExport), encoding: .utf8)!
    }
    
    func importText() {
        var newVotes: [Int: vote] = [:]
        unused = []
        let toImport = try! decoder.decode([vote: [Int]].self, from: exportText.data(using: .utf8)!)
        for voteType in toImport {
            for singleVote in voteType.value {
                newVotes[singleVote] = voteType.key
            }
        }
        votes = newVotes
        populateUnused()
        UserDefaults.standard.set(try! encoder.encode(newVotes), forKey: "votes")
    }
    
    public func randomTime() -> Int? {
        return unused.randomElement()
    }
    
    public func voteTime(time: Int, vote: vote) {
        unused.removeAll { $0 == time }
        votes[time] = vote
        UserDefaults.standard.set(try! encoder.encode(votes), forKey: "votes")
        generateExportText()
    }
    
    public enum vote: String, Codable {
        case dislike, neutral = "eh", like
    }
}
