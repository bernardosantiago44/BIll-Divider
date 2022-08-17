//
//  String extensions.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 19/06/22.
//

import Foundation

extension String {
    var forSorting: String {
        let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "").noSpace
    }
    var noSpace: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}

