//
//  MainViewModel.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-04.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    
    private var dataSource: [Season] = []
    
    private var lastcontentUpdate: NSDate?
    
    func updateContent(newContent: [Season], lastUpdated: NSDate) -> Bool {
        print("Checking if data should be refreshed")
        if let viewModelUpdated = lastcontentUpdate where NSCalendar.currentCalendar().isDate(
            viewModelUpdated,
            equalToDate: lastUpdated,
            toUnitGranularity: .Hour) {
                print("Data does not need to refresh")
                return false
        }
        
        self.lastcontentUpdate = lastUpdated
        self.dataSource = newContent
        print("Data needs refresh")
        return true
    }
    
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
        return dataSource[indexPath.section].episodes[indexPath.row]
    }

}
