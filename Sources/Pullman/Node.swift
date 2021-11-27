/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: Node.swift
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

public class Node {

    public enum NodeType: UInt8 {
        case None = 0
        case Attribute
        case Element
        case Document
        case DocumentFragment
        case Text
        case CDataSection
        case Comment
        case EntityRef
        case ProcessingInstruction
        case DocType
        case ElementDecl
        case AttributeDecl
        case Notation
        case Entity
    }

    //@f:0
    public                var nodeType:        NodeType                { fatalError("Not Implemented") }
    public                var nodeName:        String                  { (((namespaceURI == nil) || (prefix == nil)) ? localName : "\(prefix!):\(localName)") }
    public                var ownerDocument:   Document                { _ownerDocument! }
    public                var childNodes:      [Node]                  { [] }
    public                var attributes:      NamedNodeMap<Attribute> { NamedNodeMap<Attribute>() }
    public                var textContent:     String                  { get { "" } set {} }
    public                var nodeValue:       String?                 { get { nil } set {} }

    public  internal(set) var localName:       String                  = ""
    public  internal(set) var prefix:          String?                 = nil
    public  internal(set) var namespaceURI:    String?                 = nil
    public  internal(set) var baseURL:         String?                 = nil

    public  internal(set) var parentNode:      Node?                   = nil
    public  internal(set) var nextSibling:     Node?                   = nil
    public  internal(set) var previousSibling: Node?                   = nil
    public  internal(set) var firstChildNode:  Node?                   = nil
    public  internal(set) var lastChildNode:   Node?                   = nil

    private               var _ownerDocument:  Document?               = nil
    internal              var isReadOnly:      Bool                    = false
    //@f:1

    init() {}

    init(ownerDocument: Document) { self._ownerDocument = ownerDocument }

    @discardableResult public func insert(node newNode: Node, before refNode: Node?) throws -> Node { newNode }

    @discardableResult public func removeNode(_ node: Node) throws -> Node { node }

    @discardableResult public func appendNode(_ node: Node) throws -> Node { try insert(node: node, before: nil) }

    @discardableResult public func replaceNode(old xNode: Node, new node: Node) throws -> Node {
        try insert(node: node, before: xNode)
        return try removeNode(xNode)
    }

    func renameNode(nodeName: String) throws {
        throw DOMError.IllegalOperation(description: "Node cannot be renamed.")
    }

    func renameNode(prefix: String?, localName: String, namespaceURL: String) throws {
        throw DOMError.IllegalOperation(description: "Node cannot be renamed.")
    }

    func set(prefix: String?) throws {
        throw DOMError.IllegalOperation(description: "Node prefix cannot be changed.")
    }

    public func forEachInHierarchy<T>(do body: (Node) throws -> T?) rethrows -> T? {
        if let r: T = try body(self) { return r }
        if let p = parentNode { return try p.forEachInHierarchy(do: body) }
        return nil
    }

    public func forEachChildNode(shallow: Bool = true, do body: (Node) throws -> Void) rethrows {
        try childNodes.forEach {
            try body($0)
            if !shallow { try $0.forEachChildNode(shallow: false, do: body) }
        }
    }
}
