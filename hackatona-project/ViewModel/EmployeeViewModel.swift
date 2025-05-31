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
                print("=== Employees Data Received ===")
                print("Total employees: \(employees.count)")
                employees.forEach { employee in
                    print("""
                        ID: \(employee.id)
                        Name: \(employee.name)
                        Email: \(employee.email)
                        Position: \(employee.cargo)
                        ----------------------
                        """)
                }
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
                employees.enumerated().forEach { index, employee in
                }
            } catch {
                self.error = error.localizedDescription
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
                print("=== New Employee Created ===")
                print("""
                    ID: \(newEmployee.id)
                    Name: \(newEmployee.name)
                    Email: \(newEmployee.email)
                    Position: \(newEmployee.cargo)
                    ----------------------
                    """)
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
                print("=== Employees by Position: \(position) ===")
                print("Total employees found: \(employees.count)")
                employees.forEach { employee in
                    print("""
                        Name: \(employee.name)
                        Email: \(employee.email)
                        Position: \(employee.cargo)
                        ----------------------
                        """)
                }
            } catch {
                self.error = error.localizedDescription
                print("Error fetching employees by position: \(error)")
            }
            
            isLoading = false
        }
    }
} 
