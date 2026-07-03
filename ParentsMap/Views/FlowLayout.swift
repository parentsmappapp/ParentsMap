//
//  FlowLayout.swift
//  ParentsMap
//
//  Created by Mariia on 28/6/2026.
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        let rows = computeRows(maxWidth: width, subviews: subviews)
        let height = rows.reduce(0) { $0 + $1.maxHeight } + spacing * CGFloat(max(rows.count - 1, 0))
        return CGSize(width: width.isFinite ? width : (rows.first?.totalWidth ?? 0), height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(maxWidth: bounds.width, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: .unspecified)
                x += size.width + spacing
            }
            y += row.maxHeight + spacing
        }
    }
    
    private struct Row {
        var indices: [Int] = []
        var totalWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
    }
    
    private func computeRows(maxWidth: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var current = Row()
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            if current.totalWidth + size.width > maxWidth && !current.indices.isEmpty {
                rows.append(current)
                current = Row()
            }
            current.indices.append(index)
            current.totalWidth += size.width + (current.indices.count > 1 ? spacing : 0)
            current.maxHeight = max(current.maxHeight, size.height)
        }
        if !current.indices.isEmpty { rows.append(current) }
        return rows
    }
}
