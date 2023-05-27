import Foundation

class CompareModel: ObservableObject {
    @Published var commonNum: Int?
    @Published var commonVotes: [TimeModel.vote: [Int]]?
    private var decoder = JSONDecoder()
    private var encoder = JSONEncoder()
    
    func compare(otherText: String, timeModel: TimeModel) {
        let data = otherText.data(using: .utf8)!
        compareData(data: data, timeModel: timeModel)
    }
    
    func load(timeModel: TimeModel) {
        if let data = UserDefaults.standard.data(forKey: "compare") {
            compareData(data: data, timeModel: timeModel)            
        }
    }
    
    private func compareData(data: Data, timeModel: TimeModel) {
        self.commonVotes = [:]
        self.commonNum = 0
        let toImport = try! decoder.decode([TimeModel.vote: [Int]].self, from: data)
        UserDefaults.standard.set(data, forKey: "compare")
        for voteType in toImport {
            self.commonVotes![voteType.key] = []
            for singleVote in voteType.value {
                if let selfVote = timeModel.votes[singleVote] {
                    self.commonNum! += 1
                    if selfVote == voteType.key {
                        commonVotes![voteType.key]!.append(singleVote)
                    }
                }
            }
        }
    }
}
