import UIKit
import CoreData

class AppLaunchManager {
    
    static func isFirstLaunch() -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //CoreData’da veri okuma/yazma yapacağım alanı al

        if let entities = context.persistentStoreCoordinator?.managedObjectModel.entities {
            for entity in entities {
                print("Entity: \(entity.name ?? "nil")")
            }
        }

        let fetchRequest: NSFetchRequest<LaunchState> = LaunchState.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest) //CoreData’dan veri çekiyoruz
            if results.isEmpty { //Liste boş mu?
                // İlk defa açılıyor
                let state = LaunchState(context: context)
                state.isFirstLaunch = false
                try context.save()
                return true
            } else {
                return false
            }
        } catch {
            print("Veri okunamadı: \(error)")
            return false
        }
        
        
        
        
    }

// LoginState entity, lastLogin: Date()

    static func isLastLoginWithinOneHour() -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LoginState> = LoginState.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            if let state = results.first, let lastLogin = state.lastLogin {
                let now = Date()
                let interval = now.timeIntervalSince(lastLogin) // interval in seconds
                return interval <= 3600 // 3600 seconds = 1 hour
            } else {
                // No previous login; treat as not within one hour
                return false
            }
        } catch {
            print("Failed to fetch LoginState: \(error)")
            return false
        }
    }

}
