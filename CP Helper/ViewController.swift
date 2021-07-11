//
//  ViewController.swift
//  CP Helper
//
//  Created by Lithium on 11/07/21.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {
    
    @IBOutlet weak var InputDirectoryButton: NSButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        let text = defaults.string(forKey: "input")
        if(text != nil){
            InputDirectoryButton.title = text!
        }
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBAction func selectInputFile(_ sender: NSButton) {
        closePopOver()
        
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose input file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                sender.title = path
                defaults.set(path, forKey: "input")
                showPopOver()
            }
        }
        
    }
    
    @IBAction func selectOutputFile(_ sender: NSButton) {
        closePopOver()
        
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose output file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                sender.title = path
                defaults.set(path, forKey: "output")
                showPopOver()
            }
        }
    }
    
    @IBAction func selectCodeFile(_ sender: NSButton) {
        closePopOver()
        
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose code file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                sender.title = path
                defaults.set(path, forKey: "code")
                showPopOver()
            }
        }
    }

   func showPopOver() {
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
   }
    
    func closePopOver() {
        NotificationCenter.default.post(name: .didCompleteTask, object: nil)
    }
    
    @IBAction func closePopOverButton(_ sender: Any) {
        NotificationCenter.default.post(name: .didCompleteTask, object: nil)
    }
}


//g++ -o compiledcode  /Users/lithium/Desktop/CC/contests/677D3/A.cpp && /Users/lithium/Desktop/CC/contests/677D3/compiledcode < /Users/lithim/Desktop/CC/contests/677D3/input.txt > /Users/lithium/Desktop/CC/contests/677D3/output.txt
//Lithiums-MacBook-Pro:677D3 lithium$
