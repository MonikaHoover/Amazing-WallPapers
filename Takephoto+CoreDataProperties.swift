import Foundation
import CoreData
extension Takephoto {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Takephoto> {
        return NSFetchRequest<Takephoto>(entityName: "Takephoto")
    }
    @NSManaged public var id: String?
}
