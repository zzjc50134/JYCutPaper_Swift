
import SwiftUI

struct ChallengeListView: View {
    @State private var expandedChapters: Set<Int> = [1]
    @State private var selectedChapter: Int = 1

    private let chapters: [Chapter] = [
        Chapter(
            id: 1,
            name: "入门：剪圆与锯齿",
            chineseName: "壹",
            challenges: [
                Challenge(id: 1, name: "剪圆基础", chapter: "第一章", isCompleted: true, isCurrent: false, isLocked: false, stars: 3),
                Challenge(id: 2, name: "双鱼纹", chapter: "第一章", isCompleted: true, isCurrent: false, isLocked: false, stars: 3),
                Challenge(id: 3, name: "梅花纹", chapter: "第一章", isCompleted: true, isCurrent: false, isLocked: false, stars: 2),
                Challenge(id: 4, name: "锯齿纹", chapter: "第一章", isCompleted: true, isCurrent: false, isLocked: false, stars: 3),
                Challenge(id: 5, name: "入门考核", chapter: "第一章", isCompleted: true, isCurrent: false, isLocked: false, stars: 3)
            ],
            isExpanded: true
        ),
        Chapter(
            id: 2,
            name: "进阶：纹样组合",
            chineseName: "贰",
            challenges: [
                Challenge(id: 6, name: "福字纹", chapter: "第二章", isCompleted: true, isCurrent: false, isLocked: false, stars: 3),
                Challenge(id: 7, name: "兔耳纹", chapter: "第二章", isCompleted: false, isCurrent: true, isLocked: false, stars: 0),
                Challenge(id: 8, name: "牡丹纹", chapter: "第二章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 9, name: "喜鹊纹", chapter: "第二章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 10, name: "进阶考核", chapter: "第二章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0)
            ],
            isExpanded: false
        ),
        Chapter(
            id: 3,
            name: "高级：复杂构图",
            chineseName: "叁",
            challenges: [
                Challenge(id: 11, name: "龙凤呈祥", chapter: "第三章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 12, name: "连年有余", chapter: "第三章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 13, name: "福禄寿喜", chapter: "第三章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 14, name: "花开富贵", chapter: "第三章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 15, name: "高级考核", chapter: "第三章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0)
            ],
            isExpanded: false
        ),
        Chapter(
            id: 4,
            name: "大师：创作自由",
            chineseName: "肆",
            challenges: [
                Challenge(id: 16, name: "自由创作", chapter: "第四章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 17, name: "主题创作", chapter: "第四章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 18, name: "组合创作", chapter: "第四章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 19, name: "综合创作", chapter: "第四章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0),
                Challenge(id: 20, name: "大师考核", chapter: "第四章", isCompleted: false, isCurrent: false, isLocked: true, stars: 0)
            ],
            isExpanded: false
        )
    ]

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    progressOverview
                    chaptersList
                }
                .padding(.vertical, 24)
                .padding(.bottom, 120)
            }
        }
        .navigationTitle("闯关学艺")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 进度概览
    private var progressOverview: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("总进度")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(JYColor.moonWhite.opacity(0.8))

                    Text("7/20 关卡")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text("继续加油，距离大师之路更近一步！")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(JYColor.moonWhite.opacity(0.6))
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(JYColor.primaryRed.opacity(0.2), lineWidth: 10)
                        .frame(width: 90, height: 90)

                    Circle()
                        .trim(from: 0, to: 0.35)
                        .stroke(JYColor.primaryRed, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-90))

                    Text("35%")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [JYColor.deepRed, JYColor.primaryRed],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 8)

                    Capsule()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.35, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 24)
    }

    // MARK: - 章节列表
    private var chaptersList: some View {
        VStack(spacing: 20) {
            ForEach(chapters) { chapter in
                ChapterCard(
                    chapter: chapter,
                    isExpanded: expandedChapters.contains(chapter.id),
                    onToggle: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if expandedChapters.contains(chapter.id) {
                                expandedChapters.remove(chapter.id)
                            } else {
                                expandedChapters.insert(chapter.id)
                            }
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - 章节卡片
struct ChapterCard: View {
    let chapter: Chapter
    let isExpanded: Bool
    let onToggle: () -> Void

    private var completedCount: Int {
        chapter.challenges.filter { $0.isCompleted }.count
    }

    private var isAllCompleted: Bool {
        chapter.challenges.allSatisfy { $0.isCompleted }
    }

    private var currentChallenge: Challenge? {
        chapter.challenges.first { $0.isCurrent }
    }

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [JYColor.gold, JYColor.brightGold],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)

                        Text(chapter.chineseName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(chapter.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        HStack(spacing: 8) {
                            if isAllCompleted {
                                Label("已完成", systemImage: "checkmark.circle.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.green)
                            } else if let current = currentChallenge {
                                Label("进行中", systemImage: "play.circle.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(JYColor.gold)
                            } else {
                                Label("未解锁", systemImage: "lock.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(JYColor.moonWhite.opacity(0.5))
                            }

                            Text("•")
                                .foregroundColor(JYColor.moonWhite.opacity(0.4))

                            Text("\(completedCount)/\(chapter.challenges.count) 关")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(JYColor.moonWhite.opacity(0.7))
                        }
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(JYColor.moonWhite.opacity(0.6))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "2C2C2E"))
                )
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 5), spacing: 16) {
                    ForEach(chapter.challenges) { challenge in
                        ChallengeGridItem(challenge: challenge)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "252528"))
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// MARK: - 关卡格子
struct ChallengeGridItem: View {
    let challenge: Challenge

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(color: shadowColor, radius: 6, y: 3)

            VStack(spacing: 6) {
                if challenge.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(JYColor.moonWhite.opacity(0.4))
                } else if challenge.isCurrent {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 40, height: 40)

                        Image(systemName: "scissors")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }

                    Text("闯关")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    if challenge.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(JYColor.gold)
                    }

                    Text("L\(challenge.id)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)

                    if challenge.isCompleted {
                        HStack(spacing: 2) {
                            ForEach(0..<3) { i in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(i < challenge.stars ? JYColor.gold : Color.gray.opacity(0.3))
                            }
                        }
                    }
                }
            }
        }
        .frame(height: 90)
    }

    private var backgroundColor: Color {
        if challenge.isLocked {
            return Color(hex: "2C2C2E")
        } else if challenge.isCurrent {
            return JYColor.primaryRed
        } else if challenge.isCompleted {
            return JYColor.deepRed.opacity(0.6)
        } else {
            return JYColor.deepRed.opacity(0.3)
        }
    }

    private var borderColor: Color {
        if challenge.isCurrent {
            return JYColor.gold
        } else if challenge.isCompleted {
            return JYColor.gold.opacity(0.6)
        }
        return .clear
    }

    private var borderWidth: CGFloat {
        (challenge.isCurrent || challenge.isCompleted) ? 2 : 0
    }

    private var shadowColor: Color {
        if challenge.isCurrent {
            return JYColor.gold.opacity(0.4)
        } else if challenge.isCompleted {
            return JYColor.primaryRed.opacity(0.3)
        }
        return .clear
    }
}

#Preview {
    NavigationView {
        ChallengeListView()
    }
}
