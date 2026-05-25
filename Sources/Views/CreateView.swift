import SwiftUI

struct CreateView: View {
    @StateObject private var viewModel = CreateViewModel()
    @State private var showSettings = false

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                modeSelector

                ScrollView {
                    VStack(spacing: 32) {
                        resultSection
                        inputSection
                        quickPromptsSection
                    }
                    .padding(.vertical, 24)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationView {
                SettingsView()
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("AI创作中心")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20))
                    .foregroundColor(JYColor.gold)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color(hex: "2C2C2E"))
                    )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color(hex: "2C2C2E"))
    }

    // MARK: - 模式选择器
    private var modeSelector: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ForEach(Array(CreateMode.allCases.enumerated()), id: \.offset) { index, mode in
                    ModeButton(
                        title: mode.title,
                        icon: mode.icon,
                        isSelected: viewModel.selectedMode == mode,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                viewModel.selectedMode = mode
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 24)
        .background(Color(hex: "2C2C2E"))
    }

    // MARK: - 结果展示区
    @ViewBuilder
    private var resultSection: some View {
        VStack(spacing: 20) {
            if let generatedImage = viewModel.generatedImage {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [JYColor.primaryRed, JYColor.deepRed],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            CloudPattern()
                                .opacity(0.1)
                        )

                    Image(uiImage: generatedImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .padding()
                }
                .frame(height: 280)
                .padding(.horizontal, 24)
            } else if viewModel.isGenerating {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(hex: "2C2C2E"))

                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: JYColor.primaryRed))
                            .scaleEffect(1.5)

                        Text("AI 创作中...")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 280)
                .padding(.horizontal, 24)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(hex: "2C2C2E"))

                    VStack(spacing: 20) {
                        Image(systemName: "paintbrush.pointed.fill")
                            .font(.system(size: 56))
                            .foregroundColor(JYColor.primaryRed.opacity(0.5))

                        Text("开始你的创作之旅")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        Text("输入描述词，让AI为你生成独特的剪纸图样")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(JYColor.moonWhite.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    .padding(32)
                }
                .frame(height: 280)
                .padding(.horizontal, 24)
            }
        }

        if let error = viewModel.errorMessage {
            Text(error)
                .font(.system(size: 14))
                .foregroundColor(.red)
                .padding(.horizontal, 24)
        }
    }

    // MARK: - 输入区
    private var inputSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("创作描述")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                ZStack(alignment: .topLeading) {
                    if viewModel.prompt.isEmpty {
                        Text("输入你想创作的剪纸描述，如：福字、牡丹花纹...")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 20)
                    }

                    TextEditor(text: $viewModel.prompt)
                        .modifier(TextEditorBackgroundModifier())
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                }
                .frame(height: 120)
                .background(Color(hex: "2C2C2E"))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(JYColor.moonWhite.opacity(0.2), lineWidth: 1)
                )

                Button {
                    Task {
                        await viewModel.optimize()
                    }
                } label: {
                    HStack(spacing: 8) {
                        if viewModel.optimizingPrompt {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: JYColor.gold))
                                .scaleEffect(0.8)
                            Text("AI优化中...")
                                .font(.system(size: 14))
                                .foregroundColor(JYColor.moonWhite)
                        } else {
                            Image(systemName: "wand.and.stars")
                                .foregroundColor(JYColor.gold)
                            Text("AI优化")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(viewModel.optimizingPrompt || viewModel.prompt.isEmpty)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "2C2C2E"))
                .cornerRadius(12)
            }
            .padding(.horizontal, 24)

            VStack(alignment: .leading, spacing: 12) {
                Text("风格选择")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ImageStyle.allCases, id: \.self) { style in
                            StyleTag(
                                title: style.displayName,
                                isSelected: viewModel.selectedStyle == style,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        viewModel.selectedStyle = style
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 24)

            VStack(alignment: .leading, spacing: 12) {
                Text("图片尺寸")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(AspectRatio.allCases, id: \.self) { ratio in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    viewModel.selectedRatio = ratio
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    AspectRatioPreview(ratio: ratio, isSelected: viewModel.selectedRatio == ratio)
                                    Text(ratio.displayName)
                                        .font(.system(size: 11))
                                        .foregroundColor(viewModel.selectedRatio == ratio ? .white : JYColor.moonWhite.opacity(0.6))
                                }
                                .frame(width: 56, height: 64)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(viewModel.selectedRatio == ratio ? JYColor.primaryRed.opacity(0.3) : Color(hex: "2C2C2E"))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewModel.selectedRatio == ratio ? JYColor.gold : Color.clear, lineWidth: 1)
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)

            Button {
                Task {
                    await viewModel.generate()
                }
            } label: {
                HStack {
                    if viewModel.isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 18))
                        Text("开始生成")
                            .font(.system(size: 17, weight: .semibold))
                    }
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
            .disabled(viewModel.isGenerating || viewModel.prompt.isEmpty)
            .opacity((viewModel.prompt.isEmpty) ? 0.6 : 1)
            .padding(.horizontal, 24)
        }
    }

    // MARK: - 快捷语料
    private var quickPromptsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("快捷描述")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AIService.promptTemplates, id: \.self) { prompt in
                        QuickPromptTag(title: prompt) {
                            viewModel.prompt = prompt
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - 创作模式
enum CreateMode: CaseIterable {
    case textToImage
    case imageToImage
    case elementCompose

    var title: String {
        switch self {
        case .textToImage: return "文生图"
        case .imageToImage: return "图生图"
        case .elementCompose: return "元素组合"
        }
    }

    var icon: String {
        switch self {
        case .textToImage: return "text.badge.plus"
        case .imageToImage: return "photo.fill"
        case .elementCompose: return "square.grid.2x2.fill"
        }
    }
}

// MARK: - ViewModel
class CreateViewModel: ObservableObject {
    @Published var selectedMode: CreateMode = .textToImage
    @Published var prompt: String = ""
    @Published var selectedStyle: ImageStyle = .traditional
    @Published var selectedRatio: AspectRatio = .ratio1x1
    @Published var isGenerating: Bool = false
    @Published var generatedImage: UIImage?
    @Published var errorMessage: String?
    @Published var optimizingPrompt: Bool = false

    init() {
        selectedStyle = SettingsManager.shared.getDefaultStyle()
        selectedMode = SettingsManager.shared.getDefaultMode()
        selectedRatio = SettingsManager.shared.getDefaultRatio()
    }

    func generate() async {
        guard !prompt.isEmpty else { return }

        await MainActor.run {
            isGenerating = true
            errorMessage = nil
            generatedImage = nil
        }

        do {
            let request = ImageGenerationRequest(
                prompt: prompt,
                style: selectedStyle,
                aspectRatio: selectedRatio
            )

            let result = try await AIService.shared.generateImage(request: request)

            let imageBase64 = result.image.jpegData(compressionQuality: 0.8)?.base64EncodedString()
            let record = GenerationRecord(
                prompt: prompt,
                style: selectedStyle,
                ratio: selectedRatio,
                imageBase64: imageBase64
            )
            GenerationHistoryManager.shared.addRecord(record)

            await MainActor.run {
                generatedImage = result.image
                isGenerating = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isGenerating = false
            }
        }
    }

    func optimize() async {
        guard !prompt.isEmpty else { return }

        await MainActor.run {
            optimizingPrompt = true
            errorMessage = nil
        }

        do {
            let result = try await AIService.shared.optimizePrompt(prompt, style: selectedStyle)
            await MainActor.run {
                prompt = result
                optimizingPrompt = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "优化失败：\(error.localizedDescription)"
                optimizingPrompt = false
            }
        }
    }
}

// MARK: - 模式按钮
struct ModeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : JYColor.moonWhite.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? JYColor.primaryRed : Color(hex: "2C2C2E"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? JYColor.gold : Color.clear, lineWidth: 2)
            )
            .shadow(color: isSelected ? JYColor.primaryRed.opacity(0.3) : .clear, radius: 8)
        }
    }
}

// MARK: - 风格标签
struct StyleTag: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : JYColor.moonWhite.opacity(0.7))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? JYColor.primaryRed : Color(hex: "2C2C2E"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? JYColor.gold : JYColor.moonWhite.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - 快捷描述标签
struct QuickPromptTag: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 12))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(JYColor.moonWhite.opacity(0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "2C2C2E"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(JYColor.moonWhite.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct AspectRatioPreview: View {
    let ratio: AspectRatio
    let isSelected: Bool

    private var size: CGSize {
        let maxWidth: CGFloat = 36
        let maxHeight: CGFloat = 28
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
        RoundedRectangle(cornerRadius: 3)
            .stroke(isSelected ? JYColor.gold : JYColor.moonWhite.opacity(0.4), lineWidth: 1.5)
            .frame(width: size.width, height: size.height)
    }
}

#Preview {
    NavigationView {
        CreateView()
    }
}

struct TextEditorBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
