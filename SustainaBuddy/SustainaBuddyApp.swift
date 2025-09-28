//
//  SustainaBuddyApp.swift
//  SustainaBuddy
//
//  Created by SustainaBuddy Team
//

import SwiftUI
import UserNotifications
import AuthenticationServices

@main
struct SustainaBuddyApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var authManager = AppleAuthManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isSignedIn {
                    ContentView()
                } else {
                    SignInView()
                }
            }
            .environmentObject(appState)
            .environmentObject(notificationManager)
            .environmentObject(authManager)
            .preferredColorScheme(.dark)
            .onAppear {
                setupNotifications()
                authManager.restoreSession()
            }
        }
    }
    
    private func setupNotifications() {
        notificationManager.setupNotificationCategories()
        notificationManager.scheduleBuddyCareReminders(for: appState.sustainaBuddy)
        notificationManager.scheduleWeeklyReport(for: appState.sustainaBuddy)
    }
}

// MARK: - App State Management
class AppState: ObservableObject {
    @Published var selectedTab: TabType = .marineTracker
    @Published var ecoCredits: Int = 100
    @Published var userProfile: UserProfile = UserProfile()
    @Published var sustainaBuddy: SustainaBuddy = SustainaBuddy()
    
    init() {
        // Initialize app state
    }
}

// MARK: - Tab Types
enum TabType: String, CaseIterable {
    case marineTracker = "Tracker"
    case sustainaBuddy = "Buddy"
    case ecoFootprint = "Eco Footprint"
    case dining = "Dining"
    case social = "Social"
    case achievements = "Achievements"
    case scientificInfo = "Science"
    
    var iconName: String {
        switch self {
        case .marineTracker: return "location.fill"
        case .sustainaBuddy: return "heart.fill"
        case .ecoFootprint: return "leaf.fill"
        case .dining: return "fork.knife"
        case .social: return "person.2.fill"
        case .achievements: return "trophy.fill"
        case .scientificInfo: return "flask.fill"
        }
    }
}

// MARK: - Data Models
struct UserProfile {
    var name: String = "Eco Warrior"
    var level: Int = 1
    var totalEcoCredits: Int = 0
    var sustainabilityScore: Double = 0.0
}

struct SustainaBuddy {
    var id = UUID()
    var name: String = "Buddy"
    var species: BuddySpecies = .seaOtter
    
    // Core Tamagotchi Stats (0-100)
    var happiness: Int = 80
    var health: Int = 85
    var hunger: Int = 70 // Lower = more hungry
    var energy: Int = 90 // Lower = more tired
    var cleanliness: Int = 85 // Lower = dirtier
    var mood: BuddyMood = .happy
    
    // Care Tracking
    var lastFed: Date = Date()
    var lastPlayed: Date = Date()
    var lastCleaned: Date = Date()
    var lastSlept: Date = Date().addingTimeInterval(-28800) // 8 hours ago
    
    // Growth & Evolution
    var age: Int = 0 // Days old
    var experience: Int = 0
    var level: Int = 1
    var evolutionStage: EvolutionStage = .baby
    
    // Customization
    var accessories: [BuddyAccessory] = []
    var currentOutfit: BuddyOutfit? = nil
    var equippedAccessories: [BuddyAccessory.AccessoryType: BuddyAccessory] = [:]
    var ownedAccessories: [BuddyAccessory] = []
    var ownedOutfits: [BuddyOutfit] = [CustomizationStore.availableOutfits[0]] // Start with casual outfit
    
    // Computed Properties
    var needsAttention: Bool {
        return hunger < 30 || energy < 20 || cleanliness < 25 || health < 30
    }
    
    var overallWellbeing: Int {
        return (happiness + health + hunger + energy + cleanliness) / 5
    }
    
    var isAsleep: Bool {
        let hoursSinceLastSleep = Date().timeIntervalSince(lastSlept) / 3600
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        // Natural sleep cycle: 10 PM to 6 AM (22:00 to 06:00)
        let isNightTime = currentHour >= 22 || currentHour < 6
        
        // Sleep if: very tired, been awake too long, or natural night time
        return energy < 20 || hoursSinceLastSleep > 16 || (isNightTime && energy < 60)
    }
    
    var sleepCycleStatus: String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let hoursSinceLastSleep = Date().timeIntervalSince(lastSlept) / 3600
        
        if isAsleep {
            return "💤 Sleeping peacefully"
        } else if currentHour >= 22 || currentHour < 6 {
            return "🌙 Night time - getting sleepy"
        } else if hoursSinceLastSleep > 12 {
            return "😴 Getting tired"
        } else {
            return "☀️ Awake and active"
        }
    }
    
    var timeUntilSleep: String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        if currentHour < 6 {
            let hoursUntilMorning = 6 - currentHour
            return "\(hoursUntilMorning)h until morning"
        } else if currentHour < 22 {
            let hoursUntilBedtime = 22 - currentHour
            return "\(hoursUntilBedtime)h until bedtime"
        } else {
            return "Bedtime!"
        }
    }
    
    // Update stats based on time passage
    mutating func updateStats() {
        let now = Date()
        let hoursSinceLastFed = now.timeIntervalSince(lastFed) / 3600
        let hoursSinceLastPlayed = now.timeIntervalSince(lastPlayed) / 3600
        let hoursSinceLastCleaned = now.timeIntervalSince(lastCleaned) / 3600
        let hoursSinceLastSlept = now.timeIntervalSince(lastSlept) / 3600
        
        // Decay stats over time
        hunger = max(0, hunger - Int(hoursSinceLastFed * 2))
        
        // Energy decay depends on sleep cycle
        if isAsleep {
            // Recover energy while sleeping
            energy = min(100, energy + Int(hoursSinceLastSlept * 0.5))
        } else {
            // Lose energy while awake
            energy = max(0, energy - Int(hoursSinceLastSlept * 1.5))
        }
        
        cleanliness = max(0, cleanliness - Int(hoursSinceLastCleaned * 1))
        
        // Happiness affected by other stats and sleep quality
        if hunger < 30 || energy < 30 || cleanliness < 30 {
            happiness = max(0, happiness - 1)
        }
        
        // Bonus happiness for good sleep schedule
        let currentHour = Calendar.current.component(.hour, from: Date())
        if isAsleep && (currentHour >= 22 || currentHour < 6) {
            happiness = min(100, happiness + 1)
        }
        
        // Health affected by prolonged neglect or poor sleep
        if hunger < 20 || energy < 20 || hoursSinceLastSlept > 24 {
            health = max(0, health - 1)
        }
        
        // Update mood based on stats
        updateMood()
    }
    
    mutating func updateMood() {
        let avgStats = (happiness + health + hunger + energy + cleanliness) / 5
        
        switch avgStats {
        case 80...100: mood = .ecstatic
        case 60...79: mood = .happy
        case 40...59: mood = .content
        case 20...39: mood = .sad
        default: mood = .sick
        }
    }
    
    // Aging and Evolution System
    mutating func ageOneDay() {
        age += 1
        
        // Gain experience based on care quality
        let careQuality = overallWellbeing
        let experienceGain = max(1, careQuality / 10) // 1-10 exp per day
        experience += experienceGain
        
        // Check for level up
        checkLevelUp()
        
        // Check for evolution
        checkEvolution()
    }
    
    mutating func gainExperience(_ amount: Int) {
        experience += amount
        checkLevelUp()
        checkEvolution()
    }
    
    private mutating func checkLevelUp() {
        let expNeeded = level * 100 // Each level requires 100 more exp
        if experience >= expNeeded {
            level += 1
            experience -= expNeeded
            
            // Level up bonuses
            happiness = min(100, happiness + 5)
            health = min(100, health + 5)
        }
    }
    
    private mutating func checkEvolution() {
        let newStage: EvolutionStage
        
        switch (age, level, overallWellbeing) {
        case (0...2, _, _):
            newStage = .baby
        case (3...7, _, _) where overallWellbeing >= 50:
            newStage = .child
        case (8...15, _, _) where overallWellbeing >= 60 && level >= 3:
            newStage = .teen
        case (16...30, _, _) where overallWellbeing >= 70 && level >= 8:
            newStage = .adult
        case (31..., _, _) where overallWellbeing >= 80 && level >= 15:
            newStage = .elder
        default:
            newStage = evolutionStage // No evolution if care quality is poor
        }
        
        if newStage != evolutionStage {
            let oldStage = evolutionStage
            evolutionStage = newStage
            
            // Evolution bonuses
            switch newStage {
            case .child:
                happiness = min(100, happiness + 10)
                experience += 50
            case .teen:
                health = min(100, health + 15)
                experience += 100
            case .adult:
                happiness = min(100, happiness + 20)
                health = min(100, health + 20)
                experience += 200
            case .elder:
                // Elder stage - wisdom bonus
                experience += 500
            default:
                break
            }
        }
    }
    
    // MARK: - Customization Functions
    mutating func purchaseAccessory(_ accessory: BuddyAccessory, with ecoCredits: inout Int) -> Bool {
        guard ecoCredits >= accessory.cost else { return false }
        guard !ownedAccessories.contains(where: { $0.id == accessory.id }) else { return false }
        
        ecoCredits -= accessory.cost
        ownedAccessories.append(accessory)
        return true
    }
    
    mutating func purchaseOutfit(_ outfit: BuddyOutfit, with ecoCredits: inout Int) -> Bool {
        guard ecoCredits >= outfit.cost else { return false }
        guard !ownedOutfits.contains(where: { $0.id == outfit.id }) else { return false }
        
        ecoCredits -= outfit.cost
        ownedOutfits.append(outfit)
        return true
    }
    
    mutating func equipAccessory(_ accessory: BuddyAccessory) {
        guard ownedAccessories.contains(where: { $0.id == accessory.id }) else { return }
        equippedAccessories[accessory.type] = accessory
    }
    
    mutating func unequipAccessory(type: BuddyAccessory.AccessoryType) {
        equippedAccessories.removeValue(forKey: type)
    }
    
    mutating func equipOutfit(_ outfit: BuddyOutfit) {
        guard ownedOutfits.contains(where: { $0.id == outfit.id }) else { return }
        currentOutfit = outfit
    }
    
    var customizedAppearance: String {
        var appearance = species.emoji
        
        // Add equipped accessories
        if let hat = equippedAccessories[.hat] {
            appearance += hat.emoji
        }
        if let glasses = equippedAccessories[.glasses] {
            appearance += glasses.emoji
        }
        if let necklace = equippedAccessories[.necklace] {
            appearance += necklace.emoji
        }
        if let bow = equippedAccessories[.bow] {
            appearance += bow.emoji
        }
        
        // Add outfit if equipped
        if let outfit = currentOutfit, outfit.name != "Casual" {
            appearance += outfit.emoji
        }
        
        return appearance
    }
    
    var evolutionProgress: Double {
        switch evolutionStage {
        case .baby:
            return min(1.0, Double(age) / 3.0)
        case .child:
            return min(1.0, Double(age - 3) / 5.0)
        case .teen:
            return min(1.0, Double(age - 8) / 8.0)
        case .adult:
            return min(1.0, Double(age - 16) / 15.0)
        case .elder:
            return 1.0
        }
    }
    
    var nextEvolutionRequirements: String {
        switch evolutionStage {
        case .baby:
            return "Age 3+ days, Care Quality 50+"
        case .child:
            return "Age 8+ days, Level 3+, Care Quality 60+"
        case .teen:
            return "Age 16+ days, Level 8+, Care Quality 70+"
        case .adult:
            return "Age 31+ days, Level 15+, Care Quality 80+"
        case .elder:
            return "Maximum evolution reached!"
        }
    }
}

enum BuddySpecies: String, CaseIterable {
    case seaOtter = "Sea Otter"
    case turtle = "Sea Turtle"
    case dolphin = "Dolphin"
    case whale = "Whale"
    case manatee = "Manatee" // Premium
    case belugaWhale = "Beluga Whale" // Premium
    
    var isPremium: Bool {
        switch self {
        case .manatee, .belugaWhale:
            return true
        default:
            return false
        }
    }
    
    var emoji: String {
        switch self {
        case .seaOtter: return "🦦"
        case .turtle: return "🐢"
        case .dolphin: return "🐬"
        case .whale: return "🐋"
        case .manatee: return "🦭"
        case .belugaWhale: return "🐋"
        }
    }
}

enum BuddyMood: String, CaseIterable {
    case ecstatic = "Ecstatic"
    case happy = "Happy"
    case content = "Content"
    case sad = "Sad"
    case sick = "Sick"
    
    var emoji: String {
        switch self {
        case .ecstatic: return "🤩"
        case .happy: return "😊"
        case .content: return "😌"
        case .sad: return "😢"
        case .sick: return "🤒"
        }
    }
    
    var color: Color {
        switch self {
        case .ecstatic: return .yellow
        case .happy: return .green
        case .content: return .blue
        case .sad: return .orange
        case .sick: return .red
        }
    }
}

enum EvolutionStage: String, CaseIterable {
    case baby = "Baby"
    case child = "Child"
    case teen = "Teen"
    case adult = "Adult"
    case elder = "Elder"
    
    var sizeMultiplier: Double {
        switch self {
        case .baby: return 0.7
        case .child: return 0.85
        case .teen: return 1.0
        case .adult: return 1.2
        case .elder: return 1.1
        }
    }
}

struct BuddyAccessory: Identifiable, Codable {
    var id = UUID()
    let name: String
    let emoji: String
    let type: AccessoryType
    let cost: Int
    let isPremium: Bool
    
    enum AccessoryType: String, CaseIterable, Codable {
        case hat = "Hat"
        case glasses = "Glasses"
        case necklace = "Necklace"
        case bow = "Bow"
    }
}

struct BuddyOutfit: Identifiable, Codable {
    var id = UUID()
    let name: String
    let emoji: String
    let cost: Int
    let isPremium: Bool
}

// MARK: - Customization Data
struct CustomizationStore {
    static let availableAccessories: [BuddyAccessory] = [
        // Hats
        BuddyAccessory(name: "Sailor Hat", emoji: "🧢", type: .hat, cost: 50, isPremium: false),
        BuddyAccessory(name: "Crown", emoji: "👑", type: .hat, cost: 200, isPremium: true),
        BuddyAccessory(name: "Party Hat", emoji: "🎉", type: .hat, cost: 75, isPremium: false),
        
        // Glasses
        BuddyAccessory(name: "Cool Shades", emoji: "🕶️", type: .glasses, cost: 60, isPremium: false),
        BuddyAccessory(name: "Reading Glasses", emoji: "👓", type: .glasses, cost: 40, isPremium: false),
        BuddyAccessory(name: "Star Glasses", emoji: "⭐", type: .glasses, cost: 150, isPremium: true),
        
        // Necklaces
        BuddyAccessory(name: "Pearl Necklace", emoji: "📿", type: .necklace, cost: 80, isPremium: false),
        BuddyAccessory(name: "Gold Chain", emoji: "🥇", type: .necklace, cost: 120, isPremium: true),
        
        // Bows
        BuddyAccessory(name: "Cute Bow", emoji: "🎀", type: .bow, cost: 30, isPremium: false),
        BuddyAccessory(name: "Fancy Bow", emoji: "🌸", type: .bow, cost: 90, isPremium: true)
    ]
    
    static let availableOutfits: [BuddyOutfit] = [
        BuddyOutfit(name: "Casual", emoji: "👕", cost: 0, isPremium: false),
        BuddyOutfit(name: "Formal Suit", emoji: "🤵", cost: 100, isPremium: false),
        BuddyOutfit(name: "Beach Wear", emoji: "🏖️", cost: 80, isPremium: false),
        BuddyOutfit(name: "Winter Coat", emoji: "🧥", cost: 120, isPremium: false),
        BuddyOutfit(name: "Superhero", emoji: "🦸", cost: 250, isPremium: true),
        BuddyOutfit(name: "Princess Dress", emoji: "👗", cost: 200, isPremium: true),
        BuddyOutfit(name: "Pirate Costume", emoji: "🏴‍☠️", cost: 180, isPremium: true)
    ]
}