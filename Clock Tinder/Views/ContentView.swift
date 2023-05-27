import SwiftUI

struct ContentView: View {
    @ObservedObject var timeModel: TimeModel

    init() {
        timeModel = TimeModel()
    }

    var body: some View {
        TabView {
            VoteView(timeModel: timeModel)
                .badge(timeModel.unused.count)
                .tabItem {
                    Label("Vote", systemImage: "envelope.fill")
                }
            VotesView(timeModel: timeModel)
                .tabItem {
                    Label("Votes", systemImage: "chart.bar.fill")
                }
            CompareView(timeModel: timeModel)
                .tabItem {
                    Label("Compare", systemImage: "person.2.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
