//
//  Model.swift
//  RxSwiftSample
//
//  Created by shota ito on 15/04/2019.
//  Copyright © 2019 shota ito. All rights reserved.
//

import RxSwift

enum ModelError: Error {
    case invalidID
    case invalidPassword
    case invalidIDandPassword
}

protocol ModelProtocol {
    func varidate(idText: String?, passwordText: String?) -> Observable<Void>
}

final class Model: ModelProtocol {
    func varidate(idText: String?, passwordText: String?) -> Observable<Void> {
        
        switch (idText, passwordText) {
        case (.none, .none):
            return Observable.error(ModelError.invalidIDandPassword)
        case (.none, .some):
            return Observable.error(ModelError.invalidPassword)
        case (.some, .none):
            return Observable.error(ModelError.invalidID)
        case (let idText?, let passwordText?):
            switch(idText.isEmpty, passwordText.isEmpty){
            case (true, true):
                return Observable.error(ModelError.invalidIDandPassword)
            case (false, false):
                return Observable.just(())
            case (false, true):
                return Observable.error(ModelError.invalidPassword)
            case (true, false):
                return Observable.error(ModelError.invalidID)
            }
            
        }
        
    }
}


