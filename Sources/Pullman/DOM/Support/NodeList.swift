/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: NodeList.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 12/3/21
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

public class NodeList<T: Node>: BidirectionalCollection {
    public typealias Element = T
    public typealias Index = Int

    fileprivate var _nodes: [T] = []

    public var startIndex: Int { _nodes.startIndex }
    public var endIndex:   Int { _nodes.endIndex }

    init() {}

    public subscript(position: Int) -> T { _nodes[position] }

    public func index(before i: Int) -> Int { _nodes.index(before: i) }

    public func index(after i: Int) -> Int { _nodes.index(after: i) }
}

class ParentNodeList: NodeList<Node>, ChildNodeListener {

    init(parent: ParentNode) {
        super.init()
        var node: Node? = parent.firstChildNode
        while let child = node {
            _nodes.append(child)
            node = child.nextSibling
        }
        parent.addChildNodeListener(listener: self)
    }

    func handleChildNodeEvent(event: ParentNode.ChildNodeEvent, parent: Node?, child: Node?) {
        switch event {
            case .ChildAdded:
                guard let c = child else { return }
                _nodes.removeAll { $0 === c }
                if let n = c.nextSibling, let idx = _nodes.firstIndex(where: { $0 === n }) { _nodes.insert(c, at: idx) }
                else { _nodes.append(c) }
            case .ChildRemoved:
                guard let c = child else { return }
                _nodes.removeAll { $0 === c }
            case .AllChildrenRemoved:
                _nodes.removeAll()
        }
    }
}
