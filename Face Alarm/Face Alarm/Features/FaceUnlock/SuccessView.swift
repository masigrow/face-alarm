import SwiftUI

struct SuccessView: View {
    let elapsedSeconds: Int
    let onClose: () -> Void

    @State private var showConfetti = false

    var timeString: String {
        let m = elapsedSeconds / 60
        let s = elapsedSeconds % 60
        if m > 0 { return "\(m)分\(s)秒" }
        return "\(s)秒"
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()

            VStack(spacing: 16) {
                Text(showConfetti ? "🎉 🎊 ✨" : "")
                    .font(.system(size: 40))
                    .animation(.easeIn(duration: 0.3), value: showConfetti)

                Text("おはようございます！")
                    .font(.title2)
                    .fontWeight(.medium)

                Text(timeString)
                    .font(.system(size: 48, weight: .thin))
                    .foregroundStyle(.green)

                Text("で起床しました")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(Date.now.formatted(date: .long, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Button("閉じる") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 24)
            }
        }
        .onAppear {
            withAnimation { showConfetti = true }
        }
    }
}

#Preview {
    SuccessView(elapsedSeconds: 134) {}
}
