//
//  ColordleApp.swift
//  Colordle
//
//  Created by Riley Koo on 5/16/26.
//

import SwiftUI
import NotificationLog

@main
struct ColordleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .notificationLog(config: NotificationLogConfig(
                    supabaseURL: Constants.supabaseAnonKey,
                    supabaseAnonKey: Constants.supabaseAnonKey,
                    appID: Constants.appID
                ))
        }
    }
}
