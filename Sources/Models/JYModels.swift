import Foundation

struct Challenge: Identifiable {
    let id: Int
    let name: String
    let chapter: String
    let isCompleted: Bool
    let isCurrent: Bool
    let isLocked: Bool
    let stars: Int
}

struct Chapter: Identifiable {
    let id: Int
    let name: String
    let chineseName: String
    let challenges: [Challenge]
    let isExpanded: Bool
}

struct PatternItem: Identifiable {
    let id: Int
    let name: String
    let meaning: String
    let difficulty: Difficulty

    enum Difficulty: String {
        case beginner = "入门"
        case intermediate = "进阶"
        case master = "大师"
    }
}

struct CreationMode {
    let title: String
    let icon: String
    let description: String
}

struct StoryChapter: Identifiable {
    let id: Int
    let title: String
    let master: String
    let description: String
    let isUnlocked: Bool
}

struct UserProgress {
    let totalLevels: Int
    let completedLevels: Int
    let currentLevel: Int
    let currentLevelName: String
}