//
//  NotificationSettingsView.swift
//  SustainaBuddy
//
//  Created by SustainaBuddy Team
//

import SwiftUI
import UserNotifications
import UIKit

struct NotificationSettingsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var appState: AppState
    @State private var notificationsEnabled = false
    @State private var dailyReminders = true
    @State private var criticalAlerts = true
    @State private var playReminders = true
    @State private var feedingReminders = true
    @State private var cleaningReminders = true
    @State private var evolutionAlerts = true
    @State private var weeklyReports = true
    @State private var pendingNotifications: [UNNotificationRequest] = []
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationView {
            List {
                notificationStatusSection
                buddyCareRemindersSection
                activityRemindersSection
                specialEventsSection
                quickActionsSection
                upcomingNotificationsSection
            }
            .navigationTitle("Notifications")
            .onAppear {
                checkNotificationStatus()
                loadPendingNotifications()
            }
            .alert("Enable Notifications", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    openAppSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("To receive buddy care reminders, please enable notifications in Settings.")
            }
        }
    }
    
    // MARK: - View Components
    
    private var notificationStatusSection: some View {
        Section("Notification Status") {
            HStack {
                Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash.fill")
                    .foregroundColor(notificationsEnabled ? .green : .red)
                Text("Notifications")
                Spacer()
                Text(notificationsEnabled ? "Enabled" : "Disabled")
                    .foregroundColor(notificationsEnabled ? .green : .red)
            }
            
            if !notificationsEnabled {
                Button("Enable Notifications") {
                    showingPermissionAlert = true
                }
                .foregroundColor(.blue)
            }
            
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                Text("Pending Notifications")
                Spacer()
                Text("\(pendingNotifications.count)")
                    .foregroundColor(.secondary)
            }
        }
    }
                
    
    private var buddyCareRemindersSection: some View {
        Section("Buddy Care Reminders") {
            Toggle(isOn: $dailyReminders) {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading) {
                        Text("Daily Care Reminders")
                        Text("Morning, afternoon, evening, and bedtime")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: dailyReminders) { _ in
                updateNotifications()
            }
            
            Toggle(isOn: $criticalAlerts) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading) {
                        Text("Critical Care Alerts")
                        Text("When stats are dangerously low")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: criticalAlerts) { _ in
                updateNotifications()
            }
        }
    }
                
    
    private var activityRemindersSection: some View {
        Section("Activity Reminders") {
            Toggle(isOn: $feedingReminders) {
                HStack {
                    Image(systemName: "fork.knife")
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Feeding Reminders")
                        Text("Regular meal times throughout the day")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: feedingReminders) { _ in
                updateNotifications()
            }
            
            Toggle(isOn: $playReminders) {
                HStack {
                    Image(systemName: "gamecontroller.fill")
                        .foregroundColor(.purple)
                    VStack(alignment: .leading) {
                        Text("Play Time Reminders")
                        Text("Fun activities to boost happiness")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: playReminders) { _ in
                updateNotifications()
            }
            
            Toggle(isOn: $cleaningReminders) {
                HStack {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("Cleaning Reminders")
                        Text("Bath time to keep buddy clean")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: cleaningReminders) { _ in
                updateNotifications()
            }
        }
    }
                
    
    private var specialEventsSection: some View {
        Section("Special Events") {
            Toggle(isOn: $evolutionAlerts) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    VStack(alignment: .leading) {
                        Text("Evolution & Level Up Alerts")
                        Text("When buddy is ready to evolve or level up")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: evolutionAlerts) { _ in
                updateNotifications()
            }
            
            Toggle(isOn: $weeklyReports) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.indigo)
                    VStack(alignment: .leading) {
                        Text("Weekly Progress Reports")
                        Text("Sunday morning summary of buddy's week")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: weeklyReports) { _ in
                updateNotifications()
            }
        }
    }
                
    
    private var quickActionsSection: some View {
        Section("Quick Actions") {
            Button(action: {
                testNotification()
            }) {
                HStack {
                    Image(systemName: "bell.badge.fill")
                        .foregroundColor(.blue)
                    Text("Send Test Notification")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .foregroundColor(.primary)
            
            Button(action: {
                clearAllNotifications()
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                    Text("Clear All Notifications")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .foregroundColor(.red)
        }
    }
                
    
    private var upcomingNotificationsSection: some View {
        Group {
            if !pendingNotifications.isEmpty {
                Section("Upcoming Notifications") {
                    ForEach(pendingNotifications.prefix(5), id: \.identifier) { notification in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(notification.content.title)
                                    .font(.headline)
                                Spacer()
                                Text(formatNotificationDate(notification.trigger))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            if !notification.content.body.isEmpty {
                                Text(notification.content.body)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    
                    if pendingNotifications.count > 5 {
                        Text("And \(pendingNotifications.count - 5) more...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func checkNotificationStatus() {
        notificationManager.checkNotificationStatus { enabled in
            notificationsEnabled = enabled
        }
    }
    
    private func loadPendingNotifications() {
        notificationManager.getPendingNotifications { notifications in
            pendingNotifications = notifications
        }
    }
    
    private func updateNotifications() {
        guard notificationsEnabled else { return }
        
        // Clear existing notifications
        notificationManager.clearBuddyCareNotifications()
        
        // Reschedule based on current settings
        if dailyReminders || criticalAlerts || feedingReminders || playReminders || cleaningReminders {
            notificationManager.scheduleBuddyCareReminders(for: appState.sustainaBuddy)
        }
        
        if evolutionAlerts {
            notificationManager.scheduleEvolutionReminder(for: appState.sustainaBuddy)
            notificationManager.scheduleLevelUpReminder(for: appState.sustainaBuddy)
        }
        
        if weeklyReports {
            notificationManager.scheduleWeeklyReport(for: appState.sustainaBuddy)
        }
        
        // Refresh the pending notifications list
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            loadPendingNotifications()
        }
    }
    
    private func testNotification() {
        notificationManager.scheduleCustomReminder(
            title: "🧪 Test Notification",
            body: "This is a test notification from SustainaBuddy!",
            timeInterval: 5
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            loadPendingNotifications()
        }
    }
    
    private func refreshNotifications() {
        updateNotifications()
    }
    
    private func clearAllNotifications() {
        notificationManager.clearAllNotifications()
        loadPendingNotifications()
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    private func formatNotificationDate(_ trigger: UNNotificationTrigger?) -> String {
        if let trigger = trigger as? UNCalendarNotificationTrigger {
            return trigger.repeats ? "Repeats" : "Once"
        } else if let trigger = trigger as? UNTimeIntervalNotificationTrigger {
            let interval = Int(trigger.timeInterval)
            if interval < 60 {
                return "\(interval)s"
            } else if interval < 3600 {
                return "\(interval/60)m"
            } else {
                return "\(interval/3600)h"
            }
        }
        return "Unknown"
    }
}

#Preview {
    NotificationSettingsView()
        .environmentObject(NotificationManager.shared)
        .environmentObject(AppState())
}