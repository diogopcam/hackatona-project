//
//  Persistence.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Persistence {
    private static let loggedUserKey = "logged_user"
    private static let allUsersKey = "all_users"

    static func updateLoggedUser(with user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: loggedUserKey)
        } catch {
            print("Failed to save logged user:", error.localizedDescription)
        }
    }

    static func getLoggedUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: loggedUserKey) else { return nil }
        do {
            return try JSONDecoder().decode(User.self, from: data)
        } catch {
            print("Failed to load logged user:", error.localizedDescription)
            return nil
        }
    }

    static func logout() {
        UserDefaults.standard.removeObject(forKey: loggedUserKey)
    }

    static func getUsers() -> AllUsers? {
        guard let data = UserDefaults.standard.data(forKey: allUsersKey) else { return nil }
        do {
            return try JSONDecoder().decode(AllUsers.self, from: data)
        } catch {
            print("Failed to load all users:", error.localizedDescription)
            return nil
        }
    }

    static func addUser(_ user: User) {
        var allUsers = getUsers() ?? AllUsers(users: [])
        allUsers.users.append(user)
        
        saveAllUsers(allUsers)
    }

    static func updateUser(_ updatedUser: User) {
        var allUsers = getUsers() ?? AllUsers(users: [])
        guard let index = allUsers.users.firstIndex(where: { $0.id == updatedUser.id }) else { return }
        
        allUsers.users[index] = updatedUser
        saveAllUsers(allUsers)
        
        updateLoggedUser(with: updatedUser)
    }

    static func deleteAccount() {
        guard let loggedUser = getLoggedUser(),
              var allUsers = getUsers() else { return }
        
        allUsers.users.removeAll { $0.id == loggedUser.id }
        saveAllUsers(allUsers)
        logout()
    }

    private static func saveAllUsers(_ allUsers: AllUsers) {
        do {
            let data = try JSONEncoder().encode(allUsers)
            UserDefaults.standard.set(data, forKey: allUsersKey)
        } catch {
            print("Failed to save users:", error.localizedDescription)
        }
    }
}
