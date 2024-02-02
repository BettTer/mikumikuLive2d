//
//  TestInputViewController.swift
//  MikuMiku2.0
//
//  Created by XYoung on 2019/4/8.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit

class TestInputViewController: UIViewController {
    private let keyboardView = MusicKeyboardView.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(keyboardView)
        AboutAK.init()
    }

}
