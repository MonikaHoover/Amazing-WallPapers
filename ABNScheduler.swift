import Foundation
import UIKit
let MAX_ALLOWED_NOTIFICATIONS = 64
class ABNScheduler {
    static let maximumScheduledNotifications = 60
    fileprivate let identifierKey = "ABNIdentifier"
    static let identifierKey = "ABNIdentifier"
    class func schedule(alertBody: String, fireDate: Date) -> String? {
        let notification = ABNotification(alertBody: alertBody)
        if let identifier = notification.schedule(fireDate: fireDate) {
            return identifier
        }
        return nil
    }
    class func cancel(_ notification: ABNotification) {
        notification.cancel()
    }
    class func cancelAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
        ABNQueue.queue.clear()
        let _ = saveQueue()
        print("All notifications have been cancelled")
    }
    class func farthestLocalNotification() -> ABNotification? {
        if let localNotification = UIApplication.shared.scheduledLocalNotifications?.last {
            return notificationWithUILocalNotification(localNotification)
        }
        return nil
    }
    class func scheduledCount() -> Int {
        return (UIApplication.shared.scheduledLocalNotifications?.count)!
    }
    class func queuedCount() -> Int {
        return ABNQueue.queue.count()
    }
    class func count() -> Int {
        return scheduledCount() + queuedCount()
    }
    class func scheduleNotificationsFromQueue() {
        for _ in 0..<(min(maximumScheduledNotifications, MAX_ALLOWED_NOTIFICATIONS) - scheduledCount()) where ABNQueue.queue.count() > 0 {
            let notification = ABNQueue.queue.pop()
            let _ = notification.schedule(fireDate: notification.fireDate!)
        }
    }
    class func notificationWithIdentifier(_ identifier: String) -> ABNotification? {
        let notifs = UIApplication.shared.scheduledLocalNotifications
        let queue = ABNQueue.queue.notificationsQueue()
        if notifs?.count == 0 && queue.count == 0 {
            return nil
        }
        for note in notifs! {
            let id = note.userInfo![ABNScheduler.identifierKey] as! String
            if id == identifier {
                return notificationWithUILocalNotification(note)
            }
        }
        if let note = ABNQueue.queue.notificationWithIdentifier(identifier) {
            return note
        }
        return nil
    }
    class func notificationWithUILocalNotification(_ localNotification: UILocalNotification) -> ABNotification {
        return ABNotification.notificationWithUILocalNotification(localNotification)
    }
    class func rescheduleNotifications() {
        let notificationsCount = count()
        var notificationsArray = [ABNotification?](repeating: nil, count: notificationsCount)
        let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications
        var i = 0
        for note in scheduledNotifications! {
            let notif = notificationWithIdentifier(note.userInfo?[identifierKey] as! String)
            notificationsArray[i] = notif
            notif?.cancel()
            i += 1
        }
        let queuedNotifications = ABNQueue.queue.notificationsQueue()
        for note in queuedNotifications {
            notificationsArray[i] = note
            i += 1
        }
        cancelAllNotifications()
        for note in notificationsArray {
            let _ = note?.schedule(fireDate: (note?.fireDate)!)
        }
    }
    class func scheduledNotifications() -> [ABNotification]? {
        if let localNotifications = UIApplication.shared.scheduledLocalNotifications {
            var notifications = [ABNotification]()
            for localNotification in localNotifications {
                notifications.append(ABNotification.notificationWithUILocalNotification(localNotification))
            }
            return notifications
        }
        return nil
    }
    class func notificationsQueue() -> [ABNotification] {
        return ABNQueue.queue.notificationsQueue()
    }
    class func saveQueue() -> Bool {
        return ABNQueue.queue.save()
    }
    class func listScheduledNotifications() {
        let notifs = UIApplication.shared.scheduledLocalNotifications
        let notificationQueue = ABNQueue.queue.notificationsQueue()
        if notifs?.count == 0 && notificationQueue.count == 0 {
            print("There are no scheduled notifications")
            return
        }
        print("SCHEDULED")
        var i = 1
        for note in notifs! {
            let id = note.userInfo![identifierKey] as! String
            print("\(i) Alert body: \(note.alertBody!) - Fire date: \(note.fireDate!) - Repeats: \(ABNotification.calendarUnitToRepeats(calendarUnit: note.repeatInterval)) - Identifier: \(id)")
            i += 1
        }
        print("QUEUED")
        for note in notificationQueue {
            print("\(i) Alert body: \(note.alertBody) - Fire date: \(note.fireDate!) - Repeats: \(note.repeatInterval) - Identifier: \(note.identifier)")
            i += 1
        }
        print("")
    }
    class func loadQueue() -> [ABNotification]? {
        return ABNQueue().load()
    }
}
private class ABNQueue : NSObject {
    fileprivate var notifQueue = [ABNotification]()
    static let queue = ABNQueue()
    let ArchiveURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("notifications.abnqueue")
    override init() {
        super.init()
        if let notificationQueue = self.load() {
            notifQueue = notificationQueue
        }
    }
    fileprivate func push(_ notification: ABNotification) {
        notifQueue.insert(notification, at: findInsertionPoint(notification))
    }
    fileprivate func findInsertionPoint(_ notification: ABNotification) -> Int {
        let range = 0..<notifQueue.count
        var rangeLowerBound = range.lowerBound
        var rangeUpperBound = range.upperBound
        while rangeLowerBound < rangeUpperBound {
            let midIndex = rangeLowerBound + (rangeUpperBound - rangeLowerBound) / 2
            if notifQueue[midIndex] == notification {
                return midIndex
            } else if notifQueue[midIndex] < notification {
                rangeLowerBound = midIndex + 1
            } else {
                rangeUpperBound = midIndex
            }
        }
        return rangeLowerBound
    }
    fileprivate func pop() -> ABNotification {
        return notifQueue.removeFirst()
    }
    fileprivate func peek() -> ABNotification? {
        return notifQueue.last
    }
    fileprivate func clear() {
        notifQueue.removeAll()
    }
    fileprivate func removeAtIndex(_ index: Int) {
        notifQueue.remove(at: index)
    }
    fileprivate func count() -> Int {
        return notifQueue.count
    }
    fileprivate func notificationsQueue() -> [ABNotification] {
        let queue = notifQueue
        return queue
    }
    fileprivate func notificationWithIdentifier(_ identifier: String) -> ABNotification? {
        for note in notifQueue {
            if note.identifier == identifier {
                return note
            }
        }
        return nil
    }
    fileprivate func save() -> Bool {
        return NSKeyedArchiver.archiveRootObject(self.notifQueue, toFile: ArchiveURL.path)
    }
    fileprivate func load() -> [ABNotification]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [ABNotification]
    }
}
enum Repeats: String {
    case None, Hourly, Daily, Weekly, Monthly, Yearly
}
open class ABNotification : NSObject, NSCoding, Comparable {
    fileprivate var localNotification: UILocalNotification
    var alertBody: String
    var alertAction: String?
    var soundName: String?
    var repeatInterval = Repeats.None
    var userInfo: Dictionary<String, AnyObject>
    fileprivate(set) var identifier: String
    fileprivate var scheduled = false
    var fireDate: Date? {
        return localNotification.fireDate
    }
    init(alertBody: String) {
        self.alertBody = alertBody
        self.localNotification = UILocalNotification()
        self.identifier = UUID().uuidString
        self.userInfo = Dictionary<String, AnyObject>()
        super.init()
    }
    init(alertBody: String, identifier: String) {
        self.alertBody = alertBody
        self.localNotification = UILocalNotification()
        self.identifier = identifier
        self.userInfo = Dictionary<String, AnyObject>()
        super.init()
    }
    fileprivate init(notification: UILocalNotification, alertBody: String, alertAction: String?, soundName: String?, identifier: String, repeats: Repeats, userInfo: Dictionary<String, AnyObject>, scheduled: Bool) {
        self.alertBody = alertBody
        self.alertAction = alertAction
        self.soundName = soundName;
        self.localNotification = notification
        self.identifier = identifier
        self.userInfo = userInfo
        self.repeatInterval = repeats
        self.scheduled = scheduled
        super.init()
    }
    func schedule(fireDate date: Date) -> String? {
        if self.scheduled {
            return nil
        } else {
            self.localNotification = UILocalNotification()
            self.localNotification.alertBody = self.alertBody
            self.localNotification.alertAction = self.alertAction
            self.localNotification.fireDate = date.removeSeconds()
            self.localNotification.soundName = (self.soundName == nil) ? UILocalNotificationDefaultSoundName : self.soundName;
            self.userInfo[ABNScheduler.identifierKey] = self.identifier as AnyObject?
            self.localNotification.userInfo = self.userInfo
            self.soundName = self.localNotification.soundName
            if repeatInterval != .None {
                switch repeatInterval {
                case .Hourly: self.localNotification.repeatInterval = NSCalendar.Unit.hour
                case .Daily: self.localNotification.repeatInterval = NSCalendar.Unit.day
                case .Weekly: self.localNotification.repeatInterval = NSCalendar.Unit.weekOfYear
                case .Monthly: self.localNotification.repeatInterval = NSCalendar.Unit.month
                case .Yearly: self.localNotification.repeatInterval = NSCalendar.Unit.year
                default: break
                }
            }
            let count = ABNScheduler.scheduledCount()
            if count >= min(ABNScheduler.maximumScheduledNotifications, MAX_ALLOWED_NOTIFICATIONS) {
                if let farthestNotification = ABNScheduler.farthestLocalNotification() {
                    if farthestNotification > self {
                        farthestNotification.cancel()
                        ABNQueue.queue.push(farthestNotification)
                        self.scheduled = true
                        UIApplication.shared.scheduleLocalNotification(self.localNotification)
                    } else {
                        ABNQueue.queue.push(self)
                    }
                }
                return self.identifier
            }
            self.scheduled = true
            UIApplication.shared.scheduleLocalNotification(self.localNotification)
            return self.identifier
        }
    }
    func reschedule(fireDate date: Date) {
        cancel()
        let _ = schedule(fireDate: date)
    }
    func cancel() {
        UIApplication.shared.cancelLocalNotification(self.localNotification)
        let queue = ABNQueue.queue.notificationsQueue()
        var i = 0
        for note in queue {
            if self.identifier == note.identifier {
                ABNQueue.queue.removeAtIndex(i)
                break
            }
            i += 1
        }
        scheduled = false
    }
    func snoozeForMinutes(_ minutes: Int) {
        reschedule(fireDate: self.localNotification.fireDate!.nextMinutes(minutes))
    }
    func snoozeForHours(_ hours: Int) {
        reschedule(fireDate: self.localNotification.fireDate!.nextHours(hours))
    }
    func snoozeForDays(_ days: Int) {
        reschedule(fireDate: self.localNotification.fireDate!.nextDays(days))
    }
    func isScheduled() -> Bool {
        return self.scheduled
    }
    fileprivate class func calendarUnitToRepeats(calendarUnit cUnit: NSCalendar.Unit) -> Repeats {
        switch cUnit {
        case NSCalendar.Unit.hour: return .Hourly
        case NSCalendar.Unit.day: return .Daily
        case NSCalendar.Unit.weekOfYear: return .Weekly
        case NSCalendar.Unit.month: return .Monthly
        case NSCalendar.Unit.year: return .Yearly
        default: return Repeats.None
        }
    }
    fileprivate class func notificationWithUILocalNotification(_ localNotification: UILocalNotification) -> ABNotification {
        let alertBody = localNotification.alertBody!
        let alertAction = localNotification.alertAction
        let soundName = localNotification.soundName
        let identifier = localNotification.userInfo![ABNScheduler.identifierKey] as! String
        let repeats = self.calendarUnitToRepeats(calendarUnit: localNotification.repeatInterval)
        let userInfo = localNotification.userInfo!
        return ABNotification(notification: localNotification, alertBody: alertBody, alertAction: alertAction, soundName: soundName, identifier: identifier, repeats: repeats, userInfo: userInfo as! Dictionary<String, AnyObject>, scheduled: true)
    }
    @objc convenience public required init?(coder aDecoder: NSCoder) {
        guard let localNotification = aDecoder.decodeObject(forKey: "ABNNotification") as? UILocalNotification  else {
            return nil
        }
        guard let alertBody =  aDecoder.decodeObject(forKey: "ABNAlertBody") as? String else {
            return nil
        }
        guard let identifier = aDecoder.decodeObject(forKey: "ABNIdentifier") as? String else {
            return nil
        }
        guard let userInfo = aDecoder.decodeObject(forKey: "ABNUserInfo") as? Dictionary<String, AnyObject> else {
            return nil
        }
        guard let repeats = aDecoder.decodeObject(forKey: "ABNRepeats") as? String else {
            return nil
        }
        guard let soundName = aDecoder.decodeObject(forKey: "ABNSoundName") as? String else {
            return nil
        }
        let alertAction = aDecoder.decodeObject(forKey: "ABNAlertAction") as? String
        self.init(notification: localNotification, alertBody: alertBody, alertAction: alertAction, soundName: soundName, identifier: identifier, repeats: Repeats(rawValue: repeats)!, userInfo: userInfo, scheduled: false)
    }
    @objc open func encode(with aCoder: NSCoder) {
        aCoder.encode(localNotification, forKey: "ABNNotification")
        aCoder.encode(alertBody, forKey: "ABNAlertBody")
        aCoder.encode(alertAction, forKey: "ABNAlertAction")
        aCoder.encode(soundName, forKey: "ABNSoundName")
        aCoder.encode(identifier, forKey: "ABNIdentifier")
        aCoder.encode(repeatInterval.rawValue, forKey: "ABNRepeats")
        aCoder.encode(userInfo, forKey: "ABNUserInfo")
    }
}
public func <(lhs: ABNotification, rhs: ABNotification) -> Bool {
    return lhs.localNotification.fireDate?.compare(rhs.localNotification.fireDate!) == ComparisonResult.orderedAscending
}
public func ==(lhs: ABNotification, rhs: ABNotification) -> Bool {
    return lhs.identifier == rhs.identifier
}
extension Date {
    func nextMinutes(_ minutes: Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.minute = minutes
        return (calendar as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    func nextHours(_ hours: Int) -> Date {
        return self.nextMinutes(hours * 60)
    }
    func nextDays(_ days: Int) -> Date {
        return nextMinutes(days * 60 * 24)
    }
    func removeSeconds() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: components)!
    }
    static func dateWithTime(_ time: Int, offset: Int) -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: Date())
        components.minute = (time % 100) + offset % 60
        components.hour = (time / 100) + (offset / 60)
        var date = calendar.date(from: components)!
        if date < Date() {
            date = date.nextMinutes(60*24)
        }
        return date
    }
}
extension Int {
    var date: Date {
        return Date.dateWithTime(self, offset: 0)
    }
}
