//
//  BlanketWidgetExtensionBundle.swift
//  BlanketWidgetExtension
//
//  Created by Minas Giannekas on 8/4/26.
//

import WidgetKit
import SwiftUI

@main
struct BlanketWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        BlanketWidgetExtension()
        BlanketLockScreenWidget()
        BlanketWidgetExtensionControl()
        BlanketWidgetExtensionLiveActivity()
    }
}
