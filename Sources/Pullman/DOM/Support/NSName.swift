/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: Document.swift
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

let _pfx1 = "xml"
let _uri1 = "http://www.w3.org/XML/1998/namespace"
let _pfx2 = "xmlns"
let _uri2 = "http://www.w3.org/2000/xmlns/"

public struct NSName: Hashable, Comparable {
    public private(set) var prefix:       String?
    public private(set) var localName:    String
    public private(set) var namespaceURI: String?

    /*===========================================================================================================================================================================*/
    /// The qualified name. If the name represents a `namespace aware` name then this is a concatenation of the prefix and
    /// the localName separated by a colon ":".
    ///
    public var qualifiedName: String { (((namespaceURI == nil) || (prefix == nil)) ? localName : "\(prefix!):\(localName)") }

    /*===========================================================================================================================================================================*/
    /// Creates a new NSName structure with the given qualifiedName and namespaceURI. If the namespaceURI is not `nil` and
    /// not an empty string ("") then this will be a `namespace aware` name and the qualifiedName is assumed to be a concatenation
    ///  of the prefix and the localName separated by a colon ":".
    ///
    /// - Parameters:
    ///   - qualifiedName: The qualified name.
    ///   - namespaceURI: The namespace URI or `nil` if this is not a `namespace aware` name.
    /// - Throws: If the qualifiedName is a malformed qualifiedName, or if the qualifiedName has a prefix and the namespaceURI
    ///           is `nil`, or if the qualifiedName has a prefix that is "xml" and the namespaceURI is different from
    ///           "http://www.w3.org/XML/1998/namespace", or if the qualifiedName or its prefix is "xmlns" and the namespaceURI
    ///           is different from "http://www.w3.org/2000/xmlns/", or if the namespaceURI is "http://www.w3.org/2000/xmlns/"
    ///           and neither the qualifiedName nor its prefix is "xmlns".
    ///
    public init(qualifiedName: String, namespaceURI: String?) throws {
        localName = ""
        try NSName.doSet(qualifiedName: qualifiedName, namespaceURI: namespaceURI) { p, l, u in
            self.prefix = p
            self.localName = l
            self.namespaceURI = u
        }
    }

    /*===========================================================================================================================================================================*/
    /// Set the prefix for this name.
    ///
    /// - Parameter prefix: The new prefix.
    /// - Throws: If the namespaceURI is not nil the new prefix is not `nil` and not empty, or if the prefix is "xml" and the
    ///           namespaceURI is different from "http://www.w3.org/XML/1998/namespace", or if the prefix or the resulting qualifiedName is
    ///           "xmlns" and the namespaceURI is different from "http://www.w3.org/2000/xmlns/", or if the namespaceURI is
    ///           "http://www.w3.org/2000/xmlns/" and neither the prefix nor the resulting qualified name is "xmlns".
    ///
    public mutating func set(prefix: String?) throws {
        try NSName.validate(prefix, localName, namespaceURI)
        self.prefix = prefix
    }

    /*===========================================================================================================================================================================*/
    /// Change the name.
    ///
    /// - Parameters:
    ///   - qualifiedName: The qualified name.
    ///   - namespaceURI: The namespace URI or `nil` if this is not a `namespace aware` name.
    /// - Throws: If the qualifiedName is a malformed qualifiedName, or if the qualifiedName has a prefix and the namespaceURI
    ///           is `nil`, or if the qualifiedName has a prefix that is "xml" and the namespaceURI is different from
    ///           "http://www.w3.org/XML/1998/namespace", or if the qualifiedName or its prefix is "xmlns" and the namespaceURI
    ///           is different from "http://www.w3.org/2000/xmlns/", or if the namespaceURI is "http://www.w3.org/2000/xmlns/"
    ///           and neither the qualifiedName nor its prefix is "xmlns".
    ///
    public mutating func set(qualifiedName: String, namespaceURI: String?) throws {
        try NSName.doSet(qualifiedName: qualifiedName, namespaceURI: namespaceURI) {
            self.prefix = $0
            self.localName = $1
            self.namespaceURI = $2
        }
    }

    /*===========================================================================================================================================================================*/
    /// Calculate the hash of this structure.
    ///
    /// - Parameter hasher: The hasher.
    ///
    public func hash(into hasher: inout Hasher) {
        hasher.combine(prefix ?? "")
        hasher.combine(localName)
        hasher.combine(namespaceURI ?? "")
    }

    /*===========================================================================================================================================================================*/
    /// Test to see if one NSName is the same as another NSName.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand NSName.
    ///   - rhs: The right-hand NSName.
    /// - Returns: true if the prefix, localName, and namespaceURI of both the left-hand NSName and the right-hand NSName are the same.
    ///
    public static func == (lhs: NSName, rhs: NSName) -> Bool {
        ((lhs.prefix == rhs.prefix) && (lhs ~= rhs))
    }

    /*===========================================================================================================================================================================*/
    /// Test to see if one NSName is the same as another NSName. This comparison only looks at the localName and the
    /// namespaceURI because in terms of XML that is what makes two names the same. The prefix is simply cosmetic.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand NSName.
    ///   - rhs: The right-hand NSName.
    /// - Returns: true if the localName, and namespaceURI of both the left-hand NSName and the right-hand NSName are the same.
    ///
    public static func ~= (lhs: NSName, rhs: NSName) -> Bool {
        ((lhs.localName == rhs.localName) && (lhs.namespaceURI == rhs.namespaceURI))
    }

    /*===========================================================================================================================================================================*/
    /// Test to see if this NSName comes before another NSName in ordering.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand NSName.
    ///   - rhs: The right-hand NSName.
    /// - Returns: true if the left-hand NSName should be ordered before the right-hand NSName.
    ///
    public static func < (lhs: NSName, rhs: NSName) -> Bool {
        ((lhs.namespaceURI < rhs.namespaceURI) ||
         ((lhs.namespaceURI == rhs.namespaceURI) && (lhs.localName < rhs.localName)) ||
         ((lhs.namespaceURI == rhs.namespaceURI) && (lhs.localName == rhs.localName) && (lhs.prefix < rhs.prefix)))
    }

    /*===========================================================================================================================================================================*/
    /// The signature of the closure that sets the fields.
    ///
    typealias Setter = (String?, String, String?) throws -> Void

    /*===========================================================================================================================================================================*/
    /// Validate and then set the prefix, localName, and namespaceURI.
    ///
    /// - Parameters:
    ///   - qualifiedName: The qualified name.
    ///   - namespaceURI: The namespaceURI or nil if this name is not`"namespace aware"`.
    ///   - setter: The closure that actually sets the fields.
    /// - Throws: If the qualifiedName is a malformed qualifiedName, or if the qualifiedName has a prefix and the namespaceURI
    ///           is `nil`, or if the qualifiedName has a prefix that is "xml" and the namespaceURI is different from
    ///           "http://www.w3.org/XML/1998/namespace", or if the qualifiedName or its prefix is "xmlns" and the namespaceURI
    ///           is different from "http://www.w3.org/2000/xmlns/", or if the namespaceURI is "http://www.w3.org/2000/xmlns/"
    ///           and neither the qualifiedName nor its prefix is "xmlns".
    ///
    private static func doSet(qualifiedName: String, namespaceURI: String?, _ setter: Setter) throws -> Void {
        if let uri = namespaceURI?.trimmed, uri.isNotEmpty {
            if let i = qualifiedName.firstIndex(of: ":"), i > qualifiedName.startIndex {
                try validate(String(qualifiedName[..<i]), String(qualifiedName[qualifiedName.index(after: i)...]), uri)
                try setter(String(qualifiedName[..<i]), String(qualifiedName[qualifiedName.index(after: i)...]), uri)
            }
            else {
                try validate(nil, qualifiedName, uri)
                try setter(nil, qualifiedName, uri)
            }
        }
        else {
            try validate(nil, qualifiedName, nil)
            try setter(nil, qualifiedName, nil)
        }
    }

    /*===========================================================================================================================================================================*/
    /// Validate the prefix, localName, and namespaceURI.
    ///
    /// - Parameters:
    ///   - prefix: The prefix.
    ///   - localName: The localName.
    ///   - namespaceURI: The namespaceURI.
    /// - Throws: If either the prefix or localName contain invalid characters, or if the localName is empty `("")`, or
    ///           if the prefix is not `nil` and the namespaceURI is `nil`, or if the prefix is "xml" and the namespaceURI is different from
    ///           "http://www.w3.org/XML/1998/namespace", or if the prefix is "xmlns" and the namespaceURI
    ///           is different from "http://www.w3.org/2000/xmlns/", or if the namespaceURI is "http://www.w3.org/2000/xmlns/"
    ///           and neither the qualifiedName nor its prefix is "xmlns".
    ///
    private static func validate(_ prefix: String?, _ localName: String, _ namespaceURI: String?) throws {
        if let uri = namespaceURI {
            guard localName.isNotEmpty else { throw DOMError.InvalidNameError(description: "The local name cannot be empty.") }
            guard Pullman.validate(uri: uri) else { throw DOMError.InvalidNameError(description: "Invalid character in the namespace URI: \"\(uri)\"") }
            guard Pullman.validate(name: localName) else { throw DOMError.InvalidNameError(description: "Invalid character in the local name: \"\(localName)\"") }

            if let pfx = prefix {
                guard Pullman.validate(prefix: pfx) else { throw DOMError.InvalidNameError(description: "Invalid character in the prefix: \"\(pfx)\"") }
                guard !((pfx == _pfx1 && uri != _uri1) || (pfx == _pfx2 && uri != _uri2) || (pfx != _pfx2 && uri == _uri2)) else { throw domError("prefix", pfx, uri) }
            }
            else {
                guard !((localName == _pfx1 && uri != _uri1) || (localName == _pfx2 && uri != _uri2) || (localName != _pfx2 && uri == _uri2)) else { throw domError("qualifiedName", localName, uri) }
            }
        }
        else if let pfx = prefix {
            throw DOMError.NamespaceError(description: "Missing namespace URI. Prefix: \"\(pfx)\"")
        }
        else if !Pullman.validate(name: localName) {
            throw DOMError.InvalidNameError(description: "Invalid character in qualified name: \"\(localName)\"")
        }
    }

    /*===========================================================================================================================================================================*/
    /// Create the namespace error.
    ///
    /// - Parameters:
    ///   - desc: The name of the field in error.
    ///   - name: The value of the field.
    ///   - uri: The namespaceURI.
    /// - Returns: The error to be thrown.
    ///
    private static func domError(_ desc: String, _ name: String, _ uri: String) -> DOMError {
        DOMError.NamespaceError(description: "Invalid \(desc), namespace URI combination: \(desc)=\"\(name)\"; namespace URI=\"\(uri)\"")
    }
}
