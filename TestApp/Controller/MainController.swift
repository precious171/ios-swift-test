//
//  MainController.swift
//  TestApp
//
//  Created by Precious Osaro on 21/7/18.
//  Copyright © 2018 Precious Osaro. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol maintableDelegate: class {
    func saveupdate(noteValue:noteModel,index:Int,from:Int)
}


class MainController: UIViewController,UITableViewDelegate,UITableViewDataSource,maintableDelegate{
    
//outlet declaration to support view
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteCountLabel: UILabel!
    @IBOutlet weak var moreIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var logoimage: UIImageView!
    
    
    
    //variables required within the controller
    var currentPage:Int = 0
    var NoteList:[noteModel] = []
    var transferNote:noteModel?
    var activeIndex:Int = 0
    var circle = UIView(
        frame: CGRect(x: 0.0, y: 0.0, width: 5, height: 5
    ))
    
    
  //animation detransles
    let translate = CGAffineTransform(translationX: 100, y: 100)
    let scale = CGAffineTransform(scaleX: -0.001, y: -0.001)
    let bigscale = CGAffineTransform(scaleX: 1, y: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        registerCells()
        introanimation()
        fetchdata()
    }
    
    
    func showhint(){
        
            self.performSegue(withIdentifier: "showHint", sender: self)
 
    }
    
    //function to fetch data from movk api while showing a block loading sign
    func fetchdata(){
        self.moreIndicator.isHidden = true
        self.loadingView.startAnimating()
        Mockapiengine.sharedManager.fetchData(page: self.currentPage) { (result) in
            self.NoteList.append(contentsOf: result)
            self.loadingView.stopAnimating()
            self.prepareview()
            self.currentPage += 1
        }
    }
    
    
    //function to fetch data with out showing loading sign
    //this is used to fetch more on arriving at the last cell
    func fetchdatasilent(){
        self.moreIndicator.isHidden = false
        self.moreIndicator.startAnimating()
        Mockapiengine.sharedManager.fetchData(page: self.currentPage) { (result) in
            self.NoteList.append(contentsOf: result)
            self.prepareview()
            self.moreIndicator.stopAnimating()
            self.moreIndicator.isHidden = true
            self.currentPage += 1
        }
    }
    
    //prepare view for note count
    func prepareview(){
        noteCountLabel.text = "\(self.NoteList.count) Notes"
        self.tableView.reloadData()
    }
    
    //animation details
    func introanimation(){
        self.circle = UIView(
            frame: CGRect(x: 0.0, y: 0.0, width: (mainview.bounds.height * 3), height: (mainview.bounds.height * 3)
        ))
        
        circle.center = CGPoint(x: 0, y: 0);
        circle.backgroundColor = mainview.backgroundColor
        circle.layer.cornerRadius = (mainview.bounds.height * 1.5)
        mainview.addSubview(circle)
        mainview.bringSubview(toFront:logoimage)
        
        UIView.animate(withDuration: 1.5, delay: 1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.circle.transform = self.scale
            self.mainview.backgroundColor = UIColor.white
            self.logoimage.alpha = 0.1
        }, completion: { finished in
            self.logoimage.isHidden = true
            self.circle.isHidden = true
            self.mainview.willRemoveSubview(self.circle)
            self.mainview.willRemoveSubview(self.logoimage)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.showhint()
            
        })
    }
    
    //registration of cells required by table
    func registerCells(){
        let nib = UINib(nibName: "NoteTableCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NoteTableCell")
    }
    
  

    
    //function implementation to update note
    func saveupdate(noteValue: noteModel,index:Int,from:Int) {
        if(from == 0){
            if(index < self.NoteList.count){
                self.NoteList.remove(at: index)
            }
            
            self.NoteList.insert(noteValue, at: 0)
            self.tableView.reloadData()
            self.prepareview()
        }
        
    }
    
    
   //implementation of addition of new note
    @IBAction func ComposeNewNote(_ sender: Any) {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let date_value = df.string(from: Date())
        let intergervalue =  Mockapiengine.sharedManager.dataHold.count
        
        let newNote:noteModel = noteModel(id: (intergervalue+1), date_created: date_value, last_modified: date_value, title: "Unsaved \(intergervalue+1)", detail: "")
        
        self.activeIndex = intergervalue
        self.transferNote = newNote
        
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            // delete item at indexPath
            
            CATransaction.begin()
            tableView.beginUpdates()
            CATransaction.setCompletionBlock {
                
               
                self.prepareview()
                self.tableView.reloadData()
                // Code to be executed upon completion
            }
            
            self.NoteList.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .left)
            
            
            tableView.endUpdates()
            CATransaction.commit()
            
        }
        delete.backgroundColor =  hexStringToUIColor(hex: "#fd7222")
        
        return [delete]
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.NoteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableCell", for: indexPath) as! NoteTableCell
        cell.initView(celldata: self.NoteList[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            fetchdatasilent()
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.transferNote = self.NoteList[indexPath.row]
        self.activeIndex = indexPath.row
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: false)
        }
    }
    
    
    //preparation of seque for tabke
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? NoteViewController {
            
            destinationViewController.Data = self.transferNote
            destinationViewController.index = self.activeIndex
            destinationViewController.fromCont = 0
            destinationViewController.delegate = self
        }
        
    }
}
