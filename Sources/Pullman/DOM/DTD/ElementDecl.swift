/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: ElementDecl.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/28/21
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

public class ElementDecl: DTDType {
    //@f:0
    public override      var nodeType:       NodeType        { .ElementDecl }
    public internal(set) var attributeDecls: [AttributeDecl] = []
    public internal(set) var contentType:    AllowedContent  = .Anything
    public internal(set) var content:        ContentList?    = nil
    //@f:1

    internal init(ownerDocument: Document, qualifiedName: String, namespaceURI: String?, contentType: AllowedContent) throws {
        self.contentType = contentType
        try super.init(ownerDocument: ownerDocument, qualifiedName: qualifiedName, namespaceURI: namespaceURI)
    }

    public func setContent(_ content: ContentList?) throws { self.content = try validateList(content) }

    func validateList(_ content: ContentList?) throws -> ContentList? {
        if let c = content {
            guard value(contentType, isOneOf: .Children, .Mixed) else { throw DOMError.ElementDeclError(description: "%s elements cannot have content definitions.".format(contentType)) }

            if c.content.isEmpty { throw DOMError.ElementDeclError(description: "Content list is empty.") }
            var idx = c.content.startIndex

            if c.content[idx].type == .CData {
                let cc = c.content.count

                if cc > 1 && c.multiplicity != .ZeroOrMore { throw DOMError.ElementDeclError(description: "A \"MIXED\" content list must have a multiplicity of \"Zero Or More\" - '*'.") }
                else if c.multiplicity != .Once { throw DOMError.ElementDeclError(description: "A list with only \"#PCDATA\" must have a multiplicity of \"Once\".") }
                guard c.listType == .Choice else { throw DOMError.ElementDeclError(description: "Content list type must be choice '|' rather than sequence ','.") }
                guard contentType == .Mixed else { throw DOMError.ElementDeclError(description: "Content type must be \"MIXED\" to have \"#PCDATA\".") }
                guard c.parentList == nil else { throw DOMError.ElementDeclError(description: "\"#PCDATA\" cannot be in a nested element content list.") }

                idx += 1
            }

            for i in (idx ..< c.content.endIndex) {
                if c.content[i] == .CData { throw DOMError.ElementDeclError(description: "\"#PCDATA\" must be the first item.") }
            }
        }

        return content
    }

    public override func insert(node newNode: Node, before refNode: Node?) throws -> Node { newNode }

    public override func addChildNodeListener(listener: ChildNodeListener) {}

    public override func removeChildNodeListener(listener: ChildNodeListener) {}

    public enum AllowedContent: String {
        case Empty    = "EMPTY"
        case Anything = "ANY"
        case Children = "()"
        case Mixed    = "(#PCDATA)"
    }

    public enum Multiplicity: String {
        case Once       = ""
        case Optional   = "?"
        case ZeroOrMore = "*"
        case OneOrMore  = "+"
    }

    public enum ListType: String {
        case Sequence = ","
        case Choice   = "|"
    }

    public class ContentBase: Hashable {

        enum CType { case List, Element, CData }

        public internal(set) var multiplicity: Multiplicity
        public internal(set) var parentList:   ContentList? = nil
        let type: CType

        init(type: CType, multiplicity: Multiplicity) {
            self.multiplicity = multiplicity
            self.type = type
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(multiplicity)
        }

        func isEqual(other: ContentBase) -> Bool { ((self === other) || ((type(of: self) == type(of: other)) && (multiplicity == other.multiplicity))) }

        public static func == (lhs: ContentBase, rhs: ContentBase) -> Bool {
            lhs.isEqual(other: rhs)
        }

        var xmlDeclString: String { "" }
    }

    public class ContentCData: ContentBase {
        override var xmlDeclString: String { "#PCDATA" }

        public init(multiplicity: Multiplicity) { super.init(type: .CData, multiplicity: multiplicity) }
    }

    public class ContentElem: ContentBase {
        public internal(set) var name: String
        override var xmlDeclString: String { "\(name)\(multiplicity.rawValue)" }

        public init(multiplicity: Multiplicity, name: String) {
            self.name = name
            super.init(type: .Element, multiplicity: multiplicity)
        }

        public override func hash(into hasher: inout Hasher) {
            super.hash(into: &hasher)
            hasher.combine(name)
        }

        override func isEqual<T>(other: T) -> Bool where T: ContentBase {
            (super.isEqual(other: other) && (name == (other as? ContentElem)?.name))
        }
    }

    public class ContentList: ContentBase {
        public internal(set) var listType: ListType
        public internal(set) var content:  [ContentBase] = []

        override var xmlDeclString: String { "(\(content.map({ $0.xmlDeclString }).joined(separator: listType.rawValue))\(multiplicity.rawValue)" }

        public init(multiplicity: Multiplicity, listType: ListType) {
            self.listType = listType
            super.init(type: .List, multiplicity: multiplicity)
        }

        override func isEqual<T>(other: T) -> Bool where T: ContentBase {
            guard super.isEqual(other: other) else { return false }
            guard let o = (other as? ContentList) else { return false }
            guard listType == o.listType && content.count == o.content.count else { return false }
            var eq: Bool = true
            syncIterate(c1: content, c2: o.content) { e1, e2, stop in if e1 != e2 { eq = false; stop = true } }
            return eq
        }

        public override func hash(into hasher: inout Hasher) {
            super.hash(into: &hasher)
            hasher.combine(listType)
            content.forEach { i in hasher.combine(i) }
        }
    }
}
