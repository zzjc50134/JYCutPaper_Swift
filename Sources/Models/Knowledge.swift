import Foundation

struct Knowledge: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let category: KnowledgeCategory
    let tags: [String]
    let relatedPatterns: [String]
    let imageURL: String?

    init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        category: KnowledgeCategory,
        tags: [String] = [],
        relatedPatterns: [String] = [],
        imageURL: String? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.tags = tags
        self.relatedPatterns = relatedPatterns
        self.imageURL = imageURL
    }
}

enum KnowledgeCategory: String, Codable, CaseIterable {
    case history = "历史起源"
    case technique = "基础技法"
    case culture = "文化内涵"
    case master = "剪纸大师"
    case festival = "节日习俗"

    var displayName: String {
        rawValue
    }

    var icon: String {
        switch self {
        case .history: return "clock.fill"
        case .technique: return "scissors"
        case .culture: return "book.fill"
        case .master: return "person.fill"
        case .festival: return "gift.fill"
        }
    }
}

struct KnowledgeDatabase {
    static let allKnowledge: [Knowledge] = [
        Knowledge(
            title: "剪纸的起源与发展",
            content: """
            剪纸是中国最古老的民间艺术之一，距今已有1500多年的历史。

            **起源**
            最早的剪纸可追溯到西汉时期，当时人们用金箔、绢帛剪成方胜、花鸟等图案，作为装饰品。

            **发展**
            - 南北朝时期：剪纸技艺趋于成熟
            - 唐代：剪纸用于装饰和祭祀
            - 宋代：剪纸成为民间艺术的重要组成
            - 明清：剪纸艺术达到鼎盛

            **现代传承**
            2006年，剪纸被列入第一批国家级非物质文化遗产名录。
            2009年，中国剪纸入选联合国教科文组织人类非物质文化遗产代表作名录。
            """,
            category: .history,
            tags: ["起源", "历史", "非遗"],
            relatedPatterns: ["福字", "喜字"]
        ),

        Knowledge(
            title: "基础技法：对折剪",
            content: """
            对折剪是剪纸最基本的技法，适合制作对称图案。

            **步骤**
            1. 将正方形纸对折成正方形或长方形
            2. 再对折一次或多次
            3. 在折好的纸上绘制图案的一半
            4. 沿绘制好的线条剪下

            **技巧**
            - 对折要整齐，边缘要对齐压紧
            - 剪内部时不要剪断边缘
            - 先从中间开始剪，再向外延伸

            **适用图案**
            - 树叶、花瓣（对折一次）
            - 蝴蝶、鸟（对折两次）
            - 复杂花纹（多次对折）
            """,
            category: .technique,
            tags: ["技法", "入门", "对折"],
            relatedPatterns: ["蝴蝶", "牡丹"]
        ),

        Knowledge(
            title: "基础技法：阳刻与阴刻",
            content: """
            阳刻和阴刻是剪纸的两种基本表现方式。

            **阳刻（凸刻）**
            - 线条是凸起的，背景被剪去
            - 特点：清晰、整洁
            - 适合：文字、精细图案

            **阴刻（凹刻）**
            - 线条是凹下的，保留背景
            - 特点：厚重、有力
            - 适合：装饰纹样、几何图案

            **混合使用**
            一幅好的剪纸作品通常阳刻阴刻结合，层次分明。
            """,
            category: .technique,
            tags: ["技法", "阳刻", "阴刻"]
        ),

        Knowledge(
            title: "纹样寓意：牡丹",
            content: """
            牡丹是中国传统名花，被誉为"花中之王"。

            **文化寓意**
            - 富贵荣华：牡丹花大色艳，象征富贵
            - 吉祥幸福：牡丹常与凤凰组合
            - 高雅品格：文人墨客常以牡丹自喻

            **在剪纸中的应用**
            - 牡丹单独成图：象征富贵
            - 牡丹+凤凰：凤戏牡丹，吉祥富贵
            - 牡丹+花瓶：富贵平安
            - 牡丹+蝴蝶：捷报富贵

            **配色建议**
            经典配色：正红底+金牡丹
            """,
            category: .culture,
            tags: ["文化", "牡丹", "寓意"],
            relatedPatterns: ["牡丹", "凤"]
        ),

        Knowledge(
            title: "纹样寓意：龙凤",
            content: """
            龙和凤是中国文化中最重要的吉祥符号。

            **龙的文化内涵**
            - 权威与力量：龙是皇权的象征
            - 智慧与祥瑞：龙能兴云布雨
            - 进取精神：龙马精神

            **凤的文化内涵**
            - 美好与吉祥：凤鸣朝阳
            - 爱情与婚姻：鸾凤和鸣
            - 圣德与仁义：百鸟朝凤

            **龙凤呈祥**
            龙凤组合是最经典的吉祥图案，寓意：
            - 婚姻美满
            - 和谐幸福
            - 事业腾飞
            """,
            category: .culture,
            tags: ["文化", "龙", "凤", "寓意"],
            relatedPatterns: ["龙", "凤", "龙凤呈祥"]
        ),

        Knowledge(
            title: "节日习俗：春节窗花",
            content: """
            贴窗花是春节期间的重要习俗，源于古代的迎春仪式。

            **历史由来**
            据说尧舜时期就有贴窗花的习俗，用以驱邪纳福、迎接新春。

            **常见图案**
            - 福禄寿喜：四大吉祥字
            - 生肖图案：当年生肖+吉祥纹样
            - 花鸟鱼虫：寓意生机勃勃
            - 戏剧人物：寓意教化娱乐

            **贴法讲究**
            - 颜色：红色为主，喜庆热烈
            - 位置：窗户正中，四角对称
            - 数量：成双成对，取偶数

            **现代意义**
            窗花不仅是装饰，更承载着人们对美好生活的期盼。
            """,
            category: .festival,
            tags: ["节日", "春节", "窗花"],
            relatedPatterns: ["福字", "喜字", "双喜字"]
        ),

        Knowledge(
            title: "剪纸大师：库淑兰",
            content: """
            库淑兰（1920-2004），陕西旬邑县人，中国剪纸艺术大师。

            **艺术成就**
            - 联合国教科文组织授予"工艺美术大师"称号
            - 作品被中国美术馆收藏
            - 创立独特的彩色剪纸风格

            **艺术特点**
            - 色彩鲜艳，以红、黄、绿为主
            - 图案繁密，层次丰富
            - 题材广泛，花鸟鱼虫、人物故事皆可入画
            - 剪法独特，既有精细的阴刻，也有粗犷的阳刻

            **代表作品**
            《江娃拉梅香》、《石榴树》

            **艺术传承**
            她的作品被誉为"剪花娘子"，开创了民间剪纸艺术的新局面。
            """,
            category: .master,
            tags: ["大师", "库淑兰", "传承"],
            relatedPatterns: ["牡丹", "蝴蝶"]
        ),

        Knowledge(
            title: "基础技法：刀具使用",
            content: """
            剪纸工具虽然简单，但使用方法很有讲究。

            **剪刀的选择**
            - 刀尖要尖细，便于剪细小部位
            - 刀口要锋利，避免拉扯纸张
            - 剪刀不要太长，15-20cm为宜

            **使用方法**
            - 剪直线：手指均匀用力
            - 剪弧线：转纸不转剪
            - 剪小孔：用针尖挑开
            - 剪尖角：先剪大块再剪细节

            **安全提示**
            - 剪纸时注意力要集中
            - 不要用嘴咬着剪刀
            - 放置剪刀时刀口朝下

            **保养维护**
            - 使用后擦干，防止生锈
            - 定期用磨石轻磨保持锋利
            """,
            category: .technique,
            tags: ["技法", "工具", "剪刀"]
        ),

        Knowledge(
            title: "纹样寓意：福禄寿喜",
            content: """
            福、禄、寿、喜是中国最常见的四大吉祥字。

            **福**
            - 寓意：福气、好运
            - 象征：一切美好事物
            - 图案：常配蝙蝠或牡丹

            **禄**
            - 寓意：官运、财富
            - 象征：功名利禄
            - 图案：常配鹿或蝙蝠

            **寿**
            - 寓意：长寿、健康
            - 象征：生命长久
            - 图案：常配松鹤或桃子

            **喜**
            - 寓意：喜庆、欢乐
            - 象征：婚姻、事业双喜
            - 图案：常配喜鹊或蝴蝶

            **应用场合**
            - 春节：福字
            - 祝寿：寿字
            - 婚礼：喜字
            - 开业：禄字
            """,
            category: .culture,
            tags: ["文化", "寓意", "吉祥字"],
            relatedPatterns: ["福字", "寿字", "喜字"]
        ),

        Knowledge(
            title: "剪纸的地域特色",
            content: """
            中国剪纸因地域不同而形成各具特色的流派。

            **北方剪纸**
            - 陕西：粗犷豪放，色彩鲜艳
            - 山西：精细繁复，层次丰富
            - 山东：典雅秀丽，装饰性强

            **南方剪纸**
            - 广东：纤细秀丽，色彩淡雅
            - 江苏：精雕细琢，玲珑剔透
            - 浙江：秀美流畅，题材广泛

            **地方特色**
            - 佛山剪纸：铜凿剪纸，金碧辉煌
            - 蔚县剪纸：套色剪纸，色彩丰富
            - 陕北剪纸：黄土风情，古朴浑厚

            **如何欣赏**
            1. 看刀法：是否干净利落
            2. 看线条：是否流畅圆润
            3. 看构图：是否疏密有致
            4. 看寓意：是否有文化内涵
            """,
            category: .culture,
            tags: ["文化", "地域", "流派"]
        )
    ]

    static func knowledgeByCategory(_ category: KnowledgeCategory) -> [Knowledge] {
        allKnowledge.filter { $0.category == category }
    }

    static func search(_ keyword: String) -> [Knowledge] {
        let lowercased = keyword.lowercased()
        return allKnowledge.filter {
            $0.title.lowercased().contains(lowercased) ||
            $0.content.lowercased().contains(lowercased) ||
            $0.tags.contains { $0.lowercased().contains(lowercased) }
        }
    }
}
