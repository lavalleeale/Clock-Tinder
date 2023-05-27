import SwiftUI

struct VotesView: View {
    @ObservedObject var timeModel: TimeModel
    
    var body: some View {
        List {
            Text("Done: \(timeModel.votes.count)")
            Text("Left: \(timeModel.unused.count)")
            ForEach([TimeModel.vote.like, .neutral, .dislike], id: \.self) { vote in
                Section {
                    let hour = Calendar.current.component(.hour, from: Date()) % 12
                    let minute = Calendar.current.component(.minute, from: Date())
                    let total = hour * 60 + minute
                    let votes = timeModel.votes.filter {$0.value == vote}.sorted(by: { a, b in
                        ((a.key - total) < 0 ? a.key + 10000 : a.key) < ((b.key - total) < 0 ? b.key + 10000 : b.key)
                    })
                    ForEach(votes, id: \.key) { key, value in
                        Text(String(format: "%d:%02d", key / 60, key % 60))
                    }
                    .onDelete { element in
                        timeModel.removeVote(time: votes[element.first!].key)
                    }
                } header: {
                    switch vote {
                    case .like:
                        Text("Liked")
                    case .neutral:
                        Text("Neutral")
                    case .dislike:
                        Text("Disliked")
                    }
                }
            }
            TextField("Test", text: $timeModel.exportText)
            Button("Import") {
                timeModel.importText()
            }
        }
    }
}

struct VotesView_Previews: PreviewProvider {
    static var previews: some View {
        VotesView(timeModel: TimeModel())
    }
}
