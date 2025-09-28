//
//  SocialView.swift
//  SustainaBuddy
//
//  Social Features: Friends, Leaderboards, and Community Challenges
//

import SwiftUI

struct SocialView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authManager: AppleAuthManager
    @StateObject private var viewModel = SocialViewModel()
    @State private var selectedTab: SocialTab = .friends
    @State private var showingAddFriend = false
    @State private var showingChallengeDetail = false
    @State private var selectedChallenge: CommunityChallenge?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with user stats
                    headerView
                    
                    // Tab selector
                    tabSelectorView
                    
                    // Content based on selected tab
                    contentView
                }
            }
            .navigationTitle("Social Hub")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddFriend = true
                }) {
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(.glowingCyan)
                        .font(.title2)
                }
            )
        }
        .sheet(isPresented: $showingAddFriend) {
            AddFriendView()
        }
        .sheet(item: $selectedChallenge) { challenge in
            ChallengeDetailView(challenge: challenge)
        }
        .onAppear {
            viewModel.loadSocialData()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                // User avatar and info
                VStack {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [.kawaiBlue, .kawaiPink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 60, height: 60)
                        
                        Text(String(appState.userProfile.name.prefix(1)))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Text(appState.userProfile.name)
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Stats grid
                HStack(spacing: 20) {
                    StatCard(icon: "trophy.fill", value: "#\(viewModel.userRank)", label: "Rank", color: .yellow)
                    StatCard(icon: "person.2.fill", value: "\(viewModel.friends.count)", label: "Friends", color: .kawaiBlue)
                    StatCard(icon: "target", value: "\(viewModel.completedChallenges)", label: "Challenges", color: .green)
                }
            }

            // Weekly progress bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Weekly Progress")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(viewModel.weeklyProgress)%")
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
                            .fill(LinearGradient(
                                colors: [.glowingCyan, .kawaiPink],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: geometry.size.width * CGFloat(viewModel.weeklyProgress) / 100, height: 6)
                            .cornerRadius(3)
                            .animation(.easeInOut(duration: 0.5), value: viewModel.weeklyProgress)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
        .padding(.horizontal)
        .onAppear {
            // If signed in with Apple, prefer that display name
            let name = authManager.displayName.trimmingCharacters(in: .whitespaces)
            if !name.isEmpty {
                appState.userProfile.name = name
            }
        }
    }
    
    private var tabSelectorView: some View {
        HStack(spacing: 0) {
            ForEach(SocialTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.title3)
                        Text(tab.rawValue)
                            .font(.caption)
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
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .friends:
            friendsView
        case .leaderboard:
            leaderboardView
        case .challenges:
            challengesView
        }
    }
    
    private var friendsView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.friends) { friend in
                    FriendCard(friend: friend)
                }
                
                if viewModel.friends.isEmpty {
                    EmptyStateView(
                        icon: "person.2.fill",
                        title: "No Friends Yet",
                        subtitle: "Add friends to compete and share your eco-journey!"
                    )
                }
            }
            .padding()
        }
    }
    
    private var leaderboardView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Top 3 podium
                if viewModel.leaderboard.count >= 3 {
                    PodiumView(topThree: Array(viewModel.leaderboard.prefix(3)))
                }
                
                // Rest of leaderboard
                LazyVStack(spacing: 8) {
                    ForEach(Array(viewModel.leaderboard.enumerated()), id: \.element.id) { index, user in
                        LeaderboardRow(user: user, rank: index + 1, isCurrentUser: user.name == appState.userProfile.name)
                    }
                }
            }
            .padding()
        }
    }
    
    private var challengesView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Active challenges
                if !viewModel.activeChallenges.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Active Challenges")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.activeChallenges) { challenge in
                            ChallengeCard(challenge: challenge) {
                                selectedChallenge = challenge
                                showingChallengeDetail = true
                            }
                        }
                    }
                }
                
                // Available challenges
                VStack(alignment: .leading, spacing: 12) {
                    Text("Available Challenges")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(viewModel.availableChallenges) { challenge in
                        ChallengeCard(challenge: challenge) {
                            selectedChallenge = challenge
                            showingChallengeDetail = true
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Supporting Views

struct FriendCard: View {
    let friend: Friend
    
    var body: some View {
        HStack {
            // Avatar
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.kawaiBlue.opacity(0.7), .kawaiPink.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 50, height: 50)
                
                Text(String(friend.name.prefix(1)))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Level \(friend.level) • \(friend.ecoCredits) credits")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if friend.isOnline {
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("Online")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Button("Challenge") {
                    // Challenge friend action
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.glowingCyan.opacity(0.2))
                .foregroundColor(.glowingCyan)
                .cornerRadius(8)
                
                Text("#\(friend.rank)")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(12)
    }
}

struct PodiumView: View {
    let topThree: [LeaderboardUser]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            // 2nd place
            if topThree.count > 1 {
                PodiumPosition(user: topThree[1], position: 2, height: 80)
            }
            
            // 1st place
            PodiumPosition(user: topThree[0], position: 1, height: 100)
            
            // 3rd place
            if topThree.count > 2 {
                PodiumPosition(user: topThree[2], position: 3, height: 60)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
}

struct PodiumPosition: View {
    let user: LeaderboardUser
    let position: Int
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            // Crown for 1st place
            if position == 1 {
                Text("👑")
                    .font(.title)
            }
            
            // Avatar
            ZStack {
                Circle()
                    .fill(positionColor)
                    .frame(width: 50, height: 50)
                
                Text(String(user.name.prefix(1)))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text(user.name)
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text("\(user.ecoCredits)")
                .font(.caption2)
                .foregroundColor(.gray)
            
            // Podium base
            Rectangle()
                .fill(positionColor.opacity(0.3))
                .frame(width: 60, height: height)
                .cornerRadius(8)
                .overlay(
                    Text("\(position)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(positionColor)
                )
        }
    }
    
    private var positionColor: Color {
        switch position {
        case 1: return .yellow
        case 2: return .gray
        case 3: return Color.orange
        default: return .blue
        }
    }
}

struct LeaderboardRow: View {
    let user: LeaderboardUser
    let rank: Int
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(isCurrentUser ? .glowingCyan : .gray)
                .frame(width: 40, alignment: .leading)
            
            ZStack {
                Circle()
                    .fill(isCurrentUser ? Color.glowingCyan.opacity(0.3) : Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                Text(String(user.name.prefix(1)))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.subheadline)
                    .fontWeight(isCurrentUser ? .bold : .regular)
                    .foregroundColor(isCurrentUser ? .glowingCyan : .white)
                
                Text("Level \(user.level)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(user.ecoCredits)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(isCurrentUser ? .glowingCyan : .white)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(isCurrentUser ? Color.glowingCyan.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}

struct ChallengeCard: View {
    let challenge: CommunityChallenge
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(challenge.emoji)
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(challenge.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(challenge.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text("+\(challenge.rewardCredits)")
                                .font(.caption)
                                .foregroundColor(.glowingCyan)
                        }
                        
                        Text("\(challenge.participantCount) joined")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                // Progress bar for active challenges
                if challenge.isActive {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Progress")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("\(challenge.progress)%")
                                .font(.caption)
                                .foregroundColor(.glowingCyan)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 4)
                                    .cornerRadius(2)
                                
                                Rectangle()
                                    .fill(Color.glowingCyan)
                                    .frame(width: geometry.size.width * CGFloat(challenge.progress) / 100, height: 4)
                                    .cornerRadius(2)
                            }
                        }
                        .frame(height: 4)
                    }
                }
                
                HStack {
                    Text("Ends in \(challenge.daysRemaining) days")
                        .font(.caption2)
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    if challenge.isActive {
                        Text("ACTIVE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(4)
                    }
                }
            }
            .padding()
            .background(Color.frostedGlass)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
    }
}

// MARK: - Enums and Models

enum SocialTab: String, CaseIterable {
    case friends = "Friends"
    case leaderboard = "Leaderboard"
    case challenges = "Challenges"
    
    var iconName: String {
        switch self {
        case .friends: return "person.2.fill"
        case .leaderboard: return "trophy.fill"
        case .challenges: return "target"
        }
    }
}

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let level: Int
    let ecoCredits: Int
    let rank: Int
    let isOnline: Bool
}

struct LeaderboardUser: Identifiable {
    let id = UUID()
    let name: String
    let level: Int
    let ecoCredits: Int
}

struct CommunityChallenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let emoji: String
    let rewardCredits: Int
    let participantCount: Int
    let daysRemaining: Int
    let isActive: Bool
    let progress: Int
}

// MARK: - Preview}

// MARK: - Color Extensions
extension Color {
    static let sleekDark = Color(red: 0.1, green: 0.1, blue: 0.15)
    static let frostedGlass = Color(red: 0.15, green: 0.15, blue: 0.2).opacity(0.8)
    static let glowingCyan = Color(red: 0.0, green: 0.8, blue: 1.0)
    static let kawaiBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let kawaiPink = Color(red: 1.0, green: 0.7, blue: 0.8)
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
            .environmentObject(AppState())
            .preferredColorScheme(.dark)
    }
}