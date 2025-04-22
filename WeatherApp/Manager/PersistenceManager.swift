//
//  PersistenceManager.swift
//  WeatherApp
//
//  Created by Dipak Singh on 09/03/25.
//

import Foundation
import RealmSwift
import Combine

import RealmSwift

private protocol PersistanceOperations {
    //CRUD Operation
    static func write<T: Object>(_ object: T?) -> AnyPublisher<T?, Error>
    //static func add(_ object: Object) -> AnyPublisher<Void, Error>
    static func add<T: Object>(_ object: T) -> AnyPublisher<Void, Error>
    static func addList<S: Sequence>(_ objects: S) -> AnyPublisher<Void, Error> where S.Iterator.Element: Object
    static func get<T: Object>(fromEntity entityType: T.Type,
                               predicate: NSPredicate?) -> AnyPublisher<[T], NetworkError>
    static func delete(_ object: Object) -> AnyPublisher<Void, Error>
    static func deleteAll() -> AnyPublisher<Void, Error>
}

class PersistanceManager {
    
    init() {
        //Realm.Configuration.defaultConfiguration = PersistanceManager.config()
    }
    
    static func getPath() {
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            let absoluteString = fileURL.absoluteString
            print("Realm file URL: \(absoluteString)")
        } else {
            print("Error: Realm configuration file URL is nil")
        }
    }
    
    static func config() -> Realm.Configuration {
        let realmURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("WeatherApp.realm")
        return Realm.Configuration(fileURL: realmURL, schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
    }
    
    internal static func realmInstance() -> Realm {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            print("Realm error : \(error.localizedDescription)")
            fatalError("Unable to create an instance of Realm: \(error.localizedDescription)")
        }
    }
    
}

extension PersistanceManager: PersistanceOperations {
    static func write<T: Object>(_ object: T? = nil) -> AnyPublisher<T?, Error> {
        Future { promise in
            DispatchQueue(label: "Realm").sync {
                autoreleasepool {
                    let instance = realmInstance()
                    if instance.isInWriteTransaction {
                        promise(.failure(NSError(domain: "Realm", code: 1, userInfo: [NSLocalizedDescriptionKey: "Already in write transaction"])))
                        return
                    }
                    do {
                        try instance.write {
                            promise(.success(object))
                        }
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func add<T: Object>(_ object: T) -> AnyPublisher<Void, Error> {
        do {
                let realm = try Realm()
                try realm.write {
                    realm.create(T.self, value: object, update: .modified)//add(object, update: .modified)
                }
                return Just(())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
    }
    
    static func addList<S: Sequence>(_ objects: S) -> AnyPublisher<Void, Error> where S.Iterator.Element: Object {
        return write()
            .map { _ in
                let realm = realmInstance()
                realm.add(objects, update: .all)
            }
            .eraseToAnyPublisher()
    }
    
    static func get<T: Object>(fromEntity entityType: T.Type,
                               predicate: NSPredicate? = nil) -> AnyPublisher<[T], NetworkError> {
        do {
            let realm = try Realm()
            var results = realm.objects(T.self)
            if let predicate = predicate {
                results = results.filter(predicate)
            }
            results = results.sorted(byKeyPath: "timestamp", ascending: false)
            let frozenResults = results.freeze() // Make thread-safe
            
            return Just(Array(frozenResults))
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.custom("Failed to fetch: \(error.localizedDescription)"))
                .eraseToAnyPublisher()
        }
    }
    
    static func delete(_ object: Object) -> AnyPublisher<Void, Error> {
        return write(object)
            .map { _ in
                let realm = realmInstance()
                guard !object.isInvalidated else { return }
                realm.delete(object)
            }
            .eraseToAnyPublisher()
    }
    
    static func deleteAll() -> AnyPublisher<Void, Error> {
        return write()
            .map { _ in
                realmInstance().deleteAll()
            }
            .eraseToAnyPublisher()
    }
}
