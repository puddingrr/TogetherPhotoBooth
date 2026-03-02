//
//  ExtentionArrays.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/25/26.
//

extension Array {
    init(repeating: [Element], count: Int) {
        self.init([[Element]](repeating: repeating, count: count).flatMap { $0 })
    }
    func repeated(count: Int) -> [Element] {
        return [Element](repeating: self, count: count)
    }
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    func safeTake(_ count: Int) -> [Element] {
        return Array(self.prefix(Swift.max(0, count)))
    }
}
