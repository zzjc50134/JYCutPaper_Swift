import Foundation
import UIKit

enum AIError: Error, LocalizedError {
    case invalidPrompt
    case networkError(Error)
    case invalidResponse
    case serverError(String)
    case noAPIKey

    var errorDescription: String? {
        switch self {
        case .invalidPrompt:
            return "请输入有效的描述"
        case .networkError(let error):
            return "网络错误：\(error.localizedDescription)"
        case .invalidResponse:
            return "服务器返回数据无效"
        case .serverError(let message):
            return "服务器错误：\(message)"
        case .noAPIKey:
            return "请配置 AI API 密钥"
        }
    }
}

enum ImageStyle: String, CaseIterable {
    case traditional = "traditional"
    case modern = "modern"
    case minimalist = "minimalist"

    var displayName: String {
        switch self {
        case .traditional: return "传统剪纸"
        case .modern: return "现代剪纸"
        case .minimalist: return "简约剪纸"
        }
    }

    var icon: String {
        switch self {
        case .traditional: return "scissors"
        case .modern: return "wand.and.stars"
        case .minimalist: return "square.grid.3x3"
        }
    }
}

struct ImageGenerationRequest {
    let prompt: String
    let style: ImageStyle
    let aspectRatio: AspectRatio

    init(prompt: String, style: ImageStyle = .traditional, aspectRatio: AspectRatio = .ratio1x1) {
        self.prompt = prompt
        self.style = style
        self.aspectRatio = aspectRatio
    }
}

enum AspectRatio: String, CaseIterable {
    case ratio1x1 = "1:1"
    case ratio16x9 = "16:9"
    case ratio9x16 = "9:16"
    case ratio4x3 = "4:3"
    case ratio3x4 = "3:4"

    var displayName: String {
        switch self {
        case .ratio1x1: return "方形"
        case .ratio16x9: return "宽屏"
        case .ratio9x16: return "竖屏"
        case .ratio4x3: return "4:3"
        case .ratio3x4: return "3:4"
        }
    }
}

struct GeneratedImage: Identifiable {
    let id: String
    let image: UIImage
    let prompt: String
    let style: ImageStyle
    let createdAt: Date

    init(id: String = UUID().uuidString, image: UIImage, prompt: String, style: ImageStyle) {
        self.id = id
        self.image = image
        self.prompt = prompt
        self.style = style
        self.createdAt = Date()
    }
}

class AIService {
    static let shared = AIService()

    private let imageBaseURL = "https://api.minimaxi.com/v1/image_generation"
    private let llmBaseURL = "https://api.minimaxi.com/v1/text/chatcompletion_v2"

    private var apiKey: String? {
        get { UserDefaults.standard.string(forKey: "MINIMAXI_API_KEY") }
        set { UserDefaults.standard.set(newValue, forKey: "MINIMAXI_API_KEY") }
    }

    private init() {}

    func setAPIKey(_ key: String) {
        apiKey = key
    }

    func getAPIKey() -> String? {
        return apiKey
    }

    func generateImage(request: ImageGenerationRequest) async throws -> GeneratedImage {
        guard !request.prompt.isEmpty else {
            throw AIError.invalidPrompt
        }

        guard let apiKey = apiKey, !apiKey.isEmpty else {
            throw AIError.noAPIKey
        }

        let stylePrompt = addStyleToPrompt(request.prompt, style: request.style)

        guard let url = URL(string: imageBaseURL) else {
            throw AIError.invalidResponse
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "model": "image-01",
            "prompt": stylePrompt,
            "aspect_ratio": request.aspectRatio.rawValue,
            "response_format": "base64"
        ]

        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            if let errorDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = errorDict["message"] as? String {
                throw AIError.serverError(message)
            }
            throw AIError.serverError("HTTP \(httpResponse.statusCode)")
        }

        guard let resultDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let dataDict = resultDict["data"] as? [String: Any],
              let imageBase64Array = dataDict["image_base64"] as? [String],
              let firstImageBase64 = imageBase64Array.first,
              let imageData = Data(base64Encoded: firstImageBase64),
              let image = UIImage(data: imageData) else {
            throw AIError.invalidResponse
        }

        return GeneratedImage(image: image, prompt: request.prompt, style: request.style)
    }

    func generateWithMock(request: ImageGenerationRequest) async throws -> GeneratedImage {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        let randomId = Int.random(in: 1...1000)
        let mockURL = URL(string: "https://picsum.photos/seed/\(randomId)/512/512")!
        let (imageData, _) = try await URLSession.shared.data(from: mockURL)

        guard let image = UIImage(data: imageData) else {
            throw AIError.invalidResponse
        }

        return GeneratedImage(image: image, prompt: request.prompt, style: request.style)
    }

    private func addStyleToPrompt(_ prompt: String, style: ImageStyle) -> String {
        switch style {
        case .traditional:
            return "Chinese traditional paper cut art (剪纸), \(prompt), red and gold colors, symmetrical design, folk art style"
        case .modern:
            return "Modern paper cut art design, \(prompt), creative composition, contemporary art style"
        case .minimalist:
            return "Minimalist paper cut art, \(prompt), simple lines, clean design, elegant"
        }
    }

    func optimizePrompt(_ prompt: String, style: ImageStyle) async throws -> String {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            throw AIError.noAPIKey
        }

        guard let url = URL(string: llmBaseURL) else {
            throw AIError.invalidResponse
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let styleDescription: String
        switch style {
        case .traditional:
            styleDescription = "中国传统剪纸风格"
        case .modern:
            styleDescription = "现代创意剪纸风格"
        case .minimalist:
            styleDescription = "简约剪纸风格"
        }

        let systemPrompt = "你是一个专业的中国剪纸艺术描述优化师。用户会输入一个简单的剪纸描述，你需要将其优化成更详细、更有创意的剪纸创作描述。规则：1. 输出只包含优化后的中文描述，不要其他内容 2. 要体现剪纸艺术的特点：线条流畅、阴阳刻结合、镂空效果 3. 添加适当的色彩描述（红、金、黑、白等）4. 添加构图和风格描述 5. 描述要优美、有意境、有文化内涵"
        let userPrompt = "原始描述：\(prompt)\n目标风格：\(styleDescription)"

        let body: [String: Any] = [
            "model": "abab6.5s-chat",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ]
        ]

        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            if let errorDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let baseResp = errorDict["base_resp"] as? [String: Any],
               let statusMsg = baseResp["status_msg"] as? String {
                throw AIError.serverError(statusMsg)
            }
            throw AIError.serverError("HTTP \(httpResponse.statusCode)")
        }

        guard let resultDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choicesArray = resultDict["choices"] as? [[String: Any]],
              let firstChoice = choicesArray.first,
              let messageDict = firstChoice["message"] as? [String: Any],
              let optimizedPrompt = messageDict["content"] as? String else {
            throw AIError.invalidResponse
        }

        return optimizedPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension AIService {
    static let promptTemplates: [String] = [
        "福字剪纸",
        "牡丹花",
        "龙凤呈祥",
        "喜鹊登梅",
        "年年有余",
        "蝴蝶飞舞",
        "双鱼戏水",
        "梅花香自苦寒来",
        "竹报平安",
        "鹤寿松龄"
    ]

    static func buildPrompt(elements: [String], style: String = "传统剪纸风格") -> String {
        elements.isEmpty ? style : "\(elements.joined(separator: "、"))，\(style)"
    }

    static let defaultPrompts: [String: [String]] = [
        "吉祥图案": ["福字", "寿字", "喜字", "双喜", "如意"],
        "花卉": ["牡丹", "荷花", "梅花", "菊花", "兰花"],
        "动物": ["蝴蝶", "鲤鱼", "喜鹊", "凤凰", "龙"],
        "人物": ["童子", "仕女", "仙子", "老寿星"],
        "场景": ["龙凤呈祥", "喜鹊登梅", "花好月圆", "金玉满堂"]
    ]
}
