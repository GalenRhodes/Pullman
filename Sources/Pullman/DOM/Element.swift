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

    override public func set(prefix: String?) throws { try nsName.set(prefix: prefix) }

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

    @discardableResult public func setAttribute(_ attr: Attribute) throws -> Attribute? {
        guard attr.ownerElement == nil else { throw DOMError.IllegalOperation(description: "Attribute is already owned by another element.") }
        guard attr.ownerDocument === ownerDocument else { throw DOMError.WrongDocumentError(description: "Attribute belongs to a different document.") }
        attr.ownerElement = self
        let old = _attributes.add(node: attr)
        if let o = old { o.ownerElement = nil }
        return old
    }

    public func getAttribute(localName: String, namespaceURI uri: String?) -> Attribute? {
        ((uri == nil) ? _attributes[localName] : _attributes[localName, uri!])
    }

    public func removeAttribute(_ attr: Attribute) -> Attribute? {
        guard attr.ownerDocument === ownerDocument && attr.ownerElement === self else { return nil }
        _attributes.remove(node: attr)
        attr.ownerElement = nil
        return attr
    }
}

extension Element {
    @inlinable public func setAttribute(qualifiedName qName: String, namespaceURI uri: String?, value: String) throws -> Attribute? {
        if let u = uri {
            let n = NSName.split(qualifiedName: qName)
            if let a = getAttribute(localName: n.localName, namespaceURI: u) {
                a.value = value
                try a.set(prefix: a.prefix)
                return a
            }
        }
        else if let a = getAttribute(name: qName) {
            a.value = value
            return a
        }

        return try setAttribute(ownerDocument.createAttribute(qualifiedName: qName, namespaceURI: uri, value: value))
    }

    @inlinable public func setAttribute(name: String, value: String) throws -> Attribute? { try setAttribute(qualifiedName: name, namespaceURI: nil, value: value) }

    @inlinable public func getAttribute(name: String) -> Attribute? { getAttribute(localName: name, namespaceURI: nil) }

    @inlinable public func getAttributeValue(localName: String, namespaceURI: String?) -> String? { getAttribute(localName: localName, namespaceURI: namespaceURI)?.value }

    @inlinable public func getAttributeValue(name: String) -> String? { getAttribute(localName: name, namespaceURI: nil)?.value }

    @inlinable public func hasAttribute(localName: String, namespaceURI: String?) -> Bool { getAttribute(localName: localName, namespaceURI: namespaceURI) != nil }

    @inlinable public func hasAttribute(name: String) -> Bool { getAttribute(localName: name, namespaceURI: nil) != nil }

    @inlinable public func removeAttribute(localName: String, namespaceURI: String?) -> Attribute? {
        guard let attr = getAttribute(localName: localName, namespaceURI: namespaceURI) else { return nil }
        return removeAttribute(attr)
    }

    @inlinable public func removeAttribute(name: String) -> Attribute? { removeAttribute(localName: name, namespaceURI: nil) }
}

extension Document {
    public func createElement(qualifiedName: String, namespaceURI: String?) throws -> Element {
        try Element(ownerDocument: self, tagName: qualifiedName, namespaceURI: namespaceURI)
    }
}
