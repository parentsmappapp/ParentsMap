//
//  SearchResultRow.swift
//  ParentsMap
//
//  Created by Mariia on 2/7/2026.
//

import SwiftUI

struct SearchResultRow: View {

    let place: PlaceWithDetails

    var body: some View {

        HStack(alignment: .top, spacing: 14) {

            Image(systemName: place.category?.icon ?? "mappin.and.ellipse")
                .font(.system(size: 18))
                .foregroundColor(Color(.brandCoral))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {

                Text(place.place.name)
                    .font(.quicksand(.semiBold, size: 15))
                    .foregroundColor(Color(.brandBrown))

                Text(place.category?.name ?? "")
                    .font(.quicksand(.medium, size: 13))
                    .foregroundColor(Color(.brandBrown).opacity(0.6))

                if let address = place.place.address {

                    Text(address)
                        .font(.quicksand(.regular, size: 12))
                        .foregroundColor(Color(.brandBrown).opacity(0.45))
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}
