//
//  AddFriendView.swift
//  SustainaBuddy
//
//  Add Friend Modal View
//

import SwiftUI

struct AddFriendView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var selectedMethod: AddFriendMethod = .username
    @State private var showingQRScanner = false
    @State private var showingSuccess = false
    @State private var suggestedFriends: [SuggestedFriend] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.sleekDark.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Method selector
                    methodSelectorView
                    
                    // Content based on selected method
                    contentView
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Friends")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.glowingCyan),
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.glowingCyan)
            )
        }
        .sheet(isPresented: $showingQRScanner) {
            QRScannerView { code in
                handleQRCode(code)
            }
        }
        .alert("Friend Added!", isPresented: $showingSuccess) {
            Button("OK") { }
        } message: {
            Text("Successfully added friend to your network!")
        }
        .onAppear {
            loadSuggestedFriends()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.glowingCyan)
            
            Text("Connect with Friends")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Add friends to compete, share achievements, and motivate each other on your eco-journey!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(15)
    }
    
    private var methodSelectorView: some View {
        HStack(spacing: 0) {
            ForEach(AddFriendMethod.allCases, id: \.self) { method in
                Button(action: {
                    selectedMethod = method
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: method.iconName)
                            .font(.title2)
                        Text(method.rawValue)
                            .font(.caption)
                    }
                    .foregroundColor(selectedMethod == method ? .glowingCyan : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
            }
        }
        .background(Color.frostedGlass)
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedMethod {
        case .username:
            usernameSearchView
        case .qrCode:
            qrCodeView
        case .suggestions:
            suggestionsView
        }
    }
    
    private var usernameSearchView: some View {
        VStack(spacing: 16) {
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Enter username or email", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.frostedGlass)
            .cornerRadius(12)
            
            // Add button
            Button(action: {
                addFriendByUsername()
            }) {
                HStack {
                    Image(systemName: "person.badge.plus")
                    Text("Send Friend Request")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: searchText.isEmpty ? [.gray.opacity(0.3)] : [.glowingCyan, .kawaiBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .disabled(searchText.isEmpty)
            
            // Recent searches or suggestions
            if !searchText.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Search Results")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(mockSearchResults, id: \.id) { user in
                        SearchResultRow(user: user) {
                            addFriend(user)
                        }
                    }
                }
            }
        }
    }
    
    private var qrCodeView: some View {
        VStack(spacing: 24) {
            // QR Code display
            VStack(spacing: 16) {
                Text("Your QR Code")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: 200, height: 200)
                    
                    // Mock QR code pattern
                    VStack(spacing: 4) {
                        ForEach(0..<8) { row in
                            HStack(spacing: 4) {
                                ForEach(0..<8) { col in
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 16, height: 16)
                                        .opacity(Bool.random() ? 1 : 0)
                                }
                            }
                        }
                    }
                }
                
                Text("Let friends scan this code to add you")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color.frostedGlass)
            .cornerRadius(15)
            
            // Scan button
            Button(action: {
                showingQRScanner = true
            }) {
                HStack {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan Friend's QR Code")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.glowingCyan, .kawaiBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
        }
    }
    
    private var suggestionsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Suggested Friends")
                .font(.headline)
                .foregroundColor(.white)
            
            if suggestedFriends.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.2.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No suggestions available")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Try connecting through username or QR code")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(suggestedFriends) { friend in
                            SuggestedFriendRow(friend: friend) {
                                addSuggestedFriend(friend)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func addFriendByUsername() {
        // Simulate adding friend
        showingSuccess = true
        searchText = ""
    }
    
    private func addFriend(_ user: SearchResult) {
        // Simulate adding friend
        showingSuccess = true
    }
    
    private func addSuggestedFriend(_ friend: SuggestedFriend) {
        // Remove from suggestions and show success
        suggestedFriends.removeAll { $0.id == friend.id }
        showingSuccess = true
    }
    
    private func handleQRCode(_ code: String) {
        // Handle QR code scan result
        showingSuccess = true
    }
    
    private func loadSuggestedFriends() {
        // Mock suggested friends data
        suggestedFriends = [
            SuggestedFriend(
                name: "Emma Thompson",
                mutualFriends: 3,
                level: 18,
                reason: "Lives nearby"
            ),
            SuggestedFriend(
                name: "Michael Chang",
                mutualFriends: 5,
                level: 22,
                reason: "Similar interests"
            ),
            SuggestedFriend(
                name: "Lisa Garcia",
                mutualFriends: 2,
                level: 15,
                reason: "Active in your area"
            )
        ]
    }
    
    private var mockSearchResults: [SearchResult] {
        guard !searchText.isEmpty else { return [] }
        
        return [
            SearchResult(name: "\(searchText)_user1", level: 12, isOnline: true),
            SearchResult(name: "\(searchText)_eco", level: 20, isOnline: false),
            SearchResult(name: "green_\(searchText)", level: 8, isOnline: true)
        ]
    }
}

// MARK: - Supporting Views

struct SearchResultRow: View {
    let user: SearchResult
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.kawaiBlue.opacity(0.7), .kawaiPink.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 40, height: 40)
                
                Text(String(user.name.prefix(1).uppercased()))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                HStack {
                    Text("Level \(user.level)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if user.isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                        Text("Online")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.glowingCyan)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(10)
    }
}

struct SuggestedFriendRow: View {
    let friend: SuggestedFriend
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.kawaiBlue.opacity(0.7), .kawaiPink.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 50, height: 50)
                
                Text(String(friend.name.prefix(1).uppercased()))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Level \(friend.level) • \(friend.mutualFriends) mutual friends")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(friend.reason)
                    .font(.caption2)
                    .foregroundColor(.glowingCyan)
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Text("Add")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.glowingCyan.opacity(0.8))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.frostedGlass)
        .cornerRadius(12)
    }
}

struct QRScannerView: View {
    let onCodeScanned: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Text("Scan QR Code")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Mock camera view
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 250, height: 250)
                            .cornerRadius(20)
                        
                        // Scanning frame
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.glowingCyan, lineWidth: 3)
                            .frame(width: 250, height: 250)
                        
                        Text("📱")
                            .font(.system(size: 60))
                    }
                    
                    Text("Position the QR code within the frame")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Spacer()
                    
                    // Mock scan button for demo
                    Button("Simulate Scan") {
                        onCodeScanned("mock_qr_code_123")
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.glowingCyan)
                    .cornerRadius(12)
                    .padding()
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            )
        }
    }
}

// MARK: - Models

enum AddFriendMethod: String, CaseIterable {
    case username = "Username"
    case qrCode = "QR Code"
    case suggestions = "Suggestions"
    
    var iconName: String {
        switch self {
        case .username: return "at"
        case .qrCode: return "qrcode"
        case .suggestions: return "person.2"
        }
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let name: String
    let level: Int
    let isOnline: Bool
}

struct SuggestedFriend: Identifiable {
    let id = UUID()
    let name: String
    let mutualFriends: Int
    let level: Int
    let reason: String
}

// MARK: - Preview

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView()
            .preferredColorScheme(.dark)
    }
}