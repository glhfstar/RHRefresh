//
//  RHRefreshFooter.swift
//  RHRefresh
//
//  Created by xieruihua on 17/4/12.
//  Copyright © 2017年 xieruihua. All rights reserved.
//

import UIKit

class RHRefreshFooter: NSObject {
    
    var refreshHandler:((Void)->(Void))!
    
    var hasMoreData = true
    var noDataTitle = "没有更多数据了" {
        didSet {
            if noDataLabel != nil {
                noDataLabel.text = noDataTitle
            }
        }
    }
    
    private var scrollView:UIScrollView!
    private var loadingView:UIActivityIndicatorView!
    private var noDataLabel:UILabel!
    
    private let footerHeight = 35
    private var scrollWidth:CGFloat!
    private var scrollHeight:CGFloat!
    private var isRefreshing = false
    
    init(refreshScrollView:UIScrollView) {
        super.init()
        scrollView = refreshScrollView
        footerInit()
    }
    
    private func footerInit() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.frame = CGRect(x: (Int(scrollWidth) - footerHeight) / 2, y: Int(scrollView.contentSize.height), width: footerHeight, height: footerHeight)
        scrollView.addSubview(loadingView)
        
        noDataLabel = UILabel(frame: CGRect(x: 0, y: Int(scrollView.contentSize.height), width: Int(scrollWidth), height: footerHeight))
        noDataLabel.text = noDataTitle
        noDataLabel.textAlignment = .center
        noDataLabel.isHidden = hasMoreData
        scrollView.addSubview(noDataLabel)
        
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if "contentSize" == keyPath {
            let contentHeight = scrollView.contentSize.height
            if hasMoreData {
                loadingView.frame = CGRect(x: (Int(scrollWidth) - footerHeight) / 2, y: Int(contentHeight), width: footerHeight, height: footerHeight)
            }
            else {
                noDataLabel.frame = CGRect(x: 0, y: Int(contentHeight), width: Int(scrollWidth), height: footerHeight)
            }
        }
        else if "contentOffset" == keyPath {
            noDataLabel.isHidden = true
            
            let contentHeight = scrollView.contentSize.height
            let currentPostionY = scrollView.contentOffset.y
            if currentPostionY == 0 {
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
            else if currentPostionY > (contentHeight - scrollHeight) && contentHeight > scrollHeight{
                if hasMoreData {
                    beginRefresh()
                }
                else if noDataTitle != ""{
                    noDataLabel.isHidden = false
                    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGFloat(self.footerHeight), 0)
                }
            }
        }
    }
    
    func beginRefresh() {
        if !isRefreshing {
            isRefreshing = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.loadingView.startAnimating()
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGFloat(self.footerHeight), 0)
            })
            
            refreshHandler()
        }
    }
    
    func endRefresh() {
        isRefreshing = false
        
        UIView.animate(withDuration: 0.3) {
            self.loadingView.stopAnimating()
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
}
