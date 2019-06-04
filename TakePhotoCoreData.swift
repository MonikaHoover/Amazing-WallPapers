import CoreData
class TakePhotoCoreData {
    static let share = TakePhotoCoreData()
    func saveData(id:String) {
        if #available(iOS 10.0, *) {
            let wallpaperEntity = Takephoto(context: AppDelegate.context)
            wallpaperEntity.id = id
            AppDelegate.saveContext()
        } else {
        }
    }
    @available(iOS 10.0, *)
    func getAllData() -> [Takephoto]{
        let fetchRequest = NSFetchRequest<Takephoto>(entityName: "Takephoto")
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result else {
            return []
        }
        return entity
    }
    @available(iOS 10.0, *)
    func getID() -> String?{
        let fetchRequest = NSFetchRequest<Takephoto>(entityName: "Takephoto")
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result?.last else {return "-1"}
        return entity.id
    }
    @available(iOS 10.0, *)
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<Takephoto>(entityName: "Takephoto")
        fetchRequest.returnsObjectsAsFaults = false
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result else {return }
        for object in entity {
            AppDelegate.context.delete(object)
        }
    }
}
