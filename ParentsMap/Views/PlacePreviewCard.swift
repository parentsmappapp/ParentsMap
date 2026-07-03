import SwiftUI

struct PlacePreviewCard: View {
    let place: PlaceWithDetails
    let distanceKm: Double?
    let isSaved: Bool
    let onToggleSave: () -> Void
    let onClose: () -> Void
    let onExpand: () -> Void
    
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 12) {
                    Capsule()
                        .fill(Color(.brandBrown).opacity(0.25))
                        .frame(width: 56, height: 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 12)
                    
                    HStack(alignment: .top, spacing: 12) {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.brandPink))
                                .frame(width: 84, height: 84)
                                .overlay(
                                    Image(systemName: place.category?.icon ?? "mappin")
                                        .font(.system(size: 26))
                                        .foregroundColor(Color(.brandCoral))
                                )
                            
                            Text("Open Now")
                                .font(.poppins(.medium, size: 9))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color(.brandCoral))
                                .cornerRadius(8)
                                .offset(y: 10)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(place.place.name)
                                .font(.quicksand(.bold, size: 16))
                                .foregroundColor(Color(.brandBrown))
                                .lineLimit(2)
                            
                            if let distance = distanceKm {
                                Text(String(format: "%.1fkm away", distance))
                                    .font(.quicksand(.medium, size: 12))
                                    .foregroundColor(Color(.brandBrown).opacity(0.5))
                            }
                            
                            if let address = place.place.address {
                                Text(address)
                                    .font(.quicksand(.medium, size: 12))
                                    .foregroundColor(Color(.brandBrown).opacity(0.5))
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer(minLength: 32)
                    }
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < Int(place.place.averageRating ?? 0) ? "star.fill" : "star")
                                .font(.system(size: 11))
                                .foregroundColor(.yellow)
                        }
                        Text("\(place.place.reviewCount ?? 0) comments")
                            .font(.poppins(.regular, size: 11))
                            .foregroundColor(Color(.brandBrown).opacity(0.5))
                    }
                    
                    if !place.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(place.tags.prefix(2)) { tag in
                                    Text(tag.name)
                                        .font(.poppins(.medium, size: 11))
                                        .foregroundColor(Color(.brandCoral))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color(.brandPink))
                                        .cornerRadius(12)
                                }
                                if place.tags.count > 2 {
                                    Text("+\(place.tags.count - 2) more")
                                        .font(.poppins(.medium, size: 11))
                                        .foregroundColor(Color(.brandBrown).opacity(0.5))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color(.brandPink))
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            openDirections()
                        } label: {
                            Text("Get Directions")
                                .font(.quicksand(.semiBold, size: 14))
                                .foregroundColor(Color(.brandCoral))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.white)
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color(.brandCoral), lineWidth: 1.5)
                                )
                        }
                        
                        Button(action: onExpand) {
                            Text("View More")
                                .font(.quicksand(.semiBold, size: 14))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color(.brandCoral))
                                .cornerRadius(24)
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                
                // Top-right X close button
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(.brandBrown).opacity(0.3))
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
                
                // Heart button, below the X
                Button(action: onToggleSave) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(Color(.brandCoral))
                }
                .padding(.top, 52)
                .padding(.trailing, 16)
                
                // Vertically-centered expand chevron on the right edge
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: Color(red: 0.196, green: 0.098, blue: 0.086).opacity(0.15), radius: 20, x: 0, y: 8)
            .overlay(alignment: .trailing) {
                Button(action: onExpand) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(.brandBrown).opacity(0.4))
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(
                            color: Color(red: 0.196, green: 0.098, blue: 0.086).opacity(0.08),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                }
                .padding(.trailing, -8)
            }
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in dragOffset = value.translation.height }
                    .onEnded { value in
                        if value.translation.height > 100 {
                            onClose()
                        } else if value.translation.height < -60 {
                            onExpand()
                        }
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            dragOffset = 0
                        }
                    }
            )
            .onTapGesture {
                onExpand()
            }
        }
    }
    func openDirections() {
        let lat = place.place.latitude
        let lon = place.place.longitude
        
        if let googleMapsURL = URL(string: "comgooglemaps://?daddr=\(lat),\(lon)&directionsmode=driving"),
           UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL)
        } else if let appleMapsURL = URL(string: "maps://?daddr=\(lat),\(lon)") {
            UIApplication.shared.open(appleMapsURL)
        }
    }
    struct RoundedCorner: Shape {
        var radius: CGFloat = 0
        var corners: UIRectCorner = .allCorners
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
}
