import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            if appState.isLoggedIn {
                mainContent
            } else {
                LoginView()
            }
        }
    }

    private var mainContent: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)

            ChallengeListView()
                .tabItem {
                    Label("闯关", systemImage: "target")
                }
                .tag(1)

            CreateView()
                .tabItem {
                    Label("创作", systemImage: "pencil.and.surface")
                }
                .tag(2)

            StoryView()
                .tabItem {
                    Label("漫剧", systemImage: "book.closed.fill")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(4)
        }
        .tint(JYColor.primaryRed)
    }
}
#Preview {
    ContentView()
        .environmentObject(AppState())
}
