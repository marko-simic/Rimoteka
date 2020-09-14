//
//  rezultatPretrage.swift
//  Rimalator
//
//  Created by Marko Simic on 14/04/16.
//  Copyright © 2016 Marko Simic. All rights reserved.
//

import UIKit

class rezultatPretrage: NSObject {
    var sections:[String] = []
    var items:[[String]] = []
    
    func addSection(_ section:String,item:[String]){
        sections = sections + [section]
        items = items + [item]
    }
    
    func removeAll(){
        sections=[]
        items=[]
    }
}

