import SwiftUI
import CoreLocation

enum SubmitField: Hashable {
    case name, phone, website
}

struct SubmitPlaceView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var service = SubmitPlaceService()
    
    @State private var step = 0
    @State private var selectedCategory: Category?
    @State private var name = ""
    @State private var address = ""
    @State private var pinCoordinate: CLLocationCoordinate2D?
    @State private var description = ""
    @State private var phone = ""
    @State private var website = ""
    @State private var selectedTagIds: Set<Int> = []
    @State private var selectedImages: [UIImage] = []
    @FocusState private var focusedField: SubmitField?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.brandCream).ignoresSafeArea()
            
            VStack(spacing: 0) {
                Color.clear.frame(height: 104)
                
                ScrollView {
                    Group {
                        switch step {
                        case 0: categoryStep
                        case 1: nameStep
                        case 2: LocationPickerStep(service: service, address: $address, coordinate: $pinCoordinate)
                        case 3: PhotoPickerStep(selectedImages: $selectedImages)
                        case 4: featuresStep
                        default: successStep
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
                
                if step >= 1 && step <= 4 && focusedField == nil {
                    VStack(spacing: 16) {
                        ProgressBar(step: step, total: 5)
                        bottomButton
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
            
            header
            
            if focusedField != nil {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                        .font(.quicksand(.semiBold, size: 15))
                        .foregroundColor(Color(.brandCoral))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .overlay(Rectangle().frame(height: 0.5).foregroundColor(Color(.brandBrown).opacity(0.15)), alignment: .top)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .transition(.opacity)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .task {
            await service.loadFormData()
        }
    }
    
    var header: some View {
        HStack(spacing: 16) {
            if step > 0 && step < 5 {
                PMBackButton(action: {
                    focusedField = nil
                    withAnimation { step -= 1 }
                })
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
            
            Text(headerTitle)
                .font(.quicksand(.bold, size: 20))
                .foregroundColor(Color(.brandBrown))
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 48)
        .padding(.bottom, 16)
        .background(Color(.brandCream))
    }
    
    var headerTitle: String {
        switch step {
        case 0: return "Add New Spot"
        case 1, 2, 3, 4: return selectedCategory?.name ?? ""
        default: return ""
        }
    }
    
    var categoryStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What kind of spot is it?")
                .font(.quicksand(.semiBold, size: 16))
                .foregroundColor(Color(.brandBrown))
            
            VStack(spacing: 12) {
                ForEach(service.categories) { category in
                    Button {
                        selectedCategory = category
                        withAnimation { step = 1 }
                    } label: {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color(.brandPink))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: category.icon ?? "mappin")
                                        .foregroundColor(Color(.brandCoral))
                                )
                            
                            Text(category.name)
                                .font(.quicksand(.semiBold, size: 16))
                                .foregroundColor(Color(.brandBrown))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.brandBrown).opacity(0.3))
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
            }
        }
        .padding(.bottom, 32)
    }
    
    var nameStep: some View {
        VStack(spacing: 16) {
            Text("Name this place")
                .font(.quicksand(.semiBold, size: 16))
                .foregroundColor(Color(.brandBrown))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            PMFormField(title: "Spot Name", placeholder: "e.g. Westfield Parents Room", text: $name, isFocused: focusedField == .name, onTap: { focusedField = .name })
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Description (optional)")
                    .font(.quicksand(.semiBold, size: 13))
                    .foregroundColor(Color(.brandBrown))
                TextEditor(text: $description)
                    .font(.quicksand(.regular, size: 15))
                    .scrollContentBackground(.hidden)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(16)
            }
            
            PMFormField(title: "Phone (optional)", placeholder: "Phone number", text: $phone, keyboardType: .phonePad, isFocused: focusedField == .phone, onTap: { focusedField = .phone })
            PMFormField(title: "Website (optional)", placeholder: "https://...", text: $website, keyboardType: .URL, isFocused: focusedField == .website, onTap: { focusedField = .website })
        }
        .padding(.bottom, 32)
    }
    
    var featuresStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Features")
                    .font(.quicksand(.bold, size: 18))
                    .foregroundColor(Color(.brandBrown))
                Text("Please select all features that apply to this facility")
                    .font(.quicksand(.medium, size: 13))
                    .foregroundColor(Color(.brandBrown).opacity(0.6))
            }
            
            if let category = selectedCategory {
                ForEach(service.groupedTags(for: category.name), id: \.category) { group in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: icon(for: group.category))
                                .font(.system(size: 13))
                                .foregroundColor(Color(.brandCoral))
                            Text(group.category)
                                .font(.quicksand(.bold, size: 15))
                                .foregroundColor(Color(.brandBrown))
                        }
                        
                        FlowLayout(spacing: 8) {
                            ForEach(sortedTags(group.tags)) { tag in
                                ToggleChip(
                                    name: tag.name,
                                    isSelected: selectedTagIds.contains(tag.id),
                                    action: {
                                        if selectedTagIds.contains(tag.id) {
                                            selectedTagIds.remove(tag.id)
                                        } else {
                                            selectedTagIds.insert(tag.id)
                                        }
                                    }
                                )
                            }
                        }
                        .animation(.easeOut(duration: 0.2), value: selectedTagIds)
                    }
                }
            }
            
            if let error = service.errorMessage {
                Text(error)
                    .font(.quicksand(.medium, size: 13))
                    .foregroundColor(Color(.brandCoral))
            }
        }
        .padding(.bottom, 32)
    }
    
    func icon(for groupName: String) -> String {
        switch groupName {
        case "Toileting": return "toilet.fill"
        case "Feeding": return "fork.knife"
        case "Hygiene": return "drop.fill"
        case "Comfort": return "sofa.fill"
        case "Facilities Nearby": return "mappin.and.ellipse"
        default: return "sparkles"
        }
    }
    
    func sortedTags(_ tags: [Tag]) -> [Tag] {
        tags.sorted { a, b in
            let aSelected = selectedTagIds.contains(a.id)
            let bSelected = selectedTagIds.contains(b.id)
            if aSelected != bSelected { return aSelected && !bSelected }
            return false
        }
    }
    
    var successStep: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(Color(.brandCoral))
            
            Text("Submitted for review!")
                .font(.quicksand(.bold, size: 22))
                .foregroundColor(Color(.brandBrown))
            
            Text("Thanks for helping other parents. We'll review your submission and add it to the map soon.")
                .font(.quicksand(.medium, size: 14))
                .foregroundColor(Color(.brandBrown).opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            PMPrimaryButton("Done") {
                resetForm()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer()
        }
    }
    
    var bottomButton: some View {
        Group {
            if step == 1 {
                PMPrimaryButton("Continue", icon: "chevron.right") {
                    focusedField = nil
                    withAnimation { step = 2 }
                }
                .disabled(name.isEmpty)
                .opacity(name.isEmpty ? 0.5 : 1)
            } else if step == 2 {
                PMPrimaryButton("Continue", icon: "chevron.right") {
                    withAnimation { step = 3 }
                }
                .disabled(address.isEmpty || pinCoordinate == nil)
                .opacity(address.isEmpty || pinCoordinate == nil ? 0.5 : 1)
            } else if step == 3 {
                VStack(spacing: 12) {
                    Button {
                        withAnimation { step = 4 }
                    } label: {
                        Text("Skip")
                            .font(.quicksand(.semiBold, size: 15))
                            .foregroundColor(Color(.brandCoral))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(.brandPink))
                            .cornerRadius(26)
                    }
                    PMPrimaryButton("Continue") {
                        withAnimation { step = 4 }
                    }
                }
            } else if step == 4 {
                PMPrimaryButton("Submit", isLoading: service.isLoading) {
                    Task { await submit() }
                }
            }
        }
    }
    
    func submit() async {
        guard let category = selectedCategory,
              let coordinate = pinCoordinate,
              let userId = authViewModel.currentUser?.id else { return }
        
        let submissionId = await service.submit(
            name: name,
            description: description,
            address: address,
            coordinate: coordinate,
            phone: phone,
            website: website,
            categoryId: category.id,
            selectedTagIds: selectedTagIds,
            userId: userId
        )
        
        if let submissionId = submissionId {
            if !selectedImages.isEmpty {
                await service.uploadPhotos(selectedImages, submissionId: submissionId)
            }
            withAnimation { step = 5 }
        }
    }
    
    func resetForm() {
        step = 0
        selectedCategory = nil
        name = ""
        address = ""
        pinCoordinate = nil
        description = ""
        phone = ""
        website = ""
        selectedTagIds = []
        selectedImages = []
        service.didSubmitSuccessfully = false
        service.errorMessage = nil
    }
}

struct ProgressBar: View {
    let step: Int
    let total: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { i in
                Capsule()
                    .fill(i <= step ? Color(.brandCoral) : Color(.brandPink))
                    .frame(height: 4)
            }
        }
    }
}

struct ToggleChip: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(.brandCoral))
                }
                Text(name)
                    .font(.poppins(.medium, size: 13))
                    .foregroundColor(isSelected ? Color(.brandCoral) : Color(.brandBrown))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color(red: 0.984, green: 1.0, blue: 0.925) : Color(red: 0.961, green: 0.961, blue: 0.961))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(.brandCoral) : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    SubmitPlaceView()
        .environmentObject(AuthViewModel())
}
