//
//  MarineAnimal.swift
//  SustainaBuddy
//
//  Marine Animal Data Models
//

import Foundation
import MapKit
import SwiftUI

// MARK: - Marine Animal Model
struct MarineAnimal: Identifiable, Codable {
    let id = UUID()
    let name: String
    let species: MarineSpecies
    let latitude: Double
    let longitude: Double
    let location: String
    let lastSeen: Date
    let tagId: String
    let isActive: Bool
    let conservationStatus: ConservationStatus
    let size: String
    let age: String?
    let description: String
    
    init(name: String, species: MarineSpecies, latitude: Double, longitude: Double, location: String, tagId: String = UUID().uuidString, isActive: Bool = true, conservationStatus: ConservationStatus = .leastConcern, size: String = "Unknown", age: String? = nil, description: String = "") {
        self.name = name
        self.species = species
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        self.lastSeen = Date().addingTimeInterval(-Double.random(in: 0...3600)) // Random time within last hour
        self.tagId = tagId
        self.isActive = isActive
        self.conservationStatus = conservationStatus
        self.size = size
        self.age = age
        self.description = description.isEmpty ? species.defaultDescription : description
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Marine Species
enum MarineSpecies: String, CaseIterable, Codable {
    case greatWhiteShark = "Great White Shark"
    case tigerShark = "Tiger Shark"
    case hammerheadShark = "Hammerhead Shark"
    case seaTurtle = "Sea Turtle"
    case leatherbackTurtle = "Leatherback Turtle"
    case loggerheadTurtle = "Loggerhead Turtle"
    case kempsRidleyTurtle = "Kemp's Ridley Turtle"
    case humpbackWhale = "Humpback Whale"
    case blueWhale = "Blue Whale"
    case spermWhale = "Sperm Whale"
    case northAtlanticRightWhale = "North Atlantic Right Whale"
    case bottlenoseDolphin = "Bottlenose Dolphin"
    case orca = "Orca"
    case manatee = "Manatee"
    case sealion = "Sea Lion"
    case elephant_seal = "Elephant Seal"
    case manta_ray = "Manta Ray"
    case whale_shark = "Whale Shark"
    
    var emoji: String {
        switch self {
        case .greatWhiteShark, .tigerShark, .hammerheadShark, .whale_shark:
            return "🦈"
        case .seaTurtle, .leatherbackTurtle, .loggerheadTurtle, .kempsRidleyTurtle:
            return "🐢"
        case .humpbackWhale, .blueWhale, .spermWhale, .northAtlanticRightWhale:
            return "🐋"
        case .bottlenoseDolphin:
            return "🐬"
        case .orca:
            return "🐋"
        case .manatee:
            return "🦭"
        case .sealion, .elephant_seal:
            return "🦭"
        case .manta_ray:
            return "🐟"
        }
    }
    
    var color: Color {
        switch self {
        case .greatWhiteShark, .tigerShark, .hammerheadShark:
            return .red
        case .seaTurtle, .leatherbackTurtle, .loggerheadTurtle, .kempsRidleyTurtle:
            return .green
        case .humpbackWhale, .blueWhale, .spermWhale, .northAtlanticRightWhale:
            return .blue
        case .bottlenoseDolphin:
            return .cyan
        case .orca:
            return .purple
        case .manatee:
            return .brown
        case .sealion, .elephant_seal:
            return .orange
        case .manta_ray, .whale_shark:
            return .yellow
        }
    }
    
    var defaultDescription: String {
        switch self {
        case .greatWhiteShark:
            return "The great white shark is a species of large mackerel shark found in coastal waters of all major oceans."
        case .tigerShark:
            return "Tiger sharks are known for their distinctive dark stripes and are found in tropical and subtropical waters."
        case .hammerheadShark:
            return "Hammerhead sharks are distinguished by their flattened, laterally extended head structure."
        case .seaTurtle:
            return "Sea turtles are large, air-breathing reptiles that inhabit tropical and subtropical seas."
        case .leatherbackTurtle:
            return "The leatherback turtle is the largest of all living turtles and the heaviest non-crocodilian reptile."
        case .loggerheadTurtle:
            return "Loggerhead turtles are the world's largest hard-shelled turtle, known for their powerful jaws."
        case .kempsRidleyTurtle:
            return "Kemp's ridley turtles are the world's most endangered sea turtle, found primarily in the Gulf of Mexico."
        case .humpbackWhale:
            return "Humpback whales are known for their magical songs and spectacular breaching behavior."
        case .blueWhale:
            return "Blue whales are the largest animals ever known to have lived on Earth."
        case .spermWhale:
            return "Sperm whales are the largest of the toothed whales and can dive to great depths."
        case .northAtlanticRightWhale:
            return "North Atlantic right whales are critically endangered baleen whales, with fewer than 340 individuals remaining."
        case .bottlenoseDolphin:
            return "Bottlenose dolphins are highly intelligent marine mammals known for their playful behavior."
        case .orca:
            return "Orcas, or killer whales, are the largest members of the dolphin family."
        case .manatee:
            return "Manatees are gentle, slow-moving aquatic mammals also known as sea cows."
        case .sealion:
            return "Sea lions are intelligent marine mammals known for their agility both in water and on land."
        case .elephant_seal:
            return "Elephant seals are the largest pinnipeds, named for the large proboscis of adult males."
        case .manta_ray:
            return "Manta rays are large rays belonging to the genus Mobula, known for their graceful swimming."
        case .whale_shark:
            return "Whale sharks are the largest known extant fish species, despite being filter feeders."
        }
    }
}

// MARK: - Conservation Status
enum ConservationStatus: String, CaseIterable, Codable {
    case criticallyEndangered = "Critically Endangered"
    case endangered = "Endangered"
    case vulnerable = "Vulnerable"
    case nearThreatened = "Near Threatened"
    case leastConcern = "Least Concern"
    case dataDeficient = "Data Deficient"
    
    var color: Color {
        switch self {
        case .criticallyEndangered:
            return .red
        case .endangered:
            return .orange
        case .vulnerable:
            return .yellow
        case .nearThreatened:
            return .blue
        case .leastConcern:
            return .green
        case .dataDeficient:
            return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .criticallyEndangered, .endangered:
            return "exclamationmark.triangle.fill"
        case .vulnerable, .nearThreatened:
            return "exclamationmark.circle.fill"
        case .leastConcern:
            return "checkmark.circle.fill"
        case .dataDeficient:
            return "questionmark.circle.fill"
        }
    }
}