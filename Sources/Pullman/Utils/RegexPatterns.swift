/*===============================================================================================================================================================================*
 *     PROJECT: Pullman
 *    FILENAME: Utilities.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 11/27/21
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

// Bad XML Characters for any use...
private let RX_X = #"""
                   \x7F-\x84\x86-\x9F\uFDD0-\uFDEF\U0001FFFE-\U0001FFFF\U0002FFFE-\U0002FFFF\U0003FFFE-\U0003FFFF\U0004FFFE-\U0004FFFF\U0005FFFE-\U0005FFFF\U0006FFFE-\U0006FFFF\U0007FFFE-\U0007FFFF\U0008FFFE-\U0008FFFF\U0009FFFE-\U0009FFFF\U000AFFFE-\U000AFFFF\U000BFFFE-\U000BFFFF\U000CFFFE-\U000CFFFF\U000DFFFE-\U000DFFFF\U000EFFFE-\U000EFFFF\U000FFFFE-\U000FFFFF\U0010FFFE-\U0010FFFF
                   """#

private let RX_A: String = #"a-zA-Z_\xC0-\xD6\xD8-\xF6\xF8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\U00010000-\U000EFFFF"#
private let RX_B: String = #"0-9\x2E\xB7\u0300-\u036F\u203F-\u2040\x2D"#

public let RX_WS:     String = "[\\x20\\x09\\x0D\\x0A]"
public let RX_Name:   String = "[\\x3A\(RX_A)](?:[\\x3A\(RX_A)\(RX_B)])*"
public let RX_Prefix: String = "[\(RX_A)](?:[\(RX_A)\(RX_B)])*"

/// The Namespace URI can contain any character except for the ones in the "BAD" list.
///
/// - Parameter uri: The URI to test.
/// - Returns: true if the URI is valid. false if the URI contains characters from the "BAD" list.
///
func validate(uri: String) -> Bool { (getRX(pattern: "[\(RX_X)]").firstMatch(in: uri) == nil) }

func validate(name: String) -> Bool { testName(pattern: RX_Name, name: name) }

func validate(prefix: String) -> Bool { testName(pattern: RX_Prefix, name: prefix) }

@inlinable func testName(pattern: String, name: String) -> Bool { testString(pattern: "^\(pattern)$", string: name) }
