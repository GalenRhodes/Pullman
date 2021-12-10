/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: Attribute.swift
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

public class Attribute: Node {
    //@f:0
    public override      var nodeType:     NodeType { .Attribute }
    public override      var nodeValue:    String?  { get { value } set { value = (newValue ?? "") } }
    public override      var textContent:  String   { get { value } set { value = newValue } }
    public override      var nodeName:     String   { nsName.qualifiedName }
    public override      var localName:    String   { nsName.localName }
    public override      var prefix:       String?  { nsName.prefix }
    public override      var namespaceURI: String?  { nsName.namespaceURI }

    public               var name:         String   { nsName.qualifiedName }
    public               var value:        String
    public               var isSpecified:  Bool
    public internal(set) var isID:         Bool
    public internal(set) var ownerElement: Element? = nil

    private              var nsName:       NSName
    //@f:1

    init(ownerDocument: Document, qualifiedName: String, namespaceURI: String?, value: String, isSpecified: Bool, isID: Bool) throws {
        self.nsName = try NSName(qualifiedName: qualifiedName, namespaceURI: namespaceURI)
        self.value = value
        self.isSpecified = isSpecified
        self.isID = isID
        super.init(ownerDocument: ownerDocument)
    }

    override func set(qualifiedName: String, namespaceURI: String?) throws { try nsName.set(qualifiedName: qualifiedName, namespaceURI: namespaceURI) }

    override public func set(prefix: String?) throws { try nsName.set(prefix: prefix) }

    public override func lookupPrefix(namespaceURI: String) -> String? {
        if let p = prefix, self.namespaceURI == namespaceURI { return p }
        return ownerElement?.lookupPrefix(namespaceURI: namespaceURI)
    }

    public override func lookupNamespaceURI(prefix: String) -> String? {
        if let u = namespaceURI, self.prefix == prefix { return u }
        return ownerElement?.lookupNamespaceURI(prefix: prefix)
    }
}

extension Document {

    public func createAttribute(ownerElement: Element? = nil, qualifiedName: String, namespaceURI: String? = nil, value: String, isSpecified: Bool = false, isID: Bool = false) throws -> Attribute {
        let attr = try Attribute(ownerDocument: self, qualifiedName: qualifiedName, namespaceURI: namespaceURI, value: value, isSpecified: isSpecified, isID: isID)
        if let elem = ownerElement { try elem.setAttribute(attr) }
        return attr
    }
}
