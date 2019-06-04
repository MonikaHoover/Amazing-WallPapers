import Foundation
import CoreData
class WallpaperCoreData {
    static let share = WallpaperCoreData()
    func saveData(index:String?) {
        if #available(iOS 10.0, *) {
            let wallpaperEntity = Images(context: AppDelegate.context)
            wallpaperEntity.index = index
            AppDelegate.saveContext()
        } else {
        }
    }
    @available(iOS 10.0, *)
    func getAllData() -> [Images]{
        let fetchRequest = NSFetchRequest<Images>(entityName: "Images")
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result else {
            return []
        }
        return entity
    }
    @available(iOS 10.0, *)
    func getID() -> String{
        let fetchRequest = NSFetchRequest<Images>(entityName: "Images")
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result?.last else {
            return ""
        }
        return entity.index!
    }
}
