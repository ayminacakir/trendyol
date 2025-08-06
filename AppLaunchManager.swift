import UIKit
import CoreData

class AppLaunchManager {
    
    static func isFirstLaunch() -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //oreData’da veri okuma/yazma yapacağım alanı al

        if let entities = context.persistentStoreCoordinator?.managedObjectModel.entities {
            for entity in entities {
                print("Entity: \(entity.name ?? "nil")")
            }
        }

        let fetchRequest: NSFetchRequest<LaunchState> = LaunchState.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest) //CoreData’dan veri çekiyoru
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
}
