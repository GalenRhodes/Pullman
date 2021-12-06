/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: Element.swift
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

public class Element: ParentNode {
    //@f:0
    public override var nodeType:     NodeType                { .Element }
    public override var textContent:  String                  { get { super.textContent } set { setTextContent(content: newValue) } }
    public override var localName:    String                  { nsName.localName }
    public override var nodeName:     String                  { nsName.qualifiedName }
    public override var prefix:       String?                 { nsName.prefix }
    public override var namespaceURI: String?                 { nsName.namespaceURI }
    public override var attributes:   NamedNodeMap<Attribute> { SlaveNamedNodeMap<Attribute>(master: _attributes) }

    public          var tagName:      String                  { nsName.qualifiedName }

    private         var nsName:       NSName
    private         let _attributes:  MasterNamedNodeMap<Attribute> = MasterNamedNodeMap<Attribute>()
    //@f:1

    init(ownerDocument: Document, tagName: String, namespaceURI: String?) throws {
        nsName = try NSName(qualifiedName: tagName, namespaceURI: namespaceURI)
        super.init(ownerDocument: ownerDocument)
    }

    private func setTextContent(content: String) {
        removeAllNodes()
        _ = try? appendNode(TextNode(ownerDocument: ownerDocument, content: content))
    }

    override func set(qualifiedName: String, namespaceURI: String?) throws { try nsName.set(qualifiedName: qualifiedName, namespaceURI: namespaceURI) }

    override func set(prefix: String?) throws { try nsName.set(prefix: prefix) }

    public override func lookupPrefix(namespaceURI: String) -> String? {
        if let p = prefix, self.namespaceURI == namespaceURI { return p }
        for attr in _attributes { if attr.prefix == "xmlns" && attr.value == namespaceURI { return attr.localName } }
        return (parentNode as? Element)?.lookupPrefix(namespaceURI: namespaceURI)
    }

    public override func lookupNamespaceURI(prefix: String) -> String? { _lookupNamespaceURI(prefix: prefix) ?? _lookupDefaultNamespaceURI() }

    func _lookupNamespaceURI(prefix: String) -> String? {
        if let u = namespaceURI, self.prefix == prefix { return u }
        for attr in _attributes { if attr.prefix == "xmlns" && attr.localName == prefix { return attr.value } }
        return (parentNode as? Element)?._lookupNamespaceURI(prefix: prefix)
    }

    func _lookupDefaultNamespaceURI() -> String? {
        for attr in _attributes { if attr.prefix == nil && attr.localName == "xmlns" { return attr.value } }
        return (parentNode as? Element)?._lookupDefaultNamespaceURI()
    }
}

extension Element {
    private func addAttr(_ qName: String, _ uri: String?, _ value: String) throws {
        setAttribute(try Attribute(ownerDocument: ownerDocument, ownerElement: self, qualifiedName: qName, namespaceURI: uri, value: value, isSpecified: false, isID: false))
    }

    public func setAttribute(qualifiedName qName: String, namespaceURI uri: String?, value: String) throws {
        if let _uri = uri {
            if let a = _attributes.nodeWith(qualifiedName: qName, namespaceURI: _uri) {
                let prefix = NSName.split(qualifiedName: qName).prefix
                if a.prefix != prefix { try a.set(prefix: prefix) }
                a.value = value
            }
            else {
                try addAttr(qName, _uri, value)
            }
        }
        else if let a = _attributes[qName] {
            a.value = value
        }
        else {
            try addAttr(qName, nil, value)
        }
    }

    @inlinable public func setAttribute(name: String, value: String) throws { try setAttribute(qualifiedName: name, namespaceURI: nil, value: value) }

    @discardableResult public func setAttribute(_ attr: Attribute) -> Attribute? { _attributes.add(node: attr) }

    public func getAttribute(qualifiedName qName: String, namespaceURI uri: String?) -> Attribute? { _attributes.nodeWith(qualifiedName: qName, namespaceURI: uri) }

    @inlinable public func getAttribute(name: String) -> Attribute? { getAttribute(qualifiedName: name, namespaceURI: nil) }

    @inlinable public func getAttributeValue(qualifiedName qName: String, namespaceURI: String?) -> String? { getAttribute(qualifiedName: qName, namespaceURI: namespaceURI)?.value }

    @inlinable public func getAttributeValue(name: String) -> String? { getAttribute(qualifiedName: name, namespaceURI: nil)?.value }

    @inlinable public func hasAttribute(qualifiedName qName: String, namespaceURI: String?) -> Bool { getAttribute(qualifiedName: qName, namespaceURI: namespaceURI) != nil }

    @inlinable public func hasAttribute(name: String) -> Bool { getAttribute(qualifiedName: name, namespaceURI: nil) != nil }
}
