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
    private         let _attributes:  NamedNodeMap<Attribute> = MasterNamedNodeMap<Attribute>()
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
}
