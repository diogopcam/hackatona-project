import Foundation
import SwiftUI

@MainActor
class ResourceViewModel: ObservableObject {
    @Published var resources: [Resource] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiService = APIService.shared
    
    func fetchResources() {
        Task {
            isLoading = true
            error = nil
            
            do {
                resources = try await apiService.getAllResources()
                resources.forEach { resource in
                }
            } catch {
                self.error = error.localizedDescription

            }
            
            isLoading = false
        }
    }
    
    func fetchResourcesByType(_ type: String) {
        Task {
            isLoading = true
            error = nil
            
            do {
                resources = try await apiService.getResourcesByType(type)
            } catch {
                self.error = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func createResource(_ resource: Resource) {
        Task {
            isLoading = true
            error = nil
            
            do {
                let newResource = try await apiService.createResource(resource)
                resources.append(newResource)
            } catch {
                self.error = error.localizedDescription
            }
            
            isLoading = false
        }
    }
} 
