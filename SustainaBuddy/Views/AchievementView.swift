//
//  AchievementView.swift
//  SustainaBuddy
//
//  Achievement System with Badges, Milestones, and Unlockable Content
//

import SwiftUI

struct AchievementView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AchievementViewModel()
    @State private var selectedCategory: AchievementCategory = .all
    @State private var showingAchievementDetail = false
    @State private var selectedAchievement: Achievement?
    @State private var showingNewAchievement = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with user progress
                    headerView
                    
                    // Category selector
                    categorySelectorView
                    
                    // Achievement content
                    achievementContentView
                }
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .navigationBarItems(
                trailing: Button(action: {
                    viewModel.refreshAchievements()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.glowingCyan)
                        .font(.title2)
                }
            )
        }
        .sheet(item: $selectedAchievement) { achievement in
            AchievementDetailView(achievement: achievement)
        }
        .overlay(
            // New achievement popup
            newAchievementPopup
        )
        .onAppear {
            viewModel.loadAchievements()
        }
        .onReceive(viewModel.$newlyUnlockedAchievement) { achievement in
            if achievement != nil {
                showingNewAchievement = true
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // User level and progress
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Level \(viewModel.userLevel)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.glowingCyan)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(viewModel.currentXP) / \(viewModel.nextLevelXP) XP")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("\(viewModel.xpToNextLevel) XP to next level")
                                .font(.caption2)
                                .foregroundColor(.kawaiPink)
                        }
                    }
                    
                    // XP Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(LinearGradient(
                                    colors: [.glowingCyan, .kawaiBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: geometry.size.width * viewModel.levelProgress, height: 8)
                                .cornerRadius(4)
                                .animation(.easeInOut(duration: 0.5), value: viewModel.levelProgress)
                        }
                    }
                    .frame(height: 8)
                }
            }
            
            // Achievement stats
            HStack(spacing: 20) {
                StatCard(
                    icon: "trophy.fill",
                    value: "\(viewModel.unlockedCount)",
                    label: "Unlocked",
                    color: .yellow
                )
                
                StatCard(
                    icon: "target",
                    value: "\(viewModel.inProgressCount)",
                    label: "In Progress",
                    color: .orange
                )
                
                StatCard(
                    icon: "lock.fill",
                    value: "\(viewModel.lockedCount)",
                    label: "Locked",
                    color: .gray
                )
                
                StatCard(
                    icon: "star.fill",
                    value: "\(viewModel.rareCount)",
                    label: "Rare",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var categorySelectorView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(AchievementCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: category.iconName)
                                .font(.caption)
                            Text(category.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(selectedCategory == category ? .white : .gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            selectedCategory == category ?
                            Color.glowingCyan.opacity(0.8) :
                            Color.frostedGlass
                        )
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }
    
    private var achievementContentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Featured achievements
                if selectedCategory == .all && !viewModel.featuredAchievements.isEmpty {
                    featuredSection
                }
                
                // Recent achievements
                if selectedCategory == .all && !viewModel.recentAchievements.isEmpty {
                    recentSection
                }
                
                // Category achievements
                achievementGridView
            }
            .padding()
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.featuredAchievements) { achievement in
                        FeaturedAchievementCard(achievement: achievement) {
                            selectedAchievement = achievement
                            showingAchievementDetail = true
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Unlocked")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.recentAchievements) { achievement in
                        RecentAchievementCard(achievement: achievement) {
                            selectedAchievement = achievement
                            showingAchievementDetail = true
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var achievementGridView: some View {
        let filteredAchievements = viewModel.getAchievements(for: selectedCategory)
        
        return VStack(alignment: .leading, spacing: 12) {
            if selectedCategory != .all {
                Text(selectedCategory.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(filteredAchievements) { achievement in
                    AchievementCard(achievement: achievement) {
                        selectedAchievement = achievement
                        showingAchievementDetail = true
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var newAchievementPopup: some View {
        if showingNewAchievement, let achievement = viewModel.newlyUnlockedAchievement {
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissNewAchievement()
                    }
                
                VStack(spacing: 20) {
                    // Celebration animation
                    Text("🎉")
                        .font(.system(size: 60))
                        .scaleEffect(showingNewAchievement ? 1.2 : 0.8)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showingNewAchievement)
                    
                    VStack(spacing: 12) {
                        Text("Achievement Unlocked!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.glowingCyan)
                        
                        Text(achievement.emoji)
                            .font(.system(size: 80))
                        
                        Text(achievement.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(achievement.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("+\(achievement.xpReward) XP")
                                .fontWeight(.semibold)
                                .foregroundColor(.glowingCyan)
                        }
                        .padding(.top, 8)
                    }
                    
                    Button("Awesome!") {
                        dismissNewAchievement()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.glowingCyan, .kawaiBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                }
                .padding(32)
                .background(Color.sleekDark)
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(.horizontal, 40)
            }
            .transition(.opacity.combined(with: .scale))
        }
    }
    
    private func dismissNewAchievement() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showingNewAchievement = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewModel.clearNewAchievement()
        }
    }
}

// MARK: - Supporting Views

struct FeaturedAchievementCard: View {
    let achievement: Achievement
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? 
                              LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom) :
                              LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 80, height: 80)
                    
                    if achievement.isUnlocked {
                        Text(achievement.emoji)
                            .font(.system(size: 40))
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    
                    if achievement.rarity == .legendary {
                        Circle()
                            .stroke(Color.purple, lineWidth: 3)
                            .frame(width: 85, height: 85)
                    }
                }
                
                VStack(spacing: 4) {
                    Text(achievement.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    if achievement.isUnlocked {
                        Text("Unlocked")
                            .font(.caption2)
                            .foregroundColor(.green)
                    } else {
                        Text("\(achievement.progress)%")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
            }
            .frame(width: 120)
            .padding()
            .background(Color.frostedGlass)
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentAchievementCard: View {
    let achievement: Achievement
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.glowingCyan, .kawaiBlue],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 50, height: 50)
                    
                    Text(achievement.emoji)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("+\(achievement.xpReward) XP")
                        .font(.caption)
                        .foregroundColor(.glowingCyan)
                }
                
                Spacer()
                
                Text("New!")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.kawaiPink)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color.frostedGlass)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? 
                              achievement.rarity.color :
                              LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 60, height: 60)
                    
                    if achievement.isUnlocked {
                        Text(achievement.emoji)
                            .font(.title)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    
                    // Rarity indicator
                    if achievement.rarity != .common {
                        Circle()
                            .stroke(achievement.rarity.borderColor, lineWidth: 2)
                            .frame(width: 65, height: 65)
                    }
                }
                
                VStack(spacing: 6) {
                    Text(achievement.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    if achievement.isUnlocked {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text("Unlocked")
                                .font(.caption2)
                                .foregroundColor(.green)
                        }
                    } else {
                        VStack(spacing: 2) {
                            Text("\(achievement.progress)%")
                                .font(.caption2)
                                .foregroundColor(.orange)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 3)
                                        .cornerRadius(1.5)
                                    
                                    Rectangle()
                                        .fill(Color.orange)
                                        .frame(width: geometry.size.width * CGFloat(achievement.progress) / 100, height: 3)
                                        .cornerRadius(1.5)
                                }
                            }
                            .frame(height: 3)
                        }
                    }
                }
            }
            .padding()
            .background(Color.frostedGlass)
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Models and Enums

enum AchievementCategory: String, CaseIterable {
    case all = "All"
    case ocean = "Ocean"
    case sustainability = "Sustainability"
    case social = "Social"
    case buddy = "Buddy Care"
    case dining = "Eco Dining"
    case milestones = "Milestones"
    
    var iconName: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .ocean: return "drop.fill"
        case .sustainability: return "leaf.fill"
        case .social: return "person.2.fill"
        case .buddy: return "heart.fill"
        case .dining: return "fork.knife"
        case .milestones: return "flag.fill"
        }
    }
}

enum AchievementRarity: String, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: LinearGradient {
        switch self {
        case .common:
            return LinearGradient(colors: [.gray, .white], startPoint: .top, endPoint: .bottom)
        case .rare:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
        case .epic:
            return LinearGradient(colors: [.purple, .pink], startPoint: .top, endPoint: .bottom)
        case .legendary:
            return LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .common: return .clear
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .yellow
        }
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let emoji: String
    let category: AchievementCategory
    let rarity: AchievementRarity
    let xpReward: Int
    let isUnlocked: Bool
    let progress: Int
    let requirements: [String]
    let unlockedDate: Date?
    let isSecret: Bool
}

// MARK: - Preview

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView()
            .environmentObject(AppState())
            .preferredColorScheme(.dark)
    }
}