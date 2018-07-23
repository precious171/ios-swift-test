//
//  MainController.swift
//  alayaTest
//
//  Created by gHOST on 21/7/18.
//  Copyright © 2018 gHOST. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol maintableDelegate: class {
    func saveupdate(noteValue:noteData,index:Int,from:Int)
}


class MainController: UIViewController,UITableViewDelegate,UITableViewDataSource,maintableDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noteCountLabel: UILabel!
    
    @IBOutlet weak var moreIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var logoimage: UIImageView!
    var currentPage:Int = 0
    var NoteList:[noteData] = []
    var transferNote:noteData?
    var activeIndex:Int = 0
    var circle = UIView(
        frame: CGRect(x: 0.0, y: 0.0, width: 5, height: 5
    ))
    
    
    
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
    
    
    func fetchdata(){
        self.moreIndicator.isHidden = true
        self.loadingView.startAnimating()
        WebRequest.sharedManager.fetchData(page: self.currentPage) { (result) in
            self.NoteList.append(contentsOf: result)
            self.loadingView.stopAnimating()
            self.prepareview()
            self.currentPage += 1
        }
    }
    
    func fetchdatasilent(){
        self.moreIndicator.isHidden = false
        self.moreIndicator.startAnimating()
        WebRequest.sharedManager.fetchData(page: self.currentPage) { (result) in
            self.NoteList.append(contentsOf: result)
            self.prepareview()
            self.moreIndicator.stopAnimating()
            self.moreIndicator.isHidden = true
            self.currentPage += 1
        }
    }
    
    func prepareview(){
        noteCountLabel.text = "\(self.NoteList.count) Notes"
        self.tableView.reloadData()
    }
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
            
        })
    }
    func registerCells(){
        let nib = UINib(nibName: "NoteTableCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NoteTableCell")
    }
    
    
    func saveupdate(noteValue: noteData,index:Int,from:Int) {
        if(from == 0){
            if(index < self.NoteList.count){
                self.NoteList.remove(at: index)
            }
            
            self.NoteList.insert(noteValue, at: 0)
            self.tableView.reloadData()
        }
        
    }
    
    
    @IBAction func ComposeNewNote(_ sender: Any) {
        
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let date_value = df.string(from: Date())
        let intergervalue = WebRequest.sharedManager.dataHold.count
        
        let newNote:noteData = noteData(id: (intergervalue+1), date_created: date_value, last_modified: date_value, title: "Unsaved \(intergervalue+1)", detail: "")
        
        self.activeIndex = intergervalue
        self.transferNote = newNote
        
        self.performSegue(withIdentifier: "showDetail", sender: self)
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destinationViewController = segue.destination as? ViewController {
            
            destinationViewController.Data = self.transferNote
            destinationViewController.index = self.activeIndex
            destinationViewController.fromCont = 0
            destinationViewController.delegate = self
            
        }
        
    }
}
