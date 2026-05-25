import SwiftUI
import AVFoundation
import Vision

struct ScanView: View {
    @Environment(\.dismiss) var dismiss
    @State private var recognizedRegions: [CutRegion] = []
    @State private var isAnalyzing = false
    @State private var showGuide = true
    
    var body: some View {
        ZStack {
            CameraPreviewView(recognizedRegions: $recognizedRegions)
                .ignoresSafeArea()
            
            VStack {
                topBar
                Spacer()
                
                if !recognizedRegions.isEmpty {
                    instructionCard
                }
                
                bottomControls
            }
            
            if showGuide && recognizedRegions.isEmpty {
                guideOverlay
            }
        }
        .onAppear {
            startAnalysis()
        }
    }
    
    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("纸张扫描")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
            
            Spacer()
            
            Button {
                showGuide.toggle()
            } label: {
                Image(systemName: showGuide ? "questionmark.circle.fill" : "questionmark.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
    }
    
    private var bottomControls: some View {
        VStack(spacing: 20) {
            if isAnalyzing {
                HStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                    Text("正在识别纸张...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.black.opacity(0.6))
                .cornerRadius(12)
            }
            
            HStack(spacing: 40) {
                controlButton(icon: "camera.rotate", title: "翻转") {
                }
                
                controlButton(icon: "viewfinder", title: "对焦") {
                    startAnalysis()
                }
                
                controlButton(icon: "light.max", title: "闪光") {
                }
            }
            .padding(.bottom, 50)
        }
    }
    
    private func controlButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(width: 70, height: 70)
            .background(Color.black.opacity(0.4))
            .cornerRadius(16)
        }
    }
    
    private var instructionCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "4CD964"))
                
                Text("已识别到 \(recognizedRegions.count) 个裁剪区域")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text("红色阴影区域为建议裁剪位置，请确认后点击确认")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
            } label: {
                Text("确认裁剪")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [JYColor.primaryRed, JYColor.deepRed],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.8))
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 160)
    }
    
    private var guideOverlay: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "doc.viewfinder")
                    .font(.system(size: 48))
                    .foregroundColor(JYColor.gold)
                
                Text("将纸张放入框内")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("系统将自动识别可裁剪区域")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(40)
            .background(Color.black.opacity(0.6))
            .cornerRadius(20)
            
            Spacer()
                .frame(height: 200)
        }
    }
    
    private func startAnalysis() {
        isAnalyzing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            recognizedRegions = generateMockRegions()
            isAnalyzing = false
        }
    }
    
    private func generateMockRegions() -> [CutRegion] {
        return [
            CutRegion(id: 1, points: [
                CGPoint(x: 0.25, y: 0.3),
                CGPoint(x: 0.45, y: 0.3),
                CGPoint(x: 0.45, y: 0.5),
                CGPoint(x: 0.25, y: 0.5)
            ], confidence: 0.95, label: "内侧剪裁"),
            CutRegion(id: 2, points: [
                CGPoint(x: 0.55, y: 0.35),
                CGPoint(x: 0.75, y: 0.35),
                CGPoint(x: 0.75, y: 0.55),
                CGPoint(x: 0.55, y: 0.55)
            ], confidence: 0.88, label: "边缘装饰")
        ]
    }
}

struct CameraPreviewView: UIViewRepresentable {
    @Binding var recognizedRegions: [CutRegion]
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        
        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return view
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        
        let overlayView = CutRegionOverlayView(frame: UIScreen.main.bounds)
        view.addSubview(overlayView)
        
        context.coordinator.overlayView = overlayView
        context.coordinator.session = session
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.overlayView?.regions = recognizedRegions
        context.coordinator.overlayView?.setNeedsDisplay()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var overlayView: CutRegionOverlayView?
        var session: AVCaptureSession?
    }
}

class CutRegionOverlayView: UIView {
    var regions: [CutRegion] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for region in regions {
            context.setFillColor(UIColor(red: 0.76, green: 0.23, blue: 0.13, alpha: 0.4).cgColor)
            context.setStrokeColor(UIColor(red: 0.76, green: 0.23, blue: 0.13, alpha: 0.9).cgColor)
            context.setLineWidth(3)
            
            let path = UIBezierPath()
            let points = region.points.map { point in
                CGPoint(x: point.x * bounds.width, y: point.y * bounds.height)
            }
            
            guard points.count >= 3 else { continue }
            
            path.move(to: points[0])
            for i in 1..<points.count {
                path.addLine(to: points[i])
            }
            path.close()
            
            context.addPath(path.cgPath)
            context.fillPath()
            
            context.addPath(path.cgPath)
            context.strokePath()
            
            let labelPoint = CGPoint(
                x: points[0].x,
                y: points[0].y - 25
            )
            
            let labelText = "\(region.label) \(Int(region.confidence * 100))%"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            
            let textSize = labelText.size(withAttributes: attributes)
            let labelRect = CGRect(
                x: labelPoint.x - textSize.width / 2 - 8,
                y: labelPoint.y - textSize.height / 2 - 4,
                width: textSize.width + 16,
                height: textSize.height + 8
            )
            
            context.setFillColor(UIColor(red: 0.76, green: 0.23, blue: 0.13, alpha: 0.9).cgColor)
            let labelPath = UIBezierPath(roundedRect: labelRect, cornerRadius: 6)
            context.addPath(labelPath.cgPath)
            context.fillPath()
            
            labelText.draw(at: CGPoint(x: labelPoint.x - textSize.width / 2, y: labelPoint.y - textSize.height / 2), withAttributes: attributes)
        }
    }
}

struct CutRegion: Identifiable {
    let id: Int
    let points: [CGPoint]
    let confidence: Double
    let label: String
}

#Preview {
    ScanView()
}
