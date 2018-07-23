//
//  SearchController.swift
//  TestApp
//
//  Created by Precious Osaro on 23/7/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//



import UIKit

class SearchController: UITableViewController,UISearchBarDelegate,maintableDelegate {
    
    
    
    var filteredModels:[Notes] = []
    var activeIndex:Int  = 0
    var transferNote:noteModel?
    var delegate:maintableDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        registerCells()
        
        
        let searchBar:UISearchBar = UISearchBar(frame: CGRect(x:0.0,y:0.0, width:(self.view.bounds.width + 400),height:1.0))
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: hexStringToUIColor(hex: "#ffffff")]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.title = ""
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = hexStringToUIColor(hex: "#ffffff")
        
        self.navigationItem.backBarButtonItem?.title = ""
       
        
        self.navigationItem.hidesBackButton = true
        if let txfSearchField = searchBar.value(forKey: "searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.backgroundColor = hexStringToUIColor(hex: "#ececec")
            txfSearchField.font = UIFont(name: "OpenSans-Regular", size: 13.0)
            txfSearchField.addTarget(self, action: #selector(startedendting), for: UIControlEvents.editingChanged)
        }
        
        
        
        searchBar.placeholder = "Search Notes"
        searchBar.isUserInteractionEnabled = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "OpenSans-Regular", size: 13.0)
        
        
        
        
        searchBar.searchBarStyle = UISearchBarStyle.default;
        searchBar.showsCancelButton = true
        (searchBar.value(forKey: "cancelButton") as! UIButton).titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 12.0)
        searchBar.becomeFirstResponder()
        (searchBar.value(forKey: "cancelButton") as! UIButton).addTarget(self, action: #selector(cancelclicked), for: UIControlEvents.touchDown)
        searchBar.tintColor =  hexStringToUIColor(hex: "#fc9d12")
        searchBar.barTintColor = hexStringToUIColor(hex: "#ffffff")
        
        
        
        
        searchBar.delegate = self
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        navigationItem.titleView = searchBar
        
        
        
    }
    
    
   
    
    
    func saveupdate(noteValue: noteModel,index:Int,from:Int) {
        if(from == 1){
            
            let updateNote = self.filteredModels[self.activeIndex]
            updateNote.title = noteValue.title
            updateNote.detail = noteValue.detail
            updateNote.last_modified = Date()
            DatabaseHelper.sharedManager.updateData(noteData: updateNote) { (result) in
                if(result){
                    self.delegate?.reloadrequest()
                    self.filteredModels[self.activeIndex] = updateNote
                    self.tableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    
    @objc func  startedendting(_ textView: UITextField){
        
        filterRowsForSearchedText(textView.text!)
    }
    @objc func cancelclicked(){
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    func filterRowsForSearchedText(_ searchText: String) {
        DatabaseHelper.sharedManager.searchata(searchValue: searchText) { (result) in
          self.filteredModels = result
            self.tableView.reloadData()
        }
    }
    
    
    
    
    @objc override func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reloadrequest() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredModels.count
    }
    
    
    func registerCells(){
        let nib = UINib(nibName: "NoteTableCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NoteTableCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableCell", for: indexPath) as! NoteTableCell
       cell.initView(celldata: self.filteredModels[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteElement = self.filteredModels[indexPath.row]
        self.transferNote = noteModel(id: Int(noteElement.id), date_created: "", last_modified: "", title: noteElement.title!, detail: noteElement.detail!)
        self.activeIndex = indexPath.row
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destinationViewController = segue.destination as? NoteViewController {
            
            destinationViewController.Data = self.transferNote
            destinationViewController.index = self.activeIndex
            destinationViewController.fromCont = 1
            destinationViewController.delegate = self
            
        }
        
    }
    
}
