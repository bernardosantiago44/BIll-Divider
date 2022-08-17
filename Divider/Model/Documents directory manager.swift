//
//  Documents directory manager.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 07/06/22.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let filemanager = FileManager.default
    let paths = filemanager.urls(for: .documentDirectory, in: .userDomainMask)
    let checksPath = paths[0].appendingPathComponent("checks")
    let categoriesPath = paths[0].appendingPathComponent("categories")
    
    if !filemanager.fileExists(atPath: checksPath.path) {
        do {
            try filemanager.createDirectory(at: checksPath, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    if !filemanager.fileExists(atPath: categoriesPath.path) {
        do {
            try filemanager.createDirectory(at: categoriesPath, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    return paths[0]
}

func saveCheck(_ check: Check) -> ActionResponse {
    let name: String = check.id.description
    let url = getDocumentsDirectory().appendingPathComponent("checks/\(name)")
    let encoder = JSONEncoder()
    var response: ActionResponse = .error
    
    do {
        // Converts the Check into encodable data
        let data = try encoder.encode(check)
        
        //Writes the Data to the disk using documents Directory
        try data.write(to: url, options: [.atomic, .noFileProtection])
        
        response = .success
    } catch {
        print(error.localizedDescription)
        response = .error
    }
    
    return response
    
}

func saveCategory(_ category: Category) -> ActionResponse {
    let name: String = category.id.description
    let url = getDocumentsDirectory().appendingPathComponent("categories/\(name)")
    let encoder = JSONEncoder()
    var response: ActionResponse = .error
    
    do {
        // Convert the category into encodable data
        let data = try encoder.encode(category)
        
        // Write the data into the disk using documents directory
        try data.write(to: url, options: .atomic)
        
        response = .success
    } catch {
        print(error.localizedDescription)
        response = .error
    }
    
    return response
}

func retrieveSavedChecksData() -> [Check] {
    let url = getDocumentsDirectory().appendingPathComponent("checks/")
    let directoryContents = try? FileManager.default.contentsOfDirectory(atPath: url.path)
    
    guard directoryContents != nil else {
        fatalError("Nil")
    }
    
    let decoder = JSONDecoder()
    
    do {
        var checks: [Check] = []
        for directoryContent in directoryContents! {
            let data = try Data(contentsOf: url.appendingPathComponent(directoryContent))
            let check = try decoder.decode(Check.self, from: data)
            checks.append(check)
        }
        return checks
    
    } catch {
        print(error.localizedDescription)
    }
     
    return []
    
}

func retrieveSavedCategoriesData() -> [Category] {
    let url = getDocumentsDirectory().appendingPathComponent("categories/")
    let directoryContents = try? FileManager.default.contentsOfDirectory(atPath: url.path)
    
    guard directoryContents != nil else {
        fatalError("Nil")
    }
    
    let decoder = JSONDecoder()
    
    do {
        var categories: [Category] = []
        for directoryContent in directoryContents! {
            let data = try Data(contentsOf: url.appendingPathComponent(directoryContent))
            let category = try decoder.decode(Category.self, from: data)
            categories.append(category)
        }
        return categories
    } catch {
        print(error.localizedDescription)
    }
    return []
}

func deleteCheckFromDirectory(check: Check) -> ActionResponse {
    let url = getDocumentsDirectory().appendingPathComponent("checks/")
    let filename: String = check.id.description
    let filePath = url.path.appendingFormat("/" + filename)
    var deleteStatus: ActionResponse = .error
    
    do {
        let filemanager = FileManager.default
        if filemanager.fileExists(atPath: filePath) {
            try filemanager.removeItem(atPath: filePath)
            deleteStatus = .success
        } else {
            print("File does not exist")
            deleteStatus = .doesNotExist
        }
    } catch {
        print("Error \(error.localizedDescription)")
        deleteStatus = .error
    }
    return deleteStatus
}

func deleteCategoryFromDirectory(category: Category) -> ActionResponse {
    let url = getDocumentsDirectory().appendingPathComponent("categories/")
    let filename = category.id.description
    let filepath = url.path.appendingFormat("/" + filename)
    var checksWithCategoryToDelete: [Check] {
        Store().checks.filter({ $0.category.id == category.id })
    }
    var deleteStatus: ActionResponse = .error
    
    do {
        let filemanager = FileManager.default
        if filemanager.fileExists(atPath: filepath) {
            try filemanager.removeItem(atPath: filepath)
            deleteStatus = .success
        } else {
            print("File does not exist")
            deleteStatus = .doesNotExist
        }
    } catch {
        print("Error \(error.localizedDescription)")
        deleteStatus = .error
    }
    return deleteStatus
}

enum ActionResponse: String {
    case success = "checkmark.rectangle.fill"
    case error = "xmark.rectangle.fill"
    case doesNotExist = "questionmark.folder.fill"
}

