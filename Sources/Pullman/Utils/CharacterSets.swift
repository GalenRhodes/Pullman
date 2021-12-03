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

    public static let xmlBadChars: CharacterSet = { () -> CharacterSet in
        var cs = CharacterSet(charactersIn: UnicodeScalar(UInt8(0x7F)) ... UnicodeScalar(UInt8(0x84)))
        //@f:0
        cs.insert(charactersIn: UnicodeScalar(UInt8(0x86))     ... UnicodeScalar(UInt8(0x9F)))
        cs.insert(charactersIn: UnicodeScalar(UInt32(0xFDD0))! ... UnicodeScalar(UInt32(0xFDEF))!)
        cs.formUnion([ UnicodeScalar(UInt32(0x1FFFE))!, UnicodeScalar(UInt32(0x1FFFF))!, UnicodeScalar(UInt32(0x2FFFE))!, UnicodeScalar(UInt32(0x2FFFF))!, UnicodeScalar(UInt32(0x3FFFE))!,
                       UnicodeScalar(UInt32(0x3FFFF))!, UnicodeScalar(UInt32(0x4FFFE))!, UnicodeScalar(UInt32(0x4FFFF))!, UnicodeScalar(UInt32(0x5FFFE))!, UnicodeScalar(UInt32(0x5FFFF))!,
                       UnicodeScalar(UInt32(0x6FFFE))!, UnicodeScalar(UInt32(0x6FFFF))!, UnicodeScalar(UInt32(0x7FFFE))!, UnicodeScalar(UInt32(0x7FFFF))!, UnicodeScalar(UInt32(0x8FFFE))!,
                       UnicodeScalar(UInt32(0x8FFFF))!, UnicodeScalar(UInt32(0x9FFFE))!, UnicodeScalar(UInt32(0x9FFFF))!, UnicodeScalar(UInt32(0xAFFFE))!, UnicodeScalar(UInt32(0xAFFFF))!,
                       UnicodeScalar(UInt32(0xBFFFE))!, UnicodeScalar(UInt32(0xBFFFF))!, UnicodeScalar(UInt32(0xCFFFE))!, UnicodeScalar(UInt32(0xCFFFF))!, UnicodeScalar(UInt32(0xDFFFE))!,
                       UnicodeScalar(UInt32(0xDFFFF))!, UnicodeScalar(UInt32(0xEFFFE))!, UnicodeScalar(UInt32(0xEFFFF))!, UnicodeScalar(UInt32(0xFFFFE))!, UnicodeScalar(UInt32(0xFFFFF))!,
                       UnicodeScalar(UInt32(0x10FFFE))!, UnicodeScalar(UInt32(0x10FFFF))! ])
        //@f:1
        return cs
    }()
}
