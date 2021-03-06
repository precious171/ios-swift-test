//
//  NoteTableCell.swift
//  alayaTest
//
//  Created by Precious Osaro on 21/7/18.
//  Copyright © 2018 Precious Osaro. All rights reserved.
//

import UIKit

class NoteTableCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func initView(celldata:Notes){
        
        
        
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "EEE, MMM d, yyyy h:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let dateStamp = dateFormatter.string(from: celldata.last_modified!)
        self.dateLabel.text = dateStamp
        
        
        titleLabel.text = celldata.title
        detailLabel.text = celldata.detail
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
