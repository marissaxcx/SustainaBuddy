//
//  EcoDiningView.swift
//  SustainaBuddy
//
//  Eco-Dining Guide with Restaurant Map and Sustainability Scorecards
//

import SwiftUI
import MapKit

struct EcoDiningView: View {
    @StateObject private var viewModel = EcoDiningViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var selectedRestaurant: Restaurant?
    @State private var showingFilters = false
    @State private var searchText = ""
    @State private var showingLocationAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Search and Filters
                    searchAndFiltersView
                    
                    // Map and Restaurant List
                    mapAndListView
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadRestaurants()
                locationManager.requestLocationPermission()
            }
            .onChange(of: locationManager.location) { location in
                if let location = location {
                    viewModel.updateUserLocation(location)
                }
            }
            .alert("Location Access", isPresented: $showingLocationAlert) {
                Button("Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please enable location access in Settings to find nearby sustainable restaurants.")
            }
        }
        .sheet(item: $selectedRestaurant) { restaurant in
            RestaurantDetailView(restaurant: restaurant)
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Eco-Dining Guide")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack {
                        if locationManager.isLocationEnabled {
                            Image(systemName: "location.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text("\(viewModel.filteredRestaurants.count) sustainable restaurants nearby")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Image(systemName: "location.slash")
                                .foregroundColor(.red)
                                .font(.caption)
                            Text("Enable location for nearby restaurants")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    if !locationManager.isLocationEnabled {
                        Button(action: {
                            if locationManager.authorizationStatus == .denied {
                                showingLocationAlert = true
                            } else {
                                locationManager.requestLocationPermission()
                            }
                        }) {
                            Image(systemName: "location")
                                .foregroundColor(.orange)
                                .font(.title2)
                        }
                    }
                    
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.cyan)
                            .font(.title2)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }
    
    private var searchAndFiltersView: some View {
        HStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search restaurants, cuisine, or location...", text: $searchText)
                    .foregroundColor(.white)
                    .onChange(of: searchText) { _ in
                        viewModel.searchRestaurants(searchText)
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        viewModel.searchRestaurants("")
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
            )
            
            // Quick Filter Buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SustainabilityFilter.allCases, id: \.self) { filter in
                        FilterChip(
                            title: filter.displayName,
                            isSelected: viewModel.activeFilters.contains(filter),
                            action: {
                                viewModel.toggleFilter(filter)
                            }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var mapAndListView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Map View
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.filteredRestaurants) { restaurant in
                    MapAnnotation(coordinate: restaurant.coordinate) {
                        RestaurantMapPin(restaurant: restaurant) {
                            selectedRestaurant = restaurant
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.5)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Restaurant List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredRestaurants) { restaurant in
                            RestaurantCard(restaurant: restaurant) {
                                selectedRestaurant = restaurant
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
                .background(Color.black)
            }
        }
    }
}

// MARK: - Restaurant Card
struct RestaurantCard: View {
    let restaurant: Restaurant
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Restaurant Image
                    AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(restaurant.name)
                                .font(.headline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            SustainabilityBadge(score: restaurant.sustainabilityScore)
                        }
                        
                        Text(restaurant.cuisine)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.cyan)
                                .font(.caption)
                            
                            Text("\(String(format: "%.1f", restaurant.distance)) km away")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(restaurant.rating) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        // Sustainability Features
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(restaurant.sustainabilityFeatures.prefix(3), id: \.self) { feature in
                                    Text(feature.displayName)
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(feature.color.opacity(0.2))
                                        )
                                        .foregroundColor(feature.color)
                                }
                            }
                        }
                    }
                }
                
                if restaurant.hasSpecialOffer {
                    HStack {
                        Image(systemName: "gift.fill")
                            .foregroundColor(.cyan)
                        
                        Text("Check-in bonus: +\(restaurant.checkInBonus) Eco-Credits")
                            .font(.caption)
                            .foregroundColor(.cyan)
                        
                        Spacer()
                    }
                    .padding(.top, 4)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Restaurant Map Pin
struct RestaurantMapPin: View {
    let restaurant: Restaurant
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(restaurant.sustainabilityScore >= 8 ? Color.green : restaurant.sustainabilityScore >= 6 ? Color.yellow : Color.orange)
                        .frame(width: 30, height: 30)
                    
                    Image(systemName: "fork.knife")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                
                // Pin tail
                Path { path in
                    path.move(to: CGPoint(x: 15, y: 30))
                    path.addLine(to: CGPoint(x: 10, y: 40))
                    path.addLine(to: CGPoint(x: 20, y: 40))
                    path.closeSubpath()
                }
                .fill(restaurant.sustainabilityScore >= 8 ? Color.green : restaurant.sustainabilityScore >= 6 ? Color.yellow : Color.orange)
            }
        }
    }
}

// MARK: - Sustainability Badge
struct SustainabilityBadge: View {
    let score: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "leaf.fill")
                .foregroundColor(badgeColor)
                .font(.caption2)
            
            Text(String(format: "%.1f", score))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(badgeColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(badgeColor.opacity(0.2))
        )
    }
    
    private var badgeColor: Color {
        if score >= 8 {
            return .green
        } else if score >= 6 {
            return .yellow
        } else {
            return .orange
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.cyan : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? .black : .gray)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Restaurant Detail View
struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header Image
                        AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(height: 200)
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Restaurant Info
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(restaurant.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text(restaurant.cuisine)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                SustainabilityBadge(score: restaurant.sustainabilityScore)
                            }
                            
                            // Rating and Distance
                            HStack {
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < Int(restaurant.rating) ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                    }
                                    
                                    Text(String(format: "%.1f", restaurant.rating))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.cyan)
                                        .font(.caption)
                                    
                                    Text("\(String(format: "%.1f", restaurant.distance)) km away")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Description
                            Text(restaurant.description)
                                .font(.body)
                                .foregroundColor(.white)
                                .lineLimit(nil)
                            
                            // Sustainability Features
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Sustainability Features")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                    ForEach(restaurant.sustainabilityFeatures, id: \.self) { feature in
                                        HStack {
                                            Image(systemName: feature.icon)
                                                .foregroundColor(feature.color)
                                                .font(.caption)
                                            
                                            Text(feature.displayName)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.2))
                                        )
                                    }
                                }
                            }
                            
                            // Check-in Button
                            if restaurant.hasSpecialOffer {
                                Button(action: {
                                    checkInToRestaurant()
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.black)
                                        
                                        Text("Check In (+\(restaurant.checkInBonus) Eco-Credits)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.cyan)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.cyan)
            )
        }
    }
    
    private func checkInToRestaurant() {
        appState.ecoCredits += restaurant.checkInBonus
        // In a real app, you'd also track the check-in
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Filter View
struct FilterView: View {
    @ObservedObject var viewModel: EcoDiningViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Filter Restaurants")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(SustainabilityFilter.allCases, id: \.self) { filter in
                                FilterRow(
                                    filter: filter,
                                    isSelected: viewModel.activeFilters.contains(filter)
                                ) {
                                    viewModel.toggleFilter(filter)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Clear All") {
                    viewModel.clearAllFilters()
                }
                .foregroundColor(.cyan),
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.cyan)
            )
        }
    }
}

// MARK: - Filter Row
struct FilterRow: View {
    let filter: SustainabilityFilter
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                Image(systemName: filter.icon)
                    .foregroundColor(filter.color)
                    .font(.title3)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(filter.displayName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(filter.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .cyan : .gray)
                    .font(.title2)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.cyan : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    EcoDiningView()
        .environmentObject(AppState())
}