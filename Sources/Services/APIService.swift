import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int, String)
    case unknown
}

struct AuthResponse: Codable {
    let token: String
    let user: UserData
}

struct UserData: Codable {
    let id: String
    let username: String
    let nickname: String
    let level: Int
}

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let nickname: String
    let password: String
}

class APIService {
    static let shared = APIService()

    // ⚠️ 修改为你的后端服务器地址
    private let baseURL = "http://127.0.0.1:8080/api"

    private init() {}

    func login(username: String, password: String) async throws -> AuthResponse {
        let url = URL(string: "\(baseURL)/auth/login")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequest(username: username, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        if httpResponse.statusCode != 200 {
            if let errorDict = try? JSONDecoder().decode([String: String].self, from: data),
               let reason = errorDict["reason"] {
                throw APIError.serverError(httpResponse.statusCode, reason)
            }
            throw APIError.serverError(httpResponse.statusCode, "Unknown error")
        }

        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }

    func register(username: String, nickname: String, password: String) async throws -> AuthResponse {
        let url = URL(string: "\(baseURL)/auth/register")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = RegisterRequest(username: username, nickname: nickname, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        if httpResponse.statusCode != 200 {
            if let errorDict = try? JSONDecoder().decode([String: String].self, from: data),
               let reason = errorDict["reason"] {
                throw APIError.serverError(httpResponse.statusCode, reason)
            }
            throw APIError.serverError(httpResponse.statusCode, "Unknown error")
        }

        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }

    func logout() async throws {
        let url = URL(string: "\(baseURL)/auth/logout")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.unknown
        }
    }

    struct DeleteAccountRequest: Codable {
        let user_id: String
    }

    func deleteAccount(userId: String) async throws {
        let url = URL(string: "\(baseURL)/auth/account")!

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = DeleteAccountRequest(user_id: userId)
        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.unknown
        }
    }
}
