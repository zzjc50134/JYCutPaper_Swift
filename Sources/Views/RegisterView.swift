import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    @State private var username: String = ""
    @State private var nickname: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showLogin: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient

                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: geometry.size.height * 0.08)

                        headerSection

                        Spacer()
                            .frame(height: geometry.size.height * 0.06)

                        registerFormSection(geometry: geometry)

                        Spacer()
                            .frame(height: geometry.size.height * 0.08)

                        backToLoginSection

                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .ignoresSafeArea()
        .alert("注册失败", isPresented: $showError) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
                .environmentObject(appState)
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [JYColor.inkBlack, JYColor.deepRed.opacity(0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(JYColor.gold)

            Text("注册账号")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [JYColor.gold, JYColor.brightGold, JYColor.gold],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 160, height: 2)
        }
    }

    private func registerFormSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                JYTextField(
                    icon: "person.fill",
                    placeholder: "用户名",
                    text: $username
                )
                .frame(width: min(geometry.size.width * 0.6, 480))

                JYTextField(
                    icon: "person.text.rectangle",
                    placeholder: "昵称",
                    text: $nickname
                )
                .frame(width: min(geometry.size.width * 0.6, 480))

                JYTextField(
                    icon: "lock.fill",
                    placeholder: "密码",
                    text: $password,
                    isSecure: true
                )
                .frame(width: min(geometry.size.width * 0.6, 480))

                JYTextField(
                    icon: "lock.fill",
                    placeholder: "确认密码",
                    text: $confirmPassword,
                    isSecure: true
                )
                .frame(width: min(geometry.size.width * 0.6, 480))
            }

            if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
                Text("两次输入的密码不一致")
                    .font(.system(size: 14))
                    .foregroundColor(.red)
            }

            Button {
                register()
            } label: {
                HStack(spacing: 12) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("注册")
                            .font(.system(size: 20, weight: .medium))
                    }
                }
                .foregroundColor(.white)
                .frame(width: min(geometry.size.width * 0.6, 480), height: 56)
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
            .disabled(isLoading || !isFormValid)
            .opacity((!isFormValid) ? 0.6 : 1)
        }
    }

    private var backToLoginSection: some View {
        Button {
            showLogin = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.left")
                Text("返回登录")
            }
            .font(.system(size: 16, weight: .light))
            .foregroundColor(JYColor.gold)
        }
        .padding(.bottom, 50)
    }

    private var isFormValid: Bool {
        !username.isEmpty && !nickname.isEmpty && !password.isEmpty && password == confirmPassword && password.count >= 6
    }

    private func register() {
        guard password == confirmPassword else {
            errorMessage = "两次输入的密码不一致"
            showError = true
            return
        }

        guard password.count >= 6 else {
            errorMessage = "密码至少6位"
            showError = true
            return
        }

        isLoading = true

        Task {
            do {
                let response = try await APIService.shared.register(
                    username: username,
                    nickname: nickname,
                    password: password
                )
                await MainActor.run {
                    isLoading = false
                    appState.isLoggedIn = true
                    appState.currentUser = User(
                        id: response.user.id,
                        username: response.user.username,
                        nickname: response.user.nickname,
                        level: "Lv\(response.user.level)"
                    )
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    if case APIError.serverError(_, let message) = error {
                        errorMessage = message
                    } else {
                        errorMessage = "注册失败，请检查网络"
                    }
                    showError = true
                }
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AppState())
}
