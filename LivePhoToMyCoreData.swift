import CoreData
class LivePhoToMyCoreData{
    static let share = LivePhoToMyCoreData()
    func saveData(id:String,linkDataMOV:String,linkDataIMG:String) {
        if #available(iOS 10.0, *) {
            let wallpaperEntity = Livephotomy(context: AppDelegate.context)
            wallpaperEntity.id = id
            wallpaperEntity.linkDataMOV = linkDataMOV
            wallpaperEntity.linkDataIMG = linkDataIMG
            AppDelegate.saveContext()
        } else {
        }
    }
    @available(iOS 10.0, *)
    func getAllData() -> [Livephotomy]{
        let fetchRequest = NSFetchRequest<Livephotomy>(entityName: "Livephotomy")
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result else {
            return []
        }
        return entity
    }
    @available(iOS 10.0, *)
    func getDataWithId(id:String)->(String,String){
        let fetchRequest = NSFetchRequest<Livephotomy>(entityName: "Livephotomy")
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
    func getID() -> String?{
        let fetchRequest = NSFetchRequest<Livephotomy>(entityName: "Livephotomy")
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result?.last else {return "0"}
        return entity.id
    }
    @available(iOS 10.0, *)
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<Livephotomy>(entityName: "Livephotomy")
        fetchRequest.returnsObjectsAsFaults = false
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result else {return }
        for object in entity {
            AppDelegate.context.delete(object)
        }
    }
}
