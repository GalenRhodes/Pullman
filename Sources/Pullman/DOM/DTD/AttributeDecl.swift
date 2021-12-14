/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: AttributeDecl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 12/10/21
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

let ERR_MSG_001 = "Default value must be provided if attribute is niether \"#REQUIRED\" nor \"#IMPLIED\"."

public class AttributeDecl: DTDType {
    public override var      nodeType:      NodeType { .AttributeDecl }
    public internal(set) var element:       ElementDecl
    public internal(set) var attributeType: AttributeType
    public internal(set) var defaultType:   DefaultType
    public internal(set) var defaultValue:  String?
    public internal(set) var enumValues:    [String]?

    internal init(ownerDocument: Document,
                  qualifiedName: String,
                  namespaceURI: String?,
                  element: ElementDecl,
                  attributeType: AttributeType = .CData,
                  defaultType: DefaultType = .Implied,
                  defaultValue: String? = nil,
                  enumValues: [String]? = nil) throws {
        self.element = element
        self.attributeType = attributeType
        self.defaultType = defaultType
        self.defaultValue = defaultValue
        self.enumValues = enumValues
        guard (!value(defaultType, isOneOf: .Defaulted, .Fixed)) || defaultValue != nil else { throw DOMError.AttributeDeclError(description: ERR_MSG_001) }
        try super.init(ownerDocument: ownerDocument, qualifiedName: qualifiedName, namespaceURI: namespaceURI)
    }

    public override func insert(node newNode: Node, before refNode: Node?) throws -> Node { newNode }

    public override func addChildNodeListener(listener: ChildNodeListener) {}

    public override func removeChildNodeListener(listener: ChildNodeListener) {}

    public enum AttributeType: String {
        case CData      = "CDATA"
        case ID         = "ID"
        case IDRef      = "IDREF"
        case IDRefs     = "IDREFS"
        case Entity     = "ENTITY"
        case Entities   = "ENTITIES"
        case NMToken    = "NMTOKEN"
        case NMTokens   = "NMTOKENS"
        case Notation   = "NOTATION"
        case Enumerated = "(|)"
    }

    public enum DefaultType: String {
        case Required  = "#REQUIRED"
        case Implied   = "#IMPLIED"
        case Fixed     = "#FIXED"
        case Defaulted = ""
    }
}
