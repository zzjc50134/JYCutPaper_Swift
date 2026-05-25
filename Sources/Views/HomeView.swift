
import SwiftUI

struct HomeView: View {
    @State private var showCulturalDetail = false
    @State private var showScanView = false

    private let todayPatterns = [
        PatternItem(id: 1, name: "福字", meaning: "福满人间", difficulty: .beginner),
        PatternItem(id: 2, name: "双鱼", meaning: "年年有余", difficulty: .beginner),
        PatternItem(id: 3, name: "牡丹", meaning: "富贵花开", difficulty: .intermediate),
        PatternItem(id: 4, name: "喜鹊", meaning: "喜上眉梢", difficulty: .master)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                todayCultureSection
                
                scanButtonSection

                bannerSection

                mainCardsSection

                recommendedPatternsSection

                progressSection
            }
            .padding(.vertical, 24)
        }
        .background(JYColor.inkBlack)
        .sheet(isPresented: $showCulturalDetail) {
            CulturalDetailSheet()
        }
        .fullScreenCover(isPresented: $showScanView) {
            ScanView()
        }
    }

    // MARK: - 今日文化模块
    private var todayCultureSection: some View {
        Button {
            showCulturalDetail = true
        } label: {
            ZStack {
                Rectangle()
                    .fill(JYColor.deepRed)
                    .overlay(
                        CloudPattern()
                            .opacity(0.15)
                    )

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "lantern.fill")
                            .font(.system(size: 18))
                            .foregroundColor(JYColor.gold)
                        
                        Text("今日文化")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(JYColor.moonWhite.opacity(0.9))

                        Spacer()
                    }

                    Text("小年来临剪窗花")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    HStack {
                        Text("腊月二十三 · 剪窗花迎新年")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(JYColor.moonWhite.opacity(0.7))

                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(JYColor.moonWhite.opacity(0.5))
                    }
                }
                .padding(24)

                VStack {
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [JYColor.gold, JYColor.brightGold, JYColor.gold],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 2)
                }
            }
            .frame(height: 140)
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, 24)
    }
    
    // MARK: - 扫描纸张入口
    private var scanButtonSection: some View {
        Button {
            showScanView = true
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(JYColor.primaryRed.opacity(0.2))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "viewfinder")
                        .font(.system(size: 28))
                        .foregroundColor(JYColor.primaryRed)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("扫描纸张")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("识别裁剪区域，智能辅助剪纸")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(JYColor.moonWhite.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(JYColor.gold)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "2C2C2E"))
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, 24)
    }

    // MARK: - Banner区域
    private var bannerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("精选推荐")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<3) { i in
                        BannerCard(
                            gradient: cardGradient(i),
                            title: bannerTitle(i),
                            subtitle: bannerSubtitle(i)
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }

    private func cardGradient(_ index: Int) -> LinearGradient {
        let colors: [[Color]] = [
            [JYColor.primaryRed, JYColor.deepRed],
            [JYColor.gold, JYColor.brightGold],
            [JYColor.deepInkBlue, JYColor.navyBlue]
        ]
        return LinearGradient(
            colors: colors[index % colors.count],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func bannerTitle(_ index: Int) -> String {
        ["「腊月窗花」主题闯关", "AI生成新图样上线", "非遗大师故事更新"][index]
    }

    private func bannerSubtitle(_ index: Int) -> String {
        ["限时活动进行中", "创作中心全新体验", "第三章节已解锁"][index]
    }

    // MARK: - 三大入口卡片
    private var mainCardsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("快速入口")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 24)

            VStack(spacing: 24) {
                GeometryReader { geometry in
                    HStack(spacing: 18) {
                        NavigationLink(destination: ChallengeListView()) {
                            MainCard(
                                icon: "scissors",
                                title: "闯关学艺",
                                subtitle: "L1-L20 · 从剪圆到大师",
                                progress: "已通过 7 关",
                                badge: "继续"
                            )
                            .frame(width: (geometry.size.width - 18) / 2)
                        }

                        NavigationLink(destination: CreateView()) {
                            MainCard(
                                icon: "paintbrush.fill",
                                title: "AI创作",
                                subtitle: "文生图 · 图生图 · 元素组合",
                                progress: "今日创作 3 次",
                                badge: nil
                            )
                            .frame(width: (geometry.size.width - 18) / 2)
                        }
                    }
                }
                .frame(height: 190)

                NavigationLink(destination: StoryView()) {
                    MainCard(
                        icon: "book.closed.fill",
                        title: "匠魂漫话",
                        subtitle: "走进非遗大师的故事",
                        progress: "已解锁 2 章节",
                        badge: nil,
                        fullWidth: true
                    )
                }
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - 今日推荐图样
    private var recommendedPatternsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("今日推荐")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Button {
                } label: {
                    HStack(spacing: 4) {
                        Text("更多")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(JYColor.gold)
                }
            }
            .padding(.horizontal, 24)

            Divider()
                .background(
                    LinearGradient(
                        colors: [JYColor.gold.opacity(0.5), JYColor.gold.opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(todayPatterns) { pattern in
                        PatternCard(pattern: pattern)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - 我的进度
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("我的进度")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            ProgressCard()
                .padding(.horizontal, 24)
        }
        .padding(.bottom, 120)
    }
}

// MARK: - Banner卡片组件
struct BannerCard: View {
    let gradient: LinearGradient
    let title: String
    let subtitle: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(gradient)

            VStack(alignment: .leading, spacing: 12) {
                Spacer()
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .frame(width: 320, height: 160)
    }
}

// MARK: - 主卡片组件
struct MainCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let progress: String
    let badge: String?
    var fullWidth: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [JYColor.primaryRed, JYColor.deepRed],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(JYColor.primaryRed.opacity(0.2))
                            .frame(width: 52, height: 52)

                        Image(systemName: icon)
                            .font(.system(size: 26))
                            .foregroundColor(JYColor.primaryRed)
                    }

                    Spacer()

                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(JYColor.primaryRed)
                            .cornerRadius(8)
                    }
                }

                Text(title)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(JYColor.moonWhite.opacity(0.7))
                    .lineLimit(2)

                HStack {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12))
                    Text(progress)
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundColor(JYColor.gold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(JYColor.gold.opacity(0.15))
                )
            }
            .padding(18)
        }
        .frame(height: fullWidth ? 170 : 190)
        .frame(maxWidth: fullWidth ? .infinity : nil)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "2C2C2E"))
                .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
        )
    }
}

// MARK: - 进度卡片
struct ProgressCard: View {
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("7/20")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(JYColor.primaryRed)

                    Text("当前：第7关「兔耳纹」")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(JYColor.moonWhite.opacity(0.7))
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(JYColor.primaryRed.opacity(0.2), lineWidth: 8)
                        .frame(width: 70, height: 70)

                    Circle()
                        .trim(from: 0, to: 0.35)
                        .stroke(JYColor.primaryRed, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))

                    Text("35%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }

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
                        .frame(width: geometry.size.width * 0.35, height: 10)
                }
            }
            .frame(height: 10)

            NavigationLink(destination: ChallengeInProgressView()) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16))
                    
                    Text("继续闯关")
                        .font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14))
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
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
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "2C2C2E"))
        )
    }
}

// MARK: - 图样卡片
struct PatternCard: View {
    let pattern: PatternItem

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(JYColor.primaryRed.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(JYColor.primaryRed.opacity(0.3), lineWidth: 2)
                    )

                Text(pattern.name)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(JYColor.primaryRed)
            }
            .frame(width: 140, height: 140)

            Text(pattern.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            Text(pattern.meaning)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(JYColor.moonWhite.opacity(0.6))
                .multilineTextAlignment(.center)

            HStack(spacing: 4) {
                ForEach(0..<difficultyLevel, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                }
                Text(difficultyLabel)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(JYColor.gold)
        }
        .frame(width: 140)
    }

    private var difficultyLevel: Int {
        switch pattern.difficulty {
        case .beginner: return 1
        case .intermediate: return 2
        case .master: return 3
        }
    }

    private var difficultyLabel: String {
        switch pattern.difficulty {
        case .beginner: return "入门"
        case .intermediate: return "进阶"
        case .master: return "大师"
        }
    }
}

// MARK: - 云纹装饰
struct CloudPattern: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height

                path.move(to: CGPoint(x: 0, y: height * 0.6))
                path.addQuadCurve(
                    to: CGPoint(x: width * 0.3, y: height * 0.4),
                    control: CGPoint(x: width * 0.15, y: height * 0.5)
                )
                path.addQuadCurve(
                    to: CGPoint(x: width * 0.6, y: height * 0.5),
                    control: CGPoint(x: width * 0.45, y: height * 0.35)
                )
                path.addQuadCurve(
                    to: CGPoint(x: width, y: height * 0.6),
                    control: CGPoint(x: width * 0.8, y: height * 0.5)
                )
            }
            .stroke(JYColor.gold.opacity(0.3), lineWidth: 1)
        }
    }
}

// MARK: - 文化详情弹窗
struct CulturalDetailSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                JYColor.deepRed.ignoresSafeArea()

                VStack(spacing: 32) {
                    Image(systemName: "lantern.fill")
                        .font(.system(size: 80))
                        .foregroundColor(JYColor.gold)
                        .padding(.top, 40)

                    Text("小年来临剪窗花")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Text("""
                    农历腊月二十三，是传统的小年节日。

                    民间有「二十三，糖瓜粘」的传统，同时这一天也是贴窗花、迎祥瑞的重要日子。

                    剪纸艺术历史悠久，窗花寓意吉祥，是中华民族独特的民间艺术瑰宝。
                    """)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(JYColor.moonWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(JYColor.moonWhite.opacity(0.7))
                    }
                }
            }
        }
    }
}

// MARK: - 按钮样式
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    HomeView()
}
