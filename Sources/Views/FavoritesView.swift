import SwiftUI

struct FavoritesView: View {
    @State private var favorites: [FavoriteItem] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            if favorites.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 60))
                        .foregroundColor(JYColor.primaryRed.opacity(0.5))
                    Text("暂无收藏")
                        .font(.system(size: 18))
                        .foregroundColor(JYColor.moonWhite.opacity(0.6))
                    Text("收藏您喜欢的剪纸作品，方便随时查看")
                        .font(.system(size: 14))
                        .foregroundColor(JYColor.moonWhite.opacity(0.4))
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(favorites) { item in
                            FavoriteCard(item: item)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .navigationTitle("我的收藏")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FavoriteItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let date: Date
}

struct FavoriteCard: View {
    let item: FavoriteItem

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 12)
                .fill(JYColor.primaryRed.opacity(0.3))
                .frame(height: 140)
                .overlay(
                    Image(systemName: "scissors")
                        .font(.system(size: 40))
                        .foregroundColor(JYColor.gold.opacity(0.5))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(item.date, style: .date)
                    .font(.system(size: 11))
                    .foregroundColor(JYColor.moonWhite.opacity(0.5))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
        }
        .background(Color(hex: "2C2C2E"))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        FavoritesView()
    }
}
