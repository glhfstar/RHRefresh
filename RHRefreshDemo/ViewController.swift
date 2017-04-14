//
//  ViewController.swift
//  RHRefresh
//
//  Created by xieruihua on 17/4/12.
//  Copyright © 2017年 xieruihua. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var number = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RHRefresh"
        self.edgesForExtendedLayout = []
        tableView.separatorStyle = .singleLine
        
        let footer = RHRefreshFooter(refreshScrollView: tableView)
        footer.refreshHandler = {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                self.number = self.number + 20
                self.tableView.reloadData()
                footer.endRefresh()
                
                if self.number > 59 {
                    footer.hasMoreData = false
                }
            }
        }
        
        let header = RHRefreshHeader(refreshScrollView: tableView)
        header.refreshHandler = {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                self.number = 20
                self.tableView.reloadData()
                header.endRefresh()
                
                footer.hasMoreData = true
            }
        }
        header.beginRefresh()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel!.text = "第\(indexPath.row + 1)个"
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

