import Foundation
import UIKit

struct GenerationRecord: Identifiable, Codable {
    let id: String
    let prompt: String
    let style: String
    let ratio: String
    let imageBase64: String?
    let createdAt: Date

    init(id: String = UUID().uuidString, prompt: String, style: ImageStyle, ratio: AspectRatio, imageBase64: String?, createdAt: Date = Date()) {
        self.id = id
        self.prompt = prompt
        self.style = style.rawValue
        self.ratio = ratio.rawValue
        self.imageBase64 = imageBase64
        self.createdAt = createdAt
    }

    var image: UIImage? {
        guard let base64 = imageBase64,
              let data = Data(base64Encoded: base64) else { return nil }
        return UIImage(data: data)
    }

    var styleDisplayName: String {
        ImageStyle(rawValue: style)?.displayName ?? style
    }

    var ratioDisplayName: String {
        AspectRatio(rawValue: ratio)?.displayName ?? ratio
    }
}

class GenerationHistoryManager {
    static let shared = GenerationHistoryManager()

    private let historyKey = "generation_history"
    private let maxRecords = 100

    private init() {}

    func getHistory() -> [GenerationRecord] {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let history = try? JSONDecoder().decode([GenerationRecord].self, from: data) else {
            return []
        }
        return history.reversed()
    }

    func addRecord(_ record: GenerationRecord) {
        var history = getHistory()
        history.append(record)

        if history.count > maxRecords {
            history = Array(history.suffix(maxRecords))
        }

        saveHistory(history)
    }

    func deleteRecord(at index: Int) {
        var history = getHistory()
        guard index < history.count else { return }
        history.remove(at: index)
        saveHistory(history)
    }

    func deleteRecord(id: String) {
        var history = getHistory()
        history.removeAll { $0.id == id }
        saveHistory(history)
    }

    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }

    private func saveHistory(_ history: [GenerationRecord]) {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
}
