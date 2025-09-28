//
//  AnimalProfileView.swift
//  SustainaBuddy
//
//  Detailed Animal Profile View
//

import SwiftUI
import MapKit

struct AnimalProfileView: View {
    let animal: MarineAnimal
    @Environment(\.dismiss) private var dismiss
    @State private var isFollowing = false
    @State private var showingLocationHistory = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with animal info
                    headerSection
                    
                    // Current location map
                    locationSection
                    
                    // Animal details
                    detailsSection
                    
                    // Conservation status
                    conservationSection
                    
                    // Action buttons
                    actionSection
                }
                .padding()
            }
            .background(Color.sleekDark)
            .navigationTitle(animal.name)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                },
                trailing: Button(action: {
                    isFollowing.toggle()
                }) {
                    Image(systemName: isFollowing ? "heart.fill" : "heart")
                        .foregroundColor(isFollowing ? .red : .gray)
                }
            )
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(animal.species.emoji)
                    .font(.system(size: 60))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(animal.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(animal.species.rawValue)
                        .font(.title2)
                        .foregroundColor(.glowingCyan)
                    
                    HStack {
                        Circle()
                            .fill(animal.isActive ? Color.green : Color.orange)
                            .frame(width: 8, height: 8)
                        Text(animal.isActive ? "Active" : "Inactive")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            
            Text(animal.description)
                .font(.body)
                .foregroundColor(.white)
                .lineLimit(nil)
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Location")
                .font(.headline)
                .foregroundColor(.white)
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: animal.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            )), annotationItems: [animal]) { animal in
                MapAnnotation(coordinate: animal.coordinate) {
                    ZStack {
                        Circle()
                            .fill(animal.species.color)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                        Text(animal.species.emoji)
                            .font(.system(size: 16))
                    }
                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .frame(height: 200)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(animal.location)
                    .font(.subheadline)
                    .foregroundColor(.glowingCyan)
                
                Text("Last seen: \(animal.lastSeen, style: .relative) ago")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("Tag ID: \(animal.tagId)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                AnimalDetailRow(title: "Size", value: animal.size)
                if let age = animal.age {
                    AnimalDetailRow(title: "Age", value: age)
                }
                AnimalDetailRow(title: "Species", value: animal.species.rawValue)
                AnimalDetailRow(title: "Tag ID", value: animal.tagId)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var conservationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Conservation Status")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: animal.conservationStatus.icon)
                    .foregroundColor(animal.conservationStatus.color)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(animal.conservationStatus.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(animal.conservationStatus.color)
                    
                    Text(conservationDescription)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var actionSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                isFollowing.toggle()
            }) {
                HStack {
                    Image(systemName: isFollowing ? "heart.fill" : "heart")
                    Text(isFollowing ? "Following" : "Follow Animal")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFollowing ? Color.red : Color.glowingCyan)
                .cornerRadius(12)
            }
            
            Button(action: {
                showingLocationHistory = true
            }) {
                HStack {
                    Image(systemName: "location.circle")
                    Text("View Location History")
                }
                .font(.headline)
                .foregroundColor(.glowingCyan)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.frostedGlass)
                .cornerRadius(12)
            }
        }
    }
    
    private var conservationDescription: String {
        switch animal.conservationStatus {
        case .criticallyEndangered:
            return "Extremely high risk of extinction in the wild."
        case .endangered:
            return "High risk of extinction in the wild."
        case .vulnerable:
            return "High risk of endangerment in the wild."
        case .nearThreatened:
            return "Likely to become endangered in the near future."
        case .leastConcern:
            return "Lowest risk; does not qualify for a more at-risk category."
        case .dataDeficient:
            return "Inadequate information to make a direct assessment."
        }
    }
}

// MARK: - Detail Row Component
struct AnimalDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview
struct AnimalProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalProfileView(
            animal: MarineAnimal(
                name: "Bruce",
                species: .greatWhiteShark,
                latitude: 37.7749,
                longitude: -122.4194,
                location: "San Francisco Bay",
                conservationStatus: .vulnerable,
                size: "4.5 meters",
                age: "12 years"
            )
        )
        .preferredColorScheme(.dark)
    }
}