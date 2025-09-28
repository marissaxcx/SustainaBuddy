//
//  ActivityLogView.swift
//  SustainaBuddy
//
//  Activity Logging View for Eco-Footprint Tracker
//

import SwiftUI

struct ActivityLogView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = EcoFootprintViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedCategory: ActivityCategory = .transportation
    @State private var selectedActivity: EcoActivityType?
    @State private var notes = ""
    @State private var showingSuccessAlert = false
    @State private var creditsEarned = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Category Selector
                    categorySelector
                    
                    // Activity List
                    activityList
                    
                    // Notes Section
                    notesSection
                    
                    // Log Button
                    logButton
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Activity Logged!", isPresented: $showingSuccessAlert) {
            Button("Great!") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("You earned \(creditsEarned) Eco-Credits! Keep up the great work.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            
            Spacer()
            
            VStack {
                Text("Log Activity")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Earn Eco-Credits for sustainable actions")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Current Credits
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(appState.ecoCredits)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                
                Text("Credits")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ActivityCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                        selectedActivity = nil // Reset selection when category changes
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 16)
    }
    
    private var activityList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(activitiesForSelectedCategory, id: \.self) { activity in
                    ActivityRow(
                        activity: activity,
                        isSelected: selectedActivity == activity
                    ) {
                        selectedActivity = activity
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes (Optional)")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            TextField("Add details about your activity...", text: $notes, axis: .vertical)
                .foregroundColor(.white)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding(.horizontal)
                .lineLimit(3...6)
        }
        .padding(.vertical, 16)
    }
    
    private var logButton: some View {
        Button(action: logActivity) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                
                Text("Log Activity")
                    .fontWeight(.semibold)
                
                if let activity = selectedActivity {
                    Text("(+\(activity.baseCredits) Credits)")
                        .fontWeight(.medium)
                }
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedActivity != nil ? Color.cyan : Color.gray.opacity(0.3))
            )
        }
        .disabled(selectedActivity == nil)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    private var activitiesForSelectedCategory: [EcoActivityType] {
        EcoActivityType.allCases.filter { $0.category == selectedCategory }
    }
    
    private func logActivity() {
        guard let activity = selectedActivity else { return }
        
        let ecoActivity = EcoActivity(
            type: activity,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Add credits to user profile
        appState.ecoCredits += ecoActivity.creditsEarned
        creditsEarned = ecoActivity.creditsEarned
        
        // Log the activity (in a real app, this would be saved to persistent storage)
        viewModel.logActivity(ecoActivity)
        
        // Show success alert
        showingSuccessAlert = true
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let category: ActivityCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? category.color : Color.gray.opacity(0.2))
            )
            .foregroundColor(isSelected ? .black : .gray)
        }
    }
}

// MARK: - Activity Row
struct ActivityRow: View {
    let activity: EcoActivityType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Activity Icon
                ZStack {
                    Circle()
                        .fill(activity.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(activity.emoji)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.displayName)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack {
                        Text("+\(activity.baseCredits) Credits")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan)
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Text("\(String(format: "%.1f", activity.co2Impact)) kg CO₂ saved")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Selection Indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .cyan : .gray)
                    .font(.title2)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.cyan : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Quick Log Sheet
struct QuickLogSheet: View {
    let activityType: EcoActivityType
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var notes = ""
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Activity Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(activityType.color.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Text(activityType.emoji)
                                .font(.system(size: 40))
                        }
                        
                        VStack(spacing: 4) {
                            Text(activityType.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("+\(activityType.baseCredits) Eco-Credits")
                                .font(.headline)
                                .foregroundColor(.cyan)
                        }
                        
                        Text("\(String(format: "%.1f", activityType.co2Impact)) kg CO₂ saved")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (Optional)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextField("Add details about your activity...", text: $notes, axis: .vertical)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                            )
                            .lineLimit(3...6)
                    }
                    
                    Spacer()
                    
                    // Log Button
                    Button(action: logActivity) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                            
                            Text("Log Activity")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cyan)
                        )
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.cyan)
            )
        }
        .alert("Activity Logged!", isPresented: $showingSuccess) {
            Button("Great!") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("You earned \(activityType.baseCredits) Eco-Credits! Keep up the great work.")
        }
    }
    
    private func logActivity() {
        let activity = EcoActivity(
            type: activityType,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Add credits to user profile
        appState.ecoCredits += activity.creditsEarned
        
        // Show success alert
        showingSuccess = true
    }
}

#Preview {
    ActivityLogView()
        .environmentObject(AppState())
}

#Preview("Quick Log") {
    QuickLogSheet(activityType: .bikeToWork)
        .environmentObject(AppState())
}