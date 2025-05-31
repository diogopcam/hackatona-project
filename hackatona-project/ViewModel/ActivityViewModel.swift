import Foundation
import SwiftUI

@MainActor
class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiService = APIService.shared
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    // MARK: - Fetch all activities
    func fetchActivities() {
        Task {
            isLoading = true
            error = nil
            
            do {
                activities = try await apiService.getAllActivities()
                activities.forEach { activity in
                }
            } catch {
                self.error = error.localizedDescription
                print("Error fetching activities: \(error)")
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Create new activity
    func createActivity(_ activity: Activity) {
        Task {
            isLoading = true
            error = nil
            
            do {
                let newActivity = try await apiService.createActivity(activity)
                activities.append(newActivity)
            } catch {
                self.error = error.localizedDescription
                print("Error creating activity: \(error)")
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Get activity details
    func getActivityDetails(id: String) {
        Task {
            isLoading = true
            error = nil
            
            do {
                let activity = try await apiService.getActivityByID(id)
            } catch {
                self.error = error.localizedDescription
                print("Error fetching activity details: \(error)")
            }
            
            isLoading = false
        }
    }
} 
