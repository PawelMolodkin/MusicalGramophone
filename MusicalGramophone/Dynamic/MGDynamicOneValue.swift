//
//  Dynamic.swift
//  MusicalGramophone
//
//  Created by Pavel Molodkin on 24/08/2019.
//

import Foundation

class MGDynamicOneValuess<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        value = v
    }
}
