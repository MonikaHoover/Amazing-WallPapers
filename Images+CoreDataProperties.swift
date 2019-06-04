import Foundation
import CoreData
extension Images {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }
    @NSManaged public var index: String?
}
