//
//  EcoFootprintView.swift
//  SustainaBuddy
//
//  Eco Footprint Tracker and Eco-Credits System
//

import SwiftUI
import Charts

struct EcoFootprintView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = EcoFootprintViewModel()
    @State private var selectedTimeframe: TimeFrame = .week
    @State private var showingActivityLog = false
    @State private var quickLogActivity: EcoActivityType?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header with eco credits and level
                        headerView
                        
                        // Carbon footprint chart
                        footprintChartView
                        
                        // Today's activities
                        todaysActivitiesView
                        
                        // Quick actions
                        quickActionsView
                        
                        // Recent activities
                        recentActivitiesView
                    }
                    .padding()
                }
            }
            .navigationTitle("Eco Footprint")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .navigationBarItems(
                trailing: Button(action: {
                    showingActivityLog = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.glowingCyan)
                        .font(.title2)
                }
            )
        }
        .sheet(isPresented: $showingActivityLog) {
            ActivityLogView()
        }
        .sheet(item: $quickLogActivity) { activity in
            QuickLogSheet(activityType: activity)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // Eco Credits and Level
            HStack {
                VStack(alignment: .leading) {
                    Text("Eco Credits")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                        Text("\(appState.ecoCredits)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.glowingCyan)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Level \(appState.userProfile.level)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(Int(appState.userProfile.sustainabilityScore))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.kawaiPink)
                }
            }
            
            // Progress bar to next level
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Progress to Level \(appState.userProfile.level + 1)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(viewModel.progressToNextLevel)%")
                        .font(.caption)
                        .foregroundColor(.glowingCyan)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.glowingCyan, .kawaiPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(viewModel.progressToNextLevel) / 100, height: 6)
                            .cornerRadius(3)
                            .animation(.easeInOut(duration: 0.5), value: viewModel.progressToNextLevel)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var footprintChartView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Carbon Footprint")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
            
            // Chart placeholder (in a real app, you'd use Swift Charts)
            VStack(spacing: 8) {
                HStack {
                    Text(String(format: "%.1f kg CO₂", viewModel.currentFootprint))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: viewModel.footprintTrend == .down ? "arrow.down" : "arrow.up")
                            .foregroundColor(viewModel.footprintTrend == .down ? .green : .red)
                        Text(String(format: "%.1f%%", viewModel.footprintChange))
                            .font(.caption)
                            .foregroundColor(viewModel.footprintTrend == .down ? .green : .red)
                    }
                }
                
                // Simple bar chart representation
                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(viewModel.chartData, id: \.day) { data in
                        VStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.red.opacity(0.8), .orange.opacity(0.6)],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .frame(width: 30, height: CGFloat(data.value) * 3)
                                .cornerRadius(4)
                            
                            Text(data.day)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 120)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var todaysActivitiesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Impact")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ImpactCard(
                    title: "Transport",
                    value: String(format: "%.1f kg", viewModel.todayTransportCO2),
                    icon: "car.fill",
                    color: .blue
                )
                
                ImpactCard(
                    title: "Energy",
                    value: String(format: "%.1f kg", viewModel.todayEnergyCO2),
                    icon: "bolt.fill",
                    color: .yellow
                )
                
                ImpactCard(
                    title: "Food",
                    value: String(format: "%.1f kg", viewModel.todayFoodCO2),
                    icon: "fork.knife",
                    color: .green
                )
                
                ImpactCard(
                    title: "Waste",
                    value: String(format: "%.1f kg", viewModel.todayWasteCO2),
                    icon: "trash.fill",
                    color: .red
                )
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickActionButton(
                    title: "Bike Ride",
                    icon: "bicycle",
                    color: .blue
                ) {
                    quickLogActivity = .bikeToWork
                }
                
                QuickActionButton(
                    title: "Recycle",
                    icon: "arrow.3.trianglepath",
                    color: .green
                ) {
                    quickLogActivity = .recycled
                }
                
                QuickActionButton(
                    title: "Plant Food",
                    icon: "leaf.fill",
                    color: .green
                ) {
                    quickLogActivity = .vegetarianMeal
                }
                
                QuickActionButton(
                    title: "Add More",
                    icon: "plus",
                    color: .cyan
                ) {
                    showingActivityLog = true
                }
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var recentActivitiesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Activities")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("View All") {
                    // Show full activity history
                }
                .font(.caption)
                .foregroundColor(.glowingCyan)
            }
            
            ForEach(viewModel.recentActivities.prefix(5), id: \.id) { activity in
                EcoActivityRow(activity: activity)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private func logActivity(_ type: EcoActivityType) {
        let activity = EcoActivity(
            type: type,
            timestamp: Date(),
            creditsEarned: type.baseCredits,
            co2Saved: type.co2Impact
        )
        
        viewModel.logActivity(activity)
        appState.ecoCredits += activity.creditsEarned
        
        // Update user profile
        appState.userProfile.totalEcoCredits += activity.creditsEarned
        updateUserLevel()
    }
    
    private func updateUserLevel() {
        let newLevel = max(1, appState.userProfile.totalEcoCredits / 1000)
        if newLevel > appState.userProfile.level {
            appState.userProfile.level = newLevel
            // Show level up animation
        }
        
        // Update sustainability score
        appState.userProfile.sustainabilityScore = min(100, Double(appState.userProfile.totalEcoCredits) / 50.0)
    }
}

// MARK: - Impact Card Component
struct ImpactCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(12)
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title2)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Activity Row Component
struct EcoActivityRow: View {
    let activity: EcoActivity
    
    var body: some View {
        HStack {
            Text(activity.type.emoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.type.displayName)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Text(activity.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                HStack {
                    Image(systemName: "leaf.fill")
                        .font(.caption2)
                        .foregroundColor(.green)
                    Text("+\(activity.creditsEarned)")
                        .font(.caption)
                        .foregroundColor(.glowingCyan)
                }
                
                Text(String(format: "-%.1f kg CO₂", activity.co2Saved))
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Supporting Types
enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

enum FootprintTrend {
    case up, down
}

struct ChartDataPoint {
    let day: String
    let value: Double
}