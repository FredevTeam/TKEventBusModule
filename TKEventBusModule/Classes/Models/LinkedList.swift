//
//  LinkedList.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation


class Node<V> {
    var value: V
    var next: Node<V>?
    var previous: Node<V>?

    init(_ value: V) {
        self.value = value
    }

    init(_ value: V, next: Node<V>? = nil , previous: Node<V>? = nil) {
        self.value = value
        self.next = next
        self.previous = previous
    }
}


final class LinkedList<V> {
    private var size = 0
    private var firstNode: Node<V>?
    private var lastNode: Node<V>?

    init() {
    }
}

extension LinkedList {
    func append(_ newElement: V) {
        let node = Node.init(newElement, next: nil, previous: lastNode)
        if lastNode == nil {
            firstNode = node
        }
        lastNode?.next = node
        lastNode = node
        size += 1
    }

    /// 追加多个元素
    func append<S>(contentsOf newElements: S) where S : Sequence, V == S.Element {
        for item in newElements {
            append(item)
        }
    }
    /// 插入单个元素
    func insert(_ newElement: V, at i: Int){
        let newNode = Node.init(newElement, next: nil, previous: nil)
        if i == 0 && size == 0{
            firstNode = newNode
            lastNode = newNode
        }else {
            let insertNode = node(at: i)
            newNode.next = insertNode
            insertNode.previous = newNode
            newNode.previous = insertNode.previous
            insertNode.previous?.next = newNode
            if i == 0 {
                firstNode = newNode
            }
        }
        size += 1
    }
    /// 插入多个元素
    func insert<S>(contentsOf newElements: S, at i: Int) where S : Collection, V == S.Element {
        if i == 0 && size == 0 {
            append(contentsOf: newElements)
        }else {
            let insertNode = node(at: i)
            var firstNode:Node<V>?
            var lastNode:Node<V>?
            for (index,item) in newElements.enumerated() {
                let newNode = Node.init(item, next: nil, previous: nil)
                if index == 0 {
                    firstNode = newNode
                    lastNode = newNode
                }else {
                    newNode.previous = lastNode
                    lastNode?.next = newNode
                    lastNode = newNode
                }
                size += 1
            }
            firstNode?.previous = insertNode.previous
            lastNode?.next = insertNode
            insertNode.previous?.next = firstNode
            insertNode.previous = lastNode
            if i == 0 {
                self.firstNode = firstNode
            }
        }
    }
}

// MARK: - 实现Collection协议
extension LinkedList : Collection {
    /// 开始位置
    var startIndex: Int {  return 0 }
    /// 结束位置
    var endIndex: Int { return size }
    /// 给定位置后面的索引值
    func index(after i: Int) -> Int {
        return i + 1
    }
    /// 返回指定的迭代器
    func makeIterator() -> Iterator {
        return Iterator(self)
    }
    /// 通过下标存取元素
    subscript(position: Int) -> V {
        get {
            return node(at: position).value
        }
        set {
            node(at: position).value = newValue
        }
    }
}
// MARK: - 迭代器
extension LinkedList {
    struct Iterator: IteratorProtocol {
        let list: LinkedList
        var index: Int
        private var nextNode:Node<V>?
        init(_ list: LinkedList) {
            self.list = list
            self.index = 0
            self.nextNode = list.firstNode
        }
        /// 获取下一个元素，在for in里若返回nil，则停止循环
        mutating func next() -> V? {
            let item = nextNode?.value
            nextNode = nextNode?.next
            return item
        }
    }
}

extension LinkedList {
    private func node(at index: Int) -> Node<V> {
        if index < 0 || index > size {
            fatalError("index out of rang")
        }
        //如果节点在前一半顺序查找，否则逆序查找
        if index < (size >> 1) {
            var node = firstNode
            for _ in 0..<index {
                node = node?.next
            }
            return node!
        }else {
            var node = lastNode
            for _ in stride(from: size - 1, to: index, by: -1) {
                node = node?.previous
            }
            return node!
        }
    }
}



extension LinkedList {
    /// 删除指定位置的元素
    @discardableResult
    func remove(at position: Int) -> V {
        let removeNode = node(at: position)
        removeNode.previous?.next = removeNode.next
        removeNode.next?.previous = removeNode.previous
        size -= 1
        return removeNode.value
    }

    /// 删除第一个元素
    @discardableResult
    func removefirstNode() -> V? {
        return firstNode == nil ? nil : remove(at: 0)
    }
    /// 删除最后一个元素
    @discardableResult
    func removelastNode() -> V? {
        return lastNode == nil ? nil : remove(at: size - 1)
    }
    /// 删除所有元素
    func removeAll() {
        var next = firstNode
        while next != nil {
            let tmp = next
            next?.next = nil
            next?.previous = nil
            next = tmp
        }
        firstNode = nil
        lastNode = nil
        size = 0
    }

}

extension LinkedList {
    /// 顺序查找
    func firstIndex(where predicate: (V) throws -> Bool) rethrows -> Int? {
        for (index,item) in self.enumerated() {
            if try predicate(item) {
                return index
            }
        }
        return nil
    }

    /// 倒序查找
    func lastIndex(where predicate: (V) throws -> Bool) rethrows -> Int? {
        var prev = lastNode
        var currentIndex = size - 1
        while prev != nil {
            if try predicate(prev!.value) {
                return currentIndex
            }
            currentIndex -= 1
            prev = prev?.previous
        }
        return nil
    }

    /// 是否包含
    func contains(where predicate: (V) throws -> Bool) rethrows -> Bool {
        for item in self {
            if try predicate(item) {
                return true
            }
        }
        return false
    }
}


extension LinkedList where V : Equatable {
    func firstIndex(of element: V) -> Int? {
        return firstIndex { (item) -> Bool in
            return item == element
        }
    }
    func lastIndex(of element: V) -> Int? {
        return lastIndex(where: { (item) -> Bool in
            return item == element
        })
    }

    func contains(_ element: V) -> Bool {
        return contains(where: { (item) -> Bool in
            return item == element
        })
    }

    func find(by value: V) -> Node<V>? {
        guard let index = firstIndex(of: value) else { return nil }
        return node(at: index)
    }

    func removes(at: [V])  {
        at.forEach { (v) in
            guard let index = firstIndex(of: v) else { return }
            remove(at: index)
        }
    }
}
// MARK: - 把LinkedList转成Array
extension LinkedList {
    func toArray() -> [V] {
        return self.map({ (item) -> V in
            return item
        })
    }
}


// MARK: - CustomDebugStringConvertible协议，通过实现该协议，实现自定义打印
extension LinkedList : CustomDebugStringConvertible {
    var debugDescription: String {
        var desc = ""
        if size > 0 {
            for item in self.dropLast() {
                desc += "\(item)-->"
            }
            desc += "\(lastNode!.value)"
        }
        return desc
    }
}

