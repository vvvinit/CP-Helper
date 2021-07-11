//
//  AppDelegate.swift
//  CP Helper
//
//  Created by Lithium on 11/07/21.
//

import Cocoa

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
            static let didCompleteTask = Notification.Name("didCompleteTask")
//            static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popOverView = NSPopover()
    var eventMonitor: EventMonitor?
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPopover(_:)), name: .didReceiveData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closePopover(_:)), name: .didCompleteTask, object: nil)
        
        if let button = statusItem.button {
                    statusItem.button?.title = "λCP"
                    button.action = #selector(AppDelegate.togglePopover(_:))
                }
                
                let mainViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ViewController") as! ViewController
                
            popOverView.contentViewController = mainViewController
                
                eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
                    if self.popOverView.isShown {
                        self.closePopover(event)
                    }
                }
                eventMonitor?.start()
        
        


        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
  
    
    
    @objc func onDidCompleteTask() {
        popOverView.close()
    }
    
    
    @objc func togglePopover(_ sender: AnyObject?) {
            if popOverView.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        }
        
    @objc func showPopover(_ sender: AnyObject?) {
        if popOverView.isShown {
            
        } else {
            if let button = statusItem.button {
                NSRunningApplication.current.activate(options: [.activateIgnoringOtherApps])
                popOverView.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
            eventMonitor?.start()
        }
            
        }
        
    @objc func closePopover(_ sender: AnyObject?) {
        if popOverView.isShown {
            popOverView.performClose(sender)
            eventMonitor?.stop()
        }
    }
}

