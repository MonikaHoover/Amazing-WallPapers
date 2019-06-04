import CoreData
class LivePhoToCoreData{
    static let share = LivePhoToCoreData()
    func saveData(id:String,linkDataMOV:String,linkDataIMG:String) {
        if #available(iOS 10.0, *) {
            let wallpaperEntity = Livephoto(context: AppDelegate.context)
            wallpaperEntity.id = id
            wallpaperEntity.linkDataMOV = linkDataMOV
            wallpaperEntity.linkDataIMG = linkDataIMG
            AppDelegate.saveContext()
        } else {
        }
    }
    @available(iOS 10.0, *)
    func getAllData() -> [Livephoto]{
        let fetchRequest = NSFetchRequest<Livephoto>(entityName: "Livephoto")
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result else {
            return []
        }
        return entity
    }
    @available(iOS 10.0, *)
    func getDataWithId(id:String)->(String,String){
        let fetchRequest = NSFetchRequest<Livephoto>(entityName: "Livephoto")
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result else {
           return ("nil","nil")
        }
        for en in entity{
            if en.id == id{
                return (en.linkDataMOV!,en.linkDataIMG!)
            }
        }
        return ("nil","nil")
    }
    @available(iOS 10.0, *)
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<Livephoto>(entityName: "Livephoto")
        fetchRequest.returnsObjectsAsFaults = false
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result else {return }
        for object in entity {
            AppDelegate.context.delete(object)
        }
    }
}
