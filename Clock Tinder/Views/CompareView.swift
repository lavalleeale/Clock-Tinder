import SwiftUI

struct CompareView: View {
    @ObservedObject var timeModel: TimeModel
    @ObservedObject var compareModel = CompareModel()
    @State var pie = PieChart()
    @State var compareText = ""

    var body: some View {
        VStack {
            List {
                if compareModel.commonNum != nil {
                    Text("Total comparable votes: \(compareModel.commonNum!)")
                    Section {
                        let commonLikes = Double(compareModel.commonVotes![TimeModel.vote.like]!.count)
                        let commonNeutrals = Double(compareModel.commonVotes![TimeModel.vote.neutral]!.count)
                        let commonDislikes = Double(compareModel.commonVotes![TimeModel.vote.dislike]!.count)
                        pie.chart(
                            PlottableValue(name: "Common Likes", value: commonLikes, color: .green),
                            PlottableValue(name: "Common Neutrals", value: commonNeutrals, color: .yellow),
                            PlottableValue(name: "Common Dislikes", value: commonDislikes, color: .red),
                            PlottableValue(name: "Uncommon", value: Double(compareModel.commonNum!) - commonLikes - commonDislikes - commonNeutrals, color: .gray)
                        )
                    } header: {
                        Text("Total comparable votes: \(compareModel.commonNum!)")
                    }
                    let hour = Calendar.current.component(.hour, from: Date()) % 12
                    let minute = Calendar.current.component(.minute, from: Date())
                    let total = hour * 60 + minute
                    ForEach([TimeModel.vote.like, .neutral, .dislike], id: \.self) { vote in
                        Section {
                            ForEach(compareModel.commonVotes![vote]!.sorted(by: { a, b in
                                ((a - total) < 0 ? a + 10000 : a) < ((b - total) < 0 ? b + 10000 : b)
                            }), id: \.self) { time in
                                Text(String(format: "%d:%02d", time / 60, time % 60))
                            }
                        } header: {
                            switch vote {
                            case .like:
                                Text("Common Liked")
                            case .neutral:
                                Text("Common Neutral")
                            case .dislike:
                                Text("Common Disliked")
                            }
                        }
                    }
                }
                TextField("Friend's Exported Data", text: $compareText)
                Button("Import") {
                    compareModel.compare(otherText: compareText, timeModel: timeModel)
                }
            }
        }.onAppear {
            compareModel.load(timeModel: timeModel)
        }
    }
}

struct CompareView_Previews: PreviewProvider {
    static var previews: some View {
        CompareView(timeModel: TimeModel())
    }
}
