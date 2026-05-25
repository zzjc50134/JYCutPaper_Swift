import SwiftUI

struct GenerationHistoryView: View {
    @State private var records: [GenerationRecord] = []
    @State private var selectedRecord: GenerationRecord?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            if records.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(JYColor.primaryRed.opacity(0.5))
                    Text("暂无创作记录")
                        .font(.system(size: 18))
                        .foregroundColor(JYColor.moonWhite.opacity(0.6))
                    Text("在创作中心生成的图片将显示在这里")
                        .font(.system(size: 14))
                        .foregroundColor(JYColor.moonWhite.opacity(0.4))
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(records) { record in
                            GenerationRecordCard(record: record)
                                .onTapGesture {
                                    selectedRecord = record
                                }
                        }
                    }
                    .padding(24)
                }
            }
        }
        .navigationTitle("创作记录")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            records = GenerationHistoryManager.shared.getHistory()
        }
        .sheet(item: $selectedRecord) { record in
            NavigationView {
                GenerationDetailView(record: record)
            }
        }
    }
}

struct GenerationRecordCard: View {
    let record: GenerationRecord

    var body: some View {
        VStack(spacing: 0) {
            if let image = record.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(JYColor.primaryRed.opacity(0.3))
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(JYColor.gold.opacity(0.5))
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(record.prompt)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .lineLimit(2)

                HStack {
                    Text(record.styleDisplayName)
                        .font(.system(size: 10))
                        .foregroundColor(JYColor.gold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(JYColor.gold.opacity(0.2))
                        .cornerRadius(4)

                    Text(record.createdAt, style: .date)
                        .font(.system(size: 10))
                        .foregroundColor(JYColor.moonWhite.opacity(0.5))
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(hex: "2C2C2E"))
        .cornerRadius(16)
    }
}

struct GenerationDetailView: View {
    let record: GenerationRecord
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    if let image = record.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("创作描述")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(JYColor.moonWhite.opacity(0.6))
                            Text(record.prompt)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("风格")
                                    .font(.system(size: 12))
                                    .foregroundColor(JYColor.moonWhite.opacity(0.5))
                                Text(record.styleDisplayName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(JYColor.gold)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("尺寸")
                                    .font(.system(size: 12))
                                    .foregroundColor(JYColor.moonWhite.opacity(0.5))
                                Text(record.ratioDisplayName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(JYColor.gold)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("创作时间")
                                    .font(.system(size: 12))
                                    .foregroundColor(JYColor.moonWhite.opacity(0.5))
                                Text(record.createdAt, style: .date)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(hex: "2C2C2E"))
                    .cornerRadius(16)

                    Button {
                        showDeleteAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("删除记录")
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle("创作详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完成") {
                    dismiss()
                }
                .foregroundColor(JYColor.gold)
            }
        }
        .alert("删除记录", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                GenerationHistoryManager.shared.deleteRecord(id: record.id)
                dismiss()
            }
        } message: {
            Text("确定要删除这条创作记录吗？")
        }
    }
}

#Preview {
    NavigationView {
        GenerationHistoryView()
    }
}
