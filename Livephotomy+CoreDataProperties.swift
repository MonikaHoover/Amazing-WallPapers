import Foundation
import CoreData
extension Livephotomy {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Livephotomy> {
        return NSFetchRequest<Livephotomy>(entityName: "Livephotomy")
    }
    @NSManaged public var id: String?
    @NSManaged public var linkDataIMG: String?
    @NSManaged public var linkDataMOV: String?
}
