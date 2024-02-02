//
//  HomeViewController.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/3.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

class HomeViewController: BaseTableViewController {
    /// 测试数据源
    private var testDataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0 ..< 40 {
            testDataSource.append(String(index))
            
        }
        
        tableView.reloadData()
    }
    
}

// MARK: - 关于TableView ==============================
extension HomeViewController {
    // * 组数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // * 行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testDataSource.count
    }
    
    // * 行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // * cell样式
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = testDataSource[indexPath.row]
        
        return cell
    }
    
    // * cell点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let upHomeViewController = HomeViewController.init(modalAnimationType: .pageIn(direction: .right))
        upHomeViewController.view.backgroundColor = UIColor.flatPink
        
        (self.navigationController as! BaseNaviController).pushViewController(upHomeViewController, animated: true)
    }
    
    
}

// MARK: - 关于Scrollview ==============================
extension HomeViewController {
    /// 记录的纵向滑动偏移量
    static private var ScrollContentOffsetY: CGFloat = 0
    /// 触发纵向滑动偏移量
    static private var TriggerY: CGFloat = 100
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(scrollView.contentOffset.y)
        
        // * 偏移量比记录的大 && 大于等于标准量 -> 向下跳转
        if HomeViewController.ScrollContentOffsetY < scrollView.contentOffset.y
            && scrollView.contentOffset.y >= HomeViewController.TriggerY  {
            HomeViewController.ScrollContentOffsetY = 0
            
            self.dismiss(animated: true, completion: nil)
        }
        
        // * 偏移量比记录的小 && 小于于等于负的标准量 -> 向上跳转
        if HomeViewController.ScrollContentOffsetY > scrollView.contentOffset.y
            && scrollView.contentOffset.y <= -HomeViewController.TriggerY {
            HomeViewController.ScrollContentOffsetY = 0
            
            let upHomeViewController = HomeViewController.init(modalAnimationType: .slide(direction: .down))
            upHomeViewController.view.backgroundColor = UIColor.randomFlat
            
            self.present(upHomeViewController, animated: true, completion: nil)
        }
        
        // * 记录偏移量
        HomeViewController.ScrollContentOffsetY = scrollView.contentOffset.y
        
    }
    
    
}
