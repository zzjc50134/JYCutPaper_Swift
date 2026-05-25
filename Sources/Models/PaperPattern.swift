import Foundation

struct PaperPattern: Identifiable, Codable {
    let id: String
    let name: String
    let category: PatternCategory
    let difficulty: Int
    let meaning: String
    let description: String
    let techniques: [String]
    let imageURL: String?
    let level: Int?
    let isUnlocked: Bool
    let isFavorite: Bool

    init(
        id: String = UUID().uuidString,
        name: String,
        category: PatternCategory,
        difficulty: Int,
        meaning: String,
        description: String,
        techniques: [String] = [],
        imageURL: String? = nil,
        level: Int? = nil,
        isUnlocked: Bool = false,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.difficulty = difficulty
        self.meaning = meaning
        self.description = description
        self.techniques = techniques
        self.imageURL = imageURL
        self.level = level
        self.isUnlocked = isUnlocked
        self.isFavorite = isFavorite
    }
}

enum PatternCategory: String, Codable, CaseIterable {
    case blessing = "吉祥符号"
    case nature = "花鸟虫鱼"
    case legend = "瑞兽传说"
    case animal = "动物"
    case zodiac = "生肖"
    case figure = "人物场景"
    case geometric = "几何纹样"
    case beginner = "入门基础"

    var displayName: String {
        rawValue
    }

    var icon: String {
        switch self {
        case .blessing: return "star.fill"
        case .nature: return "leaf.fill"
        case .legend: return "flame.fill"
        case .animal: return "hare.fill"
        case .zodiac: return "sparkles"
        case .figure: return "person.fill"
        case .geometric: return "square.grid.2x2.fill"
        case .beginner: return "circle.grid.3x3.fill"
        }
    }
}

struct PaperPatternDatabase {
    static let allPatterns: [PaperPattern] = [
        // 入门基础 L1-L5
        PaperPattern(name: "圆形", category: .beginner, difficulty: 1, meaning: "圆满、完整",
                    description: "最简单的圆形剪纸，练习剪刀的基本操作",
                    techniques: ["直线剪", "弧线剪"], level: 1, isUnlocked: true),
        PaperPattern(name: "方形", category: .beginner, difficulty: 1, meaning: "正直、稳定",
                    description: "基础的方形纹样",
                    techniques: ["直线剪"], level: 2, isUnlocked: true),
        PaperPattern(name: "三角形", category: .beginner, difficulty: 2, meaning: "稳定、庄重",
                    description: "学习转角技巧",
                    techniques: ["直线剪", "转角剪"], level: 3, isUnlocked: true),
        PaperPattern(name: "椭圆形", category: .beginner, difficulty: 2, meaning: "柔和、包容",
                    description: "练习不规则弧线",
                    techniques: ["弧线剪"], level: 4, isUnlocked: true),
        PaperPattern(name: "心形", category: .beginner, difficulty: 3, meaning: "爱心、温暖",
                    description: "组合弧线练习",
                    techniques: ["弧线剪", "尖角剪"], level: 5, isUnlocked: true),

        // 吉祥符号 L6-L10
        PaperPattern(name: "福字", category: .blessing, difficulty: 3, meaning: "福气、好运",
                    description: "最重要的吉祥符号，代表一切美好事物的总和",
                    techniques: ["对折剪", "连续纹样"], imageURL: "https://picsum.photos/400/400?random=1",
                    level: 6, isUnlocked: false),
        PaperPattern(name: "寿字", category: .blessing, difficulty: 4, meaning: "长寿、健康",
                    description: "寿字象征长寿康健，常用于祝寿场合",
                    techniques: ["对折剪", "笔画连接"], imageURL: "https://picsum.photos/400/400?random=2",
                    level: 7, isUnlocked: false),
        PaperPattern(name: "喜字", category: .blessing, difficulty: 3, meaning: "喜庆、欢乐",
                    description: "喜字代表喜庆之事，常双喜连用",
                    techniques: ["对折剪"], imageURL: "https://picsum.photos/400/400?random=3",
                    level: 8, isUnlocked: false),
        PaperPattern(name: "双喜字", category: .blessing, difficulty: 4, meaning: "喜上加喜",
                    description: "婚礼必备装饰，寓意成双成对",
                    techniques: ["对折剪", "组合剪"], imageURL: "https://picsum.photos/400/400?random=4",
                    level: 9, isUnlocked: false),
        PaperPattern(name: "如意", category: .blessing, difficulty: 4, meaning: "事事如意",
                    description: "如意象征事事顺心、吉祥如意",
                    techniques: ["弧线剪", "S形剪"], imageURL: "https://picsum.photos/400/400?random=5",
                    level: 10, isUnlocked: false),

        // 花鸟虫鱼 L11-L15
        PaperPattern(name: "牡丹", category: .nature, difficulty: 4, meaning: "富贵荣华",
                    description: "牡丹被誉为花中之王，象征富贵高雅",
                    techniques: ["花瓣剪", "层叠剪"], imageURL: "https://picsum.photos/400/400?random=6",
                    level: 11, isUnlocked: false),
        PaperPattern(name: "荷花", category: .nature, difficulty: 3, meaning: "清廉高洁",
                    description: "荷花出淤泥而不染，象征纯洁高尚",
                    techniques: ["花瓣剪"], imageURL: "https://picsum.photos/400/400?random=7",
                    level: 12, isUnlocked: false),
        PaperPattern(name: "梅花", category: .nature, difficulty: 4, meaning: "坚韧不拔",
                    description: "梅花傲雪开放，象征坚强不屈",
                    techniques: ["花瓣剪", "枝干剪"], imageURL: "https://picsum.photos/400/400?random=8",
                    level: 13, isUnlocked: false),
        PaperPattern(name: "蝴蝶", category: .nature, difficulty: 4, meaning: "美好爱情",
                    description: "蝴蝶象征美好爱情，常与花卉组合",
                    techniques: ["对称剪", "翅膀剪"], imageURL: "https://picsum.photos/400/400?random=9",
                    level: 14, isUnlocked: false),
        PaperPattern(name: "鲤鱼", category: .nature, difficulty: 5, meaning: "年年有余",
                    description: "鱼与余谐音，象征富足有余",
                    techniques: ["弧线剪", "鳞片剪"], imageURL: "https://picsum.photos/400/400?random=10",
                    level: 15, isUnlocked: false),

        // 瑞兽传说 L16-L20
        PaperPattern(name: "龙", category: .legend, difficulty: 5, meaning: "权威、力量",
                    description: "龙是中华民族图腾，象征皇权力量",
                    techniques: ["精细剪", "鳞片剪", "须发剪"], imageURL: "https://picsum.photos/400/400?random=11",
                    level: 16, isUnlocked: false),
        PaperPattern(name: "凤", category: .legend, difficulty: 5, meaning: "美好、祥瑞",
                    description: "凤凰象征美好祥瑞，与龙成对",
                    techniques: ["精细剪", "羽毛剪"], imageURL: "https://picsum.photos/400/400?random=12",
                    level: 17, isUnlocked: false),
        PaperPattern(name: "蝙蝠", category: .animal, difficulty: 4, meaning: "遍地是福",
                    description: "蝠与福谐音，五蝠代表五福临门",
                    techniques: ["对称剪", "翅膀剪"], imageURL: "https://picsum.photos/400/400?random=13",
                    level: 18, isUnlocked: false),
        PaperPattern(name: "喜鹊登梅", category: .nature, difficulty: 5, meaning: "喜讯将至",
                    description: "喜鹊报喜，梅花报春，吉祥图案经典组合",
                    techniques: ["组合剪", "精细剪"], imageURL: "https://picsum.photos/400/400?random=14",
                    level: 19, isUnlocked: false),
        PaperPattern(name: "龙凤呈祥", category: .legend, difficulty: 5, meaning: "吉祥和谐",
                    description: "龙凤组合是最经典的吉祥图案",
                    techniques: ["精细剪", "组合剪"], imageURL: "https://picsum.photos/400/400?random=15",
                    level: 20, isUnlocked: false)
    ]

    static func patternsByCategory(_ category: PatternCategory) -> [PaperPattern] {
        allPatterns.filter { $0.category == category }
    }

    static func patternsByLevel(_ level: Int) -> [PaperPattern] {
        allPatterns.filter { $0.level == level }
    }

    static func unlockedPatterns() -> [PaperPattern] {
        allPatterns.filter { $0.isUnlocked }
    }

    static func favoritePatterns() -> [PaperPattern] {
        allPatterns.filter { $0.isFavorite }
    }

    static func search(_ keyword: String) -> [PaperPattern] {
        let lowercased = keyword.lowercased()
        return allPatterns.filter {
            $0.name.lowercased().contains(lowercased) ||
            $0.meaning.lowercased().contains(lowercased) ||
            $0.description.lowercased().contains(lowercased)
        }
    }
}
