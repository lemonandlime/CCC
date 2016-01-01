//
//  MainViewModel.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-04.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    
    var dataSource: [Season] = []
    
    func numberOfSections() -> Int {
        return dataSource.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return dataSource[section].episodes.count
    }
    
    func titleForSection(section: Int) -> String {
        return dataSource[section].name
    }
    
    func dataForIndexPath(indexPath: NSIndexPath) -> Episode {
        print("section", indexPath.section)
        print("row", indexPath.row)
        return dataSource[indexPath.section].episodes[indexPath.row]
    }

}
