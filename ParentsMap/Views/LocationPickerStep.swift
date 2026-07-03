import SwiftUI
import MapKit

struct LocationPickerStep: View {
    @ObservedObject var service: SubmitPlaceService
    @Binding var address: String
    @Binding var coordinate: CLLocationCoordinate2D?
    @StateObject private var locationManager = LocationManager()
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.8915, longitude: 151.2025),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var pinCoordinate = CLLocationCoordinate2D(latitude: -33.8915, longitude: 151.2025)
    @State private var isResolvingAddress = false
    @State private var hasCenteredOnUser = false
    @State private var useManualAddress = false
    @State private var manualAddressText = ""
    @State private var isGeocodingManual = false
    @State private var manualGeocodeError: String?
    @FocusState private var addressFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Where is it located?")
                    .font(.quicksand(.semiBold, size: 16))
                    .foregroundColor(Color(.brandBrown))
                Spacer()
                Button {
                    useManualAddress.toggle()
                } label: {
                    Text(useManualAddress ? "Use map instead" : "Enter address instead")
                        .font(.quicksand(.semiBold, size: 13))
                        .foregroundColor(Color(.brandCoral))
                        .underline()
                }
            }
            
            if useManualAddress {
                manualAddressMode
            } else {
                mapPickerMode
            }
        }
        .onAppear {
            locationManager.requestLocationPermission()
            if !useManualAddress {
                resolveAddress(for: pinCoordinate)
            }
        }
        .onReceive(locationManager.$userLocation) { location in
            guard let location, !hasCenteredOnUser else { return }
            hasCenteredOnUser = true
            moveCamera(to: location)
        }
        .onChange(of: pinCoordinate.latitude) { _, _ in
            if !useManualAddress {
                scheduleResolve()
            }
        }
    }
    
    var mapPickerMode: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                Map(position: $cameraPosition)
                    .frame(height: 240)
                    .cornerRadius(20)
                    .onMapCameraChange { context in
                        pinCoordinate = context.region.center
                    }
                
                Image(systemName: "mappin")
                    .font(.system(size: 32))
                    .foregroundColor(Color(.brandCoral))
                    .offset(y: -16)
                    .allowsHitTesting(false)
            }
            
            Button {
                useCurrentLocation()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 13))
                    Text("Use my current location")
                        .font(.quicksand(.semiBold, size: 14))
                }
                .foregroundColor(Color(.brandCoral))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color(.brandPink))
                .cornerRadius(22)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Address")
                    .font(.quicksand(.semiBold, size: 13))
                    .foregroundColor(Color(.brandBrown))
                
                HStack {
                    if isResolvingAddress {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    Text(address.isEmpty ? "Move the map to find this spot's address" : address)
                        .font(.quicksand(.regular, size: 14))
                        .foregroundColor(address.isEmpty ? Color(.brandBrown).opacity(0.4) : Color(.brandBrown))
                        .lineLimit(2)
                }
                .padding(.horizontal, 16)
                .frame(minHeight: 50)
                .background(Color.white)
                .cornerRadius(20)
            }
            
            Text("Drag the map so the pin sits exactly on the spot")
                .font(.quicksand(.medium, size: 12))
                .foregroundColor(Color(.brandBrown).opacity(0.5))
        }
    }
    
    var manualAddressMode: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Address")
                    .font(.quicksand(.semiBold, size: 13))
                    .foregroundColor(Color(.brandBrown))
                
                TextField("Street address, suburb, state", text: $manualAddressText)
                    .font(.quicksand(.regular, size: 15))
                    .focused($addressFieldFocused)
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(25)
                    .submitLabel(.search)
                    .onSubmit {
                        geocodeManualAddress()
                    }
            }
            
            Button {
                geocodeManualAddress()
            } label: {
                HStack(spacing: 8) {
                    if isGeocodingManual {
                        ProgressView().tint(.white)
                    } else {
                        Text("Find this address")
                            .font(.quicksand(.semiBold, size: 14))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color(.brandCoral))
                .cornerRadius(22)
            }
            .disabled(manualAddressText.isEmpty || isGeocodingManual)
            .opacity(manualAddressText.isEmpty ? 0.5 : 1)
            if let error = manualGeocodeError {
                Text(error)
                    .font(.quicksand(.medium, size: 13))
                    .foregroundColor(Color(.brandCoral))
            }
            
            if let coord = coordinate, !address.isEmpty, useManualAddress {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(.brandCoral))
                    Text(address)
                        .font(.quicksand(.medium, size: 13))
                        .foregroundColor(Color(.brandBrown).opacity(0.7))
                        .lineLimit(2)
                }
                .padding(12)
                .background(Color(.brandPink))
                .cornerRadius(16)
                
                Map(position: .constant(.region(MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))) {
                    Marker("", coordinate: coord).tint(Color(.brandCoral))
                }
                .frame(height: 160)
                .cornerRadius(20)
                .allowsHitTesting(false)
            }
        }
    }
    
    func useCurrentLocation() {
        if let location = locationManager.userLocation {
            moveCamera(to: location)
        }
    }
    
    func moveCamera(to location: CLLocationCoordinate2D) {
        cameraPosition = .region(
            MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        )
        pinCoordinate = location
        resolveAddress(for: location)
    }
    
    @State private var resolveTask: Task<Void, Never>?
    
    func scheduleResolve() {
        resolveTask?.cancel()
        resolveTask = Task {
            try? await Task.sleep(nanoseconds: 600_000_000)
            if !Task.isCancelled {
                resolveAddress(for: pinCoordinate)
            }
        }
    }
    
    func resolveAddress(for coord: CLLocationCoordinate2D) {
        isResolvingAddress = true
        Task {
            let resolved = await service.reverseGeocode(coord)
            address = resolved ?? ""
            coordinate = coord
            isResolvingAddress = false
        }
    }
    
    func geocodeManualAddress() {
        addressFieldFocused = false
        isGeocodingManual = true
        manualGeocodeError = nil
        Task {
            if let coord = await service.geocodeAddress(manualAddressText) {
                coordinate = coord
                address = manualAddressText
            } else {
                address = ""
                coordinate = nil
                manualGeocodeError = "We couldn't find that address. Try adding more detail, like the suburb or postcode."
            }
            isGeocodingManual = false
        }
    }
}
