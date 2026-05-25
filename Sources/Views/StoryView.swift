
import SwiftUI

struct StoryView: View {
    private let stories: [StoryItem] = [
        StoryItem(
            id: 1,
            title: "窗花奶奶的传承",
            subtitle: "剪纸世家四代人的坚守",
            chapter: "第一章",
            progress: "已完成",
            isUnlocked: true
        ),
        StoryItem(
            id: 2,
            title: "从艺之路",
            subtitle: "拜师学艺的十年",
            chapter: "第二章",
            progress: "进行中",
            isUnlocked: true
        ),
        StoryItem(
            id: 3,
            title: "创新与传承",
            subtitle: "AI时代的非遗新篇章",
            chapter: "第三章",
            progress: "未解锁",
            isUnlocked: false
        )
    ]

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    storiesList
                }
                .padding(.vertical, 24)
                .padding(.bottom, 120)
            }
        }
        .navigationTitle("匠魂漫话")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 头部区域
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [JYColor.primaryRed, JYColor.deepRed],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [JYColor.gold, JYColor.brightGold],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )

                Image(systemName: "book.closed.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.white)
            }

            VStack(spacing: 8) {
                Text("非遗大师故事")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text("聆听匠人故事，传承非遗文化")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(JYColor.moonWhite.opacity(0.7))
            }

            HStack(spacing: 32) {
                StoryStat(icon: "book.fill", value: "3", label: "章节")
                StoryStat(icon: "clock.fill", value: "45分钟", label: "时长")
                StoryStat(icon: "person.fill", value: "2位", label: "大师")
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: "2C2C2E"))
        )
        .padding(.horizontal, 24)
    }

    // MARK: - 故事列表
    private var storiesList: some View {
        VStack(spacing: 20) {
            ForEach(stories) { story in
                StoryCard(story: story)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - 故事统计
struct StoryStat: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(JYColor.gold)

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(JYColor.moonWhite.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 故事卡片
struct StoryCard: View {
    let story: StoryItem

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: story.isUnlocked ? 
                                [JYColor.deepRed, JYColor.primaryRed] : 
                                [Color(hex: "2C2C2E"), Color(hex: "252528")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        CloudPattern()
                            .opacity(story.isUnlocked ? 0.15 : 0)
                    )

                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "bookmark.fill")
                                    .font(.system(size: 12))
                                Text(story.chapter)
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(JYColor.gold)

                            Text(story.title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)

                            Text(story.subtitle)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(JYColor.moonWhite.opacity(0.8))
                        }

                        Spacer()

                        if !story.isUnlocked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 24))
                                .foregroundColor(JYColor.moonWhite.opacity(0.4))
                        }
                    }

                    Spacer()

                    HStack {
                        Label(story.progress, systemImage: story.isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(story.isUnlocked ? JYColor.gold : JYColor.moonWhite.opacity(0.5))

                        Spacer()

                        if story.isUnlocked {
                            HStack(spacing: 4) {
                                Text("开始阅读")
                                Image(systemName: "arrow.right")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                            )
                        }
                    }
                }
                .padding(24)
            }
            .frame(height: 200)
        }
    }
}

// MARK: - 故事数据模型
struct StoryItem: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let chapter: String
    let progress: String
    let isUnlocked: Bool
}

#Preview {
    NavigationView {
        StoryView()
    }
}
