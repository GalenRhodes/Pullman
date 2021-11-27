/*****************************************************************************************************************************//**
 *     PROJECT: Pullman
 *    FILENAME: RegexPatterns.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: November 26, 2021
 *
  * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided
 * that the above copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
 * NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *//*****************************************************************************************************************************/

import Foundation
import CoreFoundation
import Rubicon

private let RX_A: String = #"a-zA-Z_\xC0-\xD6\xD8-\xF6\xF8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\U00010000-\U000EFFFF"#
private let RX_B: String = #"0-9\x2E\xB7\u0300-\u036F\u203F-\u2040\x2D"#
private let RX_C: String = #"\x3A"# // Colon ':'
private let RX_D: String = #"\x20\x09\x0D\x0A"#

public let RX_WS:     String = "[\(RX_D)]"
public let RX_Name:   String = "[\(RX_C)\(RX_A)](?:[\(RX_C)\(RX_A)\(RX_B)])*"
public let RX_Prefix: String = "[\(RX_A)](?:[\(RX_A)\(RX_B)])*"

@inlinable func validate(name: String) -> Bool { testName(pattern: RX_Name, name: name) }

@inlinable func validate(prefix: String) -> Bool { testName(pattern: RX_Prefix, name: prefix) }

@inlinable func testName(pattern: String, name: String) -> Bool { testString(pattern: "^\(pattern)$", string: name) }

@inlinable func testString(pattern: String, string: String) -> Bool {
    var error: Error? = nil
    guard let rx = RegularExpression(pattern: pattern, error: &error) else { fatalError(error!.localizedDescription) }
    let b = (rx.firstMatch(in: string) != nil)
    return b
}
