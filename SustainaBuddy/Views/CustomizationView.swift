//
//  CustomizationView.swift
//  SustainaBuddy
//
//  Created by SustainaBuddy Team
//

import SwiftUI

struct CustomizationView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: CustomizationTab = .accessories
    @State private var selectedAccessoryType: BuddyAccessory.AccessoryType = .hat
    @State private var showingPurchaseAlert = false
    @State private var purchaseMessage = ""
    
    enum CustomizationTab: String, CaseIterable {
        case accessories = "Accessories"
        case outfits = "Outfits"
        
        var icon: String {
            switch self {
            case .accessories: return "eyeglasses"
            case .outfits: return "tshirt"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Buddy Preview
                buddyPreviewSection
                
                // Tab Selector
                tabSelector
                
                // Content
                if selectedTab == .accessories {
                    accessoriesView
                } else {
                    outfitsView
                }
                
                Spacer()
            }
            .navigationTitle("Customize Buddy")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.sleekDark)
        }
        .alert("Purchase Result", isPresented: $showingPurchaseAlert) {
            Button("OK") { }
        } message: {
            Text(purchaseMessage)
        }
    }
    
    private var buddyPreviewSection: some View {
        VStack(spacing: 16) {
            Text("Preview")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(appState.sustainaBuddy.customizedAppearance)
                .font(.system(size: 80))
                .padding()
                .background(Color.frostedGlass)
                .cornerRadius(20)
            
            Text(appState.sustainaBuddy.name)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding()
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(CustomizationTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: tab.icon)
                            .font(.title2)
                        Text(tab.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == tab ? .glowingCyan : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color.frostedGlass)
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var accessoriesView: some View {
        VStack(spacing: 16) {
            // Accessory Type Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(BuddyAccessory.AccessoryType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedAccessoryType = type
                        }) {
                            Text(type.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedAccessoryType == type ? Color.glowingCyan : Color.frostedGlass)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Accessories Grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(accessoriesForSelectedType, id: \.id) { accessory in
                        AccessoryCard(
                            accessory: accessory,
                            isOwned: appState.sustainaBuddy.ownedAccessories.contains { $0.id == accessory.id },
                            isEquipped: appState.sustainaBuddy.equippedAccessories[accessory.type]?.id == accessory.id,
                            ecoCredits: appState.ecoCredits
                        ) { action in
                            handleAccessoryAction(accessory, action: action)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var outfitsView: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(CustomizationStore.availableOutfits, id: \.id) { outfit in
                    OutfitCard(
                        outfit: outfit,
                        isOwned: appState.sustainaBuddy.ownedOutfits.contains { $0.id == outfit.id },
                        isEquipped: appState.sustainaBuddy.currentOutfit?.id == outfit.id,
                        ecoCredits: appState.ecoCredits
                    ) { action in
                        handleOutfitAction(outfit, action: action)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var accessoriesForSelectedType: [BuddyAccessory] {
        CustomizationStore.availableAccessories.filter { $0.type == selectedAccessoryType }
    }
    
    private func handleAccessoryAction(_ accessory: BuddyAccessory, action: ItemAction) {
        switch action {
        case .purchase:
            if appState.sustainaBuddy.purchaseAccessory(accessory, with: &appState.ecoCredits) {
                purchaseMessage = "Successfully purchased \(accessory.name)!"
            } else {
                purchaseMessage = "Not enough Eco Credits to purchase \(accessory.name)."
            }
            showingPurchaseAlert = true
            
        case .equip:
            appState.sustainaBuddy.equipAccessory(accessory)
            
        case .unequip:
            appState.sustainaBuddy.unequipAccessory(type: accessory.type)
        }
    }
    
    private func handleOutfitAction(_ outfit: BuddyOutfit, action: ItemAction) {
        switch action {
        case .purchase:
            if appState.sustainaBuddy.purchaseOutfit(outfit, with: &appState.ecoCredits) {
                purchaseMessage = "Successfully purchased \(outfit.name)!"
            } else {
                purchaseMessage = "Not enough Eco Credits to purchase \(outfit.name)."
            }
            showingPurchaseAlert = true
            
        case .equip:
            appState.sustainaBuddy.equipOutfit(outfit)
            
        case .unequip:
            appState.sustainaBuddy.currentOutfit = nil
        }
    }
}

enum ItemAction {
    case purchase
    case equip
    case unequip
}

struct AccessoryCard: View {
    let accessory: BuddyAccessory
    let isOwned: Bool
    let isEquipped: Bool
    let ecoCredits: Int
    let onAction: (ItemAction) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(accessory.emoji)
                .font(.system(size: 40))
            
            VStack(spacing: 4) {
                Text(accessory.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                if accessory.isPremium {
                    Text("PREMIUM")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            if isOwned {
                Button(action: {
                    onAction(isEquipped ? .unequip : .equip)
                }) {
                    Text(isEquipped ? "Unequip" : "Equip")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(isEquipped ? Color.red : Color.glowingCyan)
                        .cornerRadius(8)
                }
            } else {
                Button(action: {
                    onAction(.purchase)
                }) {
                    HStack(spacing: 4) {
                        Text("\(accessory.cost)")
                        Image(systemName: "leaf.fill")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(ecoCredits >= accessory.cost ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(ecoCredits >= accessory.cost ? Color.green : Color.gray.opacity(0.3))
                    .cornerRadius(8)
                }
                .disabled(ecoCredits < accessory.cost)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(12)
    }
}

struct OutfitCard: View {
    let outfit: BuddyOutfit
    let isOwned: Bool
    let isEquipped: Bool
    let ecoCredits: Int
    let onAction: (ItemAction) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(outfit.emoji)
                .font(.system(size: 40))
            
            VStack(spacing: 4) {
                Text(outfit.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                if outfit.isPremium {
                    Text("PREMIUM")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            if isOwned {
                Button(action: {
                    onAction(isEquipped ? .unequip : .equip)
                }) {
                    Text(isEquipped ? "Unequip" : "Equip")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(isEquipped ? Color.red : Color.glowingCyan)
                        .cornerRadius(8)
                }
            } else if outfit.cost > 0 {
                Button(action: {
                    onAction(.purchase)
                }) {
                    HStack(spacing: 4) {
                        Text("\(outfit.cost)")
                        Image(systemName: "leaf.fill")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(ecoCredits >= outfit.cost ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(ecoCredits >= outfit.cost ? Color.green : Color.gray.opacity(0.3))
                    .cornerRadius(8)
                }
                .disabled(ecoCredits < outfit.cost)
            } else {
                Text("Free")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(12)
    }
}

#Preview {
    CustomizationView()
        .environmentObject(AppState())
}