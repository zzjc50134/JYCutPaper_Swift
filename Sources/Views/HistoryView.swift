import SwiftUI

struct HistoryView: View {
    @State private var historyItems: [HistoryItem] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            if historyItems.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(JYColor.primaryRed.opacity(0.5))
                    Text("暂无学习历史")
                        .font(.system(size: 18))
                        .foregroundColor(JYColor.moonWhite.opacity(0.6))
                    Text("开始学习后，这里将显示您的学习记录")
                        .font(.system(size: 14))
                        .foregroundColor(JYColor.moonWhite.opacity(0.4))
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(historyItems) { item in
                            HistoryItemRow(item: item)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .navigationTitle("学习历史")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HistoryItem: Identifiable {
    let id = UUID()
    let title: String
    let type: String
    let date: Date
    let duration: String
}

struct HistoryItemRow: View {
    let item: HistoryItem

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(JYColor.primaryRed.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: "book.fill")
                    .foregroundColor(JYColor.primaryRed)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                Text(item.type)
                    .font(.system(size: 13))
                    .foregroundColor(JYColor.moonWhite.opacity(0.6))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(item.duration)
                    .font(.system(size: 14))
                    .foregroundColor(JYColor.gold)
                Text(item.date, style: .date)
                    .font(.system(size: 12))
                    .foregroundColor(JYColor.moonWhite.opacity(0.4))
            }
        }
        .padding(16)
        .background(Color(hex: "2C2C2E"))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        HistoryView()
    }
}
