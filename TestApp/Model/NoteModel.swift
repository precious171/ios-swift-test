//

//  alaya test
//
//  Created by Precious Osato  on 22/7/18.
//  Copyright © 2018 Precious Osaro . All rights reserved.
//
import Foundation
struct noteModel:Codable {
    let id : Int?
    let  date_created : String?
    var last_modified : String?
    var title : String?
    var detail : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case date_created = "date_created"
        case last_modified = "last_modified"
        case title = "title"
        case detail = "detail"
    }
    
    init(id:Int,date_created:String,last_modified:String,title:String,detail:String){
        self.id = id
        self.date_created = date_created
        self.last_modified = last_modified
        self.title = title
        self.detail = detail
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        date_created = try values.decodeIfPresent(String.self, forKey: .date_created)
        last_modified = try values.decodeIfPresent(String.self, forKey: .last_modified)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        detail = try values.decodeIfPresent(String.self, forKey: .detail)
    }
    
}
