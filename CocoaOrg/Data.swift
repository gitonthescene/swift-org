//
//  Data.swift
//  CocoaOrg
//
//  Created by Xiaoxing Hu on 31/08/16.
//  Copyright © 2016 Xiaoxing Hu. All rights reserved.
//

import Foundation

internal struct Queue<T> {
    var array = [T]()
    var snapshot: [T]?
    
    init(data: [T]) {
        array = data
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        }
        return array.removeFirst()
    }
    
    mutating func swapNext(with element: T) {
        _ = dequeue()
        array.insert(element, at: 0)
    }
    
    func peek() -> T? {
        return array.first
    }
        
    mutating func takeSnapshot() {
        snapshot = array
    }
    
    mutating func restore() {
        if let s = snapshot {
            array = s
        }
    }
}

extension Queue : CustomStringConvertible {
    internal var description: String {
        return array.map{i in "\(i)"}.joined(separator: "\n")
    }
}

internal extension Array {
    func toQueue() -> Queue<Element> {
        return Queue<Element>(data: self)
    }
}

open class TreeNode<T> {
    open var value: T
    open var parent: TreeNode?
    open var children = [TreeNode<T>]()
    public init(value v: T) {
        value = v
    }
    
    func add(_ child: TreeNode<T>) -> TreeNode<T> {
        children.append(child)
        child.parent = self
        return child
    }
    
    func add(_ child: T) -> TreeNode<T> {
        let c = TreeNode<T>(value: child)
        c.parent = self
        children.append(c)
        return c
    }
    
    var isLeaf: Bool {
        return children.count == 0
    }
    
    var isRoot: Bool {
        return parent == nil
    }
    
    var depth: Int {
        if let p = parent {
            return p.depth + 1
        }
        return 0
    }
    
    open func lookUp<Type>(_ type: Type.Type) -> Type? {
        if let v = value as? Type {
            return v
        }
        if let p = parent {
            return p.lookUp(type)
        }
        return nil
    }
}

extension TreeNode: CustomStringConvertible {
    public var description: String {
        let prefix = String(repeating: "-", count: depth)
        var lines = ["\(prefix) \(value)"]
        if !children.isEmpty {
            lines += children.map { $0.description }
        }
        return lines.joined(separator: "\n")
    }
}

public struct Progress {
    public var total: Int = 0
    public var done: Int = 0
    
    public init(_ d: Int = 0, outof t: Int = 0) {
        total = t
        done = d
    }
}

extension Progress: Equatable {
    public static func ==(lhs: Progress, rhs: Progress) -> Bool {
        return lhs.total == rhs.total && lhs.done == rhs.done
    }
}


/// Index of elements within org file.
public struct OrgIndex: CustomStringConvertible, Hashable {
    var indexes: [Int]
    
    public init(_ theIndexes: [Int] = [0]) {
        indexes = theIndexes
    }
    
    public var out: OrgIndex {
        var newIndex = indexes
        newIndex.removeLast()
        return OrgIndex(newIndex)
    }
    
    public var `in`: OrgIndex {
        var newIndex = indexes
        newIndex.append(0)
        return OrgIndex(newIndex)
    }
    
    public var next: OrgIndex {
        var newIndex = indexes
        newIndex[newIndex.endIndex - 1] = newIndex.last! + 1
        return OrgIndex(newIndex)
    }
    
    public var prev: OrgIndex {
        var newIndex = indexes
        newIndex[newIndex.endIndex - 1] = newIndex.last! - 1
       return OrgIndex(newIndex)
    }
    
    public var description: String {
        return indexes.map { n in
            return "\(n)"
        }.joined(separator: ".")
    }
    
    public var hashValue: Int {
        return description.hashValue
    }
    
    public static func == (lhs: OrgIndex, rhs: OrgIndex) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
