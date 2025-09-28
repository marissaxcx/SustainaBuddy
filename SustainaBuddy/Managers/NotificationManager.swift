//
//  NotificationManager.swift
//  SustainaBuddy
//
//  Created by SustainaBuddy Team
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {
        requestNotificationPermission()
    }
    
    // MARK: - Permission Management
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
            }
        }
    }
    
    // MARK: - Buddy Care Notifications
    func scheduleBuddyCareReminders(for buddy: SustainaBuddy) {
        // Clear existing buddy care notifications
        clearBuddyCareNotifications()
        
        // Schedule immediate care notifications if needed
        scheduleImmediateCareNotifications(for: buddy)
        
        // Schedule daily care reminders
        scheduleDailyCareReminders(for: buddy)
        
        // Schedule stat-based reminders
        scheduleStatBasedReminders(for: buddy)
    }
    
    private func scheduleImmediateCareNotifications(for buddy: SustainaBuddy) {
        let center = UNUserNotificationCenter.current()
        
        // Critical hunger notification
        if buddy.hunger < 20 {
            let content = UNMutableNotificationContent()
            content.title = "🍽️ \(buddy.name) is Very Hungry!"
            content.body = "Your buddy needs food urgently! Hunger level: \(buddy.hunger)%"
            content.sound = .default
            content.categoryIdentifier = "BUDDY_CARE"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "hunger_critical", content: content, trigger: trigger)
            center.add(request)
        }
        
        // Critical energy notification
        if buddy.energy < 15 {
            let content = UNMutableNotificationContent()
            content.title = "😴 \(buddy.name) is Exhausted!"
            content.body = "Your buddy needs rest immediately! Energy level: \(buddy.energy)%"
            content.sound = .default
            content.categoryIdentifier = "BUDDY_CARE"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: "energy_critical", content: content, trigger: trigger)
            center.add(request)
        }
        
        // Critical health notification
        if buddy.health < 25 {
            let content = UNMutableNotificationContent()
            content.title = "🏥 \(buddy.name) Needs Medical Care!"
            content.body = "Your buddy's health is low! Health level: \(buddy.health)%"
            content.sound = .default
            content.categoryIdentifier = "BUDDY_CARE"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
            let request = UNNotificationRequest(identifier: "health_critical", content: content, trigger: trigger)
            center.add(request)
        }
        
        // Critical cleanliness notification
        if buddy.cleanliness < 20 {
            let content = UNMutableNotificationContent()
            content.title = "🛁 \(buddy.name) Needs a Bath!"
            content.body = "Your buddy is getting dirty! Cleanliness level: \(buddy.cleanliness)%"
            content.sound = .default
            content.categoryIdentifier = "BUDDY_CARE"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
            let request = UNNotificationRequest(identifier: "cleanliness_critical", content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    private func scheduleDailyCareReminders(for buddy: SustainaBuddy) {
        let center = UNUserNotificationCenter.current()
        
        // Morning care reminder (8 AM)
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "🌅 Good Morning, \(buddy.name)!"
        morningContent.body = "Start the day with some breakfast and playtime!"
        morningContent.sound = .default
        morningContent.categoryIdentifier = "DAILY_CARE"
        
        var morningComponents = DateComponents()
        morningComponents.hour = 8
        morningComponents.minute = 0
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningComponents, repeats: true)
        let morningRequest = UNNotificationRequest(identifier: "morning_care", content: morningContent, trigger: morningTrigger)
        center.add(morningRequest)
        
        // Afternoon check-in (2 PM)
        let afternoonContent = UNMutableNotificationContent()
        afternoonContent.title = "☀️ Afternoon Check-in"
        afternoonContent.body = "How is \(buddy.name) doing? Time for some care and attention!"
        afternoonContent.sound = .default
        afternoonContent.categoryIdentifier = "DAILY_CARE"
        
        var afternoonComponents = DateComponents()
        afternoonComponents.hour = 14
        afternoonComponents.minute = 0
        let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoonComponents, repeats: true)
        let afternoonRequest = UNNotificationRequest(identifier: "afternoon_care", content: afternoonContent, trigger: afternoonTrigger)
        center.add(afternoonRequest)
        
        // Evening care reminder (7 PM)
        let eveningContent = UNMutableNotificationContent()
        eveningContent.title = "🌆 Evening Care Time"
        eveningContent.body = "\(buddy.name) needs dinner and some evening playtime!"
        eveningContent.sound = .default
        eveningContent.categoryIdentifier = "DAILY_CARE"
        
        var eveningComponents = DateComponents()
        eveningComponents.hour = 19
        eveningComponents.minute = 0
        let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: eveningComponents, repeats: true)
        let eveningRequest = UNNotificationRequest(identifier: "evening_care", content: eveningContent, trigger: eveningTrigger)
        center.add(eveningRequest)
        
        // Bedtime reminder (10 PM)
        let bedtimeContent = UNMutableNotificationContent()
        bedtimeContent.title = "🌙 Bedtime for \(buddy.name)"
        bedtimeContent.body = "Time to help your buddy get ready for sleep!"
        bedtimeContent.sound = .default
        bedtimeContent.categoryIdentifier = "DAILY_CARE"
        
        var bedtimeComponents = DateComponents()
        bedtimeComponents.hour = 22
        bedtimeComponents.minute = 0
        let bedtimeTrigger = UNCalendarNotificationTrigger(dateMatching: bedtimeComponents, repeats: true)
        let bedtimeRequest = UNNotificationRequest(identifier: "bedtime_care", content: bedtimeContent, trigger: bedtimeTrigger)
        center.add(bedtimeRequest)
    }
    
    private func scheduleStatBasedReminders(for buddy: SustainaBuddy) {
        let center = UNUserNotificationCenter.current()
        
        // Schedule feeding reminders based on hunger decline
        let feedingContent = UNMutableNotificationContent()
        feedingContent.title = "🍎 Feeding Time!"
        feedingContent.body = "\(buddy.name) is getting hungry. Time for a snack!"
        feedingContent.sound = .default
        feedingContent.categoryIdentifier = "STAT_REMINDER"
        
        // Schedule every 4 hours during day time
        for hour in [10, 14, 18] {
            var feedingComponents = DateComponents()
            feedingComponents.hour = hour
            feedingComponents.minute = 0
            let feedingTrigger = UNCalendarNotificationTrigger(dateMatching: feedingComponents, repeats: true)
            let feedingRequest = UNNotificationRequest(identifier: "feeding_\(hour)", content: feedingContent, trigger: feedingTrigger)
            center.add(feedingRequest)
        }
        
        // Play time reminders
        let playContent = UNMutableNotificationContent()
        playContent.title = "🎮 Play Time!"
        playContent.body = "\(buddy.name) wants to play! Boost their happiness with some fun activities."
        playContent.sound = .default
        playContent.categoryIdentifier = "STAT_REMINDER"
        
        // Schedule play reminders
        for hour in [11, 16, 20] {
            var playComponents = DateComponents()
            playComponents.hour = hour
            playComponents.minute = 30
            let playTrigger = UNCalendarNotificationTrigger(dateMatching: playComponents, repeats: true)
            let playRequest = UNNotificationRequest(identifier: "play_\(hour)", content: playContent, trigger: playTrigger)
            center.add(playRequest)
        }
        
        // Cleaning reminders (twice daily)
        let cleanContent = UNMutableNotificationContent()
        cleanContent.title = "🧼 Bath Time!"
        cleanContent.body = "\(buddy.name) could use a good cleaning to stay healthy and happy!"
        cleanContent.sound = .default
        cleanContent.categoryIdentifier = "STAT_REMINDER"
        
        for hour in [9, 21] {
            var cleanComponents = DateComponents()
            cleanComponents.hour = hour
            cleanComponents.minute = 15
            let cleanTrigger = UNCalendarNotificationTrigger(dateMatching: cleanComponents, repeats: true)
            let cleanRequest = UNNotificationRequest(identifier: "clean_\(hour)", content: cleanContent, trigger: cleanTrigger)
            center.add(cleanRequest)
        }
    }
    
    // MARK: - Special Event Notifications
    func scheduleEvolutionReminder(for buddy: SustainaBuddy) {
        guard buddy.evolutionProgress > 0.8 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🌟 Evolution Coming Soon!"
        content.body = "\(buddy.name) is almost ready to evolve! Keep up the great care!"
        content.sound = .default
        content.categoryIdentifier = "EVOLUTION"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        let request = UNNotificationRequest(identifier: "evolution_ready", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleLevelUpReminder(for buddy: SustainaBuddy) {
        let experienceNeeded = (buddy.level * 100) - buddy.experience
        guard experienceNeeded <= 20 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "⭐ Level Up Soon!"
        content.body = "\(buddy.name) needs only \(experienceNeeded) more experience to level up!"
        content.sound = .default
        content.categoryIdentifier = "LEVEL_UP"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: "level_up_soon", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Notification Management
    func clearBuddyCareNotifications() {
        let identifiers = [
            "hunger_critical", "energy_critical", "health_critical", "cleanliness_critical",
            "morning_care", "afternoon_care", "evening_care", "bedtime_care",
            "feeding_10", "feeding_14", "feeding_18",
            "play_11", "play_16", "play_20",
            "clean_9", "clean_21"
        ]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // MARK: - Notification Categories
    func setupNotificationCategories() {
        let center = UNUserNotificationCenter.current()
        
        // Buddy Care Category
        let careAction = UNNotificationAction(identifier: "CARE_ACTION", title: "Care for Buddy", options: [.foreground])
        let careCategory = UNNotificationCategory(identifier: "BUDDY_CARE", actions: [careAction], intentIdentifiers: [], options: [])
        
        // Daily Care Category
        let checkAction = UNNotificationAction(identifier: "CHECK_ACTION", title: "Check Buddy", options: [.foreground])
        let dailyCategory = UNNotificationCategory(identifier: "DAILY_CARE", actions: [checkAction], intentIdentifiers: [], options: [])
        
        // Stat Reminder Category
        let statAction = UNNotificationAction(identifier: "STAT_ACTION", title: "Open App", options: [.foreground])
        let statCategory = UNNotificationCategory(identifier: "STAT_REMINDER", actions: [statAction], intentIdentifiers: [], options: [])
        
        // Evolution Category
        let evolutionAction = UNNotificationAction(identifier: "EVOLUTION_ACTION", title: "Check Evolution", options: [.foreground])
        let evolutionCategory = UNNotificationCategory(identifier: "EVOLUTION", actions: [evolutionAction], intentIdentifiers: [], options: [])
        
        // Level Up Category
        let levelAction = UNNotificationAction(identifier: "LEVEL_ACTION", title: "View Progress", options: [.foreground])
        let levelCategory = UNNotificationCategory(identifier: "LEVEL_UP", actions: [levelAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([careCategory, dailyCategory, statCategory, evolutionCategory, levelCategory])
    }
    
    // MARK: - Notification Status
    func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
}

// MARK: - Notification Extensions
extension NotificationManager {
    func scheduleCustomReminder(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyReport(for buddy: SustainaBuddy) {
        let content = UNMutableNotificationContent()
        content.title = "📊 Weekly Buddy Report"
        content.body = "Check out \(buddy.name)'s progress this week! Level \(buddy.level), \(buddy.evolutionStage.rawValue) stage."
        content.sound = .default
        content.categoryIdentifier = "WEEKLY_REPORT"
        
        var weeklyComponents = DateComponents()
        weeklyComponents.weekday = 1 // Sunday
        weeklyComponents.hour = 10
        weeklyComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weekly_report", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}