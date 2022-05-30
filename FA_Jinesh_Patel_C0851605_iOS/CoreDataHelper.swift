//
//  CoreDataHelper.swift
//  FA_Jinesh_Patel_C0851605_iOS
//
//  Created by Jinesh Patel on 29/05/22.
//

import UIKit
import Foundation
import CoreData

class CoreDataHelper {
    static var instance : CoreDataHelper = CoreDataHelper()
    
    /// This methods return total count of data added for board
    func totalDataCount() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.ENTITY_BOARD)
        fetchRequest.predicate = NSPredicate(format: "id = %@", Constant.GAME_ID)
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        do {
            let res = try managedContext.fetch(fetchRequest)
            if let arr =  res as? [NSManagedObject] {
                return arr.count
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return 0
    }
    
    /// This method can be called first time when user initiate game
    func saveFirstTime(turn : String) {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        let objEntityGame = NSEntityDescription.insertNewObject(forEntityName: Constant.ENTITY_BOARD, into: managedContext) as! BoardOfGame
        
        objEntityGame.firstMove = turn
        objEntityGame.id = Constant.GAME_ID
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /// This method will be called when user tap on "O" or "X"
    func addBoard(move : MoveOfButton, turn : String, start : String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.ENTITY_BOARD)
        fetchRequest.predicate = NSPredicate(format: "id = %@", Constant.GAME_ID)
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        do {
            let res = try managedContext.fetch(fetchRequest)
            if let arr =  res as? [NSManagedObject] {
                if arr.count != 0 {
                    let managedObject = arr[0]
                    let obj = managedObject as! BoardOfGame
                    if obj.moves == nil {
                        var arrMoves : [String] = []
                        arrMoves.append(move.rawValue)
                        obj.moves = arrMoves as NSObject
                    } else {
                        var arrImg = obj.moves as! [String]
                        arrImg.append(move.rawValue)
                        obj.moves = arrImg as NSObject
                    }
                    obj.firstMove = start
                    obj.lastMove = turn
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /// This method will be called to save first move
    func changePlayer(move : String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.ENTITY_BOARD)
        fetchRequest.predicate = NSPredicate(format: "id = %@", Constant.GAME_ID)
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        do {
            let res = try managedContext.fetch(fetchRequest)
            if let arr =  res as? [NSManagedObject] {
                if arr.count != 0 {
                    let managedObject = arr[0]
                    let obj = managedObject as! BoardOfGame
                    obj.firstMove = move
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /// This method will be called when user shake device to remove last move
    func removeRecentItem(turn : String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.ENTITY_BOARD)
        fetchRequest.predicate = NSPredicate(format: "id = %@", Constant.GAME_ID)
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        do {
            let res = try managedContext.fetch(fetchRequest)
            if let arr =  res as? [NSManagedObject] {
                if arr.count != 0 {
                    let managedObject = arr[0]
                    let obj = managedObject as! BoardOfGame
                    if obj.moves != nil {
                        var arrImg = obj.moves as! [String]
                        arrImg.removeLast()
                        obj.moves = arrImg as NSObject
                    }
                    obj.firstMove = turn
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /// This method will be called to update count of NOUGHT value
    func modifyNoughtValue(count : Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.ENTITY_BOARD)
        fetchRequest.predicate = NSPredicate(format: "id = %@", Constant.GAME_ID)
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        do {
            let res = try managedContext.fetch(fetchRequest)
            if let arr =  res as? [NSManagedObject] {
                if arr.count != 0 {
                    let managedObject = arr[0]
                    let obj = managedObject as! BoardOfGame
                    obj.totalOfO = Double(count)
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /// This method will be called to update count of CROSS value
    func modifyCrossValue(count : Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.ENTITY_BOARD)
        fetchRequest.predicate = NSPredicate(format: "id = %@", Constant.GAME_ID)
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        do {
            let res = try managedContext.fetch(fetchRequest)
            if let arr =  res as? [NSManagedObject] {
                if arr.count != 0 {
                    let managedObject = arr[0]
                    let obj = managedObject as! BoardOfGame
                    var arrMoves = obj.moves as! [String]
                    arrMoves.removeAll()
                    obj.totalOfX = Double(count)
                    obj.moves = arrMoves as NSObject
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /// This method will be called to sync database with application
    func syncDatabase() {
        appDelegate.arrData.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.ENTITY_BOARD)
        
        do {
            appDelegate.arrData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /// This method will be called when user wants to reset data in database(When swipe gesture is called)
    func resetBoardFromDatabase() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.ENTITY_BOARD)
        fetchRequest.predicate = NSPredicate(format: "id = %@", Constant.GAME_ID)
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        do {
            let res = try managedContext.fetch(fetchRequest)
            if let arr =  res as? [NSManagedObject] {
                if arr.count != 0 {
                    let managedObject = arr[0]
                    managedContext.delete(managedObject)
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

