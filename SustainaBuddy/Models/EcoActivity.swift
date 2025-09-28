//
//  EcoActivity.swift
//  SustainaBuddy
//
//  Eco Activity Data Models
//

import Foundation
import SwiftUI

// MARK: - Eco Activity Model
struct EcoActivity: Identifiable, Codable {
    let id = UUID()
    let type: EcoActivityType
    let timestamp: Date
    let creditsEarned: Int
    let co2Saved: Double // in kg
    let notes: String?
    
    init(type: EcoActivityType, timestamp: Date = Date(), creditsEarned: Int? = nil, co2Saved: Double? = nil, notes: String? = nil) {
        self.type = type
        self.timestamp = timestamp
        self.creditsEarned = creditsEarned ?? type.baseCredits
        self.co2Saved = co2Saved ?? type.co2Impact
        self.notes = notes
    }
}

// MARK: - Eco Activity Types
enum EcoActivityType: String, CaseIterable, Codable, Identifiable {
    var id: String { self.rawValue }
    // Transportation
    case bikeToWork = "bike_to_work"
    case walkToWork = "walk_to_work"
    case publicTransit = "public_transit"
    case carpool = "carpool"
    case electricVehicle = "electric_vehicle"
    case workFromHome = "work_from_home"
    
    // Food & Diet
    case vegetarianMeal = "vegetarian_meal"
    case veganMeal = "vegan_meal"
    case localFood = "local_food"
    case organicFood = "organic_food"
    case reducedMeat = "reduced_meat"
    case homeCooking = "home_cooking"
    
    // Energy & Home
    case solarPower = "solar_power"
    case energyEfficient = "energy_efficient"
    case reducedHeating = "reduced_heating"
    case ledLights = "led_lights"
    case unplugDevices = "unplug_devices"
    case coldWaterWash = "cold_water_wash"
    
    // Waste & Recycling
    case recycled = "recycled"
    case composted = "composted"
    case reusedItems = "reused_items"
    case reducedPlastic = "reduced_plastic"
    case repaired = "repaired"
    case donated = "donated"
    
    // Water Conservation
    case shorterShower = "shorter_shower"
    case rainwaterCollection = "rainwater_collection"
    case waterEfficientAppliances = "water_efficient_appliances"
    case fixedLeaks = "fixed_leaks"
    
    // Sustainable Shopping
    case secondhandPurchase = "secondhand_purchase"
    case sustainableBrands = "sustainable_brands"
    case minimalPackaging = "minimal_packaging"
    case bulkBuying = "bulk_buying"
    
    var displayName: String {
        switch self {
        case .bikeToWork: return "Biked to Work"
        case .walkToWork: return "Walked to Work"
        case .publicTransit: return "Used Public Transit"
        case .carpool: return "Carpooled"
        case .electricVehicle: return "Used Electric Vehicle"
        case .workFromHome: return "Worked from Home"
        case .vegetarianMeal: return "Ate Vegetarian Meal"
        case .veganMeal: return "Ate Vegan Meal"
        case .localFood: return "Bought Local Food"
        case .organicFood: return "Chose Organic Food"
        case .reducedMeat: return "Reduced Meat Consumption"
        case .homeCooking: return "Cooked at Home"
        case .solarPower: return "Used Solar Power"
        case .energyEfficient: return "Used Energy Efficient Appliances"
        case .reducedHeating: return "Reduced Heating/Cooling"
        case .ledLights: return "Switched to LED Lights"
        case .unplugDevices: return "Unplugged Devices"
        case .coldWaterWash: return "Washed in Cold Water"
        case .recycled: return "Recycled Items"
        case .composted: return "Composted Organic Waste"
        case .reusedItems: return "Reused Items"
        case .reducedPlastic: return "Reduced Plastic Use"
        case .repaired: return "Repaired Instead of Replacing"
        case .donated: return "Donated Items"
        case .shorterShower: return "Took Shorter Shower"
        case .rainwaterCollection: return "Collected Rainwater"
        case .waterEfficientAppliances: return "Used Water Efficient Appliances"
        case .fixedLeaks: return "Fixed Water Leaks"
        case .secondhandPurchase: return "Bought Secondhand"
        case .sustainableBrands: return "Chose Sustainable Brands"
        case .minimalPackaging: return "Chose Minimal Packaging"
        case .bulkBuying: return "Bought in Bulk"
        }
    }
    
    var emoji: String {
        switch self {
        case .bikeToWork: return "🚴‍♀️"
        case .walkToWork: return "🚶‍♀️"
        case .publicTransit: return "🚌"
        case .carpool: return "🚗"
        case .electricVehicle: return "🔋"
        case .workFromHome: return "🏠"
        case .vegetarianMeal: return "🥗"
        case .veganMeal: return "🌱"
        case .localFood: return "🏪"
        case .organicFood: return "🌿"
        case .reducedMeat: return "🥬"
        case .homeCooking: return "👩‍🍳"
        case .solarPower: return "☀️"
        case .energyEfficient: return "⚡"
        case .reducedHeating: return "🌡️"
        case .ledLights: return "💡"
        case .unplugDevices: return "🔌"
        case .coldWaterWash: return "🧺"
        case .recycled: return "♻️"
        case .composted: return "🍂"
        case .reusedItems: return "🔄"
        case .reducedPlastic: return "🚫"
        case .repaired: return "🔧"
        case .donated: return "💝"
        case .shorterShower: return "🚿"
        case .rainwaterCollection: return "🌧️"
        case .waterEfficientAppliances: return "💧"
        case .fixedLeaks: return "🔧"
        case .secondhandPurchase: return "👕"
        case .sustainableBrands: return "🌍"
        case .minimalPackaging: return "📦"
        case .bulkBuying: return "🛒"
        }
    }
    
    var baseCredits: Int {
        switch self {
        case .bikeToWork, .walkToWork: return 25
        case .publicTransit, .carpool: return 15
        case .electricVehicle: return 20
        case .workFromHome: return 30
        case .vegetarianMeal: return 20
        case .veganMeal: return 30
        case .localFood, .organicFood: return 15
        case .reducedMeat, .homeCooking: return 10
        case .solarPower: return 50
        case .energyEfficient: return 25
        case .reducedHeating, .ledLights: return 15
        case .unplugDevices, .coldWaterWash: return 10
        case .recycled, .composted: return 10
        case .reusedItems, .reducedPlastic: return 15
        case .repaired: return 25
        case .donated: return 20
        case .shorterShower: return 10
        case .rainwaterCollection: return 30
        case .waterEfficientAppliances: return 25
        case .fixedLeaks: return 20
        case .secondhandPurchase: return 20
        case .sustainableBrands: return 15
        case .minimalPackaging, .bulkBuying: return 10
        }
    }
    
    var co2Impact: Double {
        switch self {
        case .bikeToWork, .walkToWork: return 2.5
        case .publicTransit: return 1.8
        case .carpool: return 1.2
        case .electricVehicle: return 2.0
        case .workFromHome: return 3.5
        case .vegetarianMeal: return 1.5
        case .veganMeal: return 2.2
        case .localFood: return 0.8
        case .organicFood: return 0.6
        case .reducedMeat: return 1.0
        case .homeCooking: return 0.5
        case .solarPower: return 5.0
        case .energyEfficient: return 2.0
        case .reducedHeating: return 1.5
        case .ledLights: return 0.8
        case .unplugDevices: return 0.3
        case .coldWaterWash: return 0.4
        case .recycled: return 0.5
        case .composted: return 0.3
        case .reusedItems: return 0.8
        case .reducedPlastic: return 0.6
        case .repaired: return 1.5
        case .donated: return 1.0
        case .shorterShower: return 0.4
        case .rainwaterCollection: return 1.2
        case .waterEfficientAppliances: return 1.0
        case .fixedLeaks: return 0.8
        case .secondhandPurchase: return 1.5
        case .sustainableBrands: return 0.8
        case .minimalPackaging: return 0.3
        case .bulkBuying: return 0.4
        }
    }
    
    var category: ActivityCategory {
        switch self {
        case .bikeToWork, .walkToWork, .publicTransit, .carpool, .electricVehicle, .workFromHome:
            return .transportation
        case .vegetarianMeal, .veganMeal, .localFood, .organicFood, .reducedMeat, .homeCooking:
            return .food
        case .solarPower, .energyEfficient, .reducedHeating, .ledLights, .unplugDevices, .coldWaterWash:
            return .energy
        case .recycled, .composted, .reusedItems, .reducedPlastic, .repaired, .donated:
            return .waste
        case .shorterShower, .rainwaterCollection, .waterEfficientAppliances, .fixedLeaks:
            return .water
        case .secondhandPurchase, .sustainableBrands, .minimalPackaging, .bulkBuying:
            return .shopping
        }
    }
    
    var color: Color {
        return category.color
    }
}

// MARK: - Activity Categories
enum ActivityCategory: String, CaseIterable {
    case transportation = "Transportation"
    case food = "Food & Diet"
    case energy = "Energy & Home"
    case waste = "Waste & Recycling"
    case water = "Water Conservation"
    case shopping = "Sustainable Shopping"
    
    var color: Color {
        switch self {
        case .transportation: return .blue
        case .food: return .green
        case .energy: return .yellow
        case .waste: return .red
        case .water: return .cyan
        case .shopping: return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .transportation: return "car.fill"
        case .food: return "fork.knife"
        case .energy: return "bolt.fill"
        case .waste: return "trash.fill"
        case .water: return "drop.fill"
        case .shopping: return "bag.fill"
        }
    }
}

// MARK: - Eco Footprint View Model
class EcoFootprintViewModel: ObservableObject {
    @Published var recentActivities: [EcoActivity] = []
    @Published var currentFootprint: Double = 0.0
    @Published var footprintTrend: FootprintTrend = .down
    @Published var footprintChange: Double = 0.0
    @Published var progressToNextLevel: Int = 65
    
    @Published var todayTransportCO2: Double = 0.0
    @Published var todayEnergyCO2: Double = 0.0
    @Published var todayFoodCO2: Double = 0.0
    @Published var todayWasteCO2: Double = 0.0
    
    @Published var chartData: [ChartDataPoint] = []
    
    func loadData() {
        // Load sample data
        generateSampleActivities()
        calculateTodaysImpact()
        generateChartData()
        calculateFootprintMetrics()
    }
    
    func logActivity(_ activity: EcoActivity) {
        recentActivities.insert(activity, at: 0)
        calculateTodaysImpact()
        
        // In a real app, save to persistent storage
    }
    
    private func generateSampleActivities() {
        let sampleActivities = [
            EcoActivity(type: .bikeToWork, timestamp: Date().addingTimeInterval(-3600)),
            EcoActivity(type: .vegetarianMeal, timestamp: Date().addingTimeInterval(-7200)),
            EcoActivity(type: .recycled, timestamp: Date().addingTimeInterval(-10800)),
            EcoActivity(type: .publicTransit, timestamp: Date().addingTimeInterval(-14400)),
            EcoActivity(type: .shorterShower, timestamp: Date().addingTimeInterval(-18000)),
        ]
        
        recentActivities = sampleActivities
    }
    
    private func calculateTodaysImpact() {
        let today = Calendar.current.startOfDay(for: Date())
        let todaysActivities = recentActivities.filter {
            Calendar.current.isDate($0.timestamp, inSameDayAs: today)
        }
        
        todayTransportCO2 = todaysActivities
            .filter { $0.type.category == .transportation }
            .reduce(0) { $0 + $1.co2Saved }
        
        todayEnergyCO2 = todaysActivities
            .filter { $0.type.category == .energy }
            .reduce(0) { $0 + $1.co2Saved }
        
        todayFoodCO2 = todaysActivities
            .filter { $0.type.category == .food }
            .reduce(0) { $0 + $1.co2Saved }
        
        todayWasteCO2 = todaysActivities
            .filter { $0.type.category == .waste }
            .reduce(0) { $0 + $1.co2Saved }
    }
    
    private func generateChartData() {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        chartData = days.map { day in
            ChartDataPoint(day: day, value: Double.random(in: 15...35))
        }
    }
    
    private func calculateFootprintMetrics() {
        currentFootprint = 24.5 // Sample current footprint
        footprintTrend = .down
        footprintChange = -12.3
    }
}