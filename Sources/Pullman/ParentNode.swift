/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: ParentNode.swift
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

public class ParentNode: Node {
    private var _childNodes: [Node] = []

    public override var childNodes: [Node] { _childNodes }

    public internal(set) override var firstChildNode: Node? {
        get { _childNodes.first }
        set { if let n = newValue { _ = try? insert(node: n, before: _childNodes.first) } }
    }
    public internal(set) override var lastChildNode:  Node? {
        get { _childNodes.last }
        set { if let n = newValue { _ = try? appendNode(n) } }
    }

    override init(ownerDocument: Document) { super.init(ownerDocument: ownerDocument) }

    override init() { super.init() }

    public override var textContent: String {
        get {
            var str: String = ""
            _childNodes.forEach { str += $0.textContent }
            return str
        }
        set {}
    }

    @discardableResult func removeAllNodes() -> [Node] {
        let out: [Node] = _childNodes.map {
            $0.parentNode = nil
            $0.nextSibling = nil
            $0.previousSibling = nil
            return $0
        }
        _childNodes.removeAll()
        return out
    }

    @discardableResult public override func insert(node newNode: Node, before refNode: Node?) throws -> Node {
        guard newNode.ownerDocument === ownerDocument else { throw DOMError.WrongDocumentError(description: "New node does not belong to the same document as this node.") }
        guard (forEachInHierarchy(do: { ($0 === newNode ? false : nil) }) ?? true) else { throw DOMError.HierarchyError(description: "New node cannot be this node or any of this node's parents.") }

        if let _xNode = refNode {
            guard _xNode.parentNode === self else { throw DOMError.NodeNotFound(description: "Reference node is not a child of this node.") }
            guard newNode !== _xNode else { return newNode }
            for (i, x): (Int, Node) in _childNodes.enumerated() { if x === _xNode { return try _insert(newNode, x, i) } }
            throw DOMError.InternalInconsistencyError(description: "Reference node was not found despite it's parent node field being set to this node.")
        }

        return try _append(newNode)
    }

    @discardableResult public override func removeNode(_ node: Node) throws -> Node {
        guard node.parentNode === self else { throw DOMError.NodeNotFound(description: "Node is not a child of this node.") }

        for (i, _node): (Int, Node) in _childNodes.enumerated() {
            if node === _node {
                return _remove(node, i)
            }
        }

        throw DOMError.InternalInconsistencyError(description: "Node was not found despite it's parent node field being set to this node.")
    }

    private func _append(_ node: Node) throws -> Node {
        try adopt(node: node)

        if let l = _childNodes.last {
            node.previousSibling = l.previousSibling
            l.previousSibling = node
            node.nextSibling = nil
        }

        _childNodes.append(node)
        return node
    }

    private func _insert(_ node: Node, _ refNode: Node, _ position: Int) throws -> Node {
        try adopt(node: node)

        if let n = refNode.previousSibling {
            n.nextSibling = node
            node.previousSibling = n
        }

        node.nextSibling = refNode
        refNode.previousSibling = node
        _childNodes.insert(node, at: position)
        return node
    }

    private func adopt(node: Node) throws {
        if let p = node.parentNode { try p.removeNode(node) }
        node.parentNode = self
    }

    private func _remove(_ node: Node, _ position: Int) -> Node {
        if let n = node.nextSibling { n.previousSibling = node.previousSibling }
        if let n = node.previousSibling { n.nextSibling = node.nextSibling }
        node.nextSibling = nil
        node.previousSibling = nil
        node.parentNode = nil
        return _childNodes.remove(at: position)
    }
}
