import SwiftUI
import AVFoundation

struct FaceUnlockView: View {
    let alarm: Alarm
    let firingTime: Date
    @StateObject private var vm = CameraFeedViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            CameraPreview(vm: vm)
                .ignoresSafeArea()

            VStack {
                // Progress ring top-right
                HStack {
                    Spacer()
                    ProgressRingView(progress: vm.progress, remaining: remainingSeconds)
                        .padding(20)
                }
                Spacer()

                // Face frame
                ZStack {
                    Ellipse()
                        .strokeBorder(vm.faceDetected ? Color.green : Color.red, lineWidth: 2)
                        .frame(width: 160, height: 190)

                    if !vm.faceDetected {
                        Text("顔が検出できません")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .offset(y: 110)
                    }
                }

                Spacer()

                Text("両目を開けたままキープしてください")
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.bottom, 60)
            }
        }
        .onAppear {
            vm.start(targetDuration: alarm.faceDuration, firingTime: firingTime)
        }
        .onDisappear { vm.stop() }
        .fullScreenCover(isPresented: $vm.dismissed) {
            SuccessView(elapsedSeconds: vm.elapsedSeconds) {
                dismiss()
            }
        }
    }

    private var remainingSeconds: Int {
        let remaining = alarm.faceDuration - Int(Double(alarm.faceDuration) * vm.progress)
        return max(remaining, 0)
    }
}

struct ProgressRingView: View {
    let progress: Double
    let remaining: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: progress)
            Text("\(remaining)")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
        }
        .frame(width: 52, height: 52)
    }
}

struct CameraPreview: UIViewRepresentable {
    let vm: CameraFeedViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let layer = vm.previewLayer
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.frame = uiView.bounds
        }
    }
}
