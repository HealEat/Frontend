//
//  WriteReviewViewController.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.14.
//

import UIKit

class WriteReviewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = writeReviewView
    }
    
    private lazy var writeReviewView: WriteReviewView = {
        let view = WriteReviewView()
        return view
    }()
    
}
