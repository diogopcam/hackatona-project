import Foundation
import SwiftUI

@MainActor
class ResourceViewModel: ObservableObject {
    @Published var resources: [Resource] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiService = APIService.shared
    
    // MARK: - Fetch all resources
    func fetchResources() {
        Task {
            isLoading = true
            error = nil
            
            do {
                resources = try await apiService.getAllResources()
                print("=== Resources Data Received ===")
                print("Total resources: \(resources.count)")
                resources.forEach { resource in
                    print("""
                        ID: \(resource.id)
                        Name: \(resource.name)
                        Type: \(resource.type)
                        Rating: \(resource.averageRating)
                        Location: \(resource.location ?? "N/A")
                        ----------------------
                        """)
                }
            } catch {
                self.error = error.localizedDescription
                print("Error fetching resources: \(error)")
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Fetch resources by type
    func fetchResourcesByType(_ type: String) {
        Task {
            isLoading = true
            error = nil
            
            do {
                resources = try await apiService.getResourcesByType(type)
                print("=== Resources by Type: \(type) ===")
                print("Total resources found: \(resources.count)")
            } catch {
                self.error = error.localizedDescription
                print("Error fetching resources by type: \(error)")
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Create new resource
    func createResource(_ resource: Resource) {
        Task {
            isLoading = true
            error = nil
            
            do {
                let newResource = try await apiService.createResource(resource)
                resources.append(newResource)
                print("=== New Resource Created ===")
                print("""
                    ID: \(newResource.id)
                    Name: \(newResource.name)
                    Type: \(newResource.type)
                    ----------------------
                    """)
            } catch {
                self.error = error.localizedDescription
                print("Error creating resource: \(error)")
            }
            
            isLoading = false
        }
    }
} 