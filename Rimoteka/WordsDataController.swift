//
//  WordsDataController.swift
//  Rimalator
//
//  Created by Marko Simic on 13/03/16.
//  Copyright © 2016 Marko Simic. All rights reserved.
//

import UIKit
import RealmSwift

class WordsDataController: NSObject {
    class func kopirajBazu() {
        do{
            let realm = try Realm()
            let fileUrl = Foundation.URL(string: "/Users/markosimic/Documents/Swift//Users/markosimic/Documents/Swift/rimoTeka/pripremaBaze/baza.realm")
            try realm.writeCopy(toFile: fileUrl!, encryptionKey: nil)
        }catch{
            //error
        }
    }
    
    
    class func saveWord(_ Word: WordsItem){
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(Word)
                print("Word Saved!")
            })
        }catch{
            print(NSError.debugDescription())
        }
    }
    
    class func fetchAllWords(_ find:String) ->Results<WordsItem>! {
        
        do{
            let config = Realm.Configuration(
                // Get the path to the bundled file
                fileURL: Bundle.main.url(forResource: "baza", withExtension:"realm"),
                // Open the file in read-only mode as application bundles are not writeable
                readOnly: true)
            
            let realm = try Realm(configuration: config)

            let marko = realm.objects(WordsItem.self).filter("word ENDSWITH '\(find)'")
            return marko
        }catch{
            print(error)
            return nil
        }
        
    }
}
