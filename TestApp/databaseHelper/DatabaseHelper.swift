//
//  DatabaseHelper.swift
//  TestApp
//
//  Created by Precious Osaro on 23/7/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class DatabaseHelper{
    
    //function to help with inserting to coredata
public func addData( noteData: noteModel, completion: @escaping (_ result: Bool) -> Void) {
 
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
    let newNote = Notes(entity: entity!, insertInto: context)
    
    newNote.creation_date = Date()
    newNote.last_modified = Date()
    newNote.title = noteData.title
    newNote.detail = noteData.detail
    newNote.id = Int64(Date().timeIntervalSinceNow)
    
    do {
    try context.save()
      completion(true)
    } catch {
      completion(false)
    }
    }
    
    
    //function to help with fetch
    public func fetchData( completion: @escaping (_ result: [Notes]) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let sortDescriptor = NSSortDescriptor(key: "last_modified", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Notes]
          completion(result)
            
        } catch {
            let emptynote:[Notes] = []
           completion(emptynote)
        }
    }
    
     //function to help with delete
    public func deleteData( noteData: Notes, completion: @escaping (_ result: Bool) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(noteData)
        
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
     //function to help with  update
    public func updateData( noteData: Notes, completion: @escaping (_ result: Bool) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
       
        
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
     //function to help with search
    public func searchata( searchValue: String,completion: @escaping (_ result: [Notes]) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR detail CONTAINS[cd] %@",
                                             searchValue, searchValue)
        let sortDescriptor = NSSortDescriptor(key: "last_modified", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Notes]
            completion(result)
            
        } catch {
            let emptynote:[Notes] = []
            completion(emptynote)
        }
    }
    
    
    //here a simple application of singleton
    class var sharedManager: DatabaseHelper {
        struct Static {
            static let instance = DatabaseHelper()
        }
        return Static.instance
}
}
