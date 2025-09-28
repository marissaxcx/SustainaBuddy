//
//  SocialViewModel.swift
//  SustainaBuddy
//
//  ViewModel for Social Features
//

import SwiftUI
import Combine

class SocialViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var leaderboard: [LeaderboardUser] = []
    @Published var activeChallenges: [CommunityChallenge] = []
    @Published var availableChallenges: [CommunityChallenge] = []
    @Published var userRank: Int = 1
    @Published var completedChallenges: Int = 0
    @Published var weeklyProgress: Int = 0
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockData()
    }
    
    func loadSocialData() {
        isLoading = true
        
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadMockData()
            self.isLoading = false
        }
    }
    
    func addFriend(username: String) {
        // Simulate adding friend
        let newFriend = Friend(
            name: username,
            level: Int.random(in: 1...25),
            ecoCredits: Int.random(in: 100...5000),
            rank: Int.random(in: 1...1000),
            isOnline: Bool.random()
        )
        
        friends.append(newFriend)
        friends.sort { $0.ecoCredits > $1.ecoCredits }
    }
    
    func joinChallenge(_ challenge: CommunityChallenge) {
        // Move challenge from available to active
        if let index = availableChallenges.firstIndex(where: { $0.id == challenge.id }) {
            var activeChallenge = availableChallenges.remove(at: index)
            activeChallenge = CommunityChallenge(
                title: activeChallenge.title,
                description: activeChallenge.description,
                emoji: activeChallenge.emoji,
                rewardCredits: activeChallenge.rewardCredits,
                participantCount: activeChallenge.participantCount + 1,
                daysRemaining: activeChallenge.daysRemaining,
                isActive: true,
                progress: 0
            )
            activeChallenges.append(activeChallenge)
        }
    }
    
    func updateChallengeProgress(_ challengeId: UUID, progress: Int) {
        if let index = activeChallenges.firstIndex(where: { $0.id == challengeId }) {
            let challenge = activeChallenges[index]
            activeChallenges[index] = CommunityChallenge(
                title: challenge.title,
                description: challenge.description,
                emoji: challenge.emoji,
                rewardCredits: challenge.rewardCredits,
                participantCount: challenge.participantCount,
                daysRemaining: challenge.daysRemaining,
                isActive: challenge.isActive,
                progress: min(progress, 100)
            )
            
            // If challenge is completed, move to completed challenges
            if progress >= 100 {
                completedChallenges += 1
                activeChallenges.remove(at: index)
            }
        }
    }
    
    func challengeFriend(_ friend: Friend) {
        // Create a friend challenge
        let friendChallenge = CommunityChallenge(
            title: "Challenge \(friend.name)",
            description: "Compete with \(friend.name) in eco-friendly activities!",
            emoji: "⚡",
            rewardCredits: 200,
            participantCount: 2,
            daysRemaining: 7,
            isActive: true,
            progress: 0
        )
        
        activeChallenges.append(friendChallenge)
    }
    
    private func loadMockData() {
        // Mock friends data
        friends = [
            Friend(name: "Alex Chen", level: 15, ecoCredits: 2450, rank: 23, isOnline: true),
            Friend(name: "Maria Rodriguez", level: 22, ecoCredits: 3890, rank: 8, isOnline: false),
            Friend(name: "James Wilson", level: 18, ecoCredits: 2100, rank: 45, isOnline: true),
            Friend(name: "Sarah Kim", level: 25, ecoCredits: 4200, rank: 5, isOnline: true),
            Friend(name: "David Brown", level: 12, ecoCredits: 1800, rank: 67, isOnline: false)
        ]
        
        // Mock leaderboard data
        leaderboard = [
            LeaderboardUser(name: "EcoWarrior2024", level: 30, ecoCredits: 8500),
            LeaderboardUser(name: "GreenGuru", level: 28, ecoCredits: 7800),
            LeaderboardUser(name: "OceanSaver", level: 26, ecoCredits: 7200),
            LeaderboardUser(name: "Sarah Kim", level: 25, ecoCredits: 4200),
            LeaderboardUser(name: "Maria Rodriguez", level: 22, ecoCredits: 3890),
            LeaderboardUser(name: "ClimateChamp", level: 20, ecoCredits: 3500),
            LeaderboardUser(name: "You", level: 19, ecoCredits: 3200),
            LeaderboardUser(name: "Alex Chen", level: 15, ecoCredits: 2450),
            LeaderboardUser(name: "James Wilson", level: 18, ecoCredits: 2100),
            LeaderboardUser(name: "David Brown", level: 12, ecoCredits: 1800)
        ]
        
        // Mock active challenges
        activeChallenges = [
            CommunityChallenge(
                title: "Plastic-Free Week",
                description: "Avoid single-use plastics for 7 days",
                emoji: "🚫",
                rewardCredits: 500,
                participantCount: 1247,
                daysRemaining: 4,
                isActive: true,
                progress: 65
            ),
            CommunityChallenge(
                title: "Ocean Cleanup",
                description: "Document and clean up ocean debris",
                emoji: "🌊",
                rewardCredits: 300,
                participantCount: 892,
                daysRemaining: 12,
                isActive: true,
                progress: 30
            )
        ]
        
        // Mock available challenges
        availableChallenges = [
            CommunityChallenge(
                title: "Sustainable Transport",
                description: "Use eco-friendly transportation for a week",
                emoji: "🚲",
                rewardCredits: 400,
                participantCount: 2156,
                daysRemaining: 8,
                isActive: false,
                progress: 0
            ),
            CommunityChallenge(
                title: "Zero Waste Meals",
                description: "Prepare meals with zero food waste",
                emoji: "🍽️",
                rewardCredits: 350,
                participantCount: 1834,
                daysRemaining: 15,
                isActive: false,
                progress: 0
            ),
            CommunityChallenge(
                title: "Energy Saver",
                description: "Reduce home energy consumption by 20%",
                emoji: "💡",
                rewardCredits: 600,
                participantCount: 3421,
                daysRemaining: 21,
                isActive: false,
                progress: 0
            ),
            CommunityChallenge(
                title: "Plant a Tree",
                description: "Plant or sponsor a tree in your community",
                emoji: "🌳",
                rewardCredits: 250,
                participantCount: 5678,
                daysRemaining: 30,
                isActive: false,
                progress: 0
            ),
            CommunityChallenge(
                title: "Marine Life Guardian",
                description: "Track and protect marine animals in your area",
                emoji: "🐋",
                rewardCredits: 450,
                participantCount: 987,
                daysRemaining: 18,
                isActive: false,
                progress: 0
            )
        ]
        
        // Set user stats
        userRank = 7
        completedChallenges = 12
        weeklyProgress = 78
    }
    
    func refreshData() {
        loadSocialData()
    }
    
    func searchFriends(query: String) -> [Friend] {
        if query.isEmpty {
            return friends
        }
        return friends.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    func getChallengesByCategory(_ category: ChallengeCategory) -> [CommunityChallenge] {
        let allChallenges = availableChallenges + activeChallenges
        
        switch category {
        case .all:
            return allChallenges
        case .ocean:
            return allChallenges.filter { $0.title.contains("Ocean") || $0.title.contains("Marine") }
        case .waste:
            return allChallenges.filter { $0.title.contains("Waste") || $0.title.contains("Plastic") }
        case .energy:
            return allChallenges.filter { $0.title.contains("Energy") || $0.title.contains("Transport") }
        case .nature:
            return allChallenges.filter { $0.title.contains("Tree") || $0.title.contains("Plant") }
        }
    }
}

// MARK: - Supporting Types

enum ChallengeCategory: String, CaseIterable {
    case all = "All"
    case ocean = "Ocean"
    case waste = "Waste"
    case energy = "Energy"
    case nature = "Nature"
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .ocean: return "drop.fill"
        case .waste: return "trash.fill"
        case .energy: return "bolt.fill"
        case .nature: return "leaf.fill"
        }
    }
}

// MARK: - Extensions for CommunityChallenge

extension CommunityChallenge {
    var progressColor: Color {
        switch progress {
        case 0..<25:
            return .red
        case 25..<50:
            return .orange
        case 50..<75:
            return .yellow
        case 75..<100:
            return .green
        default:
            return .glowingCyan
        }
    }
    
    var difficultyLevel: String {
        switch rewardCredits {
        case 0..<300:
            return "Easy"
        case 300..<500:
            return "Medium"
        default:
            return "Hard"
        }
    }
    
    var timeRemaining: String {
        switch daysRemaining {
        case 0:
            return "Ending today"
        case 1:
            return "1 day left"
        default:
            return "\(daysRemaining) days left"
        }
    }
}