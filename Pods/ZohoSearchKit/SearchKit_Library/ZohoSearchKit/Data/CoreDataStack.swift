//
//  CoreDataStack.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 23/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import CoreData

// MARK: - CoreDataStack

struct CoreDataStack {
    
    // MARK: Properties
    
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    internal let dbURL: URL
    let context: NSManagedObjectContext
    
    // MARK: Initializers
    
    init?(modelName: String) {
        
        //TODO: This one should be from the framework bundle
        // Assumes the model is in the main bundle
        //guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
        guard let modelURL = ZohoSearchKit.frameworkBundle.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Unable to find \(modelName)in the framework bundle")
            return nil
        }
        self.modelURL = modelURL
        
        // Try to create the model from the URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        
        // Create the store coordinator
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // create a context and add connect it to the coordinator
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        // When unique constrains is violated then new value will replace the old value
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Add a SQLite store located in the documents folder
        let fm = FileManager.default
        
        guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to reach the documents folder")
            return nil
        }
        
        //SQLite DB file name
        self.dbURL = docUrl.appendingPathComponent("ZohoSearchKit_Model.sqlite")
        
        // Options for migration
        let options = [NSInferMappingModelAutomaticallyOption: true,NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: options as [NSObject : AnyObject]?)
        } catch {
            fatalError("unable to add store at \(dbURL)")
        }
    }
    
    // MARK: Utils
    
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
    }
}

// MARK: - CoreDataStack (Removing Data)

internal extension CoreDataStack  {
    
    func dropAllData() throws {
        // delete all the objects in the db. This won't delete the files, it will
        // just leave empty tables.
        try coordinator.destroyPersistentStore(at: dbURL, ofType:NSSQLiteStoreType , options: nil)
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
    }
}

// MARK: - CoreDataStack (Save Data)

extension CoreDataStack {
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    //enable autosave only when there is frequent data change, not otherwise.
    //if enabled context will be saved every specified or default 60 second
    func autoSave(_ delayInSeconds : Int = 60) {
        
        guard delayInSeconds > 0 else {
            fatalError("Can't have negative auto save interval")
        }
        
        if delayInSeconds > 0 {
            do {
                try saveContext()
                SearchKitLogger.debugLog(message: "Autosaving", filePath: #file, lineNumber: #line, funcName: #function)
            } catch {
                fatalError("Error while autosaving")
            }
            
            let delayInNanoSeconds = UInt64(delayInSeconds) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.autoSave(delayInSeconds)
            }
        }
    }
}
