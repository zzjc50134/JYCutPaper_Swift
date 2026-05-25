import Foundation

struct AIConfig {
    enum Provider: String, CaseIterable {
        case openai = "OpenAI"
        case wenxin = "百度文心"
        case tongyi = "阿里通义"
        case hunyuan = "腾讯混元"
        case local = "本地测试"

        var icon: String {
            switch self {
            case .openai: return "brain"
            case .wenxin: return "leaf.fill"
            case .tongyi: return "cloud.fill"
            case .hunyuan: return "sparkles"
            case .local: return "laptopcomputer"
            }
        }
    }

    static var currentProvider: Provider {
        get {
            let rawValue = UserDefaults.standard.string(forKey: "AI_PROVIDER") ?? Provider.openai.rawValue
            return Provider(rawValue: rawValue) ?? .openai
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "AI_PROVIDER")
        }
    }

    static var apiKey: String? {
        get { UserDefaults.standard.string(forKey: "AI_API_KEY") }
        set { UserDefaults.standard.set(newValue, forKey: "AI_API_KEY") }
    }

    static var isConfigured: Bool {
        apiKey != nil && !apiKey!.isEmpty
    }

    static func clearConfig() {
        UserDefaults.standard.removeObject(forKey: "AI_PROVIDER")
        UserDefaults.standard.removeObject(forKey: "AI_API_KEY")
    }
}

struct AIKeyManager {
    static let shared = AIKeyManager()

    private let keychain = KeychainHelper.shared

    func saveKey(_ key: String, for provider: AIConfig.Provider) throws {
        try keychain.save(key, service: "AI_\(provider.rawValue)")
    }

    func getKey(for provider: AIConfig.Provider) -> String? {
        try? keychain.load(service: "AI_\(provider.rawValue)")
    }

    func deleteKey(for provider: AIConfig.Provider) throws {
        try keychain.delete(service: "AI_\(provider.rawValue)")
    }
}

class KeychainHelper {
    static let shared = KeychainHelper()

    private init() {}

    func save(_ value: String, service: String) throws {
        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "default"
        ]

        SecItemDelete(query as CFDictionary)

        var newQuery = query
        newQuery[kSecValueData as String] = data

        let status = SecItemAdd(newQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainError", code: Int(status))
        }
    }

    func load(service: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "default",
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }

    func delete(service: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw NSError(domain: "KeychainError", code: Int(status))
        }
    }
}
