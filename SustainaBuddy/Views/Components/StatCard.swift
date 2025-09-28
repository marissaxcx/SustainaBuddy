//
//  StatCard.swift
//  SustainaBuddy
//
//  Reusable stat card component for displaying statistics
//

import SwiftUI

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.frostedGlass.opacity(0.5))
        .cornerRadius(12)
    }
}

// MARK: - Preview

struct StatCard_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "trophy.fill",
                value: "12",
                label: "Unlocked",
                color: .yellow
            )
            
            StatCard(
                icon: "target",
                value: "5",
                label: "In Progress",
                color: .orange
            )
            
            StatCard(
                icon: "lock.fill",
                value: "8",
                label: "Locked",
                color: .gray
            )
        }
        .padding()
        .background(Color.sleekDark)
        .preferredColorScheme(.dark)
    }
}