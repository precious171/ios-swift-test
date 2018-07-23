//
//  Noteviewcontroller.swift
//  TestApp
//
//  Created by Precious Osaro on 21/7/18.
//  Copyright © 2018 Precious Osaro. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    //required outlets for visual components
    
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var detailView: UITextView!
    var Data:noteModel?
    var index:Int?
    var fromCont:Int?
    var actionType:Int?
    var delegate:maintableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.delegate = self
        
        if(self.index! > Mockapiengine.sharedManager.dataHold.count){
            detailView.becomeFirstResponder()
        }
        prepareview()
    }
    
    
    @objc func rightButtonAction(){
        detailView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
        self.Data?.detail = self.detailView.text
        
        
        if let firstParagraph = self.detailView.text.components(separatedBy: CharacterSet.newlines).first {
            self.Data?.title = firstParagraph
            self.navigationItem.title = firstParagraph
        }
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        self.Data?.last_modified = df.string(from: Date())
       self.delegate?.saveupdate(noteValue: Data!, index: self.index!,from:self.fromCont!)
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        let rightButtonItem = UIBarButtonItem.init(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(rightButtonAction)
        )
        
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    
    func prepareview(){
        self.navigationItem.title = Data?.title
        self.detailView.text = Data?.detail
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //registering for keyboard apperance
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        if(self.fromCont == 1){
            detailView.becomeFirstResponder()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomContraint.constant += (keyboardSize.height + 40)
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomContraint.constant -= (keyboardSize.height + 40)
            
        }
    }
    
    
}

