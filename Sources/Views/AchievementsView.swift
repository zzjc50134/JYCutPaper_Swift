import SwiftUI

struct AchievementsView: View {
    @State private var achievements: [Achievement] = Achievement.allAchievements
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    progressHeader

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(achievements) { achievement in
                            AchievementBadge(achievement: achievement)
                        }
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle("成就徽章")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var progressHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Text("已获得")
                    .font(.system(size: 16))
                    .foregroundColor(JYColor.moonWhite.opacity(0.7))
                Text("\(achievements.filter { $0.isUnlocked }.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(JYColor.gold)
                Text("/ \(achievements.count)")
                    .font(.system(size: 16))
                    .foregroundColor(JYColor.moonWhite.opacity(0.5))
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2C2C2E"))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [JYColor.primaryRed, JYColor.gold],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(achievements.filter { $0.isUnlocked }.count) / CGFloat(achievements.count), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(20)
        .background(Color(hex: "2C2C2E"))
        .cornerRadius(16)
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let desc: String
    let icon: String
    let isUnlocked: Bool

    static let allAchievements: [Achievement] = [
        Achievement(title: "初识剪纸", desc: "完成第一个剪纸教程", icon: "scissors", isUnlocked: true),
        Achievement(title: "创作达人", desc: "创作10幅剪纸作品", icon: "paintbrush.fill", isUnlocked: true),
        Achievement(title: "收藏家", desc: "收藏5幅作品", icon: "bookmark.fill", isUnlocked: false),
        Achievement(title: "传承者", desc: "完成所有基础教程", icon: "graduationcap.fill", isUnlocked: false),
        Achievement(title: "大师之路", desc: "创作50幅作品", icon: "crown.fill", isUnlocked: false),
        Achievement(title: "文化使者", desc: "分享作品给好友", icon: "person.2.fill", isUnlocked: false),
        Achievement(title: "每日一剪", desc: "连续7天创作", icon: "flame.fill", isUnlocked: false),
        Achievement(title: "精通阴阳", desc: "掌握阴阳刻技巧", icon: "circle.lefthalf.filled", isUnlocked: false)
    ]
}

struct AchievementBadge: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? JYColor.gold.opacity(0.2) : Color(hex: "2C2C2E"))
                    .frame(width: 70, height: 70)

                Image(systemName: achievement.icon)
                    .font(.system(size: 30))
                    .foregroundColor(achievement.isUnlocked ? JYColor.gold : JYColor.moonWhite.opacity(0.3))
            }

            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(achievement.isUnlocked ? .white : JYColor.moonWhite.opacity(0.5))

                Text(achievement.desc)
                    .font(.system(size: 11))
                    .foregroundColor(JYColor.moonWhite.opacity(0.4))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "2C2C2E"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievement.isUnlocked ? JYColor.gold.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        AchievementsView()
    }
}
