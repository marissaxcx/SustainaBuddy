//
//  SustainaBuddyView.swift
//  SustainaBuddy
//
//  Virtual Pet Care Interface
//

import SwiftUI
import UIKit

struct SustainaBuddyView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var showingSpeciesSelector = false
    @State private var showingNameEditor = false
    @State private var animationOffset: CGFloat = 0
    @State private var showingCareActions = false
    @State private var showingFeedingView = false
    @State private var showingNotificationSettings = false
    @State private var statsUpdateTimer: Timer?
    @State private var reactionAnimation: String = ""
    @State private var showReaction = false
    @State private var petScale: CGFloat = 1.0
    @State private var petRotation: Double = 0
    @State private var sparkleOffset1: CGFloat = 0
    @State private var sparkleOffset2: CGFloat = 0
    @State private var sparkleOffset3: CGFloat = 0
    @State private var floatingHearts: [FloatingHeart] = []
    @State private var heartTimer: Timer?
    @State private var foodParticles: [FoodParticle] = []
    @State private var foodParticleTimer: Timer?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header with eco credits
                        headerView
                        
                        // Pet display area
                        petDisplayView
                        
                        // Stats bars
                        statsView
                        
                        // Evolution & Growth
                        evolutionView
                        
                        // Care actions
                        careActionsView
                        
                        // Pet info
                        petInfoView
                    }
                    .padding()
                }
            }
            .navigationTitle("SustainaBuddy")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNotificationSettings = true
                    }) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.glowingCyan)
                    }
                }
            }
            .sheet(isPresented: $showingSpeciesSelector) {
                SpeciesSelectorView()
            }
            .sheet(isPresented: $showingNameEditor) {
                NameEditorView()
            }
            .sheet(isPresented: $showingFeedingView) {
                FeedingView(onFeedingComplete: createFoodParticles)
            }
            .sheet(isPresented: $showingNotificationSettings) {
                NotificationSettingsView()
            }
        }
        .onAppear {
            startIdleAnimation()
            startStatsUpdateTimer()
        }
        .onDisappear {
            statsUpdateTimer?.invalidate()
            heartTimer?.invalidate()
            foodParticleTimer?.invalidate()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Eco Credits")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.green)
                    Text("\(appState.ecoCredits)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.glowingCyan)
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                NavigationLink(destination: CreditsView()) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Credits")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Button("Earn More") {
                    // Navigate to eco footprint tab
                    appState.selectedTab = .ecoFootprint
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.glowingCyan.opacity(0.2))
                .foregroundColor(.glowingCyan)
                .cornerRadius(8)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.dreamyGlass)
                .shadow(color: Color.kawaiBlue.opacity(0.2), radius: 12, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var petDisplayView: some View {
        VStack(spacing: 16) {
            // Pet display area
            ZStack {
                // Enhanced background gradient
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.kawaiGradient)
                    .frame(height: 280)
                    .shadow(color: Color.kawaiPink.opacity(0.3), radius: 15, x: 0, y: 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.dreamyGlass, lineWidth: 1)
                    )
                
                // Decorative elements with sparkles
                HStack {
                    VStack {
                        Text("🌊")
                            .font(.system(size: 30))
                            .offset(y: sin(animationOffset) * 5)
                        Spacer()
                        Text("🐚")
                            .font(.system(size: 20))
                            .offset(y: cos(animationOffset * 0.8) * 3)
                    }
                    
                    Spacer()
                    
                    // Main pet character with sparkles
                    VStack {
                        ZStack {
                            // Sparkle effects around pet
                            Text("✨")
                                .font(.system(size: 20))
                                .offset(x: -40, y: -30)
                                .offset(y: sin(sparkleOffset1) * 8)
                                .opacity(0.8)
                            
                            Text("💫")
                                .font(.system(size: 16))
                                .offset(x: 45, y: -20)
                                .offset(y: cos(sparkleOffset2) * 6)
                                .opacity(0.7)
                            
                            Text("⭐")
                                .font(.system(size: 14))
                                .offset(x: -35, y: 40)
                                .offset(y: sin(sparkleOffset3) * 4)
                                .opacity(0.6)
                            
                            // Main pet
                            Text(appState.sustainaBuddy.customizedAppearance)
                                .font(.system(size: 80))
                                .offset(y: sin(animationOffset * getMoodAnimationSpeed()) * getMoodAnimationIntensity())
                                .scaleEffect(petScale * (appState.sustainaBuddy.needsAttention ? 0.9 : 1.0) * (appState.sustainaBuddy.mood == .happy || appState.sustainaBuddy.mood == .ecstatic ? 1.1 : 1.0))
                                .rotationEffect(.degrees(petRotation + getMoodRotation()))
                                .animation(.easeInOut(duration: getMoodAnimationDuration()).repeatForever(autoreverses: true), value: appState.sustainaBuddy.needsAttention)
                                .animation(.spring(response: 0.6, dampingFraction: 0.4).repeatForever(autoreverses: true), value: appState.sustainaBuddy.mood)
                                .shadow(color: Color.kawaiPink.opacity(0.4), radius: 10, x: 0, y: 5)
                                .onTapGesture {
                                    triggerPetInteraction()
                                }
                            
                            // Floating hearts
                            ForEach(floatingHearts, id: \.id) { heart in
                                Text("💖")
                                    .font(.system(size: heart.size))
                                    .offset(x: heart.x, y: heart.y)
                                    .opacity(heart.opacity)
                                    .scaleEffect(heart.scale)
                            }
                            
                            // Food particles animation
                            ForEach(foodParticles, id: \.id) { particle in
                                Text(particle.emoji)
                                    .font(.system(size: particle.size))
                                    .offset(x: particle.x, y: particle.y)
                                    .opacity(particle.opacity)
                                    .scaleEffect(particle.scale)
                                    .rotationEffect(.degrees(particle.rotation))
                            }
                            
                            // Reaction animation overlay
                            if showReaction {
                                Text(reactionAnimation)
                                    .font(.system(size: 40))
                                    .offset(y: -60)
                                    .opacity(showReaction ? 1 : 0)
                                    .scaleEffect(showReaction ? 1.2 : 0.5)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showReaction)
                            }
                        }
                        
                        // Pet name
                        Button(action: {
                            showingNameEditor = true
                        }) {
                            Text(appState.sustainaBuddy.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.frostedGlass)
                                .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("🪸")
                            .font(.system(size: 25))
                            .offset(y: cos(animationOffset * 0.6) * 4)
                        Spacer()
                        Text("⭐")
                            .font(.system(size: 15))
                            .offset(y: sin(animationOffset * 1.5) * 6)
                    }
                }
                .padding()
                
                // Attention indicator removed
            }
            
            // Species and customization buttons
            HStack(spacing: 16) {
                Button(action: {
                    showingSpeciesSelector = true
                }) {
                    HStack {
                        Text("Change Species")
                        Image(systemName: "chevron.right")
                    }
                    .font(.caption)
                    .foregroundColor(.glowingCyan)
                }
                
                NavigationLink(destination: CustomizationView()) {
                    HStack {
                        Text("Customize")
                        Image(systemName: "paintbrush.fill")
                    }
                    .font(.caption)
                    .foregroundColor(.kawaiPink)
                }
            }
        }
    }
    
    private var statsView: some View {
        VStack(spacing: 12) {
            // Mood indicator
            HStack {
                HStack(spacing: 8) {
                    Text(appState.sustainaBuddy.mood.emoji)
                        .font(.title2)
                        .scaleEffect(appState.sustainaBuddy.mood == .happy || appState.sustainaBuddy.mood == .ecstatic ? 1.2 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6).repeatForever(autoreverses: true), value: appState.sustainaBuddy.mood)
                    
                    Text("\(appState.sustainaBuddy.mood.rawValue.capitalized)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.kawaiPink.opacity(0.15))
                        .shadow(color: Color.kawaiPink.opacity(0.2), radius: 6, x: 0, y: 3)
                )
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.kawaiYellow)
                        .rotationEffect(.degrees(appState.sustainaBuddy.level > 1 ? 360 : 0))
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: appState.sustainaBuddy.level)
                    
                    Text("Level \(appState.sustainaBuddy.level)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.kawaiYellow)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.sleekDark.opacity(0.4))
                        .shadow(color: Color.kawaiYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                )
                .overlay(
                    Capsule()
                        .stroke(Color.kawaiYellow.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Core stats
            StatBar(
                title: "Happiness",
                value: appState.sustainaBuddy.happiness,
                maxValue: 100,
                color: .kawaiPink,
                icon: "heart.fill"
            )
            
            StatBar(
                title: "Health",
                value: appState.sustainaBuddy.health,
                maxValue: 100,
                color: .kawaiBlue,
                icon: "cross.fill"
            )
            
            StatBar(
                title: "Hunger",
                value: appState.sustainaBuddy.hunger,
                maxValue: 100,
                color: .green,
                icon: "leaf.fill"
            )
            
            StatBar(
                title: "Energy",
                value: appState.sustainaBuddy.energy,
                maxValue: 100,
                color: .yellow,
                icon: "bolt.fill"
            )
            
            StatBar(
                title: "Cleanliness",
                value: appState.sustainaBuddy.cleanliness,
                maxValue: 100,
                color: .cyan,
                icon: "sparkles"
            )
            
            // Sleep Cycle Information
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: appState.sustainaBuddy.isAsleep ? "moon.fill" : "sun.max.fill")
                        .foregroundColor(appState.sustainaBuddy.isAsleep ? .purple : .orange)
                    Text("Sleep Cycle")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(appState.sustainaBuddy.sleepCycleStatus)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(appState.sustainaBuddy.isAsleep ? Color.purple.opacity(0.3) : Color.orange.opacity(0.3))
                        .cornerRadius(6)
                    
                    Text(appState.sustainaBuddy.timeUntilSleep)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var evolutionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Growth & Evolution")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                // Current evolution stage
                HStack {
                    Text("Stage: \(appState.sustainaBuddy.evolutionStage.rawValue)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.glowingCyan)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Age: \(appState.sustainaBuddy.age)")
                        Text(appState.sustainaBuddy.age == 1 ? "day" : "days")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                
                // Experience bar
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Experience")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(appState.sustainaBuddy.experience) XP")
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
                                    colors: [.yellow, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: geometry.size.width * min(1.0, Double(appState.sustainaBuddy.experience % (appState.sustainaBuddy.level * 100)) / Double(appState.sustainaBuddy.level * 100)), height: 8)
                                .cornerRadius(4)
                                .animation(.easeInOut(duration: 0.5), value: appState.sustainaBuddy.experience)
                        }
                    }
                    .frame(height: 8)
                }
                
                // Evolution progress
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.kawaiPink)
                        Text("Evolution Progress")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(appState.sustainaBuddy.evolutionProgress * 100))%")
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
                                    colors: [.kawaiPink, .kawaiBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: geometry.size.width * appState.sustainaBuddy.evolutionProgress, height: 8)
                                .cornerRadius(4)
                                .animation(.easeInOut(duration: 0.5), value: appState.sustainaBuddy.evolutionProgress)
                        }
                    }
                    .frame(height: 8)
                }
                
                // Next evolution requirements
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next Evolution:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(appState.sustainaBuddy.nextEvolutionRequirements)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)
                }
                
                // Age buddy button (for testing)
                Button("Age One Day (Test)") {
                    var buddy = appState.sustainaBuddy
                    buddy.ageOneDay()
                    appState.sustainaBuddy = buddy
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.glowingCyan.opacity(0.2))
                .foregroundColor(.glowingCyan)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var careActionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Care Actions")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                CareActionButton(
                    title: "Feed",
                    icon: "🐟",
                    cost: 0,
                    action: { showingFeedingView = true }
                )
                
                CareActionButton(
                    title: "Play",
                    icon: "🎾",
                    cost: 15,
                    action: { playWithBuddy() }
                )
                
                CareActionButton(
                    title: "Clean Habitat",
                    icon: "🧽",
                    cost: 20,
                    action: { cleanHabitat() }
                )
                
                CareActionButton(
                    title: "Sleep",
                    icon: "💤",
                    cost: 5,
                    action: { restBuddy() }
                )
                
                CareActionButton(
                    title: "Medical Care",
                    icon: "🏥",
                    cost: 25,
                    action: { provideMedicalCare() }
                )
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var petInfoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About \(appState.sustainaBuddy.name)")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(title: "Species", value: appState.sustainaBuddy.species.rawValue)
                InfoRow(title: "Last Fed", value: timeAgoString(from: appState.sustainaBuddy.lastFed))
                InfoRow(title: "Last Played", value: timeAgoString(from: appState.sustainaBuddy.lastPlayed))
                InfoRow(title: "Needs Attention", value: appState.sustainaBuddy.needsAttention ? "Yes" : "No")
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    // MARK: - Care Actions
    private func feedBuddy() {
        guard appState.ecoCredits >= 10 else { return }
        
        triggerCareReaction("🍽️")
        createFoodParticles() // Trigger food animation
        withAnimation(.spring()) {
            appState.ecoCredits -= 10
            var buddy = appState.sustainaBuddy
            buddy.hunger = min(100, buddy.hunger + 30)
            buddy.happiness = min(100, buddy.happiness + 10)
            buddy.health = min(100, buddy.health + 5)
            buddy.lastFed = Date()
            buddy.gainExperience(5) // Feeding gives experience
            buddy.updateMood()
            appState.sustainaBuddy = buddy
            
            // Update notifications based on new stats
            notificationManager.scheduleBuddyCareReminders(for: buddy)
            
            // Check for level up notification
            notificationManager.scheduleLevelUpReminder(for: buddy)
        }
    }
    
    private func playWithBuddy() {
        guard appState.ecoCredits >= 15 else { return }
        
        triggerCareReaction("🎾")
        withAnimation(.spring()) {
            appState.ecoCredits -= 15
            var buddy = appState.sustainaBuddy
            buddy.happiness = min(100, buddy.happiness + 20)
            buddy.energy = max(0, buddy.energy - 10)
            buddy.lastPlayed = Date()
            buddy.gainExperience(10) // Playing gives experience
            buddy.updateMood()
            appState.sustainaBuddy = buddy
            
            // Update notifications based on new stats
            notificationManager.scheduleBuddyCareReminders(for: buddy)
            notificationManager.scheduleLevelUpReminder(for: buddy)
        }
    }
    
    private func cleanHabitat() {
        guard appState.ecoCredits >= 20 else { return }
        
        triggerCareReaction("🧽")
        withAnimation(.spring()) {
            appState.ecoCredits -= 20
            var buddy = appState.sustainaBuddy
            buddy.cleanliness = min(100, buddy.cleanliness + 30)
            buddy.happiness = min(100, buddy.happiness + 10)
            buddy.lastCleaned = Date()
            buddy.gainExperience(8) // Cleaning gives experience
            buddy.updateMood()
            appState.sustainaBuddy = buddy
        }
    }
    
    private func provideMedicalCare() {
        guard appState.ecoCredits >= 25 else { return }
        
        triggerCareReaction("🏥")
        withAnimation(.spring()) {
            appState.ecoCredits -= 25
            var buddy = appState.sustainaBuddy
            buddy.health = 100
            buddy.gainExperience(12) // Medical care gives experience
            buddy.updateMood()
            appState.sustainaBuddy = buddy
            
            // Update notifications based on new stats
            notificationManager.scheduleBuddyCareReminders(for: buddy)
            notificationManager.scheduleLevelUpReminder(for: buddy)
        }
    }
    
    private func restBuddy() {
        guard appState.ecoCredits >= 5 else { return }
        
        triggerCareReaction("💤")
        withAnimation(.spring()) {
            appState.ecoCredits -= 5
            var buddy = appState.sustainaBuddy
            
            // Better sleep benefits during night time
            let currentHour = Calendar.current.component(.hour, from: Date())
            let isNightTime = currentHour >= 22 || currentHour < 6
            
            if isNightTime {
                buddy.energy = min(100, buddy.energy + 40)
                buddy.happiness = min(100, buddy.happiness + 10)
                buddy.gainExperience(5) // Better experience for proper sleep timing
            } else {
                buddy.energy = min(100, buddy.energy + 25)
                buddy.happiness = min(100, buddy.happiness + 5)
                buddy.gainExperience(3)
            }
            
            buddy.lastSlept = Date()
            buddy.updateMood()
            appState.sustainaBuddy = buddy
        }
    }
    
    private func startIdleAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            animationOffset += 0.1
            sparkleOffset1 += 0.08
            sparkleOffset2 += 0.12
            sparkleOffset3 += 0.06
        }
        
        // Start floating hearts timer
        heartTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if appState.sustainaBuddy.mood == .happy || appState.sustainaBuddy.mood == .ecstatic {
                addFloatingHeart()
            }
        }
    }
    
    private func startStatsUpdateTimer() {
        statsUpdateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            appState.sustainaBuddy.updateStats()
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func triggerPetInteraction() {
        // Random reaction animations
        let reactions = ["💖", "✨", "🌟", "💫", "🎉", "😊", "🥰"]
        reactionAnimation = reactions.randomElement() ?? "💖"
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            petScale = 1.2
            showReaction = true
        }
        
        // Reset after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                petScale = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                showReaction = false
            }
        }
        
        // Small happiness boost for interaction
        var buddy = appState.sustainaBuddy
        buddy.happiness = min(100, buddy.happiness + 2)
        buddy.gainExperience(1)
        buddy.updateMood()
        appState.sustainaBuddy = buddy
    }
    
    private func triggerCareReaction(_ emoji: String) {
        reactionAnimation = emoji
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            petScale = 1.2
            showReaction = true
        }
        
        // Reset after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                petScale = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                showReaction = false
            }
        }
     }
     
     // MARK: - Mood-based Animation Helpers
     private func getMoodAnimationSpeed() -> Double {
         switch appState.sustainaBuddy.mood {
         case .happy:
             return 1.0
         case .ecstatic:
             return 1.5
         case .content:
             return 0.8
         case .sad, .sick:
             return 0.3
         }
     }
     
     private func getMoodAnimationIntensity() -> CGFloat {
         switch appState.sustainaBuddy.mood {
         case .happy, .ecstatic:
             return 8.0
         case .content:
             return 5.0
         case .sad, .sick:
             return 2.0
         }
     }
     
     private func getMoodAnimationDuration() -> Double {
         switch appState.sustainaBuddy.mood {
         case .happy, .ecstatic:
             return 0.8
         case .content:
             return 1.0
         case .sad, .sick:
             return 2.0
         }
     }
     
     private func getMoodRotation() -> Double {
         switch appState.sustainaBuddy.mood {
         case .happy:
             return sin(animationOffset * 0.5) * 5
         case .ecstatic:
             return sin(animationOffset * 1.0) * 8
         case .content:
             return sin(animationOffset * 0.3) * 2
         default:
             return 0
         }
     }
     
     private func addFloatingHeart() {
         let heart = FloatingHeart(
             id: UUID(),
             x: CGFloat.random(in: -50...50),
             y: CGFloat.random(in: -30...30),
             size: CGFloat.random(in: 12...20),
             opacity: 1.0,
             scale: 0.5
         )
         
         floatingHearts.append(heart)
         
         // Animate heart
         withAnimation(.easeOut(duration: 3.0)) {
             if let index = floatingHearts.firstIndex(where: { $0.id == heart.id }) {
                 floatingHearts[index].y -= 100
                 floatingHearts[index].opacity = 0
                 floatingHearts[index].scale = 1.2
             }
         }
         
         // Remove heart after animation
         DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
             floatingHearts.removeAll { $0.id == heart.id }
         }
     }
     
     private func createFoodParticles() {
         let foodEmojis = ["🥬", "🍲", "🥤", "🫐", "🍬", "🌯"]
         
         for i in 0..<6 {
             let startX = CGFloat.random(in: -100...100)
             let startY = CGFloat.random(in: -150...(-50))
             let targetX = CGFloat.random(in: -30...30)
             let targetY = CGFloat.random(in: 20...60)
             
             let particle = FoodParticle(
                 id: UUID(),
                 emoji: foodEmojis.randomElement() ?? "🐟",
                 x: startX,
                 y: startY,
                 size: CGFloat.random(in: 20...30),
                 opacity: 1.0,
                 scale: 0.1,
                 rotation: 0,
                 targetX: targetX,
                 targetY: targetY
             )
             
             foodParticles.append(particle)
             
             // Animate particle falling and being eaten
             withAnimation(.easeInOut(duration: 0.8).delay(Double(i) * 0.1)) {
                 if let index = foodParticles.firstIndex(where: { $0.id == particle.id }) {
                     foodParticles[index].x = particle.targetX
                     foodParticles[index].y = particle.targetY
                     foodParticles[index].scale = 1.0
                 }
             }
             
             // Make particle disappear (eaten)
             withAnimation(.easeOut(duration: 0.3).delay(0.8 + Double(i) * 0.1)) {
                 if let index = foodParticles.firstIndex(where: { $0.id == particle.id }) {
                     foodParticles[index].scale = 0.1
                     foodParticles[index].opacity = 0.0
                     foodParticles[index].rotation = 360
                 }
             }
         }
         
         // Clean up particles after animation
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             foodParticles.removeAll()
         }
     }
 }
 
 // MARK: - FloatingHeart Model
 struct FloatingHeart {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    var opacity: Double
    var scale: CGFloat
}

struct FoodParticle {
    let id: UUID
    let emoji: String
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    var opacity: Double
    var scale: CGFloat
    var rotation: Double
    let targetX: CGFloat
    let targetY: CGFloat
}

// MARK: - Stat Bar Component
struct StatBar: View {
    let title: String
    let value: Int
    let maxValue: Int
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                // Enhanced icon with background
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 28, height: 28)
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Spacer()
                
                // Cute value display
                Text("\(value)/\(maxValue)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(color.opacity(0.15))
                    )
            }
            
            // Enhanced progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                    
                    // Progress with gradient
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.8), color],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(value) / CGFloat(maxValue), height: 12)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: value)
                        .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    // Sparkle effect on full bars
                    if value >= maxValue {
                        HStack {
                            Spacer()
                            Text("✨")
                                .font(.system(size: 10))
                                .offset(y: -1)
                        }
                        .padding(.trailing, 4)
                    }
                }
            }
            .frame(height: 12)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Color Extensions
extension Color {
    // Additional Kawai Colors
    static let kawaiPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let kawaiMint = Color(red: 0.4, green: 1.0, blue: 0.8)
    static let kawaiPeach = Color(red: 1.0, green: 0.8, blue: 0.7)
    static let kawaiLavender = Color(red: 0.9, green: 0.8, blue: 1.0)
    static let kawaiYellow = Color(red: 1.0, green: 0.9, blue: 0.4)
    
    // Gradients
    static let dreamyGlass = LinearGradient(
        colors: [Color.kawaiPink.opacity(0.3), Color.kawaiBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let kawaiGradient = LinearGradient(
        colors: [Color.kawaiPink, Color.kawaiLavender],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let sparkleGradient = LinearGradient(
        colors: [Color.kawaiMint, Color.kawaiBlue, Color.kawaiPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Care Action Button
struct CareActionButton: View {
    let title: String
    let icon: String
    let cost: Int
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            VStack(spacing: 10) {
                // Enhanced icon with glow effect
                ZStack {
                    Circle()
                        .fill(Color.kawaiPink.opacity(0.15))
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.kawaiPink.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Text(icon)
                        .font(.system(size: 28))
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Enhanced cost display
                HStack(spacing: 4) {
                    Image(systemName: "leaf.fill")
                        .font(.caption2)
                        .foregroundColor(.kawaiMint)
                    Text("\(cost)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.kawaiYellow)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color.sleekDark.opacity(0.3))
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.dreamyGlass)
                    .shadow(color: Color.kawaiBlue.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.sparkleGradient, lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}