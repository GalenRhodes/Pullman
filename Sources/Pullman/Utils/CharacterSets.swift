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
//@f:0
    public static let xmlPrefixStartChar: CharacterSet = CharacterSet(codePoints: 0x5F).union(codePointRanges: 0x41 ... 0x5A, 0x61 ... 0x7A, 0xC0 ... 0xD6, 0xD8 ... 0xF6, 0xF8 ... 0x2FF, 0x370 ... 0x37D, 0x37F ... 0x1FFF, 0x200C ... 0x200D, 0x2070 ... 0x218F, 0x2C00 ... 0x2FEF, 0x3001 ... 0xD7FF, 0xF900 ... 0xFDCF, 0xFDF0 ... 0xFFFD, 0x10000 ... 0xEFFFF)
    public static let xmlPrefixChars:     CharacterSet = xmlPrefixStartChar.union(codePoints: 0x2D, 0x2E, 0xB7, 0x203F, 0x2040).union(codePointRanges: 0x30 ... 0x39, 0x300 ... 0x36F)
    public static let xmlNameStartChar:   CharacterSet = xmlPrefixStartChar.union(codePoints: 0x3A)
    public static let xmlNameChars:       CharacterSet = xmlPrefixChars.union(codePoints: 0x3A)
    public static let xmlWSChars:         CharacterSet = CharacterSet(codePoints: 0x20, 0x09, 0x0D, 0x0A)
//@f:1
}
