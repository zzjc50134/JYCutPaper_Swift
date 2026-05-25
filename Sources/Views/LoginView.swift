
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showRegister: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient

                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: geometry.size.height * 0.12)

                        logoSection

                        Spacer()
                            .frame(height: geometry.size.height * 0.08)

                        loginFormSection(geometry: geometry)

                        Spacer()
                            .frame(height: geometry.size.height * 0.1)

                        otherLoginSection

                        registerSection

                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .ignoresSafeArea()
        .alert("登录失败", isPresented: $showError) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView()
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

    private var logoSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(JYColor.primaryRed.opacity(0.3))
                    .frame(width: 160, height: 160)

                ForEach(0..<6) { i in
                    PlumBlossomShape()
                        .fill(JYColor.primaryRed)
                        .frame(width: 50, height: 50)
                        .rotationEffect(Angle(degrees: Double(i) * 60))
                }

                Image(systemName: "scissors")
                    .font(.system(size: 60))
                    .foregroundColor(JYColor.gold)
            }

            Text("京韵剪影")
                .font(.system(size: 56, weight: .bold))
                .foregroundColor(.white)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [JYColor.gold, JYColor.brightGold, JYColor.gold],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 240, height: 2)

            Text("非遗剪纸 AI 平台")
                .font(.system(size: 24, weight: .light))
                .foregroundColor(JYColor.moonWhite.opacity(0.8))
        }
    }

    private func loginFormSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                JYTextField(
                    icon: "person.fill",
                    placeholder: "请输入用户名",
                    text: $username
                )
                .frame(width: min(geometry.size.width * 0.6, 480))

                JYTextField(
                    icon: "lock.fill",
                    placeholder: "请输入密码",
                    text: $password,
                    isSecure: true
                )
                .frame(width: min(geometry.size.width * 0.6, 480))
            }

            Button {
                login()
            } label: {
                HStack(spacing: 12) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("登录")
                            .font(.system(size: 20, weight: .medium))
                    }
                }
                .foregroundColor(.white)
                .frame(width: min(geometry.size.width * 0.6, 480), height: 60)
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
            .disabled(isLoading || username.isEmpty || password.isEmpty)
            .opacity((username.isEmpty || password.isEmpty) ? 0.6 : 1)

            Button {
            } label: {
                Text("忘记密码？")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(JYColor.gold)
            }
        }
    }

    private var otherLoginSection: some View {
        VStack(spacing: 20) {
            HStack {
                Rectangle()
                    .fill(JYColor.moonWhite.opacity(0.3))
                    .frame(height: 1)
                Text("其他登录方式")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(JYColor.moonWhite.opacity(0.6))
                Rectangle()
                    .fill(JYColor.moonWhite.opacity(0.3))
                    .frame(height: 1)
            }
            .frame(width: min(UIScreen.main.bounds.width * 0.6, 480))

            HStack(spacing: 40) {
                OtherLoginButton(icon: "applelogo", title: "Apple")
                OtherLoginButton(icon: "message.fill", title: "微信")
                OtherLoginButton(icon: "envelope.fill", title: "邮箱")
            }
        }
        .padding(.bottom, 50)
    }

    private var registerSection: some View {
        Button {
            showRegister = true
        } label: {
            HStack(spacing: 8) {
                Text("没有账号？")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(JYColor.moonWhite.opacity(0.7))
                Text("立即注册")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(JYColor.gold)
            }
        }
        .padding(.bottom, 50)
    }

    private func login() {
        isLoading = true

        Task {
            do {
                let response = try await APIService.shared.login(
                    username: username,
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
                    errorMessage = "登录失败，请检查网络或账号信息"
                    showError = true
                }
            }
        }
    }
}

struct JYTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(JYColor.gold)
                .frame(width: 24)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(JYColor.moonWhite.opacity(0.4))
                }

                if isSecure {
                    SecureField("", text: $text)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                } else {
                    TextField("", text: $text)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "2C2C2E"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(JYColor.moonWhite.opacity(0.2), lineWidth: 1)
        )
    }
}

struct OtherLoginButton: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(JYColor.moonWhite.opacity(0.8))
                .frame(width: 64, height: 64)
                .background(
                    Circle()
                        .fill(Color(hex: "2C2C2E"))
                )

            Text(title)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(JYColor.moonWhite.opacity(0.6))
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
