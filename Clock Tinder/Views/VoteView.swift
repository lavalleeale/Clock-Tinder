import SwiftUI

struct VoteView: View {
    @ObservedObject var timeModel: TimeModel
    @State var currentTime: Int?
    @State var textOffset: CGFloat = 0

    init(timeModel: TimeModel) {
        self.timeModel = timeModel
        _currentTime = State(initialValue: timeModel.randomTime())
    }

    var body: some View {
        if currentTime != nil {
            VStack {
                Spacer()
                Text(String(format: "%d:%02d", currentTime! / 60, currentTime! % 60))
                    .bold()
                    .font(.system(size: 100))
                    .offset(x: textOffset)
                Spacer()
                HStack(spacing: 50) {
                    Button {
                        vote(.dislike)
                    } label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                    }
                    Button {
                        vote(.neutral)
                    } label: {
                        Image(systemName: "hand.thumbsup.circle")
                            .resizable()
                            .rotationEffect(
                                Angle(degrees: 90)
                            )
                            .frame(width: 75, height: 75)
                    }
                    Button {
                        vote(.like)
                    } label: {
                        Image(systemName: "heart.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                    }
                }
            }
        } else {
            Text("Finished ))):")
                .bold()
                .font(.system(size: 100))
                .offset(x: textOffset)
        }
    }

    func vote(_ vote: TimeModel.vote) {
        timeModel.voteTime(time: currentTime!, vote: vote)
        withAnimation(Animation.easeIn(duration: 0.5)) {
            textOffset = 300
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            currentTime = timeModel.randomTime()
            textOffset = -300
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                textOffset = 0
            }
        }
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView(timeModel: TimeModel())
    }
}
