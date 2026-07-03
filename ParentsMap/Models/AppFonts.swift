//
//  AppFonts.swift
//  ParentsMap
//
//  Created by Mariia on 13/6/2026.
//
import SwiftUI

extension Font {
    static func quicksand(_ weight: QuicksandWeight, size: CGFloat) -> Font {
        return .custom(weight.rawValue, size: size)
    }
    
    static func poppins(_ weight: PoppinsWeight, size: CGFloat) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}

enum QuicksandWeight: String {
    case light = "Quicksand-Light"
    case regular = "Quicksand-Regular"
    case medium = "Quicksand-Medium"
    case semiBold = "Quicksand-SemiBold"
    case bold = "Quicksand-Bold"
}

enum PoppinsWeight: String {
    case light = "Poppins-Light"
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case bold = "Poppins-Bold"
}
