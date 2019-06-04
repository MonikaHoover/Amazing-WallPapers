 import UIKit
 import CoreData
 let appKey = "3f7c5034a8192e9af9769913"
 let channel = "Publish channel"
 let isProduction = true
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate,JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
    }
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
    }
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("get the deviceToken  \(deviceToken)")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    var window: UIWindow?
    static var share = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    var reachability: Reachability! = {
        guard let reachability = Reachability(hostname: "google.com") else {
            return nil
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        return reachability
    }()
    @objc func reachabilityChanged() {
        switch reachability.connection {
        case .none:
            showAlertToOpenSetting(title: "Cellular Data is Turned Off", message: "Turn on cellular data and allow app to access or use Wi-Fi to access data.")
        case .wifi:
            break
        case .cellular:
            break
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
            NSInteger(UNAuthorizationOptions.sound.rawValue) |
            NSInteger(UNAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel: channel, apsForProduction: isProduction)
        _ = NotificationCenter.default
        window = UIWindow(frame: UIScreen.main.bounds)
        let s = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainWallPapersID") as! MainWallPapersViewController
        window?.rootViewController = s
        window?.makeKeyAndVisible()
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        reachabilityChanged()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        AppDelegate.saveContext()
    }
    @available(iOS 10.0, *)
    static var context: NSManagedObjectContext {
        return AppDelegate.persistentContainer.viewContext
    }
    @available(iOS 10.0, *)
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    static func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                print("save successful")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    static func deleteContext(object:NSManagedObject){
        context.delete(object)
        print("delete successful")
        do {
            try context.save()
            print("save successful")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
 }
