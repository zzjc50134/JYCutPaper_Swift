import SwiftUI

enum JYColor {
    // 主色调 - 京韵红系
    static let primaryRed = Color(hex: "C41E3A")      // 正红
    static let deepRed = Color(hex: "8B0000")        // 深红
    static let lightRed = Color(hex: "FF6B6B")       // 浅红
    static let paleRed = Color(hex: "FFF0F0")        // 淡红

    // 辅色调 - 墨金色系
    static let inkBlack = Color(hex: "1A1A1A")       // 墨黑
    static let gold = Color(hex: "C8A200")           // 金色
    static let brightGold = Color(hex: "D4AF37")     // 亮金
    static let paleGold = Color(hex: "F5E6C8")       // 淡金

    // 辅助色 - 青墨色系
    static let deepInkBlue = Color(hex: "2C3E50")    // 深墨蓝
    static let navyBlue = Color(hex: "4A6FA5")        // 藏青
    static let moonWhite = Color(hex: "FFFFFF")       // 月白

    // 渐变色
    static let backgroundGradient = LinearGradient(
        colors: [Color(hex: "1A1A1A"), Color(hex: "8B0000")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardGradient = LinearGradient(
        colors: [Color(hex: "C41E3A"), Color(hex: "8B0000")],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let buttonGradient = LinearGradient(
        colors: [Color(hex: "C41E3A"), Color(hex: "FF6B6B")],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum JYFont {
    static func title() -> Font {
        .system(size: 48, weight: .bold, design: .default)
    }

    static func chapterTitle() -> Font {
        .system(size: 22, weight: .medium, design: .default)
    }

    static func body() -> Font {
        .system(size: 16, weight: .regular, design: .default)
    }

    static func caption() -> Font {
        .system(size: 12, weight: .light, design: .default)
    }

    static func specialNumber() -> Font {
        .system(size: 36, weight: .bold, design: .rounded)
    }

    static func monoNumber() -> Font {
        .system(size: 24, weight: .medium, design: .monospaced)
    }
}

enum JYSpacing {
    static let pageMargin: CGFloat = 16
    static let sectionSpacing: CGFloat = 24
    static let cardPadding: CGFloat = 16
    static let itemSpacing: CGFloat = 12
    static let iconTextSpacing: CGFloat = 8
}

enum JYCornerRadius {
    static let largeCard: CGFloat = 16
    static let mediumCard: CGFloat = 12
    static let smallIcon: CGFloat = 8
    static let inputField: CGFloat = 10
}