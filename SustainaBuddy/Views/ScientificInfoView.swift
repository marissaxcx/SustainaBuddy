//
//  ScientificInfoView.swift
//  SustainaBuddy
//
//  Created by SustainaBuddy Team.
//

import SwiftUI

struct ScientificInfoView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .center, spacing: 10) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Scientific Information")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Learn about marine conservation and sustainability")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    Divider()
                    
                    // Marine Conservation Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Marine Conservation")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("Our oceans are home to incredible biodiversity, but they face unprecedented threats from climate change, pollution, and overfishing. Marine conservation efforts focus on protecting critical habitats, endangered species, and maintaining healthy ocean ecosystems.")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    // Sustainability Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Sustainable Living")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        
                        Text("Sustainable living involves making choices that reduce our environmental impact. This includes choosing eco-friendly restaurants, reducing plastic consumption, supporting renewable energy, and making conscious decisions about transportation and consumption.")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    // App Mission Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Our Mission")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                        
                        Text("SustainaBuddy aims to connect people with marine life and sustainable practices. By tracking marine animals and suggesting eco-friendly dining options, we help users make informed decisions that benefit both the environment and local communities.")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Scientific Info")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ScientificInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ScientificInfoView()
    }
}