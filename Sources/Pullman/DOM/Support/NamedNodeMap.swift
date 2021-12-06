/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: NamedNodeMap.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/26/21
 *
 * Copyright © 2021. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this
 * permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 * AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *===============================================================================================================================================================================*/

import Foundation
import CoreFoundation
import Rubicon
import RedBlackTree

public class NamedNodeMap<T>: BidirectionalCollection, ChildNodeListener where T: Node {
    public typealias Index = Int
    public typealias Element = T

    public private(set) var startIndex: Int = 0
    public private(set) var endIndex:   Int = 0

    init() {}

    public subscript(position: Int) -> T { fatalError("Index out of bounds.") }

    public func index(before i: Int) -> Int {
        guard (i == 1) else { fatalError("Index out of bounds.") }
        return 0
    }

    public func index(after i: Int) -> Int {
        guard (i == -1) else { fatalError("Index out of bounds.") }
        return 0
    }

    public subscript(nodeName: String) -> T? { nil }

    public subscript(localName: String, namespaceURI: String) -> T? { nil }

    @discardableResult public func add(node: T) -> T? { fatalError("Named Node Map is read-only.") }

    @discardableResult public func remove(node: T) -> T? { nil }

    @discardableResult public func removeNodeWith(nodeName: String) -> T? { nil }

    @discardableResult public func removeNodeWith(localName: String, namespaceURI: String) -> T? { nil }

    public func removeAll() {}

    public func handleChildNodeEvent(event: ParentNode.ChildNodeEvent, parent: Node?, child: Node?) {}
}

extension NamedNodeMap {
    @inlinable public func nodeWith(qualifiedName qName: String, namespaceURI uri: String?) -> T? {
        guard let _uri = uri else { return self[qName] }
        return self[NSName.split(qualifiedName: qName).localName, _uri]
    }
}

class MasterNamedNodeMap<T: Node>: NamedNodeMap<T> {
    override var startIndex: Int { _nodes.startIndex }
    override var endIndex:   Int { _nodes.endIndex }

    private var _nodes:   [T]         = []
    private var _nnCache: [String: T] = [:]
    private var _nsCache: [NSKey: T]  = [:]

    override init() { super.init() }

    override func index(after i: Int) -> Int { _nodes.index(after: i) }

    override func index(before i: Int) -> Int { _nodes.index(before: i) }

    override subscript(position: Int) -> T { _nodes[position] }

    override subscript(nodeName: String) -> T? {
        if let node = _nnCache[nodeName] { return node }
        guard let node = _nodes.first(where: { $0.nodeName == nodeName && $0.namespaceURI == nil }) else { return nil }
        _nnCache[nodeName] = node
        return node
    }

    override subscript(localName: String, namespaceURI: String) -> T? {
        let key = NSKey(localName: localName, namespaceURI: namespaceURI)
        if let node = _nsCache[key] { return node }
        guard let node = _nodes.first(where: { ($0.localName == localName && $0.namespaceURI == namespaceURI) }) else { return nil }
        _nsCache[key] = node
        return node
    }

    @discardableResult override func remove(node: T) -> T? {
        if let uri = node.namespaceURI { return removeNodeWith(localName: node.localName, namespaceURI: uri) }
        else { return removeNodeWith(nodeName: node.nodeName) }
    }

    @discardableResult override func removeNodeWith(nodeName: String) -> T? {
        _nnCache.removeValue(forKey: nodeName)
        guard let idx = _nodes.firstIndex(where: { $0.namespaceURI == nil && $0.nodeName == nodeName }) else { return nil }
        return _nodes.remove(at: idx)
    }

    @discardableResult override func removeNodeWith(localName: String, namespaceURI: String) -> T? {
        _nsCache.removeValue(forKey: NSKey(localName: localName, namespaceURI: namespaceURI))
        guard let idx = _nodes.firstIndex(where: { $0.namespaceURI == namespaceURI && $0.localName == localName }) else { return nil }
        return _nodes.remove(at: idx)
    }

    override func handleChildNodeEvent(event: ParentNode.ChildNodeEvent, parent: Node?, child: Node?) {
        switch event {
            case .ChildAdded:         if let c = (child as? T) { add(node: c) }
            case .ChildRemoved:       if let c = (child as? T) { remove(node: c) }
            case .AllChildrenRemoved: removeAll()
        }
    }

    override func removeAll() {
        _nodes.removeAll()
        _nsCache.removeAll()
        _nnCache.removeAll()
    }

    @discardableResult override func add(node c: T) -> T? {
        guard _nodes.first(where: { $0 === c }) == nil else { return nil }
        let other = remove(node: c)
        _nodes.append(c)
        return other
    }

    struct NSKey: Hashable, Comparable {
        let localName:    String
        let namespaceURI: String

        static func < (lhs: NSKey, rhs: NSKey) -> Bool { ((lhs.localName < rhs.localName) || ((lhs.localName == rhs.localName) && (lhs.namespaceURI < rhs.namespaceURI))) }
    }
}

class SlaveNamedNodeMap<T: Node>: NamedNodeMap<T> {
    private let master: NamedNodeMap<T>

    init(master: NamedNodeMap<T>) { self.master = master }

    override func index(before i: Int) -> Int { master.index(before: i) }

    override func index(after i: Int) -> Int { master.index(after: i) }

    override subscript(position: Int) -> T { master[position] }

    override subscript(nodeName: String) -> T? { master[nodeName] }

    override subscript(localName: String, namespaceURI: String) -> T? { master[localName, namespaceURI] }

    override func handleChildNodeEvent(event: ParentNode.ChildNodeEvent, parent: Node?, child: Node?) {}
}
