//
//  ChallengeDetailView.swift
//  SustainaBuddy
//
//  Challenge Detail Modal View
//

import SwiftUI

struct ChallengeDetailView: View {
    let challenge: CommunityChallenge
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ChallengeDetailViewModel()
    @State private var showingJoinConfirmation = false
    @State private var showingLeaderboard = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with challenge info
                        headerView
                        
                        // Progress section (if active)
                        if challenge.isActive {
                            progressView
                        }
                        
                        // Description and details
                        detailsView
                        
                        // Participants and leaderboard
                        participantsView
                        
                        // Tips and strategies
                        tipsView
                        
                        // Action buttons
                        actionButtonsView
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationTitle("Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.white)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.glowingCyan),
                trailing: Button(action: {
                    shareChallenge()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.glowingCyan)
                }
            )
        }
        .sheet(isPresented: $showingLeaderboard) {
            ChallengeLeaderboardView(challenge: challenge)
        }
        .alert("Join Challenge?", isPresented: $showingJoinConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Join") {
                joinChallenge()
            }
        } message: {
            Text("Are you ready to take on the \(challenge.title) challenge?")
        }
        .onAppear {
            viewModel.loadChallengeDetails(challenge)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // Challenge emoji and title
            VStack(spacing: 12) {
                Text(challenge.emoji)
                    .font(.system(size: 80))
                
                Text(challenge.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(challenge.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            // Stats row
            HStack(spacing: 20) {
                StatItem(
                    icon: "leaf.fill",
                    value: "+\(challenge.rewardCredits)",
                    label: "Credits",
                    color: .green
                )
                
                StatItem(
                    icon: "person.2.fill",
                    value: "\(challenge.participantCount)",
                    label: "Joined",
                    color: .kawaiBlue
                )
                
                StatItem(
                    icon: "clock.fill",
                    value: "\(challenge.daysRemaining)",
                    label: "Days Left",
                    color: .orange
                )
                
                StatItem(
                    icon: "star.fill",
                    value: challenge.difficultyLevel,
                    label: "Difficulty",
                    color: .yellow
                )
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(20)
    }
    
    private var progressView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(challenge.progress)%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.glowingCyan)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 12)
                        .cornerRadius(6)
                    
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [.glowingCyan, .kawaiBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: geometry.size.width * CGFloat(challenge.progress) / 100, height: 12)
                        .cornerRadius(6)
                        .animation(.easeInOut(duration: 0.5), value: challenge.progress)
                }
            }
            .frame(height: 12)
            
            // Milestones
            HStack {
                ForEach(viewModel.milestones, id: \.percentage) { milestone in
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(challenge.progress >= milestone.percentage ? Color.glowingCyan : Color.gray.opacity(0.3))
                                .frame(width: 20, height: 20)
                            
                            if challenge.progress >= milestone.percentage {
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Text(milestone.title)
                            .font(.caption2)
                            .foregroundColor(challenge.progress >= milestone.percentage ? .glowingCyan : .gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    if milestone != viewModel.milestones.last {
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var detailsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Challenge Details")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                DetailRow(
                    icon: "target",
                    title: "Objective",
                    description: viewModel.challengeObjective
                )
                
                DetailRow(
                    icon: "calendar",
                    title: "Duration",
                    description: viewModel.challengeDuration
                )
                
                DetailRow(
                    icon: "checkmark.circle",
                    title: "Requirements",
                    description: viewModel.challengeRequirements
                )
                
                DetailRow(
                    icon: "trophy",
                    title: "Rewards",
                    description: viewModel.challengeRewards
                )
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var participantsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Community")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("View All") {
                    showingLeaderboard = true
                }
                .font(.caption)
                .foregroundColor(.glowingCyan)
            }
            
            // Top participants
            VStack(spacing: 8) {
                ForEach(Array(viewModel.topParticipants.enumerated()), id: \.element.id) { index, participant in
                    ParticipantRow(participant: participant, rank: index + 1)
                }
            }
            
            // Join stats
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(challenge.participantCount) participants")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.completionRate)% completion rate")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: -8) {
                    ForEach(0..<min(5, viewModel.recentParticipants.count), id: \.self) { index in
                        Circle()
                            .fill(LinearGradient(
                                colors: [.kawaiBlue.opacity(0.7), .kawaiPink.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Text(String(viewModel.recentParticipants[index].name.prefix(1)))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                    
                    if viewModel.recentParticipants.count > 5 {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Text("+\(viewModel.recentParticipants.count - 5)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var tipsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tips & Strategies")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(viewModel.tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .font(.title3)
                            .foregroundColor(.yellow)
                        
                        Text(tip)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            if challenge.isActive {
                // Update progress button
                Button(action: {
                    updateProgress()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Update Progress")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.glowingCyan, .kawaiBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
            } else {
                // Join challenge button
                Button(action: {
                    showingJoinConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Join Challenge")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.green, .kawaiBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
            
            // Secondary actions
            HStack(spacing: 12) {
                Button(action: {
                    inviteFriends()
                }) {
                    HStack {
                        Image(systemName: "person.2")
                        Text("Invite Friends")
                    }
                    .font(.subheadline)
                    .foregroundColor(.glowingCyan)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.glowingCyan.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Button(action: {
                    showingLeaderboard = true
                }) {
                    HStack {
                        Image(systemName: "trophy")
                        Text("Leaderboard")
                    }
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func joinChallenge() {
        // Simulate joining challenge
        presentationMode.wrappedValue.dismiss()
    }
    
    private func updateProgress() {
        // Show progress update interface
        viewModel.showProgressUpdate = true
    }
    
    private func inviteFriends() {
        // Show friend invitation interface
    }
    
    private func shareChallenge() {
        // Share challenge with others
    }
}

// MARK: - Supporting Views

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.glowingCyan)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

struct ParticipantRow: View {
    let participant: ChallengeParticipant
    let rank: Int
    
    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
                .frame(width: 30, alignment: .leading)
            
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.kawaiBlue.opacity(0.7), .kawaiPink.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 30, height: 30)
                
                Text(String(participant.name.prefix(1)))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(participant.name)
                    .font(.caption)
                    .foregroundColor(.white)
                
                Text("\(participant.progress)% complete")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("+\(participant.pointsEarned)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.green)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Challenge Leaderboard View

struct ChallengeLeaderboardView: View {
    let challenge: CommunityChallenge
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                VStack {
                    Text("Challenge Leaderboard")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("Coming soon - Full leaderboard view")
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.glowingCyan)
            )
        }
    }
}

// MARK: - Models and ViewModel

struct ChallengeMilestone: Equatable {
    let percentage: Int
    let title: String
    let reward: String
}

struct ChallengeParticipant: Identifiable {
    let id = UUID()
    let name: String
    let progress: Int
    let pointsEarned: Int
}

class ChallengeDetailViewModel: ObservableObject {
    @Published var milestones: [ChallengeMilestone] = []
    @Published var topParticipants: [ChallengeParticipant] = []
    @Published var recentParticipants: [ChallengeParticipant] = []
    @Published var tips: [String] = []
    @Published var challengeObjective = ""
    @Published var challengeDuration = ""
    @Published var challengeRequirements = ""
    @Published var challengeRewards = ""
    @Published var completionRate = 0
    @Published var showProgressUpdate = false
    
    func loadChallengeDetails(_ challenge: CommunityChallenge) {
        // Load challenge-specific data
        loadMilestones(for: challenge)
        loadParticipants(for: challenge)
        loadTips(for: challenge)
        loadChallengeInfo(for: challenge)
    }
    
    private func loadMilestones(for challenge: CommunityChallenge) {
        milestones = [
            ChallengeMilestone(percentage: 25, title: "Started", reward: "50 pts"),
            ChallengeMilestone(percentage: 50, title: "Halfway", reward: "100 pts"),
            ChallengeMilestone(percentage: 75, title: "Almost There", reward: "150 pts"),
            ChallengeMilestone(percentage: 100, title: "Complete", reward: "\(challenge.rewardCredits) pts")
        ]
    }
    
    private func loadParticipants(for challenge: CommunityChallenge) {
        topParticipants = [
            ChallengeParticipant(name: "EcoChampion", progress: 95, pointsEarned: 450),
            ChallengeParticipant(name: "GreenGuru", progress: 87, pointsEarned: 380),
            ChallengeParticipant(name: "OceanSaver", progress: 82, pointsEarned: 350)
        ]
        
        recentParticipants = [
            ChallengeParticipant(name: "Alex", progress: 45, pointsEarned: 200),
            ChallengeParticipant(name: "Maria", progress: 67, pointsEarned: 280),
            ChallengeParticipant(name: "James", progress: 23, pointsEarned: 120),
            ChallengeParticipant(name: "Sarah", progress: 78, pointsEarned: 320),
            ChallengeParticipant(name: "David", progress: 56, pointsEarned: 240),
            ChallengeParticipant(name: "Emma", progress: 34, pointsEarned: 150)
        ]
        
        completionRate = 73
    }
    
    private func loadTips(for challenge: CommunityChallenge) {
        switch challenge.title {
        case "Plastic-Free Week":
            tips = [
                "Bring reusable bags when shopping",
                "Use a refillable water bottle",
                "Choose products with minimal packaging",
                "Opt for glass or metal containers over plastic"
            ]
        case "Ocean Cleanup":
            tips = [
                "Join local beach cleanup events",
                "Document debris with photos for tracking",
                "Focus on microplastics and small items",
                "Share your cleanup efforts on social media"
            ]
        default:
            tips = [
                "Start small and build momentum",
                "Track your daily progress",
                "Connect with other participants",
                "Celebrate small wins along the way"
            ]
        }
    }
    
    private func loadChallengeInfo(for challenge: CommunityChallenge) {
        challengeObjective = challenge.description
        challengeDuration = "\(challenge.daysRemaining) days remaining"
        challengeRequirements = "Daily check-ins and photo documentation required"
        challengeRewards = "\(challenge.rewardCredits) eco-credits plus exclusive badges"
    }
}

// MARK: - Preview

struct ChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailView(
            challenge: CommunityChallenge(
                title: "Plastic-Free Week",
                description: "Avoid single-use plastics for 7 days",
                emoji: "🚫",
                rewardCredits: 500,
                participantCount: 1247,
                daysRemaining: 4,
                isActive: true,
                progress: 65
            )
        )
        .preferredColorScheme(.dark)
    }
}