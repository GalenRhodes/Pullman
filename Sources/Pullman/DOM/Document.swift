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

public class Document: ParentNode {
    //@f:0
    public  override     var nodeType:            NodeType { .Document }
    public  override     var nodeName:            String   { "#document" }
    public  override     var ownerDocument:       Document { self }

    public               var documentURI:         String?  = nil
    public internal(set) var inputEncoding:       String   = "UTF-8"
    public               var xmlEncoding:         String   = "UTF-8"
    public               var xmlStandalone:       Bool     = true
    public               var xmlVersion:          String   = "1.0"
    public               var strictErrorChecking: Bool     = false
    //@f:1

    public override init() {
        super.init()
    }

    public func renameNode(node: Node, qualifiedName: String, namespaceURI: String?) throws {
    }

    private var standardEntityCache: [String: EntityDecl] = [:]

    public func createEntityRef(qualifiedName: String, namespaceURI: String?) throws -> EntityRef? {
        if namespaceURI == nil {
            if let stdDecl = standardEntityCache[qualifiedName] {
                return try EntityRef(ownerDocument: self, qualifiedName: qualifiedName, namespaceURI: nil, entity: stdDecl)
            }
            if let std = EntityDecl.expandHTMLEntity(named: qualifiedName) {
                let stdDecl = try EntityDecl(ownerDocument: self, qualifiedName: qualifiedName, namespaceURI: nil, textContent: std, location: nil, publicID: nil, systemID: nil)
                standardEntityCache[qualifiedName] = stdDecl
                return try EntityRef(ownerDocument: self, qualifiedName: qualifiedName, namespaceURI: nil, entity: stdDecl)
            }
        }
        // TODO: Search for entity in the DOCTYPE.
        return nil
    }
}
