//
//  ViewController.swift
//  RxSwiftSample
//
//  Created by shota ito on 15/04/2019.
//  Copyright © 2019 shota ito. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    // pass the user-input values as observable to ViewModel
    private lazy var viewModel = ViewModel(idTextObservable: idTextField.rx.text.asObservable(), passwordTextObservable: passwordTextField.rx.text.asObservable(), model: Model())
    
    private let disposeBag = DisposeBag()
    
    private var loadLabelColor: Binder<UIColor> {
        return Binder(self) {me, color in
            me.validationLabel.textColor = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         binding
         Depending on the result of validationText on VM,
         validationLable on View changes
        */
        viewModel.validationText
        .bind(to: validationLabel.rx.text)
        .disposed(by: disposeBag)
        
        viewModel.loadLabelColor
        .bind(to: loadLabelColor)
        .disposed(by: disposeBag)
        
    }
    
    


}

