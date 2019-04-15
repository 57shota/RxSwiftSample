//
//  ViewModel.swift
//  RxSwiftSample
//
//  Created by shota ito on 15/04/2019.
//  Copyright © 2019 shota ito. All rights reserved.
//

import UIKit
import RxSwift


final class ViewModel {
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>
    
    init(idTextObservable: Observable<String?>, passwordTextObservable: Observable<String?>, model: ModelProtocol) {
        
        // observe event create
        let event = Observable
            .combineLatest(idTextObservable, passwordTextObservable)
            .skip(1)
            .flatMap { idText, passwordText -> Observable<Event<Void>> in
                
                return model
                    .varidate(idText: idText, passwordText: passwordText)
                    .materialize()
        }
        .share()
        
        // validate input text and return String or result
        self.validationText = event
            .flatMap { event -> Observable<String> in
                switch event {
                case .next:
                    return .just("OK")
                case let .error(error as ModelError):
                    return .just(error.errorText)
                case .error, .completed:
                    return .empty()
                }
            }
            .startWith("Enter ID and Password")
        
        // change colour
        self.loadLabelColor = event
            .flatMap { event -> Observable<UIColor> in
                switch event {
                case .next:
                    return .just(.green)
                case .error(_):
                    return .just(.red)
                case .completed:
                    return .empty()
                }
        }
    }
}

extension ModelError {
    fileprivate var errorText: String {
        switch self {
        case .invalidID:
            return "ID is brank."
        case .invalidPassword:
            return "Password is brank."
        case .invalidIDandPassword:
            return "ID and Password are brank."
        }
    }
}
