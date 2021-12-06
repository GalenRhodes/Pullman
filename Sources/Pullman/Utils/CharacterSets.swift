/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: CharacterSets.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 12/3/21
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

@usableFromInline func sc(_ value: Int) -> Unicode.Scalar {
    let _value = UInt32(bitPattern: Int32(truncatingIfNeeded: value))
    return Unicode.Scalar(_value)!
}

extension CharacterSet {

    @inlinable public init(char: Character) { self.init(charactersIn: String(char)) }

    @inlinable public init(ranges: ClosedRange<Int>...) {
        self.init(ranges: ranges)
    }

    @inlinable public init(ranges: [ClosedRange<Int>]) {
        self.init()
        for range in ranges { insert(charactersIn: sc(range.lowerBound) ... sc(range.upperBound)) }
    }

    @inlinable public func union(_ ranges: ClosedRange<Int>...) -> CharacterSet { self.union(CharacterSet(ranges: ranges)) }

    public static let xmlPrefixStartChar: CharacterSet = CharacterSet(char: "_").union(0x41 ... 0x5A,
                                                                                       0x61 ... 0x7A,
                                                                                       0xC0 ... 0xD6,
                                                                                       0xD8 ... 0xF6,
                                                                                       0xF8 ... 0x2FF,
                                                                                       0x370 ... 0x37D,
                                                                                       0x37F ... 0x1FFF,
                                                                                       0x200C ... 0x200D,
                                                                                       0x2070 ... 0x218F,
                                                                                       0x2C00 ... 0x2FEF,
                                                                                       0x3001 ... 0xD7FF,
                                                                                       0xF900 ... 0xFDCF,
                                                                                       0xFDF0 ... 0xFFFD,
                                                                                       0x10000 ... 0xEFFFF)

    public static let xmlPrefixChars: CharacterSet = { () -> CharacterSet in
        var cs = xmlPrefixStartChar.union(CharacterSet(charactersIn: "0123456789-."))
        cs.insert(charactersIn: sc(0x300) ... sc(0x36F))
        cs.formUnion([ sc(0xB7), sc(0x203F), sc(0x2040) ] as CharacterSet)
        return cs
    }()

    public static let xmlNameStartChar: CharacterSet = xmlPrefixStartChar.union(CharacterSet(charactersIn: ":"))

    public static let xmlNameChars: CharacterSet = xmlPrefixChars.union(CharacterSet(charactersIn: ":"))

    public static let xmlWSChars: CharacterSet = [ sc(0x20), sc(0x09), sc(0x0D), sc(0x0A) ]
}
