//
//  IntentHandler.swift
//  macOSIntent
//
//  Created by Robin Kment on 2/6/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
        
    
}

extension IntentHandler: FavoriteSmoothieIntentHandling {
    func resolveSmoothie(for intent: FavoriteSmoothieIntent, with completion: @escaping (SmoothieTypeResolutionResult) -> Void) {
        let type = SmoothieType(identifier: "", display: "sdf")

        completion(
            .success(with: type)
        )
    }
  
    func provideSmoothieOptionsCollection(for intent: FavoriteSmoothieIntent, with completion: @escaping (INObjectCollection<SmoothieType>?, Error?) -> Void) {
        print("Here")

        let smoothies = Smoothie.all.map { smoothie in
            SmoothieType(identifier: smoothie.id, display: smoothie.title)
        }

        let collection = INObjectCollection(items: smoothies)
        completion(collection, nil)
    }
    
    func defaultSmoothie(for intent: FavoriteSmoothieIntent) -> SmoothieType? {
        print("Here")
        guard let smoothie = Smoothie.all.first else {
            return nil
        }

        return SmoothieType(identifier: smoothie.id, display: smoothie.title)
    }
}
