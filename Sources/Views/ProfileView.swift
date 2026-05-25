
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    @State private var showHistory = false
    @State private var showFavorites = false
    @State private var showAchievements = false
    @State private var showHelp = false
    @State private var showSettings = false
    @State private var showGenerationHistory = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                userInfoCard
                statsSection
                menuSection
                logoutButton
                deleteAccountButton
                versionSection
            }
            .padding(.vertical, 24)
        }
        .background(JYColor.inkBlack)
        .navigationTitle("我的")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showHistory) {
            NavigationView {
                HistoryView()
            }
        }
        .sheet(isPresented: $showFavorites) {
            NavigationView {
                FavoritesView()
            }
        }
        .sheet(isPresented: $showAchievements) {
            NavigationView {
                AchievementsView()
            }
        }
        .sheet(isPresented: $showHelp) {
            NavigationView {
                HelpView()
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationView {
                SettingsView()
            }
        }
        .sheet(isPresented: $showGenerationHistory) {
            NavigationView {
                GenerationHistoryView()
            }
        }
        .alert("退出登录", isPresented: $showLogoutAlert) {
            Button("取消", role: .cancel) {}
            Button("确定", role: .destructive) {
                logout()
            }
        } message: {
            Text("确定要退出登录吗？")
        }
        .alert("注销账号", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("注销", role: .destructive) {
                deleteAccount()
            }
        } message: {
            Text("注销后您的所有数据将被删除，且无法恢复。确定要注销账号吗？")
        }
    }

    // MARK: - 用户信息卡片
    private var userInfoCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [JYColor.deepRed, JYColor.primaryRed],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    CloudPattern()
                        .opacity(0.15)
                )

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(JYColor.gold.opacity(0.2))
                        .frame(width: 100, height: 100)

                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [JYColor.gold, JYColor.brightGold],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 100, height: 100)

                    Image(systemName: "person.fill")
                        .font(.system(size: 44))
                        .foregroundColor(JYColor.gold)
                }

                VStack(spacing: 8) {
                    Text(appState.currentUser?.nickname ?? "剪纸学徒")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text(appState.currentUser?.level ?? "非遗传承人")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(JYColor.moonWhite.opacity(0.8))
                }

                HStack(spacing: 32) {
                    BadgeItem(icon: "star.fill", value: "7关", label: "闯关")
                    BadgeItem(icon: "paintbrush.fill", value: "12次", label: "创作")
                    BadgeItem(icon: "book.closed.fill", value: "2章", label: "漫剧")
                }
            }
            .padding(32)
        }
        .padding(.horizontal, 24)
    }

    // MARK: - 数据统计
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("我的数据")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            HStack(spacing: 16) {
                StatCard(title: "闯关进度", value: "7/20", icon: "target", color: JYColor.primaryRed)
                StatCard(title: "创作次数", value: "12", icon: "paintbrush", color: JYColor.gold)
                StatCard(title: "获得星星", value: "21", icon: "star.fill", color: JYColor.brightGold)
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - 功能菜单
    private var menuSection: some View {
        VStack(spacing: 12) {
            MenuItem(icon: "paintbrush.pointed.fill", title: "创作记录", hasArrow: true) {
                showGenerationHistory = true
            }
            MenuItem(icon: "clock.arrow.circlepath", title: "学习历史", hasArrow: true) {
                showHistory = true
            }
            MenuItem(icon: "bookmark.fill", title: "我的收藏", hasArrow: true) {
                showFavorites = true
            }
            MenuItem(icon: "trophy.fill", title: "成就徽章", hasArrow: true) {
                showAchievements = true
            }
            MenuItem(icon: "gearshape.fill", title: "设置", hasArrow: true) {
                showSettings = true
            }
            MenuItem(icon: "questionmark.circle.fill", title: "帮助与反馈", hasArrow: true) {
                showHelp = true
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - 退出登录按钮
    private var logoutButton: some View {
        Button {
            showLogoutAlert = true
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18))
                Text("退出登录")
                    .font(.system(size: 17, weight: .medium))
            }
            .foregroundColor(JYColor.primaryRed)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(JYColor.primaryRed, lineWidth: 2)
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }

    // MARK: - 注销账号按钮
    private var deleteAccountButton: some View {
        Button {
            showDeleteAlert = true
        } label: {
            HStack {
                Image(systemName: "trash")
                    .font(.system(size: 18))
                Text("注销账号")
                    .font(.system(size: 17, weight: .medium))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.red, lineWidth: 2)
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }

    // MARK: - 版本信息
    private var versionSection: some View {
        VStack(spacing: 8) {
            Text("京韵剪影 v1.0.0")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(JYColor.moonWhite.opacity(0.5))

            Text("非遗剪纸 AI 平台")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(JYColor.moonWhite.opacity(0.3))
        }
        .padding(.top, 24)
        .padding(.bottom, 120)
    }

    private func logout() {
        Task {
            try? await APIService.shared.logout()
            await MainActor.run {
                appState.isLoggedIn = false
                appState.currentUser = nil
            }
        }
    }

    private func deleteAccount() {
        guard let userId = appState.currentUser?.id else { return }
        Task {
            try? await APIService.shared.deleteAccount(userId: userId)
            await MainActor.run {
                appState.isLoggedIn = false
                appState.currentUser = nil
            }
        }
    }
}

// MARK: - 徽章组件
struct BadgeItem: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(JYColor.gold)

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(JYColor.moonWhite.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(JYColor.inkBlack.opacity(0.3))
        )
    }
}

// MARK: - 统计卡片
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }

            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text(title)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(JYColor.moonWhite.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "2C2C2E"))
        )
    }
}

// MARK: - 菜单项
struct MenuItem: View {
    let icon: String
    let title: String
    var hasArrow: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(JYColor.primaryRed.opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(JYColor.primaryRed)
                }

                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)

                Spacer()

                if hasArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(JYColor.moonWhite.opacity(0.4))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "2C2C2E"))
            )
        }
    }
}

#Preview {
    let appState = AppState()
    appState.isLoggedIn = true
    appState.currentUser = User(id: "test-id", username: "test", nickname: "测试用户", level: "非遗传承人")

    return NavigationView {
        ProfileView()
            .environmentObject(appState)
    }
}
