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

extension CharacterSet {

    public static let xmlPrefixStartChar: CharacterSet = { () -> CharacterSet in
        var cs = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_")
        cs.insert(charactersIn: UnicodeScalar(UInt8(0xC0)) ... UnicodeScalar(UInt8(0xD6)))
        cs.insert(charactersIn: UnicodeScalar(UInt8(0xD8)) ... UnicodeScalar(UInt8(0xF6)))
        cs.insert(charactersIn: UnicodeScalar(UInt8(0xF8)) ... UnicodeScalar(UInt32(0x2FF))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x370))! ... UnicodeScalar(UInt32(0x37D))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x37F))! ... UnicodeScalar(UInt32(0x1FFF))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x200C))! ... UnicodeScalar(UInt32(0x200D))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x2070))! ... UnicodeScalar(UInt32(0x218F))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x2C00))! ... UnicodeScalar(UInt32(0x2FEF))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x3001))! ... UnicodeScalar(UInt32(0xD7FF))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0xF900))! ... UnicodeScalar(UInt32(0xFDCF))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0xFDF0))! ... UnicodeScalar(UInt32(0xFFFD))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x10000))! ... UnicodeScalar(UInt32(0xEFFFF))!)
        return cs
    }()

    public static let xmlPrefixChars: CharacterSet = { () -> CharacterSet in
        var cs = xmlPrefixStartChar.union(CharacterSet(charactersIn: "0123456789-."))
        cs.insert(UnicodeScalar(UInt8(0xB7)))
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x300))! ... UnicodeScalar(UInt32(0x36F))!)
        cs.insert(charactersIn: UnicodeScalar(UInt32(0x203F))! ... UnicodeScalar(UInt32(0x2040))!)
        return cs
    }()

    public static let xmlNameStartChar: CharacterSet = xmlPrefixStartChar

    public static let xmlNameChars: CharacterSet = { () -> CharacterSet in xmlPrefixChars.union(CharacterSet(charactersIn: ":")) }()

    public static let xmlWSChars: CharacterSet = { () -> CharacterSet in [ UnicodeScalar(UInt8(0x20)), UnicodeScalar(UInt8(0x09)), UnicodeScalar(UInt8(0x0D)), UnicodeScalar(UInt8(0x0A)) ] }()
}
