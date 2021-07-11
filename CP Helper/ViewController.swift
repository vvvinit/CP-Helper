//
//  ViewController.swift
//  CP Helper
//
//  Created by Lithium on 11/07/21.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {
    
    @IBOutlet weak var InputFileButton: NSButton!
    @IBOutlet weak var OutputFileButton: NSButton!
    @IBOutlet weak var CodeFileButton: NSButton!
    @IBOutlet weak var CompilerDirection: NSTextField!
    @IBOutlet weak var DialogBox: NSSwitch!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        InputFileButton.title = "Click to select input file"
        let InputFilePath = defaults.string(forKey: "input")
        if(InputFilePath != nil){
            InputFileButton.title = InputFilePath!
        }
        
        OutputFileButton.title = "Click to select output file"
        let OutputFilePath = defaults.string(forKey: "output")
        if(OutputFilePath != nil){
            OutputFileButton.title = OutputFilePath!
        }
        
        CodeFileButton.title = "Click to select code file"
        let CodeFilePath = defaults.string(forKey: "code")
        if(CodeFilePath != nil){
            CodeFileButton.title = CodeFilePath!
        }
        
        CompilerDirection.stringValue = "g++"
        let CompilerInstruction = defaults.string(forKey: "compile")
        if(CompilerInstruction != nil){
            CompilerDirection.stringValue = CompilerInstruction!
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
    
    @IBAction func EditCompilerInstruction(_ sender: Any) {
        closePopOver()
        promptForReply("Add custom compiler instruction below (You can add compilation flags as well)", "e.g g++, clang++", vc: self, completion: {(strCommitMsg:String, bResponse:Bool) in
            showPopOver()
            if bResponse {
                CompilerDirection.stringValue = strCommitMsg
                defaults.set(strCommitMsg, forKey: "compile")
            }
        })
        
    }
    @IBAction func ResetAppData(_ sender: Any) {
        InputFileButton.title = "Click to select input file"
        defaults.set("Click to select input file", forKey: "input")
        OutputFileButton.title = "Click to select output file"
        defaults.set("Click to select output file", forKey: "output")
        CodeFileButton.title = "Click to select code file"
        defaults.set("Click to select code file", forKey: "code")
        CompilerDirection.stringValue = "g++"
        defaults.set("g++", forKey: "compile")
    }
    
    typealias promptResponseClosure = (_ strResponse:String, _ bResponse:Bool) -> Void
    
    func promptForReply(_ strMsg:String, _ strInformative:String, vc:ViewController, completion:promptResponseClosure) {

            let alert: NSAlert = NSAlert()

            alert.addButton(withTitle: "OK")      // 1st button
            alert.addButton(withTitle: "Cancel")  // 2nd button
            alert.messageText = strMsg
            alert.informativeText = strInformative

            let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
            txt.stringValue = ""

            alert.accessoryView = txt
            let response: NSApplication.ModalResponse = alert.runModal()

            var bResponse = false
            if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
                bResponse = true
            }

            completion(txt.stringValue, bResponse)

        }
    
    @IBAction func CompileCode(_ sender: NSButton) {
        
        var str = CodeFileButton.stringValue

////        for (index, char) in str.enumerated().reversed() {
////            if char=="\\" {
////
////            }
////        }
//        print (str[str.index(str.startIndex,offsetBy: 3)..<str.index(before: str.endIndex)] )
    
        let command = CompilerDirection.stringValue + " -o compiledcode " + CodeFileButton.title + " && " + "./compiledcode" + " < " + InputFileButton.title + " > " + OutputFileButton.title
        
        if(DialogBox.intValue==Optional(1)){
            closePopOver()
            dialogOKCancel(question: "O/P", text: shell(command));
        }
        else {
            shell(command)
        }
       
        
//        print(command)
    }
    
    func shell(_ command: String) -> String {
        
//        let task:NSTask = NSTask()
//        task.launchPath = "/usr/bin/ibtool"
//        task.arguments = ["--compile", modifiedPath, modifiedPath]
       
              
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    func dialogOKCancel(question: String, text: String){
        let alert = NSAlert()
        alert.accessoryView = NSView.init(frame: NSMakeRect(0, 0, 500, 0))
    
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Close")
        alert.runModal()
        showPopOver()
    }

    
}


//g++ -o compiledcode  /Users/lithium/Desktop/CC/contests/677D3/A.cpp && /Users/lithium/Desktop/CC/contests/677D3/compiledcode < /Users/lithim/Desktop/CC/contests/677D3/input.txt > /Users/lithium/Desktop/CC/contests/677D3/output.txt
//Lithiums-MacBook-Pro:677D3 lithium$
