//
//  UserNotificationsService.swift
//  SlowDown!
//
//  Created by Daniel Meneses on 8/9/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationService: NSObject {
    
    private override init() { }
    static let shared = UserNotificationService()
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        userNotificationCenter.requestAuthorization(options: options) { (isGranted, error) in
            if let error = error {
                print("An error ocurred while trying to request notification authorization, error message: ", error.localizedDescription)
                return
            }
            guard isGranted else {
                print("USER DENIED")
                return
            }
            self.configure()
        }
    }
    
    func configure() {
        userNotificationCenter.delegate = self
    }
    
    //REQUIRIENDO EL PERMISO DEL USUARIO PARA NOTIFICACIONES
    func registerForPushNotifications() {
        userNotificationCenter
            .requestAuthorization(options: [.alert, .sound]) { // declaramos el tipo de notificaciones que se utilizaran
                [weak self] granted, error in
                guard granted else { return }
                self?.getNotificationSettings()
                print("Permission granted: \(granted)") // 3
        }
    }

    //accediendo a la configuración actual del usuario sobre los permisos de nuestra applicación
    func getNotificationSettings() {
        userNotificationCenter.getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { print (" no se han autorizado las notificaciones por el usuario! ")
                return
            }
        }
    }
    
    func defaultNotificationRequest(id: String, title:String, body:String, sound: UNNotificationSound, trigger: UNNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        let request = UNNotificationRequest(identifier: "userNotification.fotocivica." + id, content: content, trigger: trigger)
        userNotificationCenter.add(request, withCompletionHandler: nil)
    }
    
    func removeNotification(identifier: String) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["userNotification.category.date." + identifier])
    }
    
}

extension UserNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
