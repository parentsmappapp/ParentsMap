//
//  TypeFilterSheet.swift
//  ParentsMap
//
//  Created by Mariia on 21/6/2026.
//

import SwiftUI

struct TypeFilterSheet: View {
    let categories: [Category]
    @Binding var selectedCategoryIds: Set<Int>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Filter by type")
                .font(.quicksand(.bold, size: 20))
                .foregroundColor(Color(.brandBrown))
                .padding(.top, 24)
            
            VStack(spacing: 12) {
                ForEach(categories) { category in
                    Button {
                        if selectedCategoryIds.contains(category.id) {
                            selectedCategoryIds.remove(category.id)
                        } else {
                            selectedCategoryIds.insert(category.id)
                        }
                    } label: {
                        HStack {
                            Image(systemName: category.icon ?? "mappin")
                                .foregroundColor(Color(.brandCoral))
                                .frame(width: 24)
                            
                            Text(category.name)
                                .font(.quicksand(.medium, size: 15))
                                .foregroundColor(Color(.brandBrown))
                            
                            Spacer()
                            
                            Image(systemName: selectedCategoryIds.contains(category.id) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedCategoryIds.contains(category.id) ? Color(.brandCoral) : Color(.brandBrown).opacity(0.3))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                }
            }
            
            HStack(spacing: 12) {
                Button {
                    selectedCategoryIds.removeAll()
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
                
                Button {
                    dismiss()
                } label: {
                    Text("Apply")
                        .font(.quicksand(.semiBold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(.brandCoral))
                        .cornerRadius(22)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(.brandCream).ignoresSafeArea())
        .presentationDetents([.medium])
    }
}
