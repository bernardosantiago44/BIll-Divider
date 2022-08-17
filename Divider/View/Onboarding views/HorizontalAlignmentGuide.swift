//
//  HorizontalAlignmentGuide.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 23/06/22.
//

import SwiftUI

extension HorizontalAlignment {
    enum AlignIconsInRows: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }
    
    static let alignIconsInRows = HorizontalAlignment(AlignIconsInRows.self)
}
