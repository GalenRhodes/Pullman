/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: NamedNodeMap.swift
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

public class NamedNodeMap<T: Node>: BidirectionalCollection {
    public typealias Index = Int
    public typealias Element = (String, T)

    public private(set) var startIndex: Int = 0
    public private(set) var endIndex:   Int = 0

    init() {}

    public func index(after i: Int) -> Int {
        guard i < endIndex else { fatalError("Index out of bounds.") }
        return i + 1
    }

    public func index(before i: Int) -> Int {
        guard i > startIndex else { fatalError("Index out of bounds.") }
        return i - 1
    }

    public subscript(position: Int) -> (String, T) { fatalError("Index out of bounds.") }

    public subscript(key: String) -> T? { nil }

    public subscript(key: String, uri: String) -> T? { nil }
}
