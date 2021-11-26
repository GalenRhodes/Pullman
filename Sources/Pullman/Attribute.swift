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

    public               var name:         String   { nodeName }
    public               var value:        String
    public               var isSpecified:  Bool
    public               var isID:         Bool
    public internal(set) var ownerElement: Element? = nil
    //@f:1

    init(ownerDocument: Document, ownerElement: Element? = nil, name: String, value: String, isSpecified: Bool, isID: Bool) throws {
        self.value = value
        self.isSpecified = isSpecified
        self.isID = isID
        self.ownerElement = ownerElement
        super.init(ownerDocument: ownerDocument)
        localName = name
        prefix = nil
        namespaceURI = nil
    }

    init(ownerDocument: Document, ownerElement: Element? = nil, prefix: String?, localName: String, namespaceURI: String, value: String, isSpecified: Bool, isID: Bool) throws {
        self.value = value
        self.isSpecified = isSpecified
        self.isID = isID
        self.ownerElement = ownerElement
        super.init(ownerDocument: ownerDocument)
        self.localName = localName
        self.prefix = prefix
        self.namespaceURI = namespaceURI
    }
}

extension Document {

    public func createAttribute(ownerElement: Element? = nil, prefix: String?, localName: String, namespaceURI: String, value: String, isSpecified: Bool = false, isID: Bool = false) throws -> Attribute {
        try Attribute(ownerDocument: self, ownerElement: ownerElement, prefix: prefix, localName: localName, namespaceURI: namespaceURI, value: value, isSpecified: isSpecified, isID: isID)
    }

    public func createAttribute(ownerElement: Element? = nil, name: String, value: String, isSpecified: Bool = false, isID: Bool = false) throws -> Attribute {
        try Attribute(ownerDocument: self, name: name, value: value, isSpecified: isSpecified, isID: isID)
    }
}
