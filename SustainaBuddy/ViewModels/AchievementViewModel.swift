//
//  AchievementViewModel.swift
//  SustainaBuddy
//
//  Achievement System View Model
//

import SwiftUI
import Combine

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var userLevel: Int = 1
    @Published var currentXP: Int = 0
    @Published var nextLevelXP: Int = 100
    @Published var newlyUnlockedAchievement: Achievement?
    
    // Computed properties
    var levelProgress: Double {
        return Double(currentXP) / Double(nextLevelXP)
    }
    
    var xpToNextLevel: Int {
        return nextLevelXP - currentXP
    }
    
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    var inProgressCount: Int {
        achievements.filter { !$0.isUnlocked && $0.progress > 0 }.count
    }
    
    var lockedCount: Int {
        achievements.filter { !$0.isUnlocked && $0.progress == 0 }.count
    }
    
    var rareCount: Int {
        achievements.filter { $0.isUnlocked && ($0.rarity == .epic || $0.rarity == .legendary) }.count
    }
    
    var featuredAchievements: [Achievement] {
        achievements.filter { $0.rarity == .legendary || $0.rarity == .epic }.prefix(5).map { $0 }
    }
    
    var recentAchievements: [Achievement] {
        achievements
            .filter { $0.isUnlocked }
            .sorted { ($0.unlockedDate ?? Date.distantPast) > ($1.unlockedDate ?? Date.distantPast) }
            .prefix(3)
            .map { $0 }
    }
    
    init() {
        loadUserProgress()
        loadAchievements()
    }
    
    func loadAchievements() {
        // In a real app, this would load from a database or API
        achievements = createMockAchievements()
    }
    
    func refreshAchievements() {
        // Simulate checking for new achievements
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkForNewAchievements()
        }
    }
    
    func getAchievements(for category: AchievementCategory) -> [Achievement] {
        if category == .all {
            return achievements.sorted { achievement1, achievement2 in
                if achievement1.isUnlocked != achievement2.isUnlocked {
                    return achievement1.isUnlocked && !achievement2.isUnlocked
                }
                if achievement1.isUnlocked {
                    return (achievement1.unlockedDate ?? Date.distantPast) > (achievement2.unlockedDate ?? Date.distantPast)
                }
                return achievement1.progress > achievement2.progress
            }
        }
        
        return achievements
            .filter { $0.category == category }
            .sorted { achievement1, achievement2 in
                if achievement1.isUnlocked != achievement2.isUnlocked {
                    return achievement1.isUnlocked && !achievement2.isUnlocked
                }
                if achievement1.isUnlocked {
                    return (achievement1.unlockedDate ?? Date.distantPast) > (achievement2.unlockedDate ?? Date.distantPast)
                }
                return achievement1.progress > achievement2.progress
            }
    }
    
    func unlockAchievement(_ achievement: Achievement) {
        guard let index = achievements.firstIndex(where: { $0.id == achievement.id }) else { return }
        
        let unlockedAchievement = Achievement(
            title: achievement.title,
            description: achievement.description,
            emoji: achievement.emoji,
            category: achievement.category,
            rarity: achievement.rarity,
            xpReward: achievement.xpReward,
            isUnlocked: true,
            progress: 100,
            requirements: achievement.requirements,
            unlockedDate: Date(),
            isSecret: achievement.isSecret
        )
        
        achievements[index] = unlockedAchievement
        newlyUnlockedAchievement = unlockedAchievement
        
        // Add XP
        addXP(achievement.xpReward)
        
        // Save progress
        saveUserProgress()
    }
    
    func updateAchievementProgress(_ achievementId: UUID, progress: Int) {
        guard let index = achievements.firstIndex(where: { $0.id == achievementId }) else { return }
        
        let achievement = achievements[index]
        let updatedAchievement = Achievement(
            title: achievement.title,
            description: achievement.description,
            emoji: achievement.emoji,
            category: achievement.category,
            rarity: achievement.rarity,
            xpReward: achievement.xpReward,
            isUnlocked: progress >= 100 ? true : achievement.isUnlocked,
            progress: min(progress, 100),
            requirements: achievement.requirements,
            unlockedDate: progress >= 100 ? Date() : achievement.unlockedDate,
            isSecret: achievement.isSecret
        )
        
        achievements[index] = updatedAchievement
        
        // If achievement was just unlocked
        if progress >= 100 && !achievement.isUnlocked {
            unlockAchievement(updatedAchievement)
        }
    }
    
    func clearNewAchievement() {
        newlyUnlockedAchievement = nil
    }
    
    private func loadUserProgress() {
        // In a real app, load from UserDefaults or database
        userLevel = UserDefaults.standard.integer(forKey: "userLevel")
        if userLevel == 0 { userLevel = 1 }
        
        currentXP = UserDefaults.standard.integer(forKey: "currentXP")
        nextLevelXP = calculateNextLevelXP(for: userLevel)
    }
    
    private func saveUserProgress() {
        UserDefaults.standard.set(userLevel, forKey: "userLevel")
        UserDefaults.standard.set(currentXP, forKey: "currentXP")
    }
    
    private func addXP(_ amount: Int) {
        currentXP += amount
        
        // Check for level up
        while currentXP >= nextLevelXP {
            levelUp()
        }
        
        saveUserProgress()
    }
    
    private func levelUp() {
        currentXP -= nextLevelXP
        userLevel += 1
        nextLevelXP = calculateNextLevelXP(for: userLevel)
        
        // Could trigger level up celebration here
    }
    
    private func calculateNextLevelXP(for level: Int) -> Int {
        // XP required increases with each level
        return 100 + (level - 1) * 50
    }
    
    private func checkForNewAchievements() {
        // Simulate checking various conditions for achievements
        // In a real app, this would check actual user data
        
        // Example: Check if user has tracked 10 marine animals
        if let marineExplorerIndex = achievements.firstIndex(where: { $0.title == "Marine Explorer" }) {
            let achievement = achievements[marineExplorerIndex]
            if !achievement.isUnlocked {
                // Simulate progress (in real app, check actual data)
                let newProgress = min(achievement.progress + Int.random(in: 5...15), 100)
                updateAchievementProgress(achievement.id, progress: newProgress)
            }
        }
        
        // Example: Check eco-friendly dining visits
        if let ecoFoodieIndex = achievements.firstIndex(where: { $0.title == "Eco Foodie" }) {
            let achievement = achievements[ecoFoodieIndex]
            if !achievement.isUnlocked {
                let newProgress = min(achievement.progress + Int.random(in: 3...10), 100)
                updateAchievementProgress(achievement.id, progress: newProgress)
            }
        }
    }
    
    private func createMockAchievements() -> [Achievement] {
        return [
            // Ocean Category
            Achievement(
                title: "First Dive",
                description: "Track your first marine animal",
                emoji: "🐠",
                category: .ocean,
                rarity: .common,
                xpReward: 50,
                isUnlocked: true,
                progress: 100,
                requirements: ["Track 1 marine animal"],
                unlockedDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
                isSecret: false
            ),
            Achievement(
                title: "Marine Explorer",
                description: "Track 10 different marine species",
                emoji: "🐙",
                category: .ocean,
                rarity: .rare,
                xpReward: 150,
                isUnlocked: false,
                progress: 60,
                requirements: ["Track 10 different marine species"],
                unlockedDate: nil,
                isSecret: false
            ),
            Achievement(
                title: "Ocean Guardian",
                description: "Track 50 marine animals and contribute to conservation",
                emoji: "🌊",
                category: .ocean,
                rarity: .epic,
                xpReward: 300,
                isUnlocked: false,
                progress: 25,
                requirements: ["Track 50 marine animals", "Complete 5 conservation actions"],
                unlockedDate: nil,
                isSecret: false
            ),
            Achievement(
                title: "Legendary Oceanographer",
                description: "Master of the seas - track 100 species and unlock all ocean secrets",
                emoji: "🔱",
                category: .ocean,
                rarity: .legendary,
                xpReward: 500,
                isUnlocked: false,
                progress: 8,
                requirements: ["Track 100 marine species", "Unlock all ocean areas", "Complete marine research project"],
                unlockedDate: nil,
                isSecret: false
            ),
            
            // Sustainability Category
            Achievement(
                title: "Green Beginner",
                description: "Complete your first eco-friendly action",
                emoji: "🌱",
                category: .sustainability,
                rarity: .common,
                xpReward: 25,
                isUnlocked: true,
                progress: 100,
                requirements: ["Complete 1 eco-friendly action"],
                unlockedDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
                isSecret: false
            ),
            Achievement(
                title: "Eco Warrior",
                description: "Reduce your carbon footprint by 20%",
                emoji: "♻️",
                category: .sustainability,
                rarity: .rare,
                xpReward: 200,
                isUnlocked: false,
                progress: 45,
                requirements: ["Reduce carbon footprint by 20%"],
                unlockedDate: nil,
                isSecret: false
            ),
            Achievement(
                title: "Carbon Neutral",
                description: "Achieve carbon neutrality for a full month",
                emoji: "🌍",
                category: .sustainability,
                rarity: .epic,
                xpReward: 400,
                isUnlocked: false,
                progress: 15,
                requirements: ["Maintain carbon neutrality for 30 days"],
                unlockedDate: nil,
                isSecret: false
            ),
            
            // Social Category
            Achievement(
                title: "Social Butterfly",
                description: "Add your first friend",
                emoji: "🦋",
                category: .social,
                rarity: .common,
                xpReward: 30,
                isUnlocked: true,
                progress: 100,
                requirements: ["Add 1 friend"],
                unlockedDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
                isSecret: false
            ),
            Achievement(
                title: "Community Leader",
                description: "Complete 5 community challenges",
                emoji: "👑",
                category: .social,
                rarity: .rare,
                xpReward: 250,
                isUnlocked: false,
                progress: 80,
                requirements: ["Complete 5 community challenges"],
                unlockedDate: nil,
                isSecret: false
            ),
            Achievement(
                title: "Influencer",
                description: "Inspire 10 friends to join sustainability challenges",
                emoji: "✨",
                category: .social,
                rarity: .epic,
                xpReward: 350,
                isUnlocked: false,
                progress: 30,
                requirements: ["Invite 10 friends to challenges", "Have 10 friends complete challenges"],
                unlockedDate: nil,
                isSecret: false
            ),
            
            // Buddy Care Category
            Achievement(
                title: "New Parent",
                description: "Adopt your first SustainaBuddy",
                emoji: "🥚",
                category: .buddy,
                rarity: .common,
                xpReward: 40,
                isUnlocked: true,
                progress: 100,
                requirements: ["Adopt a SustainaBuddy"],
                unlockedDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
                isSecret: false
            ),
            Achievement(
                title: "Caring Guardian",
                description: "Keep your buddy happy for 7 consecutive days",
                emoji: "💖",
                category: .buddy,
                rarity: .rare,
                xpReward: 180,
                isUnlocked: false,
                progress: 70,
                requirements: ["Maintain buddy happiness for 7 days"],
                unlockedDate: nil,
                isSecret: false
            ),
            Achievement(
                title: "Buddy Whisperer",
                description: "Raise a buddy to maximum level",
                emoji: "🌟",
                category: .buddy,
                rarity: .epic,
                xpReward: 320,
                isUnlocked: false,
                progress: 40,
                requirements: ["Raise buddy to level 10", "Unlock all buddy abilities"],
                unlockedDate: nil,
                isSecret: false
            ),
            
            // Dining Category
            Achievement(
                title: "Eco Foodie",
                description: "Visit 5 eco-friendly restaurants",
                emoji: "🍃",
                category: .dining,
                rarity: .common,
                xpReward: 60,
                isUnlocked: false,
                progress: 40,
                requirements: ["Visit 5 eco-friendly restaurants"],
                unlockedDate: nil,
                isSecret: false
            ),
            Achievement(
                title: "Sustainable Chef",
                description: "Try 20 plant-based meals",
                emoji: "👨‍🍳",
                category: .dining,
                rarity: .rare,
                xpReward: 160,
                isUnlocked: false,
                progress: 55,
                requirements: ["Order 20 plant-based meals"],
                unlockedDate: nil,
                isSecret: false
            ),
            Achievement(
                title: "Zero Waste Diner",
                description: "Complete 10 zero-waste dining experiences",
                emoji: "🌿",
                category: .dining,
                rarity: .epic,
                xpReward: 280,
                isUnlocked: false,
                progress: 20,
                requirements: ["Complete 10 zero-waste meals", "Use reusable containers 10 times"],
                unlockedDate: nil,
                isSecret: false
            ),
            
            // Milestone Category
            Achievement(
                title: "Week Warrior",
                description: "Use the app for 7 consecutive days",
                emoji: "📅",
                category: .milestones,
                rarity: .common,
                xpReward: 70,
                isUnlocked: true,
                progress: 100,
                requirements: ["Use app for 7 consecutive days"],
                unlockedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                isSecret: false
            ),
            Achievement(
                title: "Monthly Master",
                description: "Use the app for 30 consecutive days",
                emoji: "🗓️",
                category: .milestones,
                rarity: .rare,
                xpReward: 220,
                isUnlocked: false,
                progress: 85,
                requirements: ["Use app for 30 consecutive days"],
                unlockedDate: nil,
                isSecret: false
            ),
            Achievement(
                title: "Legendary Dedication",
                description: "Use the app for 365 consecutive days",
                emoji: "🏆",
                category: .milestones,
                rarity: .legendary,
                xpReward: 1000,
                isUnlocked: false,
                progress: 12,
                requirements: ["Use app for 365 consecutive days"],
                unlockedDate: nil,
                isSecret: false
            ),
            
            // Secret Achievements
            Achievement(
                title: "Night Owl",
                description: "Use the app at midnight",
                emoji: "🦉",
                category: .milestones,
                rarity: .rare,
                xpReward: 100,
                isUnlocked: false,
                progress: 0,
                requirements: ["Use app between 11:59 PM and 12:01 AM"],
                unlockedDate: nil,
                isSecret: true
            ),
            Achievement(
                title: "Easter Egg Hunter",
                description: "Find the hidden easter egg in the app",
                emoji: "🥚",
                category: .milestones,
                rarity: .epic,
                xpReward: 250,
                isUnlocked: false,
                progress: 0,
                requirements: ["Find the hidden easter egg"],
                unlockedDate: nil,
                isSecret: true
            )
        ]
    }
}

// MARK: - Achievement Detail View

struct AchievementDetailView: View {
    let achievement: Achievement
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Achievement Icon
                        ZStack {
                            Circle()
                                .fill(achievement.isUnlocked ? 
                                      achievement.rarity.color :
                                      LinearGradient(colors: [Color.gray.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                                )
                                .frame(width: 120, height: 120)
                            
                            if achievement.isUnlocked {
                                Text(achievement.emoji)
                                    .font(.system(size: 60))
                            } else {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            }
                            
                            // Rarity border
                            if achievement.rarity != .common {
                                Circle()
                                    .stroke(achievement.rarity.borderColor, lineWidth: 4)
                                    .frame(width: 130, height: 130)
                            }
                        }
                        
                        // Achievement Info
                        VStack(spacing: 16) {
                            VStack(spacing: 8) {
                                Text(achievement.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(achievement.description)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            
                            // Rarity and XP
                            HStack(spacing: 20) {
                                VStack {
                                    Text("Rarity")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(achievement.rarity.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(achievement.rarity.borderColor == .clear ? .white : achievement.rarity.borderColor)
                                }
                                
                                VStack {
                                    Text("XP Reward")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                        Text("\(achievement.xpReward)")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.glowingCyan)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.frostedGlass)
                            .cornerRadius(12)
                        }
                        
                        // Progress Section
                        if !achievement.isUnlocked {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Progress")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("\(achievement.progress)% Complete")
                                            .font(.subheadline)
                                            .foregroundColor(.orange)
                                        Spacer()
                                        Text("\(100 - achievement.progress)% Remaining")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 8)
                                                .cornerRadius(4)
                                            
                                            Rectangle()
                                                .fill(LinearGradient(
                                                    colors: [.orange, .yellow],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ))
                                                .frame(width: geometry.size.width * CGFloat(achievement.progress) / 100, height: 8)
                                                .cornerRadius(4)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                            }
                            .padding()
                            .background(Color.frostedGlass)
                            .cornerRadius(12)
                        }
                        
                        // Requirements
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Requirements")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(achievement.requirements, id: \.self) { requirement in
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: achievement.isUnlocked ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(achievement.isUnlocked ? .green : .gray)
                                            .font(.body)
                                        
                                        Text(requirement)
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.frostedGlass)
                        .cornerRadius(12)
                        
                        // Unlock Date
                        if let unlockedDate = achievement.unlockedDate {
                            VStack(spacing: 8) {
                                Text("Unlocked")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                
                                Text(DateFormatter.achievementDate.string(from: unlockedDate))
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.frostedGlass)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Achievement")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.glowingCyan)
            )
        }
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let achievementDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}