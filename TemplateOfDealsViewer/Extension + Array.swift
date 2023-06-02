//
//  Extension + Array.swift
//  TemplateOfDealsViewer
//
//  Created by Green on 01.06.2023.
//

import Foundation

extension Deal.Side: Comparable {
    var sortOrder: Int {
        switch self {
        case .sell:
            return 0
        case .buy:
            return 1
        }
    }
    static func < (lhs: Deal.Side, rhs: Deal.Side) -> Bool {
        return lhs.sortOrder > rhs.sortOrder
    }
}

extension Array where Element == Deal {
    mutating func sortedBy(_ sortType: SortType, sortSide: SortSide) {
        switch sortType {
        case .dateModifierSort:
            self = sorted(by: { getDealFromSide(deals: [$0, $1], sortSide: sortSide).dateModifier >
                getDealFromSide(deals: [$1, $0], sortSide: sortSide).dateModifier })
        case .amountSort:
            self = sorted(by: { getDealFromSide(deals: [$0, $1], sortSide: sortSide).amount >
                getDealFromSide(deals: [$1, $0], sortSide: sortSide).amount })
        case .instrumentNameSort:
            self = sorted(by: { getDealFromSide(deals: [$0, $1], sortSide: sortSide).instrumentName >
                getDealFromSide(deals: [$1, $0], sortSide: sortSide).instrumentName })
        case .priceSort:
            self = sorted(by: { getDealFromSide(deals: [$0, $1], sortSide: sortSide).price >
                getDealFromSide(deals: [$1, $0], sortSide: sortSide).price })
        case .sideSort:
            self = sorted(by: { getDealFromSide(deals: [$0, $1], sortSide: sortSide).side >
                getDealFromSide(deals: [$1, $0], sortSide: sortSide).side })
        }
    }
    
    func getDealFromSide(deals: [Deal], sortSide: SortSide) -> Deal {
        return sortSide == .up ? deals[0] : deals[1]
    }
}

