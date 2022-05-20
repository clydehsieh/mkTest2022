//
//  DBManager.swift
//  Homework
//
//  Created by ClydeHsieh on 2022/5/20.
// https://www.appcoda.com.tw/fmdb-sqlite-database/

import UIKit
import FMDB
import RxSwift

enum DBManagerError: Error {
    case databaseNotExist
}

class DBManager {
    
    static let shared = DBManager()
    
    let databaseFileName = "database.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    let table_name = "items"
    let field_id = "id"
    let field_time = "time"
    let field_title = "title"
    let field_description = "description"
    
    
    let accessQueue = DispatchQueue.init(label: "dbmanger.access")
    
    init() {
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
}

extension DBManager {
    
    @discardableResult
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                if database.open() {
                    let createMoviesTableQuery = "create table \(table_name) (\(field_id) integer primary key autoincrement not null, \(field_time) integer not null, \(field_title) text not null, \(field_description) text not null)"
                    
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    } catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    func deleteDatabase() {
        do {
            try FileManager.default.removeItem(atPath: pathToDatabase)
        } catch {
            print("Could not delete table.")
            print(error.localizedDescription)
        }
    }
}

extension DBManager {
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
}

//MARK: - add
extension DBManager {
    func insert(items: [NoteItem]) -> Observable<Void> {
        return Observable<Void>.create { [unowned self] observer in
            guard openDatabase() else  {
                observer.onError(DBManagerError.databaseNotExist)
                return Disposables.create { }
            }

            do {
                for item in items {
                    try database.executeUpdate("insert or replace into \(table_name) (\(field_id), \(field_time), \(field_title), \(field_description)) values (?,?,?,?)", values: [item.id, Int(item.time.timeIntervalSince1970), item.title, item.description])
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                print(database.lastError(), database.lastErrorMessage())
                observer.onError(database.lastError())
            }
            
//            if !database.executeStatements(query) {
//                print("Failed to insert initial data into the database.")
//                print(database.lastError(), database.lastErrorMessage())
//                observer.onError(database.lastError())
//            } else {
//                observer.onNext(())
//                observer.onCompleted()
//            }
            
            database.close()
            return Disposables.create { }
        }
    }
}

//MARK: - fetch
extension DBManager {
    func loadItems() -> Observable<[NoteItem]> {
        return Observable<[NoteItem]>.create { [unowned self] observer in
            
            guard openDatabase() else  {
                observer.onError(DBManagerError.databaseNotExist)
                return Disposables.create { }
            }
            
            var itemsArray = [NoteItem]()
            
            let query = "select * from \(table_name) order by \(field_id) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let id = Int(results.int(forColumn: field_id))
                    let timeIn = Int(results.int(forColumn: field_time))
                    let time = Date.init(timeIntervalSince1970: TimeInterval(timeIn))
                    let title = results.string(forColumn: field_title) ?? ""
                    let description = results.string(forColumn: field_description) ?? ""
                    
                    let item = NoteItem(id: id, time: time, title: title, description: description)
                    itemsArray.append(item)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
            observer.onNext(itemsArray)
            observer.onCompleted()
            
            return Disposables.create { }
        }
    }
}


