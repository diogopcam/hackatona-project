import Foundation
import SwiftUI

@MainActor
class EmployeeViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiService = APIService.shared
    
    // MARK: - Fetch all employees
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
    
    // MARK: - Fetch employee ranking
    func fetchEmployeeRanking() {
        Task {
            isLoading = true
            error = nil
            
            do {
                employees = try await apiService.getEmployeeRanking()
                // Sort employees by average rating in descending order
                employees.sort { $0.average > $1.average }
            } catch {
                self.error = error.localizedDescription
                print("Error fetching employee ranking: \(error)")
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Create new employee
    func createEmployee(_ employee: Employee) {
        Task {
            isLoading = true
            error = nil
            
            do {
                let newEmployee = try await apiService.createEmployee(employee)
                employees.append(newEmployee)
            } catch {
                self.error = error.localizedDescription
                print("Error creating employee: \(error)")
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Filter employees by position
    func fetchEmployeesByPosition(_ position: String) {
        Task {
            isLoading = true
            error = nil
            
            do {
                employees = try await apiService.getEmployeesByPosition(position)
            } catch {
                self.error = error.localizedDescription
                print("Error fetching employees by position: \(error)")
            }
            
            isLoading = false
        }
    }
} 
