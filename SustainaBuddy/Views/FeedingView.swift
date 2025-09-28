//
//  FeedingView.swift
//  SustainaBuddy
//
//  Created by Assistant on 2025-01-14.
//

import SwiftUI

struct FeedingView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    var onFeedingComplete: (() -> Void)? = nil
    
    let ecoFoods = [
        EcoFood(name: "Kelp Salad", emoji: "🥬", nutritionValue: 25, cost: 8, description: "Fresh ocean kelp rich in minerals"),
        EcoFood(name: "Plankton Soup", emoji: "🍲", nutritionValue: 30, cost: 10, description: "Nutritious plankton broth"),
        EcoFood(name: "Algae Smoothie", emoji: "🥤", nutritionValue: 20, cost: 6, description: "Refreshing algae blend"),
        EcoFood(name: "Sea Berries", emoji: "🫐", nutritionValue: 15, cost: 5, description: "Sweet ocean berries"),
        EcoFood(name: "Coral Treats", emoji: "🍬", nutritionValue: 35, cost: 15, description: "Premium coral-based snacks"),
        EcoFood(name: "Seaweed Wraps", emoji: "🌯", nutritionValue: 40, cost: 18, description: "Filling seaweed wraps with nutrients")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerView
                        
                        // Food Options
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ForEach(ecoFoods, id: \.name) { food in
                                FoodCard(food: food) {
                                    feedBuddy(with: food)
                                }
                            }
                        }
                        
                        // Nutrition Info
                        nutritionInfoView
                    }
                    .padding()
                }
            }
            .navigationTitle("Feed \(appState.sustainaBuddy.name)")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.glowingCyan)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Text(appState.sustainaBuddy.species.emoji)
                .font(.system(size: 60))
            
            Text("Hunger: \(appState.sustainaBuddy.hunger)/100")
                .font(.headline)
                .foregroundColor(hungerColor)
            
            ProgressView(value: Double(appState.sustainaBuddy.hunger), total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: hungerColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var nutritionInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nutrition Tips")
                .font(.headline)
                .foregroundColor(.glowingCyan)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("• Feed regularly to maintain happiness")
                Text("• Different foods provide varying nutrition")
                Text("• Premium foods cost more but provide better benefits")
                Text("• Overfeeding won't provide extra benefits")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var hungerColor: Color {
        switch appState.sustainaBuddy.hunger {
        case 0..<30: return .red
        case 30..<60: return .orange
        case 60..<80: return .yellow
        default: return .green
        }
    }
    
    private func feedBuddy(with food: EcoFood) {
        guard appState.ecoCredits >= food.cost else { return }
        
        // Trigger food animation on main view
        onFeedingComplete?()
        
        withAnimation(.spring()) {
            appState.ecoCredits -= food.cost
            appState.sustainaBuddy.hunger = min(100, appState.sustainaBuddy.hunger + food.nutritionValue)
            appState.sustainaBuddy.happiness = min(100, appState.sustainaBuddy.happiness + (food.nutritionValue / 3))
            appState.sustainaBuddy.health = min(100, appState.sustainaBuddy.health + (food.nutritionValue / 5))
            appState.sustainaBuddy.lastFed = Date()
            
            // Update mood by modifying the buddy directly
            var updatedBuddy = appState.sustainaBuddy
            updatedBuddy.updateMood()
            appState.sustainaBuddy = updatedBuddy
        }
    }
}

struct EcoFood {
    let name: String
    let emoji: String
    let nutritionValue: Int
    let cost: Int
    let description: String
}

struct FoodCard: View {
    let food: EcoFood
    let action: () -> Void
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(food.emoji)
                    .font(.system(size: 40))
                
                Text(food.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(food.description)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "leaf.fill")
                        .font(.caption2)
                        .foregroundColor(.green)
                    Text("\(food.cost)")
                        .font(.caption2)
                        .foregroundColor(.glowingCyan)
                    
                    Spacer()
                    
                    Text("+\(food.nutritionValue)")
                        .font(.caption2)
                        .foregroundColor(.kawaiPink)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(appState.ecoCredits >= food.cost ? Color.frostedGlass : Color.gray.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(appState.ecoCredits >= food.cost ? Color.clear : Color.red.opacity(0.5), lineWidth: 1)
            )
        }
        .disabled(appState.ecoCredits < food.cost)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FeedingView()
        .environmentObject(AppState())
}