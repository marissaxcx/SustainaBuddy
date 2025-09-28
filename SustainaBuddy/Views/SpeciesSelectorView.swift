//
//  SpeciesSelectorView.swift
//  SustainaBuddy
//
//  Species Selection for SustainaBuddy
//

import SwiftUI

struct SpeciesSelectorView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSpecies: BuddySpecies
    @State private var showingProUpgrade = false
    
    init() {
        _selectedSpecies = State(initialValue: .seaOtter)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerView
                        
                        // Free species
                        freeSpeciesSection
                        
                        // Premium species
                        premiumSpeciesSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Choose Your Buddy")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Select") {
                    selectSpecies()
                }
                .disabled(selectedSpecies.isPremium && !isPremiumUser)
            )
        }
        .sheet(isPresented: $showingProUpgrade) {
            ProUpgradeView()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Text("Choose your marine companion!")
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Each species has unique characteristics and care requirements.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var freeSpeciesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Free Species")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(BuddySpecies.allCases.filter { !$0.isPremium }, id: \.self) { species in
                    SpeciesCard(
                        species: species,
                        isSelected: selectedSpecies == species,
                        isPremium: false
                    ) {
                        selectedSpecies = species
                    }
                }
            }
        }
    }
    
    private var premiumSpeciesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Premium Species")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(BuddySpecies.allCases.filter { $0.isPremium }, id: \.self) { species in
                    SpeciesCard(
                        species: species,
                        isSelected: selectedSpecies == species,
                        isPremium: true
                    ) {
                        if isPremiumUser {
                            selectedSpecies = species
                        } else {
                            showingProUpgrade = true
                        }
                    }
                }
            }
            
            if !isPremiumUser {
                Button(action: {
                    showingProUpgrade = true
                }) {
                    HStack {
                        Image(systemName: "crown.fill")
                        Text("Upgrade to SustainaBuddy Pro")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var isPremiumUser: Bool {
        // In a real app, this would check the user's subscription status
        false
    }
    
    private func selectSpecies() {
        if !selectedSpecies.isPremium || isPremiumUser {
            appState.sustainaBuddy.species = selectedSpecies
            dismiss()
        }
    }
}

// MARK: - Species Card Component
struct SpeciesCard: View {
    let species: BuddySpecies
    let isSelected: Bool
    let isPremium: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Text(species.emoji)
                        .font(.system(size: 50))
                    
                    if isPremium {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                            Spacer()
                        }
                    }
                }
                
                Text(species.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(speciesDescription(for: species))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 140)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.glowingCyan.opacity(0.3) : Color.frostedGlass)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.glowingCyan : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(isPremium && !isSelected ? 0.6 : 1.0)
    }
    
    private func speciesDescription(for species: BuddySpecies) -> String {
        switch species {
        case .seaOtter:
            return "Playful and social. Loves to float and play."
        case .turtle:
            return "Calm and wise. Enjoys peaceful environments."
        case .dolphin:
            return "Intelligent and energetic. Needs lots of interaction."
        case .whale:
            return "Majestic and gentle. Requires spacious habitat."
        case .manatee:
            return "Gentle giant. Slow-moving but very affectionate."
        case .belugaWhale:
            return "Arctic beauty. Highly social and vocal."
        }
    }
}

// MARK: - Name Editor View
struct NameEditorView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var newName: String
    
    init() {
        _newName = State(initialValue: "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Current buddy display
                    VStack(spacing: 16) {
                        Text(appState.sustainaBuddy.species.emoji)
                            .font(.system(size: 80))
                        
                        Text("Current name: \(appState.sustainaBuddy.name)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.frostedGlass)
                    .cornerRadius(15)
                    
                    // Name input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("New Name")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextField("Enter buddy name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title2)
                    }
                    .padding()
                    .background(Color.frostedGlass)
                    .cornerRadius(15)
                    
                    // Suggested names
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Suggested Names")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                            ForEach(suggestedNames, id: \.self) { name in
                                Button(name) {
                                    newName = name
                                }
                                .font(.subheadline)
                                .foregroundColor(.glowingCyan)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.frostedGlass)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.frostedGlass)
                    .cornerRadius(15)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Name Your Buddy")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveName()
                }
                .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
        }
        .onAppear {
            newName = appState.sustainaBuddy.name
        }
    }
    
    private var suggestedNames: [String] {
        switch appState.sustainaBuddy.species {
        case .seaOtter:
            return ["Ollie", "Pearl", "Splash", "Kelp", "Whiskers", "Bubbles"]
        case .turtle:
            return ["Shelly", "Crush", "Sage", "Coral", "Neptune", "Marina"]
        case .dolphin:
            return ["Echo", "Flipper", "Aqua", "Sonic", "Wave", "Splash"]
        case .whale:
            return ["Moby", "Blue", "Ocean", "Titan", "Deep", "Majesty"]
        case .manatee:
            return ["Gentle", "Serenity", "Calm", "Peaceful", "Grace", "Zen"]
        case .belugaWhale:
            return ["Arctic", "Snow", "Crystal", "Frost", "Polar", "Ice"]
        }
    }
    
    private func saveName() {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            appState.sustainaBuddy.name = trimmedName
            dismiss()
        }
    }
}

// MARK: - Pro Upgrade View
struct ProUpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.yellow)
                            
                            Text("SustainaBuddy Pro")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Unlock premium species and exclusive features")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Features list
                        VStack(alignment: .leading, spacing: 16) {
                            FeatureRow(icon: "🦭", title: "Premium Species", description: "Manatee, Beluga Whale, and more")
                            FeatureRow(icon: "🏠", title: "Rare Decorations", description: "Exclusive habitat items and themes")
                            FeatureRow(icon: "📊", title: "Advanced Analytics", description: "Detailed tracking and insights")
                            FeatureRow(icon: "🎯", title: "Priority Support", description: "Get help when you need it")
                        }
                        .padding()
                        .background(Color.frostedGlass)
                        .cornerRadius(15)
                        
                        // Pricing
                        VStack(spacing: 16) {
                            Text("$4.99/month")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Cancel anytime")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Button("Start Free Trial") {
                                // Handle subscription
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                        .padding()
                        .background(Color.frostedGlass)
                        .cornerRadius(15)
                    }
                    .padding()
                }
            }
            .navigationTitle("Upgrade")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .navigationBarItems(
                trailing: Button("Close") {
                    dismiss()
                }
            )
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}