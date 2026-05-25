import Foundation

struct Imagery: Identifiable, Codable {
    let id = UUID()
    let name: String
    let symbol: String
    let category: ImageryCategory
    let meaning: String
    let detailedMeaning: String
    let culturalBackground: String
    let usageScenarios: [String]
    let aiPromptKeywords: [String]
    let relatedSymbols: [String]?
}

enum ImageryCategory: String, Codable, CaseIterable {
    case blessing = "吉祥符号"
    case nature = "花鸟虫鱼"
    case legend = "瑞兽传说"
    case animal = "动物"
    case zodiac = "生肖"
    case figure = "人物场景"
    case geometric = "几何纹样"
    
    var displayName: String {
        self.rawValue
    }
}

struct ImageryDatabase {
    static let allImageries: [Imagery] = [
        Imagery(name: "福", symbol: "福", category: .blessing,
                meaning: "福气、好运", detailedMeaning: "福是最重要的吉祥符号，代表一切美好事物的总和",
                culturalBackground: "福字在中国文化中地位极高，春节贴福字是重要传统",
                usageScenarios: ["春节", "乔迁", "婚礼", "生日"],
                aiPromptKeywords: ["chinese character 福", "blessing", "auspicious", "red paper"],
                relatedSymbols: nil),
        
        Imagery(name: "禄", symbol: "禄", category: .blessing,
                meaning: "官运、事业", detailedMeaning: "禄代表功名利禄，事业顺遂",
                culturalBackground: "禄星是福禄寿三星之一，主掌功名利禄",
                usageScenarios: ["升职", "考试", "事业"],
                aiPromptKeywords: ["chinese character 禄", "career", "success"],
                relatedSymbols: nil),
        
        Imagery(name: "寿", symbol: "寿", category: .blessing,
                meaning: "长寿、健康", detailedMeaning: "寿字象征长寿康健，常用于祝寿场合",
                culturalBackground: "寿字有上百种变体，是祝寿必备元素",
                usageScenarios: ["祝寿", "生日", "长辈"],
                aiPromptKeywords: ["chinese character 寿", "longevity", "birthday"],
                relatedSymbols: nil),
        
        Imagery(name: "喜", symbol: "喜", category: .blessing,
                meaning: "喜庆、欢乐", detailedMeaning: "喜字代表喜庆之事，常双喜连用",
                culturalBackground: "双喜字是婚礼必备装饰，寓意喜上加喜",
                usageScenarios: ["婚礼", "订婚", "庆典"],
                aiPromptKeywords: ["chinese character 喜", "happiness", "wedding"],
                relatedSymbols: nil),
        
        Imagery(name: "财", symbol: "财", category: .blessing,
                meaning: "财富、财运", detailedMeaning: "财字象征财运亨通，招财进宝",
                culturalBackground: "财神是民间重要信仰，财字剪纸用于祈求财运",
                usageScenarios: ["开业", "新年", "求财"],
                aiPromptKeywords: ["chinese character 财", "wealth", "fortune"],
                relatedSymbols: nil),
        
        Imagery(name: "牡丹", symbol: "牡丹", category: .nature,
                meaning: "富贵荣华", detailedMeaning: "牡丹被誉为花中之王，象征富贵高雅",
                culturalBackground: "牡丹是中国国花候选，在剪纸中应用极广",
                usageScenarios: ["婚礼", "庆典", "装饰"],
                aiPromptKeywords: ["peony", "prosperity", "layered petals", "elegant"],
                relatedSymbols: ["凤凰", "蝴蝶"]),
        
        Imagery(name: "荷花", symbol: "荷花", category: .nature,
                meaning: "清廉高洁", detailedMeaning: "荷花出淤泥而不染，象征纯洁高尚",
                culturalBackground: "荷花是佛教圣花，也是文人墨客最爱题材",
                usageScenarios: ["装饰", "文人书房"],
                aiPromptKeywords: ["lotus", "pure", "elegant", "buddhist"],
                relatedSymbols: ["鱼", "蜻蜓"]),
        
        Imagery(name: "梅花", symbol: "梅花", category: .nature,
                meaning: "坚韧不拔", detailedMeaning: "梅花傲雪开放，象征坚强不屈",
                culturalBackground: "梅兰竹菊四君子之首，文人最爱",
                usageScenarios: ["新年", "文人书房", "装饰"],
                aiPromptKeywords: ["plum blossom", "winter", "resilience"],
                relatedSymbols: ["喜鹊"]),
        
        Imagery(name: "蝴蝶", symbol: "蝴蝶", category: .nature,
                meaning: "美好爱情", detailedMeaning: "蝴蝶象征美好爱情，常与花卉组合",
                culturalBackground: "梁祝化蝶的故事广为流传",
                usageScenarios: ["婚礼", "爱情", "装饰"],
                aiPromptKeywords: ["butterfly", "love", "beautiful", "detailed wings"],
                relatedSymbols: ["牡丹", "花"]),
        
        Imagery(name: "鱼", symbol: "鱼", category: .nature,
                meaning: "年年有余", detailedMeaning: "鱼与余谐音，象征富足有余",
                culturalBackground: "鱼纹是中国最古老的装饰纹样之一",
                usageScenarios: ["春节", "新年", "开业"],
                aiPromptKeywords: ["chinese carp", "swimming", "scales", "abundance"],
                relatedSymbols: ["莲", "水波"]),
        
        Imagery(name: "喜鹊", symbol: "喜鹊", category: .nature,
                meaning: "喜讯将至", detailedMeaning: "喜鹊是报喜鸟，象征喜事临门",
                culturalBackground: "喜鹊登梅是最经典的组合",
                usageScenarios: ["新年", "婚礼", "喜讯"],
                aiPromptKeywords: ["magpie", "good news", "plum branch"],
                relatedSymbols: ["梅花"]),
        
        Imagery(name: "龙", symbol: "龙", category: .legend,
                meaning: "权威、力量", detailedMeaning: "龙是中华民族图腾，象征皇权力量",
                culturalBackground: "龙是四灵之首，至高无上的神兽",
                usageScenarios: ["重要庆典", "龙年", "重大事件"],
                aiPromptKeywords: ["chinese dragon", "majestic", "scales", "clouds"],
                relatedSymbols: ["凤", "云"]),
        
        Imagery(name: "凤", symbol: "凤", category: .legend,
                meaning: "美好、祥瑞", detailedMeaning: "凤凰象征美好祥瑞，与龙成对",
                culturalBackground: "凤是百鸟之王，象征后妃之德",
                usageScenarios: ["婚礼", "重大庆典"],
                aiPromptKeywords: ["phoenix", "beautiful feathers", "elegant"],
                relatedSymbols: ["龙", "牡丹"]),
        
        Imagery(name: "蝙蝠", symbol: "蝠", category: .animal,
                meaning: "遍地是福", detailedMeaning: "蝠与福谐音，五蝠代表五福临门",
                culturalBackground: "蝙蝠在西方不吉利，但在中国是吉祥物",
                usageScenarios: ["祝寿", "新年", "祝福"],
                aiPromptKeywords: ["bat", "five bats", "blessing", "good fortune"],
                relatedSymbols: nil),
        
        Imagery(name: "鼠", symbol: "鼠", category: .zodiac,
                meaning: "机智灵活", detailedMeaning: "鼠是十二生肖之首，象征聪明机智",
                culturalBackground: "鼠咬天开，是创世神兽",
                usageScenarios: ["鼠年", "新年"],
                aiPromptKeywords: ["mouse", "clever", "cute", "zodiac"],
                relatedSymbols: nil),
        
        Imagery(name: "牛", symbol: "牛", category: .zodiac,
                meaning: "勤劳踏实", detailedMeaning: "牛象征勤劳、坚韧",
                culturalBackground: "牛是农耕文明的重要伙伴",
                usageScenarios: ["牛年", "新年"],
                aiPromptKeywords: ["ox", "hardworking", "strong", "zodiac"],
                relatedSymbols: nil),
        
        Imagery(name: "虎", symbol: "虎", category: .zodiac,
                meaning: "勇猛威严", detailedMeaning: "虎是百兽之王，象征勇猛力量",
                culturalBackground: "虎能驱邪避灾，是民间守护神",
                usageScenarios: ["虎年", "儿童", "守护"],
                aiPromptKeywords: ["tiger", "powerful", "brave", "zodiac"],
                relatedSymbols: nil),
        
        Imagery(name: "兔", symbol: "兔", category: .zodiac,
                meaning: "温柔善良", detailedMeaning: "兔象征温柔、机智",
                culturalBackground: "玉兔捣药是中秋传说",
                usageScenarios: ["兔年", "中秋", "新年"],
                aiPromptKeywords: ["rabbit", "cute", "gentle", "moon", "zodiac"],
                relatedSymbols: ["月", "桂花"]),
        
        Imagery(name: "龙", symbol: "龙", category: .zodiac,
                meaning: "尊贵权威", detailedMeaning: "龙是十二生肖中唯一的神兽",
                culturalBackground: "龙是皇权的象征",
                usageScenarios: ["龙年", "庆典"],
                aiPromptKeywords: ["dragon", "majestic", "powerful", "zodiac"],
                relatedSymbols: ["凤"]),
        
        Imagery(name: "蛇", symbol: "蛇", category: .zodiac,
                meaning: "智慧灵动", detailedMeaning: "蛇象征智慧与重生",
                culturalBackground: "蛇是龙的雏形，小龙之称",
                usageScenarios: ["蛇年", "新年"],
                aiPromptKeywords: ["snake", "wisdom", "elegant curves", "zodiac"],
                relatedSymbols: nil),
        
        Imagery(name: "马", symbol: "马", category: .zodiac,
                meaning: "马到成功", detailedMeaning: "马象征成功、进取",
                culturalBackground: "千里马是人才的象征",
                usageScenarios: ["马年", "成功"],
                aiPromptKeywords: ["horse", "success", "galloping", "zodiac"],
                relatedSymbols: ["云"]),
        
        Imagery(name: "羊", symbol: "羊", category: .zodiac,
                meaning: "吉祥美好", detailedMeaning: "羊与祥谐音，象征吉祥",
                culturalBackground: "三阳开泰是吉祥话",
                usageScenarios: ["羊年", "吉祥"],
                aiPromptKeywords: ["goat", "gentle", "peaceful", "zodiac"],
                relatedSymbols: nil),
        
        Imagery(name: "猴", symbol: "猴", category: .zodiac,
                meaning: "聪明伶俐", detailedMeaning: "猴象征聪明、活泼",
                culturalBackground: "孙悟空是最著名的猴子形象",
                usageScenarios: ["猴年", "儿童"],
                aiPromptKeywords: ["monkey", "clever", "playful", "zodiac"],
                relatedSymbols: ["桃"]),
        
        Imagery(name: "鸡", symbol: "鸡", category: .zodiac,
                meaning: "吉祥如意", detailedMeaning: "鸡与吉谐音，象征吉祥",
                culturalBackground: "雄鸡报晓，驱邪避灾",
                usageScenarios: ["鸡年", "辟邪"],
                aiPromptKeywords: ["rooster", "morning", "brave", "zodiac"],
                relatedSymbols: ["太阳"]),
        
        Imagery(name: "狗", symbol: "狗", category: .zodiac,
                meaning: "忠诚守护", detailedMeaning: "狗象征忠诚、守护",
                culturalBackground: "狗是人类最忠实的朋友",
                usageScenarios: ["狗年", "守护"],
                aiPromptKeywords: ["dog", "loyal", "friendly", "zodiac"],
                relatedSymbols: nil),
        
        Imagery(name: "猪", symbol: "猪", category: .zodiac,
                meaning: "富足安康", detailedMeaning: "猪象征富足、吉祥",
                culturalBackground: "肥猪拱门是吉祥图案",
                usageScenarios: ["猪年", "富足"],
                aiPromptKeywords: ["pig", "wealthy", "happy", "zodiac"],
                relatedSymbols: ["元宝"]),
        
        Imagery(name: "童子", symbol: "童子", category: .figure,
                meaning: "多子多福", detailedMeaning: "童子象征子孙繁衍、人丁兴旺",
                culturalBackground: "百子图是传统剪纸经典题材",
                usageScenarios: ["婚礼", "祝寿", "新年"],
                aiPromptKeywords: ["boy child", "happy", "traditional chinese", "playing"],
                relatedSymbols: nil),
        
        Imagery(name: "仕女", symbol: "仕女", category: .figure,
                meaning: "优雅高贵", detailedMeaning: "仕女象征优雅、美好",
                culturalBackground: "仕女图是中国传统美术经典题材",
                usageScenarios: ["装饰", "书房"],
                aiPromptKeywords: ["lady", "elegant", "traditional dress", "graceful"],
                relatedSymbols: nil),
        
        Imagery(name: "云纹", symbol: "云", category: .nature,
                meaning: "祥云瑞气", detailedMeaning: "云纹象征吉祥、祥瑞",
                culturalBackground: "云纹是中国传统装饰纹样，寓意吉祥",
                usageScenarios: ["边饰", "底纹", "搭配"],
                aiPromptKeywords: ["cloud pattern", "flowing curves", "auspicious"],
                relatedSymbols: ["龙", "凤"]),
        
        Imagery(name: "回纹", symbol: "回", category: .geometric,
                meaning: "富贵不断", detailedMeaning: "回纹象征连绵不断、永无止境",
                culturalBackground: "回纹是几何纹样中最经典的之一",
                usageScenarios: ["边框", "底纹"],
                aiPromptKeywords: ["hui pattern", "geometric", "continuous", "border"],
                relatedSymbols: nil),
        
        Imagery(name: "水波纹", symbol: "水", category: .geometric,
                meaning: "财源滚滚", detailedMeaning: "水波纹象征财富源源不断",
                culturalBackground: "水为财，财源滚滚来",
                usageScenarios: ["边框", "底纹", "搭配"],
                aiPromptKeywords: ["water wave", "flowing", "wealth", "pattern"],
                relatedSymbols: ["鱼"]),
        
        Imagery(name: "如意", symbol: "如意", category: .blessing,
                meaning: "事事如意", detailedMeaning: "如意象征事事顺心、吉祥如意",
                culturalBackground: "如意是传统吉祥器物",
                usageScenarios: ["祝福", "装饰"],
                aiPromptKeywords: ["ruyi", "scepter", "auspicious", "good luck"],
                relatedSymbols: ["祥云"]),
        
        Imagery(name: "葫芦", symbol: "葫芦", category: .blessing,
                meaning: "福禄双全", detailedMeaning: "葫芦与福禄谐音",
                culturalBackground: "葫芦是道教法器，能驱邪避灾",
                usageScenarios: ["祝寿", "辟邪"],
                aiPromptKeywords: ["gourd", "calabash", "blessing", "protection"],
                relatedSymbols: ["蝙蝠"]),
        
        Imagery(name: "石榴", symbol: "石榴", category: .nature,
                meaning: "多子多福", detailedMeaning: "石榴籽多，象征子孙满堂",
                culturalBackground: "石榴是传统吉祥果",
                usageScenarios: ["婚礼", "祝福"],
                aiPromptKeywords: ["pomegranate", "seeds", "fertility", "fruit"],
                relatedSymbols: ["童子"]),
        
        Imagery(name: "桃子", symbol: "桃", category: .nature,
                meaning: "长寿安康", detailedMeaning: "桃子象征长寿",
                culturalBackground: "蟠桃是神仙的果实",
                usageScenarios: ["祝寿", "生日"],
                aiPromptKeywords: ["peach", "longevity", "fruit", "immortality"],
                relatedSymbols: ["寿星"]),
        
        Imagery(name: "麒麟", symbol: "麒麟", category: .legend,
                meaning: "吉祥瑞兽", detailedMeaning: "麒麟是吉祥的象征",
                culturalBackground: "麒麟送子是传统吉祥图案",
                usageScenarios: ["祝福", "生子"],
                aiPromptKeywords: ["qilin", "unicorn", "auspicious", "mythical"],
                relatedSymbols: ["童子"]),
        
        Imagery(name: "狮子", symbol: "狮", category: .animal,
                meaning: "镇宅辟邪", detailedMeaning: "狮子象征威严、守护",
                culturalBackground: "石狮子是传统镇宅之物",
                usageScenarios: ["镇宅", "守护"],
                aiPromptKeywords: ["lion", "guardian", "powerful", "traditional"],
                relatedSymbols: ["绣球"]),
        
        Imagery(name: "鹿", symbol: "鹿", category: .animal,
                meaning: "福禄双全", detailedMeaning: "鹿与禄谐音",
                culturalBackground: "鹿是长寿的象征",
                usageScenarios: ["祝寿", "祝福"],
                aiPromptKeywords: ["deer", "peaceful", "longevity", "nature"],
                relatedSymbols: ["鹤"]),
        
        Imagery(name: "仙鹤", symbol: "鹤", category: .animal,
                meaning: "长寿延年", detailedMeaning: "仙鹤象征长寿",
                culturalBackground: "鹤是神仙的坐骑",
                usageScenarios: ["祝寿", "高雅"],
                aiPromptKeywords: ["crane", "longevity", "elegant", "bird"],
                relatedSymbols: ["松"]),
        
        Imagery(name: "松树", symbol: "松", category: .nature,
                meaning: "坚韧长寿", detailedMeaning: "松树象征坚韧、长寿",
                culturalBackground: "松鹤延年是经典吉祥图案",
                usageScenarios: ["祝寿", "装饰"],
                aiPromptKeywords: ["pine tree", "evergreen", "longevity", "resilience"],
                relatedSymbols: ["鹤"]),
        
        Imagery(name: "竹", symbol: "竹", category: .nature,
                meaning: "君子之风", detailedMeaning: "竹象征正直、谦虚",
                culturalBackground: "梅兰竹菊四君子之一",
                usageScenarios: ["书房", "装饰"],
                aiPromptKeywords: ["bamboo", "elegant", "modesty", "asian"],
                relatedSymbols: ["梅", "兰"]),
        
        Imagery(name: "兰", symbol: "兰", category: .nature,
                meaning: "高洁典雅", detailedMeaning: "兰象征高洁、典雅",
                culturalBackground: "梅兰竹菊四君子之一",
                usageScenarios: ["书房", "装饰"],
                aiPromptKeywords: ["orchid", "elegant", "pure", "flower"],
                relatedSymbols: ["竹"]),
        
        Imagery(name: "菊", symbol: "菊", category: .nature,
                meaning: "高洁长寿", detailedMeaning: "菊象征高洁、长寿",
                culturalBackground: "梅兰竹菊四君子之一",
                usageScenarios: ["秋天", "装饰"],
                aiPromptKeywords: ["chrysanthemum", "autumn", "elegant", "flower"],
                relatedSymbols: ["梅"]),
        
        Imagery(name: "鸳鸯", symbol: "鸳鸯", category: .animal,
                meaning: "百年好合", detailedMeaning: "鸳鸯象征夫妻恩爱",
                culturalBackground: "鸳鸯总是成对出现",
                usageScenarios: ["婚礼", "爱情"],
                aiPromptKeywords: ["mandarin duck", "love", "couple", "romantic"],
                relatedSymbols: ["荷花"]),
        
        Imagery(name: "鲤鱼", symbol: "鲤鱼", category: .nature,
                meaning: "步步高升", detailedMeaning: "鲤鱼跳龙门象征成功",
                culturalBackground: "鲤鱼化龙是经典传说",
                usageScenarios: ["升学", "成功"],
                aiPromptKeywords: ["carp", "dragon gate", "success", "fish"],
                relatedSymbols: ["龙"]),
        
        Imagery(name: "元宝", symbol: "元宝", category: .blessing,
                meaning: "招财进宝", detailedMeaning: "元宝象征财富",
                culturalBackground: "元宝是古代货币",
                usageScenarios: ["招财", "开业"],
                aiPromptKeywords: ["gold ingot", "wealth", "fortune", "treasure"],
                relatedSymbols: ["财神"]),
        
        Imagery(name: "灯笼", symbol: "灯", category: .blessing,
                meaning: "喜庆光明", detailedMeaning: "灯笼象征喜庆、光明",
                culturalBackground: "灯笼是传统节日装饰",
                usageScenarios: ["节日", "喜庆"],
                aiPromptKeywords: ["lantern", "festive", "red", "traditional"],
                relatedSymbols: ["鞭炮"]),
        
        Imagery(name: "鞭炮", symbol: "炮", category: .blessing,
                meaning: "驱邪迎喜", detailedMeaning: "鞭炮象征喜庆、驱邪",
                culturalBackground: "春节放鞭炮是传统习俗",
                usageScenarios: ["新年", "喜庆"],
                aiPromptKeywords: ["firecracker", "celebration", "chinese new year"],
                relatedSymbols: ["灯笼"]),
        
        Imagery(name: "八卦", symbol: "八卦", category: .geometric,
                meaning: "辟邪镇宅", detailedMeaning: "八卦象征阴阳平衡",
                culturalBackground: "八卦是道家符号",
                usageScenarios: ["辟邪", "镇宅"],
                aiPromptKeywords: ["bagua", "eight trigrams", "feng shui", "protection"],
                relatedSymbols: ["太极"])
    ]
    
    static func imageriesByCategory(_ category: ImageryCategory) -> [Imagery] {
        allImageries.filter { $0.category == category }
    }
    
    static func searchByName(_ name: String) -> [Imagery] {
        allImageries.filter { $0.name.contains(name) || $0.symbol.contains(name) }
    }
    
    static func searchByMeaning(_ meaning: String) -> [Imagery] {
        allImageries.filter { $0.meaning.contains(meaning) || $0.detailedMeaning.contains(meaning) }
    }
}