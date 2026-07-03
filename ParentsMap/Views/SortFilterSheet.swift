//
//  SortFilterSheet.swift
//  ParentsMap
//
//  Created by Mariia on 21/6/2026.
//

import SwiftUI

struct SortFilterSheet: View {
    @Binding var selectedSort: SortOption
    @Environment(\.dismiss) var dismiss
    
    let options: [SortOption] = [.none, .nearest, .highestRated, .mostReviewed]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sort by")
                .font(.quicksand(.bold, size: 20))
                .foregroundColor(Color(.brandBrown))
                .padding(.top, 24)
            
            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button {
                        selectedSort = option
                        dismiss()
                    } label: {
                        HStack {
                            Text(option.rawValue)
                                .font(.quicksand(.medium, size: 15))
                                .foregroundColor(Color(.brandBrown))
                            
                            Spacer()
                            
                            Image(systemName: selectedSort == option ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedSort == option ? Color(.brandCoral) : Color(.brandBrown).opacity(0.3))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                }
            }

            Button {
                selectedSort = .none
                dismiss()
            } label: {
                Text("Clear")
                    .font(.quicksand(.semiBold, size: 14))
                    .foregroundColor(Color(.brandBrown))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color(.brandBrown).opacity(0.2), lineWidth: 1)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(.brandCream).ignoresSafeArea())
        .presentationDetents([.medium])
    }
}
