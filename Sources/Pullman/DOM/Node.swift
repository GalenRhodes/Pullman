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

    public typealias UserDataHandler = (DocumentNodeEvent, String, Any, Node, Node?) -> Void

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

    public enum DocumentNodeEvent {
        case Adopted
        case Cloned
        case Removed
        case Imported
        case Renamed
    }

    //@f:0
    public                var nodeType:        NodeType                { fatalError("Not Implemented") }
    public                var nodeName:        String                  { fatalError("Not Implemented") }
    public                var ownerDocument:   Document                { _ownerDocument! }
    public                var childNodes:      NodeList<Node>          { NodeList<Node>() }
    public                var attributes:      NamedNodeMap<Attribute> { NamedNodeMap<Attribute>() }
    public                var textContent:     String                  { get { "" } set {} }
    public                var nodeValue:       String?                 { get { nil } set {} }
    public                var localName:       String                  { "" }
    public                var prefix:          String?                 { nil }
    public                var namespaceURI:    String?                 { nil }
    public                var firstChildNode:  Node?                   { nil }
    public                var lastChildNode:   Node?                   { nil }

    public  internal(set) var baseURL:         String?                 = nil
    public  internal(set) var parentNode:      Node?                   = nil
    public  internal(set) var nextSibling:     Node?                   = nil
    public  internal(set) var previousSibling: Node?                   = nil

    private               var _ownerDocument:  Document?               = nil
    private               var userData:        [String:UserData]       = [:]
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

    func set(qualifiedName: String, namespaceURI: String?) throws {
        throw DOMError.IllegalOperation(description: "Node cannot be renamed.")
    }

    func set(prefix: String?, localName: String, namespaceURI: String) throws {
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

    public func addChildNodeListener(listener: ChildNodeListener) { /* Only parents can have children. */ }

    public func removeChildNodeListener(listener: ChildNodeListener) { /* Only parents can have children. */ }

    func sendEvent(event: DocumentNodeEvent, source: Node, destination: Node?) {
        for ud in userData {
            if let h = ud.value.handler {
                h(event, ud.key, ud.value.data, source, destination)
            }
        }
    }

    public func getUserData(key: String) -> Any? {
        userData[key]?.data
    }

    @discardableResult public func setUserData(key: String, data: Any?, handler: UserDataHandler? = nil) -> Any? {
        if let data = data {
            let o = userData.removeValue(forKey: key)?.data
            userData[key] = UserData(data: data, handler: handler)
            return o
        }
        else {
            return userData.removeValue(forKey: key)?.data
        }
    }

    private struct UserData {
        let data:    Any
        let handler: UserDataHandler?

        init(data: Any, handler: UserDataHandler?) {
            self.data = data
            self.handler = handler
        }
    }

}
