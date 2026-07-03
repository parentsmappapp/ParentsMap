import SwiftUI

struct PlaceDetailView: View {
    let place: PlaceWithDetails
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var savedPlacesService: SavedPlacesService
    @Environment(\.dismiss) var dismiss
    @State private var showAllAmenities = false
    @State private var showFullDescription = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.brandCream).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(.brandPink))
                            .frame(height: 320)
                            .overlay(
                                Image(systemName: place.category?.icon ?? "mappin")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color(.brandCoral))
                            )
                        
                        Text("1 / 9")
                            .font(.poppins(.medium, size: 11))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(place.place.name)
                                    .font(.quicksand(.bold, size: 22))
                                    .foregroundColor(Color(.brandBrown))
                                
                                if let address = place.place.address {
                                    HStack(spacing: 4) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(.brandBrown).opacity(0.5))
                                        Text(address)
                                            .font(.quicksand(.medium, size: 13))
                                            .foregroundColor(Color(.brandBrown).opacity(0.6))
                                    }
                                }
                                
                                if let hours = todayHoursText {
                                    HStack(spacing: 4) {
                                        Image(systemName: "clock.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(.brandBrown).opacity(0.5))
                                        Text(hours)
                                            .font(.quicksand(.medium, size: 13))
                                            .foregroundColor(Color(.brandBrown).opacity(0.6))
                                    }
                                }
                            }
                            Spacer()
                            EditPencilButton {}
                        }
                        .staggerReveal(0)
                        
                        HStack {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { i in
                                    Image(systemName: i < Int(place.place.averageRating ?? 0) ? "star.fill" : "star")
                                        .font(.system(size: 14))
                                        .foregroundColor(.yellow)
                                }
                                Text(String(format: "%.1f", place.place.averageRating ?? 0))
                                    .font(.quicksand(.semiBold, size: 14))
                                    .foregroundColor(Color(.brandBrown))
                            }
                            Spacer()
                            Button {} label: {
                                Text("\(place.place.reviewCount ?? 0) Comments")
                                    .font(.quicksand(.semiBold, size: 13))
                                    .foregroundColor(Color(.brandCoral))
                                    .underline()
                            }
                        }
                        .staggerReveal(1)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Key Features")
                                    .font(.quicksand(.bold, size: 17))
                                    .foregroundColor(Color(.brandBrown))
                                Spacer()
                                EditPencilButton {}
                            }
                            
                            FlowTags(tags: showAllAmenities ? place.tags : Array(place.tags.prefix(5)))
                            
                            if place.tags.count > 5 {
                                Button {
                                    showAllAmenities.toggle()
                                } label: {
                                    Text(showAllAmenities ? "Show less" : "Show all \(place.tags.count) amenities")
                                        .font(.quicksand(.semiBold, size: 14))
                                        .foregroundColor(Color(.brandCoral))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(Color(.brandPink))
                                        .cornerRadius(22)
                                }
                            }
                        }
                        .staggerReveal(2)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Description")
                                    .font(.quicksand(.bold, size: 17))
                                    .foregroundColor(Color(.brandBrown))
                                Spacer()
                                EditPencilButton {}
                            }
                            
                            if let description = place.place.description {
                                Text(description)
                                    .font(.quicksand(.medium, size: 14))
                                    .foregroundColor(Color(.brandBrown).opacity(0.7))
                                    .lineLimit(showFullDescription ? nil : 3)
                                
                                Button {
                                    showFullDescription.toggle()
                                } label: {
                                    Text(showFullDescription ? "Show less" : "Show More")
                                        .font(.quicksand(.semiBold, size: 14))
                                        .foregroundColor(Color(.brandCoral))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(Color(.brandPink))
                                        .cornerRadius(22)
                                }
                            }
                        }
                        .staggerReveal(3)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Contact Details")
                                    .font(.quicksand(.bold, size: 17))
                                    .foregroundColor(Color(.brandBrown))
                                Spacer()
                                EditPencilButton {}
                            }
                            .staggerReveal(4)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                if let address = place.place.address {
                                    ContactRow(icon: "location.fill", text: address)
                                }
                                if let phone = place.place.phone {
                                    ContactRow(icon: "phone.fill", text: phone)
                                }
                                if let hours = place.place.openingHours {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HourRow(day: "Monday", hours: hours.mon)
                                        HourRow(day: "Tuesday", hours: hours.tue)
                                        HourRow(day: "Wednesday", hours: hours.wed)
                                        HourRow(day: "Thursday", hours: hours.thu)
                                        HourRow(day: "Friday", hours: hours.fri)
                                        HourRow(day: "Saturday", hours: hours.sat)
                                        HourRow(day: "Sunday", hours: hours.sun)
                                    }
                                    .padding(.leading, 22)
                                }
                            }
                            
                            Button {
                                openDirections()
                            } label: {
                                Text("Directions")
                                    .font(.quicksand(.semiBold, size: 15))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color(.brandCoral))
                                    .cornerRadius(25)
                            }
                            .padding(.top, 4)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Comments")
                                    .font(.quicksand(.bold, size: 17))
                                    .foregroundColor(Color(.brandBrown))
                                Spacer()
                                Button {} label: {
                                    Text("See all")
                                        .font(.quicksand(.semiBold, size: 13))
                                        .foregroundColor(Color(.brandCoral))
                                }
                            }
                            .staggerReveal(5)
                            
                            HStack(alignment: .top, spacing: 16) {
                                VStack {
                                    Text(String(format: "%.1f", place.place.averageRating ?? 0))
                                        .font(.quicksand(.bold, size: 20))
                                        .foregroundColor(Color(.brandBrown))
                                    HStack(spacing: 1) {
                                        ForEach(0..<5) { i in
                                            Image(systemName: i < Int(place.place.averageRating ?? 0) ? "star.fill" : "star")
                                                .font(.system(size: 9))
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    Text("\(place.place.reviewCount ?? 0)+ ratings")
                                        .font(.poppins(.regular, size: 10))
                                        .foregroundColor(Color(.brandBrown).opacity(0.5))
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Circle()
                                            .fill(Color(.brandPink))
                                            .frame(width: 28, height: 28)
                                            .overlay(Text("K").font(.quicksand(.bold, size: 12)).foregroundColor(Color(.brandCoral)))
                                        Text("Kasia - Mum")
                                            .font(.quicksand(.semiBold, size: 13))
                                            .foregroundColor(Color(.brandBrown))
                                        HStack(spacing: 1) {
                                            ForEach(0..<4) { _ in
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 8))
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                        Text("1 month ago")
                                            .font(.poppins(.regular, size: 10))
                                            .foregroundColor(Color(.brandBrown).opacity(0.4))
                                    }
                                    Text("So nice and convenient, had a recent upgrade and never too busy, also... more")
                                        .font(.quicksand(.regular, size: 13))
                                        .foregroundColor(Color(.brandBrown).opacity(0.7))
                                }
                            }
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                        
                        Text("Last updated\nLast month")
                            .font(.poppins(.regular, size: 11))
                            .foregroundColor(Color(.brandBrown).opacity(0.4))
                        
                        Button {} label: {
                            Text("Add Info / Suggest Edit")
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
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 48)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            HStack {
                CircleIconButton(icon: "chevron.left") { dismiss() }
                Spacer()
                CircleIconButton(icon: savedPlacesService.isSaved(place.place.id) ? "heart.fill" : "heart") {
                    if let userId = authViewModel.currentUser?.id {
                        Task {
                            await savedPlacesService.toggleSave(placeId: place.place.id, userId: userId)
                        }
                    }
                }
                CircleIconButton(icon: "square.and.arrow.up") {}
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)
        }
    }
    
    var todayHoursText: String? {
        guard let hours = place.place.openingHours else { return nil }
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        let today: String?
        switch weekday {
        case 1: today = hours.sun
        case 2: today = hours.mon
        case 3: today = hours.tue
        case 4: today = hours.wed
        case 5: today = hours.thu
        case 6: today = hours.fri
        case 7: today = hours.sat
        default: today = nil
        }
        guard let today = today else { return nil }
        return "Open today: \(today)"
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
}

struct FlowTags: View {
    let tags: [Tag]
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(tags) { tag in
                TagChip(name: tag.name)
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > UIScreen.main.bounds.width - 48 {
                            width = 0
                            height -= dimension.height + 8
                        }
                        let result = width
                        if tag.id == tags.last?.id {
                            width = 0
                        } else {
                            width -= dimension.width + 8
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if tag.id == tags.last?.id {
                            height = 0
                        }
                        return result
                    }
            }
        }
    }
}

struct TagChip: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.poppins(.medium, size: 12))
            .foregroundColor(Color(.brandCoral))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.brandPink))
            .cornerRadius(16)
    }
}

struct EditPencilButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "pencil")
                .font(.system(size: 12))
                .foregroundColor(Color(.brandCoral))
                .frame(width: 28, height: 28)
                .background(Color(.brandPink))
                .clipShape(Circle())
        }
    }
}

struct ContactRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Color(.brandBrown).opacity(0.5))
                .frame(width: 16)
            Text(text)
                .font(.quicksand(.medium, size: 14))
                .foregroundColor(Color(.brandBrown).opacity(0.8))
        }
    }
}

struct HourRow: View {
    let day: String
    let hours: String?
    var body: some View {
        HStack {
            Text(day)
                .font(.quicksand(.medium, size: 13))
                .foregroundColor(Color(.brandBrown).opacity(0.6))
            Spacer()
            Text(hours ?? "Closed")
                .font(.quicksand(.medium, size: 13))
                .foregroundColor(Color(.brandBrown).opacity(0.6))
        }
    }
}

struct CircleIconButton: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(.brandCoral))
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
}

#Preview {
    PlaceDetailView(place: PlaceWithDetails(
        place: Place(id: 1, name: "Royal Randwick Parents Room", description: "Parents rooms located in Royal Randwick shopping centre, with all necessary amenities for parents and their children.", address: "100 Avoca Street, Randwick", latitude: -33.91, longitude: 151.24, categoryId: 1, averageRating: 4.1, reviewCount: 3, isApproved: true, phone: "(02) 9398 9099", website: nil, openingHours: OpeningHours(mon: "8am-6pm", tue: "8am-6pm", wed: "8am-6pm", thu: "8am-9pm", fri: "8am-6pm", sat: "9am-6pm", sun: "9am-5pm")),
        category: Category(id: 1, name: "Parent Room", icon: "figure.and.child.holdinghands"),
        tags: []
    ))
    .environmentObject(AuthViewModel())
    .environmentObject(SavedPlacesService())
}
