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
    
    func createActivity(_ activity: Activity) {
        Task {
            isLoading = true
            error = nil
            
            do {
                let newActivity = try await apiService.createActivity(activity)
                activities.append(newActivity)
            } catch {
                self.error = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func getActivityDetails(id: String) {
        Task {
            isLoading = true
            error = nil
            
            do {
                _ = try await apiService.getActivityByID(id)
            } catch {
                self.error = error.localizedDescription
                print("Error fetching activity details: \(error)")
            }
            
            isLoading = false
        }
    }
} 
