//
//  ViewController.swift
//  Weather_APP
//
//  Created by 전상민 on 2023/05/10.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    let contentView: UIView = {
        let contentView = UIView(frame: CGRect.zero)
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 테이블 뷰 높이 동적으로 설정
    func setTableViewDynamicHeight(tableView: UITableView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentHeight = tableView.contentSize.height
            tableView.snp.updateConstraints { make in
                make.height.equalTo(contentHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
}
