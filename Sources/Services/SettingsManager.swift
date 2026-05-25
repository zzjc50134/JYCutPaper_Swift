import Foundation

class SettingsManager {
    static let shared = SettingsManager()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let defaultStyle = "default_style"
        static let defaultRatio = "default_ratio"
        static let defaultMode = "default_mode"
    }

    private init() {}

    func setDefaultStyle(_ style: ImageStyle) {
        defaults.set(style.rawValue, forKey: Keys.defaultStyle)
    }

    func getDefaultStyle() -> ImageStyle {
        guard let rawValue = defaults.string(forKey: Keys.defaultStyle),
              let style = ImageStyle(rawValue: rawValue) else {
            return .traditional
        }
        return style
    }

    func setDefaultRatio(_ ratio: AspectRatio) {
        defaults.set(ratio.rawValue, forKey: Keys.defaultRatio)
    }

    func getDefaultRatio() -> AspectRatio {
        guard let rawValue = defaults.string(forKey: Keys.defaultRatio),
              let ratio = AspectRatio(rawValue: rawValue) else {
            return .ratio1x1
        }
        return ratio
    }

    func setDefaultMode(_ mode: CreateMode) {
        defaults.set(mode.title, forKey: Keys.defaultMode)
    }

    func getDefaultMode() -> CreateMode {
        guard let title = defaults.string(forKey: Keys.defaultMode) else {
            return .textToImage
        }
        return CreateMode.allCases.first { $0.title == title } ?? .textToImage
    }
}
