//
//  TestNotificationCenter.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 16.03.2021.
//

import Foundation

class TestNotificationCenter: NotificationCenter {
    var postedNotificationName: NSNotification.Name?
    var postedNotificationUserInfo: [AnyHashable : Any]?
    
    override func post(_ notification: Notification) {
        postedNotificationName = notification.name
        postedNotificationUserInfo = notification.userInfo
    }
    
    override func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        postedNotificationName = aName
        postedNotificationUserInfo = aUserInfo
    }
}
