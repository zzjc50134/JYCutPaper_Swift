import SwiftUI

struct SettingsView: View {
    @State private var apiKey: String = ""
    @State private var showSaveAlert = false
    @State private var selectedStyle: ImageStyle = .traditional
    @State private var selectedRatio: AspectRatio = .ratio1x1
    @State private var selectedMode: CreateMode = .textToImage
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    apiKeySection
                    styleSection
                    ratioSection
                    modeSection
                    saveButton
                    Spacer()
                }
                .padding(24)
            }
        }
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完成") {
                    dismiss()
                }
                .foregroundColor(JYColor.gold)
            }
        }
        .onAppear {
            apiKey = AIService.shared.getAPIKey() ?? ""
            selectedStyle = SettingsManager.shared.getDefaultStyle()
            selectedRatio = SettingsManager.shared.getDefaultRatio()
            selectedMode = SettingsManager.shared.getDefaultMode()
        }
        .alert("保存成功", isPresented: $showSaveAlert) {
            Button("确定") {
                dismiss()
            }
        } message: {
            Text("设置已保存")
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [JYColor.primaryRed, JYColor.deepRed],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: "gearshape.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }

            Text("偏好设置")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            Text("自定义您的创作体验")
                .font(.system(size: 14))
                .foregroundColor(JYColor.moonWhite.opacity(0.6))
        }
        .padding(.vertical, 16)
    }

    private var apiKeySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader(icon: "key.fill", title: "API 配置", subtitle: "连接 MiniMax 服务")

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(JYColor.gold)
                    Text("MiniMax API Key")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }

                SecureField("请输入 API Key", text: $apiKey)
                    .textFieldStyle(.plain)
                    .padding(16)
                    .background(Color(hex: "1C1C1E"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(JYColor.moonWhite.opacity(0.1), lineWidth: 1)
                    )

                Text("用于 AI 生成剪纸图片，请从 MiniMax 平台获取")
                    .font(.system(size: 12))
                    .foregroundColor(JYColor.moonWhite.opacity(0.5))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "2C2C2E"))
            )
        }
    }

    private var styleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader(icon: "paintpalette.fill", title: "默认风格", subtitle: "选择偏好的剪纸风格")

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    ForEach(ImageStyle.allCases, id: \.self) { style in
                        StyleOptionButton(
                            style: style,
                            isSelected: selectedStyle == style,
                            action: { selectedStyle = style }
                        )
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "2C2C2E"))
            )
        }
    }

    private var ratioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader(icon: "aspectratio", title: "默认尺寸", subtitle: "选择图片输出比例")

            VStack(spacing: 12) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))], spacing: 12) {
                    ForEach(AspectRatio.allCases, id: \.self) { ratio in
                        RatioOptionButton(
                            ratio: ratio,
                            isSelected: selectedRatio == ratio,
                            action: { selectedRatio = ratio }
                        )
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "2C2C2E"))
            )
        }
    }

    private var modeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader(icon: "wand.and.stars", title: "默认创作模式", subtitle: "选择默认的创作方式")

            VStack(spacing: 12) {
                ForEach(CreateMode.allCases, id: \.self) { mode in
                    ModeOptionRow(
                        mode: mode,
                        isSelected: selectedMode == mode,
                        action: { selectedMode = mode }
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "2C2C2E"))
            )
        }
    }

    private var saveButton: some View {
        Button {
            AIService.shared.setAPIKey(apiKey)
            SettingsManager.shared.setDefaultStyle(selectedStyle)
            SettingsManager.shared.setDefaultRatio(selectedRatio)
            SettingsManager.shared.setDefaultMode(selectedMode)
            showSaveAlert = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                Text("保存设置")
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
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
    }
}

struct SettingsSectionHeader: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(JYColor.primaryRed.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(JYColor.primaryRed)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(JYColor.moonWhite.opacity(0.5))
            }
        }
    }
}

struct StyleOptionButton: View {
    let style: ImageStyle
    let isSelected: Bool
    let action: () -> Void

    private var icon: String {
        switch style {
        case .traditional: return "scissors"
        case .modern: return "wand.and.stars"
        case .minimalist: return "square.grid.3x3"
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? JYColor.gold.opacity(0.2) : Color(hex: "1C1C1E"))
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? JYColor.gold : JYColor.moonWhite.opacity(0.6))
                }

                Text(style.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : JYColor.moonWhite.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? JYColor.primaryRed.opacity(0.3) : Color(hex: "1C1C1E"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? JYColor.gold : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct RatioOptionButton: View {
    let ratio: AspectRatio
    let isSelected: Bool
    let action: () -> Void

    private var previewSize: CGSize {
        let maxWidth: CGFloat = 32
        let maxHeight: CGFloat = 24
        switch ratio {
        case .ratio1x1:
            return CGSize(width: maxWidth, height: maxWidth)
        case .ratio16x9:
            return CGSize(width: maxWidth, height: maxWidth * 9 / 16)
        case .ratio9x16:
            return CGSize(width: maxWidth * 9 / 16, height: maxHeight)
        case .ratio4x3:
            return CGSize(width: maxWidth, height: maxWidth * 3 / 4)
        case .ratio3x4:
            return CGSize(width: maxWidth * 3 / 4, height: maxHeight)
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(isSelected ? JYColor.gold : JYColor.moonWhite.opacity(0.4), lineWidth: 1.5)
                    .frame(width: previewSize.width, height: previewSize.height)

                Text(ratio.displayName)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(isSelected ? .white : JYColor.moonWhite.opacity(0.6))
            }
            .frame(width: 65, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? JYColor.primaryRed.opacity(0.3) : Color(hex: "1C1C1E"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? JYColor.gold : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

struct ModeOptionRow: View {
    let mode: CreateMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? JYColor.gold.opacity(0.2) : Color(hex: "1C1C1E"))
                        .frame(width: 44, height: 44)

                    Image(systemName: mode.icon)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? JYColor.gold : JYColor.moonWhite.opacity(0.6))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)

                    Text(modeDescription)
                        .font(.system(size: 12))
                        .foregroundColor(JYColor.moonWhite.opacity(0.5))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(JYColor.gold)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? JYColor.primaryRed.opacity(0.15) : Color(hex: "1C1C1E"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? JYColor.gold.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
    }

    private var modeDescription: String {
        switch mode {
        case .textToImage:
            return "输入文字描述生成图片"
        case .imageToImage:
            return "上传图片进行风格转换"
        case .elementCompose:
            return "选择元素组合创作"
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
