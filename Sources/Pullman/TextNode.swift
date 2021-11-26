/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: TextNode.swift
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

public class CharacterContent: Node {
    //@f:0
    public override var textContent: String  { get { content } set { content = newValue } }
    public override var nodeValue:   String? { get { content } set { content = newValue ?? "" } }
    public          var content:     String
    //@f:1

    init(ownerDocument: Document, content: String) {
        self.content = content
        super.init(ownerDocument: ownerDocument)
    }
}

public class TextNode: CharacterContent {
    public override var nodeType: NodeType { .Text }
    public override var nodeName: String { "#text" }

    @usableFromInline override init(ownerDocument: Document, content: String) { super.init(ownerDocument: ownerDocument, content: content) }
}

public class Comment: CharacterContent {
    public override var nodeType: NodeType { .Comment }
    public override var nodeName: String { "#comment" }

    @usableFromInline override init(ownerDocument: Document, content: String) { super.init(ownerDocument: ownerDocument, content: content) }
}

public class CDataSection: CharacterContent {
    public override var nodeType: NodeType { .CDataSection }
    public override var nodeName: String { "#cdata-section" }

    @usableFromInline override init(ownerDocument: Document, content: String) { super.init(ownerDocument: ownerDocument, content: content) }
}

extension Document {

    @inlinable public func createTextNode(content: String) -> TextNode { TextNode(ownerDocument: self, content: content) }

    @inlinable public func createCDataSection(content: String) -> CDataSection { CDataSection(ownerDocument: self, content: content) }

    @inlinable public func createComment(content: String) -> Comment { Comment(ownerDocument: self, content: content) }
}
