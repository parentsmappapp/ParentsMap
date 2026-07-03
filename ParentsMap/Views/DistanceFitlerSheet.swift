//
//  DistanceFitlerSheet.swift
//  ParentsMap
//
//  Created by Mariia on 21/6/2026.
//

import SwiftUI

struct DistanceFilterSheet: View {
    @Binding var selectedRadiusKm: Double?
    @Environment(\.dismiss) var dismiss
    
    let options: [(label: String, value: Double?)] = [
        ("500m", 0.5),
        ("1km", 1),
        ("5km", 5),
        ("10km", 10),
        ("Any distance", nil)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Filter by distance")
                .font(.quicksand(.bold, size: 20))
                .foregroundColor(Color(.brandBrown))
                .padding(.top, 24)
            
            VStack(spacing: 12) {
                ForEach(options, id: \.label) { option in
                    Button {
                        selectedRadiusKm = option.value
                    } label: {
                        HStack {
                            Text(option.label)
                                .font(.quicksand(.medium, size: 15))
                                .foregroundColor(Color(.brandBrown))
                            
                            Spacer()
                            
                            Image(systemName: selectedRadiusKm == option.value ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedRadiusKm == option.value ? Color(.brandCoral) : Color(.brandBrown).opacity(0.3))
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
                    selectedRadiusKm = nil
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
