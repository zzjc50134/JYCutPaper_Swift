import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    var onComplete: (() -> Void)?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [JYColor.inkBlack, JYColor.deepRed],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 40) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(JYColor.primaryRed.opacity(0.3))
                        .frame(width: 150, height: 150)

                    ForEach(0..<6) { i in
                        PlumBlossomShape()
                            .fill(JYColor.primaryRed)
                            .frame(width: 40, height: 40)
                            .rotationEffect(Angle(degrees: Double(i) * 60))
                    }
                }
                .scaleEffect(isAnimating ? 1 : 0.5)
                .opacity(isAnimating ? 1 : 0)

                Text("京韵剪影")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [JYColor.gold, JYColor.brightGold, JYColor.gold],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 200, height: 2)
                    .opacity(showContent ? 1 : 0)

                Text("非遗剪纸 AI 平台")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(JYColor.moonWhite.opacity(0.8))
                    .opacity(showContent ? 1 : 0)

                Spacer()

                HStack(spacing: 12) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(JYColor.gold)
                            .frame(width: 10, height: 10)
                            .scaleEffect(isAnimating ? 1 : 0.3)
                    }
                }
                .opacity(showContent ? 1 : 0)

                Spacer()
                    .frame(height: 60)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
            withAnimation(.easeInOut(duration: 0.6).delay(0.5)) {
                showContent = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete?()
            }
        }
    }
}

struct PlumBlossomShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.45
        
        var path = Path()
        for i in 0..<5 {
            let angle = CGFloat(i) * .pi * 2 / 5 - .pi / 2
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
            if i == 0 {
                path.move(to: point)
            } else {
                let prevAngle = CGFloat(i - 1) * .pi * 2 / 5 - .pi / 2
                let prevPoint = CGPoint(
                    x: center.x + cos(prevAngle) * radius,
                    y: center.y + sin(prevAngle) * radius
                )
                let midPoint = CGPoint(
                    x: (prevPoint.x + point.x) / 2,
                    y: (prevPoint.y + point.y) / 2
                )
                path.addQuadCurve(to: point, control: midPoint)
            }
        }
        path.closeSubpath()
        return path
    }
}
#Preview {
    SplashView()
}
