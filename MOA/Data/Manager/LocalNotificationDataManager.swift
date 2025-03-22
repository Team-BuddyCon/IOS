//
//  NotificationDataManager.swift
//  MOA
//
//  Created by 오원석 on 3/8/25.
//

import Foundation
import CoreData

class LocalNotificationDataManager {
    static let shared = LocalNotificationDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotificationModel")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error {
                fatalError()
            }
        })
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func insertNotification(_ notification: NotificationModel) -> Bool{
        MOALogger.logd("\(notification)")
        if let entity = NSEntityDescription.entity(forEntityName: "NotificationInfo", in: context) {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(notification.count, forKey: "count")
            info.setValue(notification.date, forKey: "date")
            info.setValue(notification.message, forKey: "message")
            info.setValue(notification.gifticonId, forKey: "gifticonId")
            info.setValue(notification.isRead, forKey: "isRead")
            
            do {
                try context.save()
                return true
            } catch {
                MOALogger.loge(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func updateNotification(_ notification: NotificationModel) -> Bool {
        MOALogger.logd("\(notification)")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "NotificationInfo")
        fetchRequest.predicate = NSPredicate(format: "date = %@", notification.date)
        do {
            if let info = try context.fetch(fetchRequest)[0] as? NotificationInfo {
                info.setValue(true, forKey: "isRead")
                
                do {
                    try context.save()
                    return true
                } catch {
                    MOALogger.loge(error.localizedDescription)
                    return false
                }
            }
        } catch {
            MOALogger.loge(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    func fetchNotification() -> [NotificationModel] {
        MOALogger.logd()
        do {
            if let notifications = try context.fetch(NotificationInfo.fetchRequest()) as? [NotificationInfo] {
                return notifications.reversed().map {
                    NotificationModel(
                        count: Int($0.count),
                        date: $0.date,
                        message: $0.message,
                        gifticonId: $0.gifticonId,
                        isRead: $0.isRead
                    )
                }
            }
            return []
        } catch {
            return []
        }
    }
    
    func deleteNotification(_ notification: NotificationInfo) -> Bool {
        MOALogger.logd()
        context.delete(notification)
        do {
            try context.save()
            return true
        } catch {
            MOALogger.loge(error.localizedDescription)
            return false
        }
    }
    
    func deleteAll() -> Bool {
        MOALogger.logd()
        let delete = NSBatchDeleteRequest(fetchRequest: NotificationInfo.fetchRequest())
        do {
            try context.execute(delete)
            return true
        } catch {
            MOALogger.loge(error.localizedDescription)
            return false
        }
    }
}
