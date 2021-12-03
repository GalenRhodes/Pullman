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
    public  override var nodeType:       NodeType { .Document }
    public  override var nodeName:       String   { "#document" }
    public  override var ownerDocument:  Document { self }
    //@f:1

    public override init() {
        super.init()
    }

    public func renameNode(node: Node, nodeName: String) throws {
        try node.set(qualifiedName: nodeName, namespaceURI: nil)
    }

    public func renameNode(node: Node, prefix: String?, localName: String, namespaceURI: String) throws {
        try node.set(prefix: prefix, localName: localName, namespaceURI: namespaceURI)
    }
}
