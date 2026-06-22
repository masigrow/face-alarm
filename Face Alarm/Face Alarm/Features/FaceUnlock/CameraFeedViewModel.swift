import AVFoundation
import Vision
import Combine

final class CameraFeedViewModel: NSObject, ObservableObject {
    @Published var faceDetected = false
    @Published var eyesOpen = false
    @Published var progress: Double = 0
    @Published var dismissed = false
    @Published var elapsedSeconds: Int = 0

    var targetDuration: Int = 5
    private var holdFrames = 0
    private var firingTime: Date = .now
    private let captureSession = AVCaptureSession()
    private let output = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session")
    private var displayLink: CADisplayLink?

    var previewLayer: AVCaptureVideoPreviewLayer {
        AVCaptureVideoPreviewLayer(session: captureSession)
    }

    func start(targetDuration: Int, firingTime: Date) {
        self.targetDuration = targetDuration
        self.firingTime = firingTime
        sessionQueue.async { [weak self] in
            self?.setupSession()
            self?.captureSession.startRunning()
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            self?.captureSession.stopRunning()
        }
        displayLink?.invalidate()
    }

    private func setupSession() {
        captureSession.beginConfiguration()
        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
            let input = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(input)
        else { return }
        captureSession.addInput(input)
        output.setSampleBufferDelegate(self, queue: sessionQueue)
        if captureSession.canAddOutput(output) { captureSession.addOutput(output) }
        captureSession.commitConfiguration()
    }
}

extension CameraFeedViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNDetectFaceLandmarksRequest { [weak self] req, _ in
            self?.handleFaceResult(req)
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored)
            .perform([request])
    }

    private func handleFaceResult(_ request: VNRequest) {
        guard let face = (request.results as? [VNFaceObservation])?.first else {
            DispatchQueue.main.async { [weak self] in
                self?.faceDetected = false
                self?.eyesOpen = false
                self?.holdFrames = 0
                self?.progress = 0
            }
            return
        }

        let leftOpen = face.landmarks?.leftEye != nil
        let rightOpen = face.landmarks?.rightEye != nil
        let bothOpen = leftOpen && rightOpen

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.faceDetected = true
            self.eyesOpen = bothOpen

            let targetFrames = self.targetDuration * 30
            if bothOpen {
                self.holdFrames = min(self.holdFrames + 1, targetFrames)
            } else {
                self.holdFrames = 0
            }
            self.progress = Double(self.holdFrames) / Double(targetFrames)

            if self.holdFrames >= targetFrames && !self.dismissed {
                self.elapsedSeconds = Int(Date.now.timeIntervalSince(self.firingTime))
                self.dismissed = true
                self.stop()
            }
        }
    }
}
