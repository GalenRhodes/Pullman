/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: DTDLocated.swift
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

public class DTDLocated: DTDType {
    public enum Location: String { case PUBLIC, SYSTEM }

    public let location: Location?
    public let publicID: String?
    public let systemID: String?

    public init(ownerDocument: Document, qualifiedName: String, namespaceURI: String?, location: Location?, publicID: String?, systemID: String?) throws {
        self.location = location
        self.publicID = publicID
        self.systemID = systemID
        try super.init(ownerDocument: ownerDocument, qualifiedName: qualifiedName, namespaceURI: namespaceURI)
    }
}
