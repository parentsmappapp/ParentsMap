import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentPage = 0
    @State private var showLogin = false
    @State private var showSignUp = false
    
    let slides = [
        OnboardingSlide(
            imageName: "AppLogo",
            title: "Welcome to\nParents Map",
            subtitle: "Where you can find everything you need as a parent to feel confident while out and about"
        ),
        OnboardingSlide(
            imageName: "AppLogo",
            title: "Panic Over. You know where to change the next nappy.",
            subtitle: ""
        ),
        OnboardingSlide(
            imageName: "AppLogo",
            title: "Search the map view for nearest spots",
            subtitle: ""
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                // Slide area
                TabView(selection: $currentPage) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        SlideView(slide: slides[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                // Dot indicators
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Capsule()
                            .fill(currentPage == index ? Color(.brandCoral) : Color(.brandPink))
                            .frame(width: currentPage == index ? 24 : 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 24)

                // Buttons
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        PMSecondaryButton("Skip Tutorial") {
                            showSignUp = true
                        }
                        
                        PMPrimaryButton(
                            currentPage < slides.count - 1 ? "How it Works" : "Start now",
                            icon: "chevron.right"
                        ) {
                            if currentPage < slides.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                showSignUp = true
                            }
                        }
                    }
                    
                    Button {
                        showLogin = true
                    } label: {
                        Text("Already have an account? Log in")
                            .font(.quicksand(.medium, size: 13))
                            .foregroundColor(Color(.brandBrown).opacity(0.6))
                            .underline()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 80)
            }
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView()
                .environmentObject(authViewModel)
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}

struct OnboardingSlide {
    let imageName: String
    let title: String
    let subtitle: String
}

struct SlideView: View {
    let slide: OnboardingSlide
    
    var body: some View {
        VStack(spacing: 0) {
            Image(slide.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
                .padding(.top, 60)
                .padding(.bottom, 40)
            
            VStack(spacing: 12) {
                Text(slide.title)
                    .font(.quicksand(.bold, size: 26))
                    .foregroundColor(Color(.brandBrown))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                if !slide.subtitle.isEmpty {
                    Text(slide.subtitle)
                        .font(.quicksand(.medium, size: 15))
                        .foregroundColor(Color(.brandBrown).opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AuthViewModel())
}
