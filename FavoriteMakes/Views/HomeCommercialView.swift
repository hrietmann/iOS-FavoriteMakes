//
//  HomeCommercialView.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 01/06/2022.
//

import SwiftUI


/// Simulates the commercial that should be send from a server API using UserDefaults flags
/// Each and every commercial suggestion should follow this cycle presented in the book [Hooked](https://books.apple.com/fr/book/hooked/id922743888) :
///
///         Trigger (External/Internal) —> Action —> Variable Reward —> Investment —> Trigger —> etc...
///
/// In our specific case we exploit this cycle like this:
/// - Empty list triggers the 'AddFavoriteSuggestion' message
/// - The 'AddFavoriteSuggestion' button help the user to select makes directly (instead of reaching the '+' button)
/// - Based on the user activity (favorites added, usage amount, account's creation age, ...) we suggest to the user:
///     - To be notified when new makes are publish, so he can invest more time in the app adding the newest makes.
///     - To create its account so he can increase its list max item count limit for free and add even more favorites
///     - To subscribe to a yearly subscription to get access to features that increases its capabilities of adding/saving its favorite makes
struct HomeCommercialView: View {
    
    
    @EnvironmentObject private var homeModel: HomeViewModel
    
    @AppStorage("hasPresentedAddFavoriteSuggestion")
    private var hasPresentedAddFavoriteSuggestion = false
    @AppStorage("hasPresentedNotificationsSuggestion")
    private var hasPresentedNotificationsSuggestion = false
    @AppStorage("hasPresentedCreateAccountSuggestion")
    private var hasPresentedCreateAccountSuggestion = false
    @AppStorage("hasPresentedSubscriptionSuggestion")
    private var hasPresentedSubscriptionSuggestion = false
    @State private var presentBrandsSelector = false
    @State private var presentAuth = false
    { willSet { if !newValue, presentAuth { hasPresentedCreateAccountSuggestion = true } } }
    
    
    init() {
        /// Removes any flags so we can test the marketing flow
        UserDefaults.standard.removeObject(forKey: "hasPresentedAddFavoriteSuggestion")
        UserDefaults.standard.removeObject(forKey: "hasPresentedNotificationsSuggestion")
        UserDefaults.standard.removeObject(forKey: "hasPresentedCreateAccountSuggestion")
        UserDefaults.standard.removeObject(forKey: "hasPresentedSubscriptionSuggestion")
    }
    
    
    var body: some View {
        Group {
            if homeModel.favoriteBrands.isEmpty, !hasPresentedAddFavoriteSuggestion {
                SuggestionRow(
                    title: "HomeView.AddFavoriteSuggestion.title",
                    message: "HomeView.AddFavoriteSuggestion.message"
                ) {
                    Button("HomeView.AddFavoriteSuggestion.buttonTitle")
                    { presentBrandsSelector = true }
                        .buttonStyle(PlainButton())
                        .sheet(isPresented: $presentBrandsSelector) {
                            BrandsSelector(
                                favorite: homeModel.favoriteBrands,
                                completion: { [weak homeModel] in homeModel?.set(favorite: $0) }
                            )
                        }
                    Button("Not now")
                    { hasPresentedAddFavoriteSuggestion = true }
                        .buttonStyle(OutlinedButton())
                }
            } else if homeModel.favoriteBrands.count > 3, !hasPresentedNotificationsSuggestion {
                SuggestionRow(
                    title: "HomeView.NotificationsSuggestion.title",
                    message: "HomeView.NotificationsSuggestion.message"
                ) {
                    Button("HomeView.NotificationsSuggestion.buttonTitle") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                            self.hasPresentedNotificationsSuggestion = true
                        }
                    }
                    .buttonStyle(PlainButton())
                    Button("HomeView.HomeCommercialView.notNowButton")
                    { hasPresentedNotificationsSuggestion = true }
                        .buttonStyle(OutlinedButton())
                }
            } else if !hasPresentedCreateAccountSuggestion, hasPresentedNotificationsSuggestion {
                SuggestionRow(
                    title: "HomeView.CreateAccountSuggestion.title",
                    message: "HomeView.CreateAccountSuggestion.message"
                ) {
                    Button("HomeView.CreateAccountSuggestion.buttonTitle")
                    { presentAuth = true }
                        .buttonStyle(PlainButton())
                        .sheet(isPresented: $presentAuth) {
                            AuthView()
                        }
                    Button("HomeView.HomeCommercialView.notNowButton")
                    { hasPresentedCreateAccountSuggestion = true }
                        .buttonStyle(OutlinedButton())
                }
            } else if !hasPresentedSubscriptionSuggestion, hasPresentedCreateAccountSuggestion {
                SuggestionRow(
                    title: "HomeView.SubscriptionSuggestion.title",
                    message: "HomeView.SubscriptionSuggestion.message"
                ) {
                    Button("HomeView.SubscriptionSuggestion.buttonTitle")
                    {  }
                        .buttonStyle(PlainButton())
                    Button("HomeView.HomeCommercialView.notNowButton")
                    { hasPresentedSubscriptionSuggestion = true }
                        .buttonStyle(OutlinedButton())
                }
            }
        }
        .transition(.opacity.combined(with: .offset(y: 40)))
        .animation(.easeIn, value: hasPresentedAddFavoriteSuggestion)
        .animation(.strongBounce, value: homeModel.favoriteBrands)
        .animation(.strongBounce, value: hasPresentedNotificationsSuggestion)
        .animation(.strongBounce, value: hasPresentedCreateAccountSuggestion)
        .animation(.strongBounce, value: hasPresentedSubscriptionSuggestion)
    }
    
    
}

struct HomeCommercialView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCommercialView()
            .environmentObject(HomeViewModel())
    }
}
