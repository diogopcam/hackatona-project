import Foundation
import SwiftUI

@MainActor
class EmployeeViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiService = APIService.shared
    
    func fetchEmployees() {
        Task {
            isLoading = true
            error = nil
            do {
                employees = try await apiService.getAllEmployees()
            } catch {
                self.error = error.localizedDescription
                print("Error fetching employees: \(error)")
            }
            
            isLoading = false
        }
    }
    
    func fetchEmployeeRanking() {
        Task {
            isLoading = true
            error = nil
            
            do {
                employees = try await apiService.getEmployeeRanking()
                employees.sort { $0.average > $1.average }
            } catch {
                self.error = error.localizedDescription
                print("Error fetching employee ranking: \(error)")
            }
            
            isLoading = false
        }
    }
    
    func createEmployee(_ employee: Employee) {
        Task {
            isLoading = true
            error = nil
            
            do {
                let newEmployee = try await apiService.createEmployee(employee)
                employees.append(newEmployee)
            } catch {
                self.error = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func fetchEmployeesByPosition(_ position: String) {
        Task {
            isLoading = true
            error = nil
            
            do {
                employees = try await apiService.getEmployeesByPosition(position)
            } catch {
                self.error = error.localizedDescription
            }
            
            isLoading = false
        }
    }
} 
