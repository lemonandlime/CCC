//
//  MainViewModel.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-04.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    
    var dataSource: Dictionary<Int, Array<Episode>> = [ : ]
    
    func numberOfSections() -> Int {
        return dataSource.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return (dataSource[section+1]?.count)!
    }
    
    func titleForSection(section: Int) -> String {
        return String(format: "Season %d", dataSource[section+1]![0].season) ?? "No name WTF!?";
    }
    
    func dataForIndexPath(indexPath: NSIndexPath) -> Episode {
        return dataSource[indexPath.section+1]![indexPath.row]
    }

}
