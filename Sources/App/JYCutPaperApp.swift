import SwiftUI

@main
struct JYCutPaperApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppStartView()
                .environmentObject(appState)
        }
    }
}

struct User {
    var id: String
    var username: String
    var nickname: String
    var level: String
}

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var hasCompletedOnboarding: Bool = false
    @Published var currentUser: User?
    @Published var showSplash: Bool = true
}

struct AppStartView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            if appState.showSplash {
                SplashView(onComplete: {
                    appState.showSplash = false
                })
            } else {
                if appState.isLoggedIn {
                    ContentView()
                } else {
                    LoginView()
                }
            }
        }
    }
}