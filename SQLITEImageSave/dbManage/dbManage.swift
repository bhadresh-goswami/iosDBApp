//
//  dbManage.swift
//  SQLITEImageSave
//
//  Created by COE-18 on 03/01/20.
//  Copyright © 2020 bSquareG. All rights reserved.
//

import UIKit

class dbManage: NSObject {

    private var dbPath = ""
    var db:OpaquePointer?
    override init() {
        super.init()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.dbPath = appDel.dbLocation
    }

    func IsDatabaseOpen() -> Bool {
        
        if sqlite3_open(self.dbPath, &db) == SQLITE_OK
        {
            return true
        }
        
        return false
    }
    
    func RunCommand(cmd:String) -> Bool {
        var isDone = true
        
        var stmt:OpaquePointer?
        
        if(IsDatabaseOpen())
        {
            if sqlite3_prepare_v2(db, cmd, -1, &stmt, nil) == SQLITE_OK{
                
                if sqlite3_step(stmt) == SQLITE_DONE{
                    sqlite3_finalize(stmt)
                }
                else{
                    isDone = false
                }
                
                
                
            }
            sqlite3_close(db)
        }
        else{
            isDone = false
        }
        
        return isDone
        
    }
    
    
    func RunQuery(query:String) -> [[String:Any]] {
        var data = [[String:Any]]()
        
        var stmt:OpaquePointer?
        
        if(IsDatabaseOpen())
        {
            if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK{
                
                while sqlite3_step(stmt) == SQLITE_ROW{
                    //find number of col
                    
                    let colCount = sqlite3_column_count(stmt)
                    
                    var row = [String:Any]()
                    for i in 0..<colCount{
                        
                        let colName = String.init(cString: sqlite3_column_name(stmt, i))
                        let colText = String.init(cString: sqlite3_column_text(stmt, i))
                        
                        row[colName] = colText
                    }
                    data.append(row)
                    
                }
                
                sqlite3_finalize(stmt)
            }
            sqlite3_close(db)
        }
        else{
            
        }
        
        return data
        
    }
    
}
