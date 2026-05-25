import SwiftUI

struct HelpView: View {
    @State private var feedbackText: String = ""
    @State private var showSuccessAlert: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            JYColor.inkBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    faqSection
                    feedbackSection
                }
                .padding(24)
            }
        }
        .navigationTitle("帮助与反馈")
        .navigationBarTitleDisplayMode(.inline)
        .alert("提交成功", isPresented: $showSuccessAlert) {
            Button("确定") {}
        } message: {
            Text("感谢您的反馈，我们会尽快处理")
        }
    }

    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("常见问题")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            VStack(spacing: 0) {
                FAQItem(question: "如何开始创作剪纸？", answer: "在创作中心输入您的想法，选择风格后点击生成按钮即可创作剪纸作品。")
                Divider().background(JYColor.moonWhite.opacity(0.1))
                FAQItem(question: "AI生成失败怎么办？", answer: "请检查网络连接和API Key配置，确保您的MiniMax账号有足够的额度。")
                Divider().background(JYColor.moonWhite.opacity(0.1))
                FAQItem(question: "如何保存我的作品？", answer: "长按生成的图片即可保存到相册，也可以在创作记录中查看。")
                Divider().background(JYColor.moonWhite.opacity(0.1))
                FAQItem(question: "如何联系客服？", answer: "您可以通过以下反馈表单提交问题，我们会尽快回复您。")
            }
            .background(Color(hex: "2C2C2E"))
            .cornerRadius(16)
        }
    }

    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("意见反馈")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 12) {
                Text("请描述您遇到的问题或建议")
                    .font(.system(size: 14))
                    .foregroundColor(JYColor.moonWhite.opacity(0.6))

                ZStack(alignment: .topLeading) {
                    if feedbackText.isEmpty {
                        Text("请输入您的反馈意见...")
                            .font(.system(size: 16))
                            .foregroundColor(JYColor.moonWhite.opacity(0.4))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 20)
                    }

                    TextEditor(text: $feedbackText)
                        .modifier(TextEditorBackgroundModifier())
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                        .frame(height: 150)
                }
                .background(Color(hex: "2C2C2E"))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(JYColor.moonWhite.opacity(0.2), lineWidth: 1)
                )
            }

            Button {
                showSuccessAlert = true
                feedbackText = ""
            } label: {
                Text("提交反馈")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [JYColor.primaryRed, JYColor.deepRed],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .disabled(feedbackText.isEmpty)
            .opacity(feedbackText.isEmpty ? 0.6 : 1)
        }
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded: Bool = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                isExpanded.toggle()
            }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(question)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(JYColor.moonWhite.opacity(0.5))
                }
                .padding(16)

                if isExpanded {
                    Text(answer)
                        .font(.system(size: 14))
                        .foregroundColor(JYColor.moonWhite.opacity(0.7))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .transition(.opacity)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        HelpView()
    }
}
