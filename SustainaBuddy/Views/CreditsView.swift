//
//  CreditsView.swift
//  SustainaBuddy
//
//  Credits and Acknowledgments View
//

import SwiftUI

struct CreditsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("SustainaBuddy")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.cyan)
                            
                            Text("Version 1.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                        
                        // Development Team
                        creditsSection(
                            title: "Development Team",
                            icon: "person.3.fill",
                            content: [
                                "Lead Developer: Marissa Lucille Gomez",
                                "UI/UX Design Team",
                                "Backend Development Team",
                                "Quality Assurance Team",
                                "Project Management Team"
                            ]
                        )
                        
                        // Research Institutes
                        creditsSection(
                            title: "Research Institutes & Data Sources",
                            icon: "building.2.fill",
                            content: [
                                "Marine Biology Research Institute",
                                "Ocean Conservation Foundation",
                                "Wildlife Research Center",
                                "Biodiversity Data Consortium",
                                "Environmental Science Institute",
                                "Sustainable Development Research Lab",
                                "Climate Change Research Network",
                                "Conservation Biology Institute"
                            ]
                        )
                        
                        // Special Thanks
                        creditsSection(
                            title: "Special Thanks",
                            icon: "heart.fill",
                            content: [
                                "All research institutes that provided valuable animal data and conservation insights",
                                "Marine biologists and wildlife researchers worldwide",
                                "Environmental conservation organizations",
                                "Beta testers and community contributors",
                                "Open source community"
                            ]
                        )
                        
                        // Mission Statement
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                                
                                Text("Our Mission")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            Text("SustainaBuddy is dedicated to promoting environmental awareness and sustainable living through education, gamification, and community engagement. We believe that small actions can make a big difference in protecting our planet and its incredible biodiversity.")
                                .font(.body)
                                .foregroundColor(.gray)
                                .lineSpacing(4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                        )
                        
                        // Copyright
                        VStack(spacing: 8) {
                            Text("© 2024 SustainaBuddy")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("Made with 💚 for our planet")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.cyan)
            )
        }
    }
    
    private func creditsSection(title: String, icon: String, content: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.cyan)
                    .font(.title2)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(content, id: \.self) { item in
                    HStack(alignment: .top) {
                        Text("•")
                            .foregroundColor(.cyan)
                            .font(.body)
                        
                        Text(item)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

#Preview {
    CreditsView()
}