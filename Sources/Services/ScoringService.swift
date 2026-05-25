import Foundation
import CoreGraphics

struct CuttingResult: Codable {
    let accuracy: CGFloat
    let timeScore: CGFloat
    let precision: CGFloat
    let totalScore: CGFloat
    let stars: Int
    let passed: Bool
    let feedback: String
}

class ScoringService {
    
    static func evaluate(
        userPath: [CGPoint],
        standardPath: [CGPoint],
        timeSpent: TimeInterval,
        recommendedTime: TimeInterval,
        keyPoints: [CGPoint]
    ) -> CuttingResult {
        
        let accuracy = calculateIoU(userPath: userPath, standardPath: standardPath)
        
        let timeRatio = min(timeSpent / recommendedTime, 2.0)
        let timeScore = timeRatio <= 1.0 ? 100.0 : max(0, 100 - (timeRatio - 1) * 50)
        
        let precision = calculateKeyPointAccuracy(userPath: userPath, keyPoints: keyPoints)
        
        let totalScore = accuracy * 0.6 + timeScore * 0.2 + precision * 0.2
        
        let stars: Int
        if totalScore >= 90 { stars = 3 }
        else if totalScore >= 70 { stars = 2 }
        else if totalScore >= 50 { stars = 1 }
        else { stars = 0 }
        
        let feedback = generateFeedback(accuracy: accuracy, timeScore: timeScore, precision: precision)
        
        return CuttingResult(
            accuracy: accuracy,
            timeScore: timeScore,
            precision: precision,
            totalScore: totalScore,
            stars: stars,
            passed: stars >= 1,
            feedback: feedback
        )
    }
    
    private static func calculateIoU(userPath: [CGPoint], standardPath: [CGPoint]) -> CGFloat {
        guard userPath.count > 0, standardPath.count > 0 else { return 0 }
        
        let userPathScaled = normalizePath(userPath)
        let standardPathScaled = normalizePath(standardPath)
        
        let alignedStandard = alignPaths(userPathScaled, standardPathScaled)
        
        var totalDistance: CGFloat = 0
        let sampleCount = min(userPathScaled.count, alignedStandard.count)
        
        for i in 0..<sampleCount {
            let dx = userPathScaled[i].x - alignedStandard[i].x
            let dy = userPathScaled[i].y - alignedStandard[i].y
            totalDistance += sqrt(dx*dx + dy*dy)
        }
        
        let avgDistance = totalDistance / CGFloat(sampleCount)
        let maxDistance: CGFloat = 0.1
        
        return max(0, min(100, (1 - avgDistance / maxDistance) * 100))
    }
    
    private static func normalizePath(_ path: [CGPoint]) -> [CGPoint] {
        guard path.count > 0 else { return [] }
        
        let minX = path.map { $0.x }.min() ?? 0
        let maxX = path.map { $0.x }.max() ?? 1
        let minY = path.map { $0.y }.min() ?? 0
        let maxY = path.map { $0.y }.max() ?? 1
        
        let width = max(maxX - minX, 0.001)
        let height = max(maxY - minY, 0.001)
        
        return path.map {
            CGPoint(x: ($0.x - minX) / width, y: ($0.y - minY) / height)
        }
    }
    
    private static func alignPaths(_ path1: [CGPoint], _ path2: [CGPoint]) -> [CGPoint] {
        let targetCount = path1.count
        if path2.count == targetCount {
            return path2
        }
        
        var aligned: [CGPoint] = []
        for i in 0..<targetCount {
            let ratio = CGFloat(i) / CGFloat(targetCount - 1)
            let index = ratio * CGFloat(path2.count - 1)
            let lowerIndex = Int(floor(index))
            let upperIndex = min(lowerIndex + 1, path2.count - 1)
            let t = index - CGFloat(lowerIndex)
            
            let p1 = path2[lowerIndex]
            let p2 = path2[upperIndex]
            
            aligned.append(CGPoint(
                x: p1.x + (p2.x - p1.x) * t,
                y: p1.y + (p2.y - p1.y) * t
            ))
        }
        
        return aligned
    }
    
    private static func calculateKeyPointAccuracy(userPath: [CGPoint], keyPoints: [CGPoint]) -> CGFloat {
        guard keyPoints.count > 0 else { return 100 }
        
        let normalizedUser = normalizePath(userPath)
        let normalizedKeys = normalizePath(keyPoints)
        
        var hitCount = 0
        let threshold: CGFloat = 0.05
        
        for keyPoint in normalizedKeys {
            for userPoint in normalizedUser {
                let dx = userPoint.x - keyPoint.x
                let dy = userPoint.y - keyPoint.y
                let distance = sqrt(dx*dx + dy*dy)
                if distance < threshold {
                    hitCount += 1
                    break
                }
            }
        }
        
        return CGFloat(hitCount) / CGFloat(normalizedKeys.count) * 100
    }
    
    private static func generateFeedback(accuracy: CGFloat, timeScore: CGFloat, precision: CGFloat) -> String {
        var feedback = ""
        
        if accuracy >= 90 {
            feedback += "线条非常流畅！"
        } else if accuracy >= 70 {
            feedback += "线条不错，继续练习会更好！"
        } else {
            feedback += "注意线条的流畅性。"
        }
        
        if timeScore >= 80 {
            feedback += "速度很快！"
        } else if timeScore >= 50 {
            feedback += "节奏把握得不错。"
        } else {
            feedback += "可以适当加快速度。"
        }
        
        if precision >= 80 {
            feedback += "关键点都命中了！"
        } else {
            feedback += "注意转角处要更加圆润。"
        }
        
        return feedback
    }
}