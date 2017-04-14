//
//  RHRefreshHeader.swift
//  RHRefresh
//
//  Created by xieruihua on 17/4/12.
//  Copyright © 2017年 xieruihua. All rights reserved.
//

import UIKit

class RHRefreshHeader: NSObject {
    
    var refreshLoadingTitle = "刷新数据中..."
    var refreshPulldownTitle = "下拉可以刷新"
    var refreshReleaseTitle = "松开可以刷新"
    
    var refreshHandler:((Void)->(Void))!
    
    private var scrollView:UIScrollView!
    
    private var headerView:UIView!
    private var headerTitle:UILabel!
    private var headerImage:UIImageView!
    private var loadingView:UIActivityIndicatorView!
    
    private let headerHeight = 35
    private var isRefreshing = false
    
    init(refreshScrollView:UIScrollView) {
        super.init()
        scrollView = refreshScrollView
        headerInit()
    }
    
    private func headerInit() {
        let scrollWidth = scrollView.frame.size.width
        let labelWidth = 120
        let labelHeight = headerHeight
        let imageWidth = 15
        let imageHeight = headerHeight
        
        headerView = UIView(frame: CGRect(x: 0, y: -headerHeight, width: Int(scrollWidth), height: headerHeight))
        scrollView.addSubview(headerView)
        
        headerTitle = UILabel(frame: CGRect(x: (Int(scrollWidth) - labelWidth) / 2, y: 0, width: labelWidth, height: labelHeight))
        headerTitle.textAlignment = .center
        headerTitle.font = UIFont.systemFont(ofSize: 14)
        headerTitle.text = refreshPulldownTitle
        headerView.addSubview(headerTitle)
        
        headerImage = UIImageView(frame: CGRect(x: (Int(scrollWidth) - labelWidth) / 2 - imageWidth, y: 0, width: imageWidth, height: imageHeight))
        headerImage.image = UIImage(named: "arrow")
        headerImage.isHidden = false
        headerView.addSubview(headerImage)
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.frame = CGRect(x: (Int(scrollWidth) - labelWidth) / 2 - imageWidth, y: 0, width: imageWidth, height: imageHeight)
        loadingView.isHidden = true
        headerView.addSubview(loadingView)
        
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if "contentOffset" != keyPath {
            return
        }
        
        if scrollView.isDragging && !isRefreshing{
            let currentPostionY = scrollView.contentOffset.y
            UIView.animate(withDuration: 0.3, animations: {
                if currentPostionY < -CGFloat(self.headerHeight*3/2) {
                    self.headerTitle.text = self.refreshReleaseTitle
                    self.headerImage.transform = CGAffineTransform(rotationAngle: .pi)
                }
                else {
                    self.headerTitle.text = self.refreshPulldownTitle
                    self.headerImage.transform = CGAffineTransform(rotationAngle: .pi*2)
                }
            })
        }
        else {
            if headerTitle.text == refreshReleaseTitle {
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                beginRefresh()
            }
        }
    }
    
    func beginRefresh() {
        if !isRefreshing {
            isRefreshing = true
            headerTitle.text = refreshLoadingTitle
            headerImage.isHidden = true
            loadingView.isHidden = false
            loadingView.startAnimating()
            
            UIView.animate(withDuration: 0.3, animations: { 
                let offsetY = self.scrollView.contentOffset.y
                if offsetY > -CGFloat(self.headerHeight*3/2) {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: offsetY - CGFloat(self.headerHeight*3/2))
                }
                self.scrollView.contentInset = UIEdgeInsetsMake(CGFloat(self.headerHeight*3/2), 0, 0, 0)
            })
            
            refreshHandler()
        }
    }
    
    func endRefresh() {
        isRefreshing = false
        
        self.headerTitle.text = self.refreshPulldownTitle
        self.headerImage.isHidden = false
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
        
        UIView.animate(withDuration: 0.3) { 
            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentOffset.y + CGFloat(self.headerHeight*3/2))
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            self.headerImage.transform = CGAffineTransform(rotationAngle: .pi*2)
        }
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
}
