//
//  FlowLayout.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity

        for size in sizes {
            if lineWidth + size.width > maxWidth {
                totalHeight += lineHeight + spacing
                totalWidth = max(totalWidth, lineWidth)
                lineWidth = 0
                lineHeight = 0
            }
            lineWidth += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        totalHeight += lineHeight
        totalWidth = max(totalWidth, lineWidth - spacing)
        return CGSize(width: totalWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var minX = bounds.minX
        var minY = bounds.minY
        var lineHeight: CGFloat = 0

        for index in subviews.indices {
            let size = sizes[index]
            if minX + size.width > bounds.maxX {
                minX = bounds.minX
                minY += lineHeight + spacing
                lineHeight = 0
            }
            subviews[index].place(at: CGPoint(x: minX, y: minY), proposal: ProposedViewSize(size))
            minX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}
