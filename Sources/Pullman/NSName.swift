/*****************************************************************************************************************************//**
 *     PROJECT: Pullman
 *    FILENAME: NSName.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: November 26, 2021
 *
  * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided
 * that the above copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
 * NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *//*****************************************************************************************************************************/

import Foundation
import CoreFoundation
import Rubicon

let _pfx1 = "xml"
let _uri1 = "http://www.w3.org/XML/1998/namespace"
let _pfx2 = "xmlns"
let _uri2 = "http://www.w3.org/2000/xmlns/"

public struct NSName: Hashable {
    public private(set) var prefix:       String?
    public private(set) var localName:    String
    public private(set) var namespaceURI: String?

    public var name: String { (((namespaceURI == nil) || (prefix == nil)) ? localName : "\(prefix!):\(localName)") }

    public init(prefix: String?, localName: String, namespaceURI: String?) throws {
        if let uri = namespaceURI?.trimmed, uri.isNotEmpty {
            self.namespaceURI = uri
            self.prefix = ((prefix ?? "").isEmpty ? nil : prefix)
            self.localName = localName
        }
        else if let p = prefix {
            self.localName = "\(p):\(localName)"
        }
        else {
            self.localName = localName
        }
        try _validate(self.prefix, self.localName, self.namespaceURI)
    }

    public init(name: String) throws { try self.init(prefix: nil, localName: name, namespaceURI: nil) }

    public init(qualifiedName: String, namespaceURI: String) throws {
        if let i = qualifiedName.firstIndex(of: ":") {
            try self.init(prefix: String(qualifiedName[..<i]), localName: String(qualifiedName[i...]), namespaceURI: namespaceURI)
        }
        else {
            try self.init(prefix: nil, localName: qualifiedName, namespaceURI: namespaceURI)
        }
    }

    public mutating func rename(name: String) throws {
        try rename(prefix: nil, localName: name, namespaceURI: nil)
    }

    public mutating func rename(prefix: String?) throws {
        try rename(prefix: prefix, localName: localName, namespaceURI: namespaceURI)
    }

    public mutating func rename(qualifiedName: String, namespaceURI: String?) throws {
        if let i = qualifiedName.firstIndex(of: ":") {
            try rename(prefix: String(qualifiedName[..<i]), localName: String(qualifiedName[i...]), namespaceURI: namespaceURI)
        }
        else {
            try rename(prefix: nil, localName: qualifiedName, namespaceURI: namespaceURI)
        }
    }

    public mutating func rename(prefix: String?, localName: String, namespaceURI: String?) throws {
        let p = self.prefix
        let l = self.localName
        let u = self.namespaceURI

        

        try _validate(p, l, u)
    }

    mutating func _validate(_ p: String?, _ l: String, _ u: String?) throws {
        do {
            if let uri = namespaceURI {
                guard validate(name: localName) else { throw DOMError.InvalidNameError(description: "Invalid character in name.") }

                if let pfx = prefix {
                    guard validate(prefix: pfx) else { throw DOMError.InvalidNameError(description: "Invalid character in prefix.") }

                    if pfx == _pfx1 && uri != _uri1 { throw domError1(pfx: pfx, uri: uri) }
                    if pfx == _pfx2 && uri != _uri2 { throw domError1(pfx: pfx, uri: uri) }
                    if uri == _uri2 && pfx != _pfx2 { throw domError1(pfx: pfx, uri: uri) }
                }
                else {
                    if localName == _pfx1 && uri != _uri1 { throw domError2(qName: localName, uri: uri) }
                    if localName == _pfx2 && uri != _uri2 { throw domError2(qName: localName, uri: uri) }
                    if uri == _uri2 && localName != _pfx2 { throw domError2(qName: localName, uri: uri) }
                }
            }
            else {
                guard prefix == nil else { throw DOMError.NamespaceError(description: "Missing namespace URI.") }
                guard validate(name: localName) else { throw DOMError.InvalidNameError(description: "Invalid character in name.") }
            }
        }
        catch {
            prefix = p
            localName = l
            namespaceURI = u
            throw error
        }
    }

    private func domError1(pfx: String, uri: String) -> DOMError {
        DOMError.NamespaceError(description: "Invalid prefix, namespace URI combination: prefix=\"\(pfx)\"; namespace URI=\"\(uri)\"")
    }

    private func domError2(qName: String, uri: String) -> DOMError {
        DOMError.NamespaceError(description: "Invalid qualified name, namespace URI combination: qualified name=\"\(qName)\"; namespace URI=\"\(uri)\"")
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(prefix)
        hasher.combine(localName)
        hasher.combine(namespaceURI)
    }

    public static func == (lhs: NSName, rhs: NSName) -> Bool {
        ((lhs.prefix == rhs.prefix) && (lhs.localName == rhs.localName) && (lhs.namespaceURI == rhs.namespaceURI))
    }
}
