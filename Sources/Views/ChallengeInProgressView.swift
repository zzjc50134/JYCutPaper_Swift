
import SwiftUI

struct ChallengeInProgressView: View {
    @State private var currentStep = 1
    @State private var totalSteps = 8
    @State private var progress: CGFloat = 0.12
    @State private var score: Int = 90
    @State private var showCompletion = false

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            VStack(spacing: 0) {
                topNavigation
                stepIndicator
                progressBar
                referenceSection
                stepHintSection
                scoreSection
                submitButton
                Spacer()
            }
            .padding(.horizontal, 24)

            if showCompletion {
                completionOverlay
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - 顶部导航
    private var topNavigation: some View {
        HStack {
            Button {
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color(hex: "2C2C2E"))
                    )
            }

            Spacer()

            VStack(spacing: 4) {
                Text("第7关：兔耳纹")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text("入门：剪圆与锯齿")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(JYColor.moonWhite.opacity(0.6))
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(JYColor.moonWhite.opacity(0.6))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color(hex: "2C2C2E"))
                    )
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - 步骤指示器
    private var stepIndicator: some View {
        HStack(spacing: 12) {
            ForEach(1...totalSteps, id: \.self) { step in
                ZStack {
                    Circle()
                        .fill(stepColor(step))
                        .frame(width: 40, height: 40)

                    if step < currentStep {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Text("\(step)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(step == currentStep ? .white : JYColor.moonWhite.opacity(0.5))
                    }
                }
                .shadow(color: step == currentStep ? JYColor.gold.opacity(0.5) : .clear, radius: 6)
            }
        }
        .padding(.vertical, 24)
    }

    private func stepColor(_ step: Int) -> Color {
        if step < currentStep {
            return JYColor.gold
        } else if step == currentStep {
            return JYColor.primaryRed
        } else {
            return Color(hex: "3A3A3C")
        }
    }

    // MARK: - 进度条
    private var progressBar: some View {
        VStack(spacing: 12) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(hex: "3A3A3C"))
                        .frame(height: 10)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [JYColor.primaryRed, JYColor.lightRed],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 10)
                }
            }
            .frame(height: 10)

            HStack {
                Text("步骤 \(currentStep) / \(totalSteps)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(JYColor.moonWhite.opacity(0.8))

                Spacer()

                Text("剪出外轮廓")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 24)
    }

    // MARK: - 参考图样区
    private var referenceSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(JYColor.primaryRed)
                .overlay(
                    CloudPattern()
                        .opacity(0.15)
                )

            VStack(spacing: 20) {
                Spacer()

                ZStack {
                    Path { path in
                        let width: CGFloat = 150
                        let height: CGFloat = 150

                        path.addEllipse(in: CGRect(x: 25, y: 50, width: 100, height: 80))
                        path.addRoundedRect(in: CGRect(x: 35, y: 10, width: 25, height: 60), cornerSize: CGSize(width: 10, height: 10))
                        path.addRoundedRect(in: CGRect(x: 90, y: 10, width: 25, height: 60), cornerSize: CGSize(width: 10, height: 10))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [8, 5]))
                    .foregroundColor(.white.opacity(0.9))

                    Text("兔耳纹")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: 80)
                }

                Spacer()

                HStack(spacing: 8) {
                    Image(systemName: "hand.point.up.fill")
                        .font(.system(size: 16))
                    Text("请沿虚线剪切")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(JYColor.moonWhite.opacity(0.9))
                .padding(.bottom, 20)
            }
            .padding(24)

            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        ToolButton(icon: "book.fill")
                        ToolButton(icon: "magnifyingglass")
                        ToolButton(icon: "lightbulb.fill")
                    }
                    .padding(16)
                }
                Spacer()
            }
        }
        .frame(height: 320)
        .padding(.bottom, 24)
    }

    // MARK: - 步骤提示
    private var stepHintSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "note.text")
                    .font(.system(size: 18))
                    .foregroundColor(JYColor.gold)
                
                Text("步骤要点")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }

            Text("先剪大块，再剪细节")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)

            Text("锯齿纹方向向外，间距约5mm")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(JYColor.moonWhite.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "2C2C2E"))
        )
        .padding(.bottom, 24)
    }

    // MARK: - 评分区
    private var scoreSection: some View {
        HStack(spacing: 24) {
            ZStack {
                Circle()
                    .stroke(Color(hex: "3A3A3C"), lineWidth: 8)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text("\(score)%")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("评分")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(JYColor.moonWhite.opacity(0.7))
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                ScoreItem(label: "吻合度", value: "60%", color: JYColor.primaryRed)
                ScoreItem(label: "完整度", value: "30%", color: JYColor.gold)
                ScoreItem(label: "精度", value: "90%", color: .green)
            }

            Spacer()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "2C2C2E"))
        )
        .padding(.bottom, 24)
    }

    private var scoreColor: Color {
        if score >= 80 {
            return .green
        } else if score >= 60 {
            return .yellow
        } else {
            return .red
        }
    }

    // MARK: - 提交按钮
    private var submitButton: some View {
        NavigationLink(destination: ChallengeListView()) {
            HStack {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18))
                Text("提交作品")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 16))
            }
            .foregroundColor(.white)
            .padding(.vertical, 18)
            .padding(.horizontal, 24)
            .background(
                LinearGradient(
                    colors: [JYColor.primaryRed, JYColor.deepRed],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: JYColor.primaryRed.opacity(0.4), radius: 12, y: 6)
        }
    }

    // MARK: - 完成弹窗
    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showCompletion = false
                    }
                }

            ScrollView {
                VStack(spacing: 32) {
                    Spacer().frame(height: 60)

                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [JYColor.gold, JYColor.brightGold],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: JYColor.gold.opacity(0.5), radius: 20)

                        Image(systemName: "checkmark")
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Text("闯关成功！")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    HStack(spacing: 16) {
                        ForEach(0..<3) { i in
                            Image(systemName: "star.fill")
                                .font(.system(size: 40))
                                .foregroundColor(JYColor.gold)
                                .shadow(color: JYColor.gold.opacity(0.6), radius: 10)
                        }
                    }

                    VStack(spacing: 12) {
                        Text("得分：92%")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(JYColor.primaryRed)

                        HStack(spacing: 32) {
                            Label("吻合度：90%", systemImage: "checkmark.circle")
                            Label("精度：95%", systemImage: "target")
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(JYColor.moonWhite.opacity(0.8))
                    }

                    VStack(spacing: 16) {
                        Button {
                            withAnimation {
                                showCompletion = false
                            }
                        } label: {
                            Text("再次挑战")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(hex: "3A3A3C"))
                                .cornerRadius(16)
                        }

                        NavigationLink(destination: ChallengeListView()) {
                            HStack {
                                Text("下一关")
                                    .font(.system(size: 17, weight: .semibold))
                                Image(systemName: "arrow.right")
                            }
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
                            .cornerRadius(16)
                        }
                    }

                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 16))
                            Text("非遗小知识")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(JYColor.gold)

                        Text("「兔耳纹象征健康长寿，常用于孩童周岁礼物」")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(JYColor.moonWhite.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(JYColor.paleGold.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(JYColor.gold.opacity(0.3), lineWidth: 1)
                            )
                    )

                    Spacer().frame(height: 60)
                }
                .padding(32)
            }
        }
    }
}

// MARK: - 工具按钮
struct ToolButton: View {
    let icon: String

    var body: some View {
        Button {
        } label: {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(JYColor.deepRed.opacity(0.9))
                )
                .shadow(color: JYColor.primaryRed.opacity(0.3), radius: 6)
        }
    }
}

// MARK: - 评分项
struct ScoreItem: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(JYColor.moonWhite.opacity(0.8))

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "3A3A3C"))
        )
    }
}

#Preview {
    ChallengeInProgressView()
}
