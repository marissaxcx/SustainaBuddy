//
//  Restaurant.swift
//  SustainaBuddy
//
//  Restaurant Data Models for Eco-Dining Guide
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation

// MARK: - Restaurant Model
struct Restaurant: Identifiable, Codable {
    let id = UUID()
    let name: String
    let cuisine: String
    let description: String
    let imageURL: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    let sustainabilityScore: Double
    let sustainabilityFeatures: [SustainabilityFeature]
    let hasSpecialOffer: Bool
    let checkInBonus: Int
    let distance: Double // in km
    let address: String
    let phoneNumber: String
    let website: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(name: String, cuisine: String, description: String, imageURL: String, latitude: Double, longitude: Double, rating: Double, sustainabilityScore: Double, sustainabilityFeatures: [SustainabilityFeature], hasSpecialOffer: Bool = false, checkInBonus: Int = 0, distance: Double, address: String, phoneNumber: String, website: String? = nil) {
        self.name = name
        self.cuisine = cuisine
        self.description = description
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.sustainabilityScore = sustainabilityScore
        self.sustainabilityFeatures = sustainabilityFeatures
        self.hasSpecialOffer = hasSpecialOffer
        self.checkInBonus = checkInBonus
        self.distance = distance
        self.address = address
        self.phoneNumber = phoneNumber
        self.website = website
    }
}

// MARK: - Sustainability Features
enum SustainabilityFeature: String, CaseIterable, Codable {
    case localSourcing = "local_sourcing"
    case organicIngredients = "organic_ingredients"
    case sustainableSeafood = "sustainable_seafood"
    case zeroWaste = "zero_waste"
    case renewableEnergy = "renewable_energy"
    case waterConservation = "water_conservation"
    case compostProgram = "compost_program"
    case plasticFree = "plastic_free"
    case carbonNeutral = "carbon_neutral"
    case fairTrade = "fair_trade"
    case plantBased = "plant_based"
    case seasonalMenu = "seasonal_menu"
    case recyclingProgram = "recycling_program"
    case energyEfficient = "energy_efficient"
    case sustainablePackaging = "sustainable_packaging"
    
    var displayName: String {
        switch self {
        case .localSourcing: return "Local Sourcing"
        case .organicIngredients: return "Organic Ingredients"
        case .sustainableSeafood: return "Sustainable Seafood"
        case .zeroWaste: return "Zero Waste"
        case .renewableEnergy: return "Renewable Energy"
        case .waterConservation: return "Water Conservation"
        case .compostProgram: return "Compost Program"
        case .plasticFree: return "Plastic Free"
        case .carbonNeutral: return "Carbon Neutral"
        case .fairTrade: return "Fair Trade"
        case .plantBased: return "Plant Based Options"
        case .seasonalMenu: return "Seasonal Menu"
        case .recyclingProgram: return "Recycling Program"
        case .energyEfficient: return "Energy Efficient"
        case .sustainablePackaging: return "Sustainable Packaging"
        }
    }
    
    var icon: String {
        switch self {
        case .localSourcing: return "location.fill"
        case .organicIngredients: return "leaf.fill"
        case .sustainableSeafood: return "fish.fill"
        case .zeroWaste: return "trash.slash.fill"
        case .renewableEnergy: return "sun.max.fill"
        case .waterConservation: return "drop.fill"
        case .compostProgram: return "leaf.arrow.circlepath"
        case .plasticFree: return "xmark.circle.fill"
        case .carbonNeutral: return "cloud.fill"
        case .fairTrade: return "handshake.fill"
        case .plantBased: return "carrot.fill"
        case .seasonalMenu: return "calendar.circle.fill"
        case .recyclingProgram: return "arrow.3.trianglepath"
        case .energyEfficient: return "bolt.fill"
        case .sustainablePackaging: return "shippingbox.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .localSourcing: return .blue
        case .organicIngredients: return .green
        case .sustainableSeafood: return .cyan
        case .zeroWaste: return .red
        case .renewableEnergy: return .yellow
        case .waterConservation: return .blue
        case .compostProgram: return .brown
        case .plasticFree: return .red
        case .carbonNeutral: return .gray
        case .fairTrade: return .orange
        case .plantBased: return .green
        case .seasonalMenu: return .purple
        case .recyclingProgram: return .green
        case .energyEfficient: return .yellow
        case .sustainablePackaging: return .brown
        }
    }
    
    var description: String {
        switch self {
        case .localSourcing: return "Sources ingredients from local farms and producers"
        case .organicIngredients: return "Uses certified organic ingredients"
        case .sustainableSeafood: return "Serves only sustainably caught seafood"
        case .zeroWaste: return "Implements zero waste practices"
        case .renewableEnergy: return "Powered by renewable energy sources"
        case .waterConservation: return "Implements water conservation measures"
        case .compostProgram: return "Composts organic waste"
        case .plasticFree: return "Eliminates single-use plastics"
        case .carbonNeutral: return "Operates as a carbon neutral business"
        case .fairTrade: return "Sources fair trade certified products"
        case .plantBased: return "Offers extensive plant-based menu options"
        case .seasonalMenu: return "Menu changes with seasonal ingredients"
        case .recyclingProgram: return "Comprehensive recycling program"
        case .energyEfficient: return "Uses energy efficient appliances and lighting"
        case .sustainablePackaging: return "Uses biodegradable and sustainable packaging"
        }
    }
}

// MARK: - Sustainability Filters
enum SustainabilityFilter: String, CaseIterable {
    case highRated = "high_rated"
    case localSourcing = "local_sourcing"
    case organicFood = "organic_food"
    case sustainableSeafood = "sustainable_seafood"
    case zeroWaste = "zero_waste"
    case plantBased = "plant_based"
    case specialOffers = "special_offers"
    
    var displayName: String {
        switch self {
        case .highRated: return "Highly Rated"
        case .localSourcing: return "Local Sourcing"
        case .organicFood: return "Organic Food"
        case .sustainableSeafood: return "Sustainable Seafood"
        case .zeroWaste: return "Zero Waste"
        case .plantBased: return "Plant Based"
        case .specialOffers: return "Special Offers"
        }
    }
    
    var icon: String {
        switch self {
        case .highRated: return "star.fill"
        case .localSourcing: return "location.fill"
        case .organicFood: return "leaf.fill"
        case .sustainableSeafood: return "fish.fill"
        case .zeroWaste: return "trash.slash.fill"
        case .plantBased: return "carrot.fill"
        case .specialOffers: return "gift.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .highRated: return .yellow
        case .localSourcing: return .blue
        case .organicFood: return .green
        case .sustainableSeafood: return .cyan
        case .zeroWaste: return .red
        case .plantBased: return .green
        case .specialOffers: return .cyan
        }
    }
    
    var description: String {
        switch self {
        case .highRated: return "Restaurants with 4+ star ratings"
        case .localSourcing: return "Sources ingredients locally"
        case .organicFood: return "Serves organic food options"
        case .sustainableSeafood: return "Offers sustainably caught seafood"
        case .zeroWaste: return "Implements zero waste practices"
        case .plantBased: return "Extensive plant-based menu options"
        case .specialOffers: return "Restaurants with check-in bonuses"
        }
    }
}

// MARK: - Eco Dining View Model
class EcoDiningViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var activeFilters: Set<SustainabilityFilter> = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795), // Geographic center of US
        span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
    )
    @Published var userLocation: CLLocation?
    @Published var isLocationEnabled = false
    
    private var searchText = ""
    private let locationManager = CLLocationManager()
    private let maxDistanceKm: Double = 25.0 // Show restaurants within 25km when location available
    
    override init() {
        super.init()
        setupLocationManager()
        loadRestaurants()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateUserLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        isLocationEnabled = false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            isLocationEnabled = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            isLocationEnabled = false
            locationManager.stopUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func updateUserLocation(_ location: CLLocation) {
        userLocation = location
        
        // Update map region to center on user location
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        
        // Recalculate distances and re-sort restaurants
        updateRestaurantDistances()
        applyFilters()
    }
    
    private func updateRestaurantDistances() {
        guard let userLocation = userLocation else { return }
        
        restaurants = restaurants.map { restaurant in
            let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
            let distance = userLocation.distance(from: restaurantLocation) / 1000 // Convert to km
            
            return Restaurant(
                name: restaurant.name,
                cuisine: restaurant.cuisine,
                description: restaurant.description,
                imageURL: restaurant.imageURL,
                latitude: restaurant.latitude,
                longitude: restaurant.longitude,
                rating: restaurant.rating,
                sustainabilityScore: restaurant.sustainabilityScore,
                sustainabilityFeatures: restaurant.sustainabilityFeatures,
                hasSpecialOffer: restaurant.hasSpecialOffer,
                checkInBonus: restaurant.checkInBonus,
                distance: distance,
                address: restaurant.address,
                phoneNumber: restaurant.phoneNumber,
                website: restaurant.website
            )
        }
    }
    
    func loadRestaurants() {
        // Load sample restaurant data
        var data = generateSampleRestaurants()
        // Normalize dataset so filters have visible impact: only ~1/3 have specials
        data = data.enumerated().map { index, r in
            let specials = index % 3 == 0
            return Restaurant(
                name: r.name,
                cuisine: r.cuisine,
                description: r.description,
                imageURL: r.imageURL,
                latitude: r.latitude,
                longitude: r.longitude,
                rating: r.rating,
                sustainabilityScore: r.sustainabilityScore,
                sustainabilityFeatures: r.sustainabilityFeatures,
                hasSpecialOffer: specials,
                checkInBonus: specials ? r.checkInBonus : 0,
                distance: r.distance,
                address: r.address,
                phoneNumber: r.phoneNumber,
                website: r.website
            )
        }
        restaurants = data
        filteredRestaurants = data
    }
    
    func searchRestaurants(_ text: String) {
        searchText = text
        applyFilters()
    }
    
    func toggleFilter(_ filter: SustainabilityFilter) {
        print("🔄 Toggle filter called for: \(filter.displayName)")
        print("📊 Active filters before: \(activeFilters.map { $0.displayName })")
        
        if activeFilters.contains(filter) {
            activeFilters.remove(filter)
            print("❌ Removed filter: \(filter.displayName)")
        } else {
            activeFilters.insert(filter)
            print("✅ Added filter: \(filter.displayName)")
        }
        
        print("📊 Active filters after: \(activeFilters.map { $0.displayName })")
        print("🏪 Restaurants before filtering: \(restaurants.count)")
        
        applyFilters()
        
        print("🏪 Restaurants after filtering: \(filteredRestaurants.count)")
    }
    
    func clearAllFilters() {
        activeFilters.removeAll()
        searchText = ""
        applyFilters()
    }
    
    private func applyFilters() {
        var filtered = restaurants

        // Apply search text filter first - if user is searching, show all matching results regardless of distance
        if !searchText.isEmpty {
            filtered = filtered.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                restaurant.cuisine.localizedCaseInsensitiveContains(searchText) ||
                restaurant.address.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Apply sustainability filters
        for filter in activeFilters {
            filtered = filtered.filter { restaurant in
                switch filter {
                case .highRated:
                    return restaurant.rating >= 4.6
                case .localSourcing:
                    return restaurant.sustainabilityFeatures.contains(.localSourcing)
                case .organicFood:
                    return restaurant.sustainabilityFeatures.contains(.organicIngredients)
                case .sustainableSeafood:
                    return restaurant.sustainabilityFeatures.contains(.sustainableSeafood)
                case .zeroWaste:
                    return restaurant.sustainabilityFeatures.contains(.zeroWaste)
                case .plantBased:
                    return restaurant.sustainabilityFeatures.contains(.plantBased)
                case .specialOffers:
                    return restaurant.hasSpecialOffer
                }
            }
        }

        // Prioritize "healthiest options near you" with adaptive radius and nationwide fallback
        if userLocation != nil && searchText.isEmpty {
            let radiusSteps: [Double] = [maxDistanceKm, 50, 100, 250, 1000] // up to ~nationwide
            var chosen: [Restaurant] = []
            for radius in radiusSteps {
                let candidates = filtered.filter { $0.distance <= radius }
                if candidates.count >= 5 {
                    chosen = candidates
                    break
                } else if chosen.isEmpty {
                    // keep the best-so-far set to avoid empty results
                    chosen = candidates
                }
            }

            if !chosen.isEmpty {
                // Rank by sustainability first, then distance
                filteredRestaurants = chosen.sorted { lhs, rhs in
                    if lhs.sustainabilityScore == rhs.sustainabilityScore {
                        return lhs.distance < rhs.distance
                    }
                    return lhs.sustainabilityScore > rhs.sustainabilityScore
                }
            } else {
                // Absolute fallback: show top sustainable options nationwide
                filteredRestaurants = filtered
                    .sorted { lhs, rhs in
                        if lhs.sustainabilityScore == rhs.sustainabilityScore {
                            return lhs.distance < rhs.distance
                        }
                        return lhs.sustainabilityScore > rhs.sustainabilityScore
                    }
            }
        } else {
            // When searching or we don't have location yet, rank by relevance: sustainability then distance
            filteredRestaurants = filtered.sorted { lhs, rhs in
                if lhs.sustainabilityScore == rhs.sustainabilityScore {
                    return lhs.distance < rhs.distance
                }
                return lhs.sustainabilityScore > rhs.sustainabilityScore
            }
        }
    }
    
    private func generateSampleRestaurants() -> [Restaurant] {
        return [
            // New York City - Blue Hill
            Restaurant(
                name: "Blue Hill",
                cuisine: "Farm-to-Table",
                description: "MICHELIN Green Star restaurant pioneering farm-to-table dining with ingredients from Blue Hill Farm and local producers.",
                imageURL: "https://images.squarespace-cdn.com/content/v1/5a9f966f8dd041552dd1ce1b/1520459847474-YWQX8XQXQXQXQXQX/blue-hill-restaurant-interior.jpg",
                latitude: 40.7335,
                longitude: -74.0027,
                rating: 4.6,
                sustainabilityScore: 9.8,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging, .compostProgram, .zeroWaste],
                hasSpecialOffer: true,
                checkInBonus: 75,
                distance: 0.3,
                address: "75 Washington Pl., New York, NY 10011",
                phoneNumber: "+1 (212) 539-1776",
                website: "https://bluehillnyc.com"
            ),
            // New York - ABC Kitchen
            Restaurant(
                name: "ABC Kitchen",
                cuisine: "Contemporary American",
                description: "Sustainable restaurant focusing on locally sourced, organic ingredients with a commitment to environmental responsibility.",
                imageURL: "https://media-cdn.tripadvisor.com/media/photo-s/0f/8a/9c/8a/abc-kitchen-dining-room.jpg",
                latitude: 40.7388,
                longitude: -73.9902,
                rating: 4.4,
                sustainabilityScore: 9.2,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 0.7,
                address: "35 E 18th St, New York, NY 10003",
                phoneNumber: "+1 (212) 475-5829",
                website: "https://abckitchen.com"
            ),
            // Berkeley - Chez Panisse
            Restaurant(
                name: "Chez Panisse",
                cuisine: "California Cuisine",
                description: "MICHELIN Green Star pioneer of California cuisine, sourcing 75% organic produce within 50 miles with zero landfill waste.",
                imageURL: "https://s3-media0.fl.yelpcdn.com/bphoto/QvBg4XjOLfb8X8X8X8X8XQ/o.jpg",
                latitude: 37.8799,
                longitude: -122.2690,
                rating: 4.5,
                sustainabilityScore: 9.7,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .zeroWaste, .compostProgram, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 80,
                distance: 1.1,
                address: "1517 Shattuck Ave., Berkeley, CA 94709",
                phoneNumber: "+1 (510) 548-5525",
                website: "https://chezpanisse.com"
            ),
            // Washington DC - Founding Farmers
            Restaurant(
                name: "Founding Farmers",
                cuisine: "American Farm-to-Table",
                description: "Farmer-owned restaurant committed to sustainable sourcing, featuring ingredients from American family farms.",
                imageURL: "https://foundingfarmers.com/wp-content/uploads/2019/03/founding-farmers-dc-interior.jpg",
                latitude: 38.9072,
                longitude: -77.0369,
                rating: 4.3,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging, .compostProgram, .fairTrade],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 1.4,
                address: "1924 Pennsylvania Ave NW, Washington, DC 20006",
                phoneNumber: "+1 (202) 822-8783",
                website: "https://foundingfarmers.com"
            ),
            // Atlanta - Bacchanalia
            Restaurant(
                name: "Bacchanalia",
                cuisine: "Contemporary American",
                description: "Award-winning restaurant featuring organic ingredients from their own Summerland Farm and local Georgia producers.",
                imageURL: "https://starprovisions.com/wp-content/uploads/2018/05/bacchanalia-dining-room.jpg",
                latitude: 33.7490,
                longitude: -84.3880,
                rating: 4.7,
                sustainabilityScore: 9.4,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging, .compostProgram, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 70,
                distance: 1.8,
                address: "1198 Howell Mill Rd NW, Atlanta, GA 30318",
                phoneNumber: "+1 (404) 365-0410",
                website: "https://starprovisions.com/bacchanalia"
            ),
            // Vermont - BLACKBARN Restaurant
            Restaurant(
                name: "BLACKBARN Restaurant",
                cuisine: "Farm-to-Table American",
                description: "Rustic farm-to-table restaurant sourcing ingredients from local Vermont farms and producers.",
                imageURL: "https://blackbarnrestaurant.com/wp-content/uploads/2020/02/blackbarn-interior-dining.jpg",
                latitude: 43.2081,
                longitude: -72.5806,
                rating: 4.5,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging, .compostProgram, .renewableEnergy],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 2.2,
                address: "37 Main St, Manchester, VT 05254",
                phoneNumber: "+1 (802) 362-3807",
                website: "https://blackbarnrestaurant.com"
            ),
            // Colorado - Bramble & Hare
            Restaurant(
                name: "Bramble & Hare",
                cuisine: "Farm-to-Table American",
                description: "Boulder restaurant committed to local sourcing, featuring ingredients from Colorado farms and ranches.",
                imageURL: "https://brambleandhare.com/wp-content/uploads/2019/04/bramble-hare-dining-room.jpg",
                latitude: 40.0150,
                longitude: -105.2705,
                rating: 4.6,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .seasonalMenu, .compostProgram, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 45,
                distance: 1.6,
                address: "1970 13th St, Boulder, CO 80302",
                phoneNumber: "+1 (303) 444-9110",
                website: "https://brambleandhare.com"
            ),
            // Copenhagen - Noma
            Restaurant(
                name: "Noma",
                cuisine: "New Nordic",
                description: "MICHELIN Green Star restaurant pioneering New Nordic cuisine with focus on local foraging and sustainability.",
                imageURL: "https://noma.dk/wp-content/uploads/2021/03/noma-restaurant-interior.jpg",
                latitude: 55.6761,
                longitude: 12.5683,
                rating: 4.8,
                sustainabilityScore: 9.6,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .carbonNeutral, .zeroWaste, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 100,
                distance: 0.9,
                address: "Refshalevej 96, Copenhagen, 1432, Denmark",
                phoneNumber: "+45 32 96 32 97",
                website: "https://noma.dk"
            ),
            // New York - Blue Hill at Stone Barns
            Restaurant(
                name: "Blue Hill at Stone Barns",
                cuisine: "Farm-to-Table",
                description: "MICHELIN Green Star restaurant located on a working farm, showcasing the ultimate farm-to-table experience.",
                imageURL: "https://bluehillfarm.com/wp-content/uploads/2020/01/stone-barns-dining-room.jpg",
                latitude: 41.0948,
                longitude: -73.8370,
                rating: 4.7,
                sustainabilityScore: 9.9,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .zeroWaste, .compostProgram, .renewableEnergy],
                hasSpecialOffer: true,
                checkInBonus: 90,
                distance: 1.3,
                address: "630 Bedford Rd., Tarrytown, NY 10591",
                phoneNumber: "+1 (914) 366-9600",
                website: "https://bluehillfarm.com"
            ),
            // Portland - Le Pigeon
            Restaurant(
                name: "Le Pigeon",
                cuisine: "French-Inspired Pacific Northwest",
                description: "Acclaimed restaurant focusing on local Pacific Northwest ingredients with sustainable sourcing practices.",
                imageURL: "https://lepigeon.com/wp-content/uploads/2019/06/le-pigeon-interior.jpg",
                latitude: 45.5152,
                longitude: -122.6784,
                rating: 4.5,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .seasonalMenu, .sustainablePackaging, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 2.0,
                address: "738 E Burnside St, Portland, OR 97214",
                phoneNumber: "+1 (503) 546-8796",
                website: "https://lepigeon.com"
            ),
            // San Diego - Juniper & Ivy
            Restaurant(
                name: "Juniper & Ivy",
                cuisine: "California Coastal",
                description: "Award-winning restaurant featuring locally sourced ingredients from San Diego County farms and sustainable seafood from local waters.",
                imageURL: "https://juniperandi vy.com/wp-content/uploads/2020/03/juniper-ivy-dining-room.jpg",
                latitude: 32.7157,
                longitude: -117.1611,
                rating: 4.6,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .seasonalMenu, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 0.8,
                address: "2228 Kettner Blvd, San Diego, CA 92101",
                phoneNumber: "+1 (619) 269-9036",
                website: "https://juniperandi vy.com"
            ),
            // San Diego - The Prado at Balboa Park
            Restaurant(
                name: "The Prado at Balboa Park",
                cuisine: "Contemporary American",
                description: "Historic restaurant in Balboa Park committed to sustainable practices, featuring organic ingredients and zero-waste initiatives.",
                imageURL: "https://pradosd.com/wp-content/uploads/2019/08/prado-interior-dining.jpg",
                latitude: 32.7341,
                longitude: -117.1498,
                rating: 4.4,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .zeroWaste, .compostProgram, .sustainablePackaging, .recyclingProgram],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 1.2,
                address: "1549 El Prado, San Diego, CA 92101",
                phoneNumber: "+1 (619) 557-9441",
                website: "https://pradosd.com"
            ),
            // San Diego - Cucina Urbana
            Restaurant(
                name: "Cucina Urbana",
                cuisine: "Italian",
                description: "Modern Italian restaurant emphasizing local sourcing from San Diego farms and sustainable wine practices.",
                imageURL: "https://cucinaurbana.com/wp-content/uploads/2018/12/cucina-urbana-interior.jpg",
                latitude: 32.7503,
                longitude: -117.1373,
                rating: 4.5,
                sustainabilityScore: 8.7,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging, .energyEfficient, .fairTrade],
                hasSpecialOffer: true,
                checkInBonus: 45,
                distance: 0.6,
                address: "505 Laurel St, San Diego, CA 92101",
                phoneNumber: "+1 (619) 239-2222",
                website: "https://cucinaurbana.com"
            ),
            // San Diego - Liberty Public Market
            Restaurant(
                name: "Liberty Public Market",
                cuisine: "Food Hall",
                description: "Sustainable food hall featuring multiple vendors committed to local sourcing, organic ingredients, and eco-friendly practices.",
                imageURL: "https://libertypublicmarket.com/wp-content/uploads/2019/05/liberty-market-interior.jpg",
                latitude: 32.7338,
                longitude: -117.1973,
                rating: 4.3,
                sustainabilityScore: 8.5,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainablePackaging, .compostProgram, .recyclingProgram, .plantBased],
                hasSpecialOffer: true,
                checkInBonus: 40,
                distance: 1.5,
                address: "2820 Historic Decatur Rd, San Diego, CA 92106",
                phoneNumber: "+1 (619) 487-9346",
                website: "https://libertypublicmarket.com"
            ),
            
            // WEST COAST RESTAURANTS
            
            // Los Angeles - Guelaguetza
            Restaurant(
                name: "Guelaguetza",
                cuisine: "Mexican",
                description: "Authentic Oaxacan restaurant committed to traditional sustainable farming practices and organic ingredients.",
                imageURL: "https://guelaguetza.com/images/interior.jpg",
                latitude: 34.0522,
                longitude: -118.2437,
                rating: 4.5,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .fairTrade, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 45,
                distance: 1.2,
                address: "3014 W Olympic Blvd, Los Angeles, CA 90006",
                phoneNumber: "+1 (213) 427-0601",
                website: "https://guelaguetza.com"
            ),
            
            // Los Angeles - Republique
            Restaurant(
                name: "Republique",
                cuisine: "French Bistro",
                description: "French bistro focusing on locally sourced ingredients and sustainable wine practices.",
                imageURL: "https://republiquela.com/images/dining.jpg",
                latitude: 34.0736,
                longitude: -118.3628,
                rating: 4.6,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 0.9,
                address: "624 S La Brea Ave, Los Angeles, CA 90036",
                phoneNumber: "+1 (310) 362-6115",
                website: "https://republiquela.com"
            ),
            
            // San Francisco - Greens Restaurant
            Restaurant(
                name: "Greens Restaurant",
                cuisine: "Vegetarian Fine Dining",
                description: "Pioneering vegetarian restaurant with organic ingredients from Green Gulch Farm.",
                imageURL: "https://greensrestaurant.com/images/interior.jpg",
                latitude: 37.8024,
                longitude: -122.4418,
                rating: 4.7,
                sustainabilityScore: 9.5,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .plantBased, .zeroWaste, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 70,
                distance: 2.1,
                address: "2 Marina Blvd, San Francisco, CA 94123",
                phoneNumber: "+1 (415) 771-6222",
                website: "https://greensrestaurant.com"
            ),
            
            // San Francisco - The Slanted Door
            Restaurant(
                name: "The Slanted Door",
                cuisine: "Vietnamese",
                description: "Modern Vietnamese cuisine with emphasis on organic and locally sourced ingredients.",
                imageURL: "https://slanteddoor.com/images/dining.jpg",
                latitude: 37.7955,
                longitude: -122.3933,
                rating: 4.4,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 1.8,
                address: "1 Ferry Bldg, San Francisco, CA 94111",
                phoneNumber: "+1 (415) 861-8032",
                website: "https://slanteddoor.com"
            ),
            
            // Seattle - Canlis
            Restaurant(
                name: "Canlis",
                cuisine: "Pacific Northwest",
                description: "Fine dining restaurant committed to Pacific Northwest ingredients and sustainable practices.",
                imageURL: "https://canlis.com/images/interior.jpg",
                latitude: 47.6062,
                longitude: -122.3321,
                rating: 4.8,
                sustainabilityScore: 9.3,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .energyEfficient, .carbonNeutral],
                hasSpecialOffer: true,
                checkInBonus: 80,
                distance: 2.5,
                address: "2576 Aurora Ave N, Seattle, WA 98109",
                phoneNumber: "+1 (206) 283-3313",
                website: "https://canlis.com"
            ),
            
            // Seattle - Tilth
            Restaurant(
                name: "Tilth",
                cuisine: "Organic American",
                description: "Certified organic restaurant featuring ingredients from local farms and producers.",
                imageURL: "https://tilthrestaurant.com/images/dining.jpg",
                latitude: 47.6740,
                longitude: -122.3341,
                rating: 4.5,
                sustainabilityScore: 9.4,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .compostProgram, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 1.7,
                address: "1411 N 45th St, Seattle, WA 98103",
                phoneNumber: "+1 (206) 633-0801",
                website: "https://tilthrestaurant.com"
            ),
            
            // Portland - Ox Restaurant
            Restaurant(
                name: "Ox Restaurant",
                cuisine: "Argentine Steakhouse",
                description: "Sustainable steakhouse featuring grass-fed beef and local ingredients.",
                imageURL: "https://oxpdx.com/images/interior.jpg",
                latitude: 45.5152,
                longitude: -122.6784,
                rating: 4.6,
                sustainabilityScore: 8.7,
                sustainabilityFeatures: [.localSourcing, .sustainableSeafood, .energyEfficient, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.3,
                address: "2225 NE Martin Luther King Jr Blvd, Portland, OR 97212",
                phoneNumber: "+1 (503) 284-3366",
                website: "https://oxpdx.com"
            ),
            
            // Portland - Pok Pok
            Restaurant(
                name: "Pok Pok",
                cuisine: "Thai Street Food",
                description: "Authentic Thai street food with commitment to sustainable sourcing and local ingredients.",
                imageURL: "https://pokpokpdx.com/images/interior.jpg",
                latitude: 45.5051,
                longitude: -122.6550,
                rating: 4.4,
                sustainabilityScore: 8.5,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainablePackaging, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 40,
                distance: 2.0,
                address: "3226 SE Division St, Portland, OR 97202",
                phoneNumber: "+1 (503) 232-1387",
                website: "https://pokpokpdx.com"
            ),
            
            // EAST COAST RESTAURANTS
            
            // Boston - Oleana
            Restaurant(
                name: "Oleana",
                cuisine: "Mediterranean",
                description: "Mediterranean restaurant featuring organic ingredients and sustainable practices.",
                imageURL: "https://oleanarestaurant.com/images/dining.jpg",
                latitude: 42.3601,
                longitude: -71.0589,
                rating: 4.6,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .seasonalMenu],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.5,
                address: "134 Hampshire St, Cambridge, MA 02139",
                phoneNumber: "+1 (617) 661-0505",
                website: "https://oleanarestaurant.com"
            ),
            
            // Boston - Craigie on Main
            Restaurant(
                name: "Craigie on Main",
                cuisine: "French-American",
                description: "Farm-to-table restaurant committed to whole animal utilization and local sourcing.",
                imageURL: "https://craigieonmain.com/images/interior.jpg",
                latitude: 42.3736,
                longitude: -71.1097,
                rating: 4.7,
                sustainabilityScore: 9.2,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .zeroWaste, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 1.8,
                address: "853 Main St, Cambridge, MA 02139",
                phoneNumber: "+1 (617) 497-5511",
                website: "https://craigieonmain.com"
            ),
            
            // Philadelphia - Zahav
            Restaurant(
                name: "Zahav",
                cuisine: "Israeli",
                description: "Modern Israeli cuisine with emphasis on local sourcing and sustainable practices.",
                imageURL: "https://zahavrestaurant.com/images/dining.jpg",
                latitude: 39.9526,
                longitude: -75.1652,
                rating: 4.8,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 70,
                distance: 2.2,
                address: "237 St James Pl, Philadelphia, PA 19106",
                phoneNumber: "+1 (215) 625-8800",
                website: "https://zahavrestaurant.com"
            ),
            
            // Philadelphia - Vedge
            Restaurant(
                name: "Vedge",
                cuisine: "Vegetarian Fine Dining",
                description: "Upscale vegetarian restaurant featuring local organic produce and innovative plant-based cuisine.",
                imageURL: "https://vedgerestaurant.com/images/interior.jpg",
                latitude: 39.9440,
                longitude: -75.1657,
                rating: 4.5,
                sustainabilityScore: 9.3,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .plantBased, .compostProgram, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.9,
                address: "1221 Locust St, Philadelphia, PA 19107",
                phoneNumber: "+1 (215) 320-7500",
                website: "https://vedgerestaurant.com"
            ),
            
            // Miami - Zuma
            Restaurant(
                name: "Zuma Miami",
                cuisine: "Japanese",
                description: "Contemporary Japanese restaurant with sustainable seafood and local sourcing practices.",
                imageURL: "https://zumarestaurant.com/images/miami-interior.jpg",
                latitude: 25.7617,
                longitude: -80.1918,
                rating: 4.6,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.sustainableSeafood, .localSourcing, .energyEfficient, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.4,
                address: "270 Biscayne Blvd Way, Miami, FL 33131",
                phoneNumber: "+1 (305) 577-0277",
                website: "https://zumarestaurant.com"
            ),
            
            // MIDWEST RESTAURANTS
            
            // Chicago - Alinea
            Restaurant(
                name: "Alinea",
                cuisine: "Molecular Gastronomy",
                description: "Award-winning restaurant with innovative sustainable practices and local sourcing.",
                imageURL: "https://alinearestaurant.com/images/interior.jpg",
                latitude: 41.8781,
                longitude: -87.6298,
                rating: 4.9,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .zeroWaste, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 90,
                distance: 2.3,
                address: "1723 N Halsted St, Chicago, IL 60614",
                phoneNumber: "+1 (312) 867-0110",
                website: "https://alinearestaurant.com"
            ),
            
            // Chicago - Girl & Goat
            Restaurant(
                name: "Girl & Goat",
                cuisine: "Contemporary American",
                description: "Farm-to-table restaurant featuring locally sourced ingredients and sustainable practices.",
                imageURL: "https://girlandgoat.com/images/dining.jpg",
                latitude: 41.8819,
                longitude: -87.6472,
                rating: 4.7,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainableSeafood, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 1.8,
                address: "809 W Randolph St, Chicago, IL 60607",
                phoneNumber: "+1 (312) 492-6262",
                website: "https://girlandgoat.com"
            ),
            
            // Minneapolis - Spoon and Stable
            Restaurant(
                name: "Spoon and Stable",
                cuisine: "French Bistro",
                description: "French bistro committed to local sourcing and sustainable dining practices.",
                imageURL: "https://spoonandstable.com/images/interior.jpg",
                latitude: 44.9778,
                longitude: -93.2650,
                rating: 4.6,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 2.1,
                address: "211 N 1st St, Minneapolis, MN 55401",
                phoneNumber: "+1 (612) 224-9850",
                website: "https://spoonandstable.com"
            ),
            
            // Detroit - Selden Standard
            Restaurant(
                name: "Selden Standard",
                cuisine: "New American",
                description: "Contemporary restaurant focusing on local ingredients and sustainable practices.",
                imageURL: "https://seldenstandard.com/images/dining.jpg",
                latitude: 42.3314,
                longitude: -83.0458,
                rating: 4.5,
                sustainabilityScore: 8.7,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainableSeafood, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 1.9,
                address: "3921 2nd Ave, Detroit, MI 48201",
                phoneNumber: "+1 (313) 438-5055",
                website: "https://seldenstandard.com"
            ),
            
            // SOUTHWEST RESTAURANTS
            
            // Austin - Uchi
            Restaurant(
                name: "Uchi",
                cuisine: "Japanese",
                description: "Contemporary Japanese restaurant with sustainable seafood and local sourcing.",
                imageURL: "https://uchirestaurant.com/images/austin-interior.jpg",
                latitude: 30.2672,
                longitude: -97.7431,
                rating: 4.8,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.sustainableSeafood, .localSourcing, .organicIngredients, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 70,
                distance: 2.0,
                address: "801 S Lamar Blvd, Austin, TX 78704",
                phoneNumber: "+1 (512) 916-4808",
                website: "https://uchirestaurant.com"
            ),
            
            // Austin - Odd Duck
            Restaurant(
                name: "Odd Duck",
                cuisine: "Farm-to-Table",
                description: "Farm-to-table restaurant with focus on local ingredients and sustainable practices.",
                imageURL: "https://oddduckaustin.com/images/interior.jpg",
                latitude: 30.2500,
                longitude: -97.7667,
                rating: 4.5,
                sustainabilityScore: 9.2,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .seasonalMenu, .compostProgram, .zeroWaste],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.7,
                address: "1201 S Lamar Blvd, Austin, TX 78704",
                phoneNumber: "+1 (512) 433-5000",
                website: "https://oddduckaustin.com"
            ),
            
            // Phoenix - FnB
            Restaurant(
                name: "FnB",
                cuisine: "New American",
                description: "Arizona-focused restaurant featuring local ingredients and sustainable practices.",
                imageURL: "https://fnbrestaurant.com/images/dining.jpg",
                latitude: 33.4484,
                longitude: -112.0740,
                rating: 4.6,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 2.2,
                address: "7125 E 5th Ave, Scottsdale, AZ 85251",
                phoneNumber: "+1 (480) 284-4777",
                website: "https://fnbrestaurant.com"
            ),
            
            // Las Vegas - é by José Andrés
            Restaurant(
                name: "é by José Andrés",
                cuisine: "Spanish Avant-Garde",
                description: "Innovative Spanish restaurant with commitment to sustainable sourcing.",
                imageURL: "https://ebyja.com/images/interior.jpg",
                latitude: 36.1699,
                longitude: -115.1398,
                rating: 4.9,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainableSeafood, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 85,
                distance: 2.5,
                address: "3708 Las Vegas Blvd S, Las Vegas, NV 89109",
                phoneNumber: "+1 (702) 590-8690",
                website: "https://ebyja.com"
            ),
            
            // SOUTHERN RESTAURANTS
            
            // New Orleans - Commander's Palace
            Restaurant(
                name: "Commander's Palace",
                cuisine: "Creole",
                description: "Historic Creole restaurant with commitment to local sourcing and sustainability.",
                imageURL: "https://commanderspalace.com/images/dining.jpg",
                latitude: 29.9511,
                longitude: -90.0715,
                rating: 4.7,
                sustainabilityScore: 8.6,
                sustainabilityFeatures: [.localSourcing, .sustainableSeafood, .organicIngredients, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 1.8,
                address: "1403 Washington Ave, New Orleans, LA 70130",
                phoneNumber: "+1 (504) 899-8221",
                website: "https://commanderspalace.com"
            ),
            
            // Nashville - The Catbird Seat
            Restaurant(
                name: "The Catbird Seat",
                cuisine: "Contemporary American",
                description: "Interactive dining experience with focus on local ingredients and sustainability.",
                imageURL: "https://thecatbirdseatrestaurant.com/images/interior.jpg",
                latitude: 36.1627,
                longitude: -86.7816,
                rating: 4.8,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .zeroWaste, .seasonalMenu],
                hasSpecialOffer: true,
                checkInBonus: 75,
                distance: 2.0,
                address: "1711 Division St, Nashville, TN 37203",
                phoneNumber: "+1 (615) 810-8200",
                website: "https://thecatbirdseatrestaurant.com"
            ),
            
            // Charleston - Husk
            Restaurant(
                name: "Husk",
                cuisine: "Southern",
                description: "Southern restaurant dedicated to heirloom ingredients and local sourcing.",
                imageURL: "https://huskrestaurant.com/images/charleston-interior.jpg",
                latitude: 32.7767,
                longitude: -79.9311,
                rating: 4.6,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.6,
                address: "76 Queen St, Charleston, SC 29401",
                phoneNumber: "+1 (843) 577-2500",
                website: "https://huskrestaurant.com"
            ),
            
            // MOUNTAIN WEST RESTAURANTS
            
            // Denver - Mercantile Dining & Provision
            Restaurant(
                name: "Mercantile Dining & Provision",
                cuisine: "Contemporary American",
                description: "Farm-to-table restaurant with extensive local sourcing and sustainable practices.",
                imageURL: "https://mercantiledenver.com/images/dining.jpg",
                latitude: 39.7392,
                longitude: -104.9903,
                rating: 4.5,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainableSeafood, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.9,
                address: "1701 Wynkoop St, Denver, CO 80202",
                phoneNumber: "+1 (720) 460-3733",
                website: "https://mercantiledenver.com"
            ),
            
            // Salt Lake City - Forage
            Restaurant(
                name: "Forage",
                cuisine: "Modern American",
                description: "Restaurant focused on foraged and locally sourced ingredients with sustainable practices.",
                imageURL: "https://foragerestaurant.com/images/interior.jpg",
                latitude: 40.7608,
                longitude: -111.8910,
                rating: 4.4,
                sustainabilityScore: 9.3,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .seasonalMenu, .zeroWaste, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 2.1,
                address: "370 E 900 S, Salt Lake City, UT 84111",
                phoneNumber: "+1 (801) 708-7834",
                website: "https://foragerestaurant.com"
            ),
            
            // PACIFIC NORTHWEST (Additional)
            
            // Vancouver - Vij's
            Restaurant(
                name: "Vij's",
                cuisine: "Indian",
                description: "Innovative Indian cuisine with commitment to local and organic ingredients.",
                imageURL: "https://vijs.ca/images/interior.jpg",
                latitude: 49.2827,
                longitude: -123.1207,
                rating: 4.7,
                sustainabilityScore: 8.7,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.5,
                address: "3106 Cambie St, Vancouver, BC V5Z 2W2",
                phoneNumber: "+1 (604) 736-6664",
                website: "https://vijs.ca"
            ),
            
            // Miami - Yardbird Southern Table & Bar
            Restaurant(
                name: "Yardbird Southern Table & Bar",
                cuisine: "Southern American",
                description: "Southern comfort food with commitment to local sourcing and sustainable practices.",
                imageURL: "https://runchickenrun.com/images/miami-interior.jpg",
                latitude: 25.7907,
                longitude: -80.1310,
                rating: 4.4,
                sustainabilityScore: 8.6,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 45,
                distance: 2.1,
                address: "1600 Lenox Ave, Miami Beach, FL 33139",
                phoneNumber: "+1 (305) 538-5220",
                website: "https://runchickenrun.com"
            ),
            
            // MIDWEST RESTAURANTS
            
            // Chicago - Alinea
            Restaurant(
                name: "Alinea",
                cuisine: "Molecular Gastronomy",
                description: "Innovative fine dining with commitment to sustainable sourcing and zero-waste practices.",
                imageURL: "https://alinearestaurant.com/images/interior.jpg",
                latitude: 41.8781,
                longitude: -87.6298,
                rating: 4.9,
                sustainabilityScore: 9.4,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .zeroWaste, .energyEfficient, .carbonNeutral],
                hasSpecialOffer: true,
                checkInBonus: 90,
                distance: 1.1,
                address: "1723 N Halsted St, Chicago, IL 60614",
                phoneNumber: "+1 (312) 867-0110",
                website: "https://alinearestaurant.com"
            ),
            
            // Chicago - Girl & the Goat
            Restaurant(
                name: "Girl & the Goat",
                cuisine: "Contemporary American",
                description: "Bold flavors with emphasis on local sourcing and sustainable meat practices.",
                imageURL: "https://girlandthegoat.com/images/interior.jpg",
                latitude: 41.8819,
                longitude: -87.6472,
                rating: 4.6,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.8,
                address: "809 W Randolph St, Chicago, IL 60607",
                phoneNumber: "+1 (312) 492-6262",
                website: "https://girlandthegoat.com"
            ),
            
            // Detroit - Selden Standard
            Restaurant(
                name: "Selden Standard",
                cuisine: "New American",
                description: "Farm-to-table restaurant featuring Michigan ingredients and sustainable practices.",
                imageURL: "https://seldenstandard.com/images/dining.jpg",
                latitude: 42.3314,
                longitude: -83.0458,
                rating: 4.5,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 2.3,
                address: "3921 2nd Ave, Detroit, MI 48201",
                phoneNumber: "+1 (313) 438-5055",
                website: "https://seldenstandard.com"
            ),
            
            // Minneapolis - Spoon and Stable
            Restaurant(
                name: "Spoon and Stable",
                cuisine: "French Brasserie",
                description: "French-inspired cuisine with commitment to local Minnesota ingredients.",
                imageURL: "https://spoonandstable.com/images/interior.jpg",
                latitude: 44.9778,
                longitude: -93.2650,
                rating: 4.7,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.6,
                address: "211 N 1st St, Minneapolis, MN 55401",
                phoneNumber: "+1 (612) 224-9850",
                website: "https://spoonandstable.com"
            ),
            
            // Milwaukee - Ardent
            Restaurant(
                name: "Ardent",
                cuisine: "Contemporary American",
                description: "Seasonal American cuisine with focus on Wisconsin producers and sustainable practices.",
                imageURL: "https://ardentmke.com/images/dining.jpg",
                latitude: 43.0389,
                longitude: -87.9065,
                rating: 4.6,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.9,
                address: "1751 N Farwell Ave, Milwaukee, WI 53202",
                phoneNumber: "+1 (414) 897-7022",
                website: "https://ardentmke.com"
            ),
            
            // SOUTHERN RESTAURANTS
            
            // Nashville - The Catbird Seat
            Restaurant(
                name: "The Catbird Seat",
                cuisine: "Contemporary American",
                description: "Interactive dining experience with commitment to local sourcing and sustainability.",
                imageURL: "https://thecatbirdseatrestaurant.com/images/interior.jpg",
                latitude: 36.1627,
                longitude: -86.7816,
                rating: 4.8,
                sustainabilityScore: 9.2,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .zeroWaste, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 75,
                distance: 1.4,
                address: "1711 Division St, Nashville, TN 37203",
                phoneNumber: "+1 (615) 810-8200",
                website: "https://thecatbirdseatrestaurant.com"
            ),
            
            // New Orleans - Commander's Palace
            Restaurant(
                name: "Commander's Palace",
                cuisine: "Creole",
                description: "Historic Creole restaurant with commitment to Gulf Coast sustainability and local sourcing.",
                imageURL: "https://commanderspalace.com/images/dining.jpg",
                latitude: 29.9511,
                longitude: -90.0715,
                rating: 4.7,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.localSourcing, .sustainableSeafood, .organicIngredients, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 2.0,
                address: "1403 Washington Ave, New Orleans, LA 70130",
                phoneNumber: "+1 (504) 899-8221",
                website: "https://commanderspalace.com"
            ),
            
            // Austin - Uchi
            Restaurant(
                name: "Uchi",
                cuisine: "Japanese",
                description: "Contemporary Japanese cuisine with sustainable seafood and local Texas ingredients.",
                imageURL: "https://uchirestaurants.com/images/austin-interior.jpg",
                latitude: 30.2672,
                longitude: -97.7431,
                rating: 4.8,
                sustainabilityScore: 9.3,
                sustainabilityFeatures: [.sustainableSeafood, .organicIngredients, .localSourcing, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 70,
                distance: 1.7,
                address: "801 S Lamar Blvd, Austin, TX 78704",
                phoneNumber: "+1 (512) 916-4808",
                website: "https://uchirestaurants.com"
            ),
            
            // Charleston - FIG
            Restaurant(
                name: "FIG",
                cuisine: "Southern Contemporary",
                description: "Seasonal Southern cuisine featuring local Lowcountry ingredients and sustainable practices.",
                imageURL: "https://eatatfig.com/images/interior.jpg",
                latitude: 32.7767,
                longitude: -79.9311,
                rating: 4.6,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .seasonalMenu],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.5,
                address: "232 Meeting St, Charleston, SC 29401",
                phoneNumber: "+1 (843) 805-5900",
                website: "https://eatatfig.com"
            ),
            
            // Savannah - The Grey
            Restaurant(
                name: "The Grey",
                cuisine: "Southern Contemporary",
                description: "Restored Greyhound bus terminal featuring Southern cuisine with sustainable sourcing.",
                imageURL: "https://thegreyrestaurant.com/images/interior.jpg",
                latitude: 32.0835,
                longitude: -81.0998,
                rating: 4.7,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 2.2,
                address: "109 Martin Luther King Jr Blvd, Savannah, GA 31401",
                phoneNumber: "+1 (912) 662-5999",
                website: "https://thegreyrestaurant.com"
            ),
            
            // MOUNTAIN WEST & SOUTHWEST
            
            // Denver - Root Down
            Restaurant(
                name: "Root Down",
                cuisine: "Globally Inspired",
                description: "Sustainable restaurant in converted gas station featuring local Colorado ingredients.",
                imageURL: "https://rootdowndenver.com/images/interior.jpg",
                latitude: 39.7392,
                longitude: -104.9903,
                rating: 4.5,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 1.6,
                address: "1600 W 33rd Ave, Denver, CO 80211",
                phoneNumber: "+1 (303) 993-4200",
                website: "https://rootdowndenver.com"
            ),
            
            // Phoenix - FnB
            Restaurant(
                name: "FnB",
                cuisine: "New American",
                description: "Arizona-focused cuisine featuring local desert ingredients and sustainable practices.",
                imageURL: "https://fnbrestaurant.com/images/dining.jpg",
                latitude: 33.4484,
                longitude: -112.0740,
                rating: 4.6,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.9,
                address: "7125 E 5th Ave, Scottsdale, AZ 85251",
                phoneNumber: "+1 (480) 284-4777",
                website: "https://fnbrestaurant.com"
            ),
            
            // Salt Lake City - HSL
            Restaurant(
                name: "HSL",
                cuisine: "Contemporary American",
                description: "Seasonal American cuisine with focus on Utah producers and sustainable sourcing.",
                imageURL: "https://hslrestaurant.com/images/interior.jpg",
                latitude: 40.7608,
                longitude: -111.8910,
                rating: 4.4,
                sustainabilityScore: 8.7,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 45,
                distance: 2.1,
                address: "418 E 200 S, Salt Lake City, UT 84111",
                phoneNumber: "+1 (801) 539-8134",
                website: "https://hslrestaurant.com"
            ),
            
            // Las Vegas - é by José Andrés
            Restaurant(
                name: "é by José Andrés",
                cuisine: "Spanish Avant-Garde",
                description: "Innovative Spanish cuisine with commitment to sustainable sourcing and zero waste.",
                imageURL: "https://jaleo.com/images/e-interior.jpg",
                latitude: 36.1699,
                longitude: -115.1398,
                rating: 4.8,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .zeroWaste, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 75,
                distance: 1.3,
                address: "3708 Las Vegas Blvd S, Las Vegas, NV 89109",
                phoneNumber: "+1 (702) 590-8690",
                website: "https://jaleo.com"
            ),
            
            // PACIFIC NORTHWEST EXPANSION
            
            // Portland - Canard
            Restaurant(
                name: "Canard",
                cuisine: "French Bistro",
                description: "French bistro focusing on whole animal utilization and local Oregon ingredients.",
                imageURL: "https://canardpdx.com/images/interior.jpg",
                latitude: 45.5152,
                longitude: -122.6784,
                rating: 4.5,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .zeroWaste, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 1.7,
                address: "2337 NE Glisan St, Portland, OR 97232",
                phoneNumber: "+1 (503) 719-4564",
                website: "https://canardpdx.com"
            ),
            
            // Seattle - Altura
            Restaurant(
                name: "Altura",
                cuisine: "Italian",
                description: "Italian fine dining with Pacific Northwest ingredients and sustainable practices.",
                imageURL: "https://alturarestaurant.com/images/dining.jpg",
                latitude: 47.6062,
                longitude: -122.3321,
                rating: 4.7,
                sustainabilityScore: 9.2,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 1.8,
                address: "617 Broadway E, Seattle, WA 98102",
                phoneNumber: "+1 (206) 402-6749",
                website: "https://alturarestaurant.com"
            ),
            
            // MORE CALIFORNIA RESTAURANTS
            
            // Sacramento - The Kitchen
            Restaurant(
                name: "The Kitchen",
                cuisine: "Farm-to-Table",
                description: "Interactive dining experience featuring Central Valley ingredients and sustainable practices.",
                imageURL: "https://thekitchenrestaurant.com/images/interior.jpg",
                latitude: 38.5816,
                longitude: -121.4944,
                rating: 4.6,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 2.0,
                address: "2225 Hurley Way, Sacramento, CA 95825",
                phoneNumber: "+1 (916) 568-7171",
                website: "https://thekitchenrestaurant.com"
            ),
            
            // Napa Valley - The French Laundry
            Restaurant(
                name: "The French Laundry",
                cuisine: "French Fine Dining",
                description: "World-renowned restaurant with on-site garden and commitment to sustainable practices.",
                imageURL: "https://thomaskeller.com/images/french-laundry.jpg",
                latitude: 38.4404,
                longitude: -122.5194,
                rating: 4.9,
                sustainabilityScore: 9.5,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .zeroWaste, .carbonNeutral],
                hasSpecialOffer: true,
                checkInBonus: 100,
                distance: 1.2,
                address: "6640 Washington St, Yountville, CA 94599",
                phoneNumber: "+1 (707) 944-2380",
                website: "https://thomaskeller.com"
            ),
            
            // MORE NEW YORK RESTAURANTS
            
            // New York - Gramercy Tavern
            Restaurant(
                name: "Gramercy Tavern",
                cuisine: "American Fine Dining",
                description: "Seasonal American cuisine with commitment to local sourcing and sustainable practices.",
                imageURL: "https://gramercytavern.com/images/dining.jpg",
                latitude: 40.7390,
                longitude: -73.9887,
                rating: 4.7,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 1.5,
                address: "42 E 20th St, New York, NY 10003",
                phoneNumber: "+1 (212) 477-0777",
                website: "https://gramercytavern.com"
            ),
            
            // New York - Eleven Madison Park
            Restaurant(
                name: "Eleven Madison Park",
                cuisine: "Plant-Based Fine Dining",
                description: "Plant-based fine dining with focus on sustainability and local sourcing.",
                imageURL: "https://elevenmadisonpark.com/images/interior.jpg",
                latitude: 40.7420,
                longitude: -73.9876,
                rating: 4.8,
                sustainabilityScore: 9.6,
                sustainabilityFeatures: [.plantBased, .organicIngredients, .localSourcing, .zeroWaste, .carbonNeutral],
                hasSpecialOffer: true,
                checkInBonus: 90,
                distance: 1.8,
                address: "11 Madison Ave, New York, NY 10010",
                phoneNumber: "+1 (212) 889-0905",
                website: "https://elevenmadisonpark.com"
            ),
            
            // ADDITIONAL MAJOR CITIES
            
            // Houston - Oxheart
            Restaurant(
                name: "Oxheart",
                cuisine: "Contemporary American",
                description: "Innovative American cuisine with focus on local Texas ingredients and sustainability.",
                imageURL: "https://oxhearthouston.com/images/interior.jpg",
                latitude: 29.7604,
                longitude: -95.3698,
                rating: 4.7,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.4,
                address: "1302 Nance St, Houston, TX 77002",
                phoneNumber: "+1 (832) 830-8592",
                website: "https://oxhearthouston.com"
            ),
            
            // Dallas - FT33
            Restaurant(
                name: "FT33",
                cuisine: "Modern American",
                description: "Modern American cuisine with commitment to local sourcing and sustainable practices.",
                imageURL: "https://ft33dallas.com/images/dining.jpg",
                latitude: 32.7767,
                longitude: -96.7970,
                rating: 4.6,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.7,
                address: "1617 Hi Line Dr, Dallas, TX 75207",
                phoneNumber: "+1 (214) 741-2629",
                website: "https://ft33dallas.com"
            ),
            
            // Kansas City - The Rieger
            Restaurant(
                name: "The Rieger",
                cuisine: "American Gastropub",
                description: "Farm-to-table gastropub featuring Missouri ingredients and sustainable practices.",
                imageURL: "https://theriegerhotel.com/images/restaurant.jpg",
                latitude: 39.1012,
                longitude: -94.5783,
                rating: 4.5,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 2.0,
                address: "1924 Main St, Kansas City, MO 64108",
                phoneNumber: "+1 (816) 471-2177",
                website: "https://theriegerhotel.com"
            ),
            
            // St. Louis - Vicia
            Restaurant(
                name: "Vicia",
                cuisine: "Vegetable-Forward",
                description: "Vegetable-focused cuisine with commitment to local sourcing and sustainability.",
                imageURL: "https://viciarestaurant.com/images/interior.jpg",
                latitude: 38.6270,
                longitude: -90.1994,
                rating: 4.6,
                sustainabilityScore: 9.2,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .plantBased, .seasonalMenu, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.8,
                address: "4260 Forest Park Ave, St. Louis, MO 63108",
                phoneNumber: "+1 (314) 553-9239",
                website: "https://viciarestaurant.com"
            ),
            
            // Cleveland - Greenhouse Tavern
            Restaurant(
                name: "Greenhouse Tavern",
                cuisine: "Sustainable American",
                description: "Sustainable restaurant featuring local Ohio ingredients and eco-friendly practices.",
                imageURL: "https://thegreenhousetavern.com/images/interior.jpg",
                latitude: 41.4993,
                longitude: -81.6944,
                rating: 4.4,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainablePackaging, .energyEfficient, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 2.1,
                address: "2038 E 4th St, Cleveland, OH 44115",
                phoneNumber: "+1 (216) 443-0511",
                website: "https://thegreenhousetavern.com"
            ),
            
            // Pittsburgh - Spoon
            Restaurant(
                name: "Spoon",
                cuisine: "Contemporary American",
                description: "Contemporary American cuisine with focus on Pennsylvania ingredients and sustainability.",
                imageURL: "https://spoonpgh.com/images/dining.jpg",
                latitude: 40.4406,
                longitude: -79.9959,
                rating: 4.5,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.9,
                address: "134 S 18th St, Pittsburgh, PA 15203",
                phoneNumber: "+1 (412) 431-4000",
                website: "https://spoonpgh.com"
            ),
            
            // Richmond - L'Opossum
            Restaurant(
                name: "L'Opossum",
                cuisine: "French Bistro",
                description: "French bistro with Virginia ingredients and commitment to sustainable sourcing.",
                imageURL: "https://lopossum.com/images/interior.jpg",
                latitude: 37.5407,
                longitude: -77.4360,
                rating: 4.6,
                sustainabilityScore: 8.7,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .seasonalMenu],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 1.6,
                address: "626 China St, Richmond, VA 23220",
                phoneNumber: "+1 (804) 918-6028",
                website: "https://lopossum.com"
            ),
            
            // Raleigh - Lantern
            Restaurant(
                name: "Lantern",
                cuisine: "Asian Fusion",
                description: "Asian-inspired cuisine featuring North Carolina ingredients and sustainable practices.",
                imageURL: "https://lanternrestaurant.com/images/dining.jpg",
                latitude: 35.7796,
                longitude: -78.6382,
                rating: 4.5,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainableSeafood, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 2.0,
                address: "423 W Davie St, Raleigh, NC 27601",
                phoneNumber: "+1 (919) 969-8846",
                website: "https://lanternrestaurant.com"
            ),
            
            // Louisville - Proof on Main
            Restaurant(
                name: "Proof on Main",
                cuisine: "Contemporary American",
                description: "Contemporary American cuisine with Kentucky bourbon focus and sustainable sourcing.",
                imageURL: "https://proofonmain.com/images/interior.jpg",
                latitude: 38.2527,
                longitude: -85.7585,
                rating: 4.4,
                sustainabilityScore: 8.6,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 45,
                distance: 1.8,
                address: "702 W Main St, Louisville, KY 40202",
                phoneNumber: "+1 (502) 217-6360",
                website: "https://proofonmain.com"
            ),
            
            // Memphis - The Beauty Shop
            Restaurant(
                name: "The Beauty Shop",
                cuisine: "Contemporary Southern",
                description: "Contemporary Southern cuisine in converted beauty salon with sustainable practices.",
                imageURL: "https://thebeautyshoprestaurant.com/images/interior.jpg",
                latitude: 35.1495,
                longitude: -90.0490,
                rating: 4.5,
                sustainabilityScore: 8.7,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 2.2,
                address: "966 S Cooper St, Memphis, TN 38104",
                phoneNumber: "+1 (901) 272-7111",
                website: "https://thebeautyshoprestaurant.com"
            ),
            
            // Birmingham - Highlands Bar and Grill
            Restaurant(
                name: "Highlands Bar and Grill",
                cuisine: "French-Southern",
                description: "French-Southern cuisine with Alabama ingredients and sustainable sourcing practices.",
                imageURL: "https://highlandsbarandgrill.com/images/dining.jpg",
                latitude: 33.5186,
                longitude: -86.8104,
                rating: 4.6,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 1.9,
                address: "2011 11th Ave S, Birmingham, AL 35205",
                phoneNumber: "+1 (205) 939-1400",
                website: "https://highlandsbarandgrill.com"
            ),
            
            // Little Rock - The Root Cafe
            Restaurant(
                name: "The Root Cafe",
                cuisine: "Farm-to-Table",
                description: "Farm-to-table cafe featuring Arkansas ingredients and sustainable practices.",
                imageURL: "https://therootcafe.com/images/interior.jpg",
                latitude: 34.7465,
                longitude: -92.2896,
                rating: 4.3,
                sustainabilityScore: 8.9,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .sustainablePackaging, .compostProgram, .plantBased],
                hasSpecialOffer: true,
                checkInBonus: 45,
                distance: 2.3,
                address: "1500 S Main St, Little Rock, AR 72202",
                phoneNumber: "+1 (501) 414-0423",
                website: "https://therootcafe.com"
            ),
            
            // Tulsa - The Tavern
            Restaurant(
                name: "The Tavern",
                cuisine: "Contemporary American",
                description: "Contemporary American cuisine with Oklahoma ingredients and sustainable practices.",
                imageURL: "https://thetaverntulsa.com/images/dining.jpg",
                latitude: 36.1540,
                longitude: -95.9928,
                rating: 4.4,
                sustainabilityScore: 8.6,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 45,
                distance: 2.0,
                address: "201 N Main St, Tulsa, OK 74103",
                phoneNumber: "+1 (918) 949-9590",
                website: "https://thetaverntulsa.com"
            ),
            
            // Omaha - The Grey Plume
            Restaurant(
                name: "The Grey Plume",
                cuisine: "Eco-Bistro",
                description: "Eco-conscious bistro featuring Nebraska ingredients and comprehensive sustainability practices.",
                imageURL: "https://thegreyplume.com/images/interior.jpg",
                latitude: 41.2565,
                longitude: -95.9345,
                rating: 4.5,
                sustainabilityScore: 9.3,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .zeroWaste, .carbonNeutral, .sustainablePackaging, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 65,
                distance: 1.7,
                address: "220 S 31st Ave, Omaha, NE 68131",
                phoneNumber: "+1 (402) 505-3663",
                website: "https://thegreyplume.com"
            ),
            
            // Des Moines - Alba
            Restaurant(
                name: "Alba",
                cuisine: "Contemporary American",
                description: "Contemporary American cuisine featuring Iowa ingredients and sustainable sourcing.",
                imageURL: "https://albadesmoines.com/images/dining.jpg",
                latitude: 41.5868,
                longitude: -93.6250,
                rating: 4.4,
                sustainabilityScore: 8.7,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 50,
                distance: 1.9,
                address: "524 E 6th St, Des Moines, IA 50309",
                phoneNumber: "+1 (515) 244-0261",
                website: "https://albadesmoines.com"
            ),
            
            // Boise - Bittercreek Alehouse
            Restaurant(
                name: "Bittercreek Alehouse",
                cuisine: "Northwest Gastropub",
                description: "Northwest gastropub featuring Idaho ingredients and sustainable brewing practices.",
                imageURL: "https://bittercreekalehouse.com/images/interior.jpg",
                latitude: 43.6150,
                longitude: -116.2023,
                rating: 4.3,
                sustainabilityScore: 8.5,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainablePackaging, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 40,
                distance: 2.1,
                address: "246 N 8th St, Boise, ID 83702",
                phoneNumber: "+1 (208) 345-1813",
                website: "https://bittercreekalehouse.com"
            ),
            
            // Albuquerque - Farm & Table
            Restaurant(
                name: "Farm & Table",
                cuisine: "New Mexican",
                description: "New Mexican cuisine with on-site farm and commitment to sustainable practices.",
                imageURL: "https://farmandtablenm.com/images/interior.jpg",
                latitude: 35.0844,
                longitude: -106.6504,
                rating: 4.5,
                sustainabilityScore: 9.1,
                sustainabilityFeatures: [.organicIngredients, .localSourcing, .seasonalMenu, .zeroWaste, .compostProgram],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.8,
                address: "8917 4th St NW, Albuquerque, NM 87114",
                phoneNumber: "+1 (505) 503-7124",
                website: "https://farmandtablenm.com"
            ),
            
            // Anchorage - Orso
            Restaurant(
                name: "Orso",
                cuisine: "Alaskan Contemporary",
                description: "Alaskan contemporary cuisine featuring local seafood and sustainable practices.",
                imageURL: "https://orsoalaska.com/images/dining.jpg",
                latitude: 61.2181,
                longitude: -149.9003,
                rating: 4.6,
                sustainabilityScore: 9.0,
                sustainabilityFeatures: [.sustainableSeafood, .localSourcing, .organicIngredients, .energyEfficient],
                hasSpecialOffer: true,
                checkInBonus: 60,
                distance: 1.5,
                address: "737 W 5th Ave, Anchorage, AK 99501",
                phoneNumber: "+1 (907) 222-3232",
                website: "https://orsoalaska.com"
            ),
            
            // Honolulu - Town
            Restaurant(
                name: "Town",
                cuisine: "Italian-Hawaiian",
                description: "Italian-Hawaiian fusion featuring local Hawaiian ingredients and sustainable practices.",
                imageURL: "https://townkaimuki.com/images/interior.jpg",
                latitude: 21.3099,
                longitude: -157.8581,
                rating: 4.5,
                sustainabilityScore: 8.8,
                sustainabilityFeatures: [.localSourcing, .organicIngredients, .sustainableSeafood, .sustainablePackaging],
                hasSpecialOffer: true,
                checkInBonus: 55,
                distance: 2.0,
                address: "3435 Waialae Ave, Honolulu, HI 96816",
                phoneNumber: "+1 (808) 735-5900",
                website: "https://townkaimuki.com"
            )
        ]
    }
}

// MARK: - Extensions
extension Color {
    static let brown = Color(red: 0.6, green: 0.4, blue: 0.2)
}