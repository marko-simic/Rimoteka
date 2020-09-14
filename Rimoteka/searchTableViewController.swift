//
//  searchTableViewController.swift
//  test3
//
//  Created by Marko Simic on 29/09/16.
//  Copyright © 2016 Marko Simic. All rights reserved.
//
import RealmSwift
import UIKit


class searchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var wordsTable: UITableView!
    let searchBar = UISearchBar()
    var nizRijeci = [String]()
    
    var datasource: Results<WordsItem>!
    
    var pretrazeno = rezultatPretrage()
  
    @IBOutlet var statusFakeButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(Realm.Configuration.defaultConfiguration.fileURL ?? "Greska")
        //WordsDataController.kopirajBazu()
        createSearchBar()
        self.wordsTable.reloadData()
        self.navigationController?.toolbar.isTranslucent = false
    }
 

    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Upišite samo jednu riječ"
        searchBar.delegate = self
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none

        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.navigationItem.title = ""
        self.navigationItem.titleView = searchBar
        
    }
    
    
    func theReloadTable() {
        pretrazeno.removeAll()
        nizRijeci.removeAll()
        var odabraneRijeci = [String]()
        let izvornaRijec = searchBar.text!.lowercased()
        var wordToFind = searchBar.text!.lowercased()
        if wordToFind.characters.count < 4 {
            servirajAlert(poruka: "Upišite riječ dužu od tri slova.")
            return
        }
        var duzinaRijeci = wordToFind.characters.count
        

        repeat{
            //print(wordToFind)
            datasource = WordsDataController.fetchAllWords(wordToFind)
            //print("Vratio \(datasource.count)")
            
            for data in datasource {

                if nizRijeci.count == 1000 {
                    break
                }
                if nizRijeci.contains(data.word) || data.word == izvornaRijec {
                    continue
                }else{
                        print(data.word)
                        odabraneRijeci.append(data.word)
                        nizRijeci.append(data.word)
                }
                
            }
            
            odabraneRijeci.sort(by: { $0.characters.count < $1.characters.count })
            
            if odabraneRijeci.count != 0 {
                pretrazeno.addSection(wordToFind, item: odabraneRijeci)
            }
            odabraneRijeci = []
            
            wordToFind.remove(at: wordToFind.startIndex)
            
            duzinaRijeci = wordToFind.characters.count
            //print("Duzina rijeci: \(duzinaRijeci) = \(wordToFind)")
            if datasource.count > 500 {
                break
            }
        }while duzinaRijeci > 2
        if nizRijeci.count == 0 {
            statusFakeButton.title = ":( Nema pogodaka"
        } else if nizRijeci.count == 1 {
            statusFakeButton.title = "1 pogodak"
        } else {
            statusFakeButton.title = "\(nizRijeci.count) pogodaka"
        }
        
        do_table_refresh()
        
        if nizRijeci.count < 1 {
            servirajAlert(poruka: "Nije pronađena ni jedna rimujuća riječ.")
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if nizRijeci.count > 0 {
            
        } else {

        }
        return pretrazeno.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pretrazeno.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return pretrazeno.sections[section]
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        let text = cell?.textLabel?.text
        if let text = text {
            kopirajSelekciju(rijec: "\(text)")
        }
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("!indexPath: \(indexPath.row), nizRijeci: \(nizRijeci.count)")
       
        let identifer: String = "basicCell"
        var cell = wordsTable.dequeueReusableCell(withIdentifier: identifer)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifer)
        }
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifer)
        }
        
        let currentNewWord = pretrazeno.items[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = currentNewWord
        
        return cell!
    }
    
    
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.wordsTable.reloadData()
            self.wordsTable.setContentOffset(CGPoint.zero, animated:true)
            return
        })
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        theReloadTable()
        searchBar.endEditing(true)
        let searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.textAlignment = NSTextAlignment.center
    }
    
    func kopirajSelekciju(rijec: String) {
        UIPasteboard.general.string = rijec
        servirajAlert(poruka: "Riječ \"\(rijec)\" je uspješno kopirana.")
    }
    
    func servirajAlert(poruka: String) {
        // the alert view
        let alert = UIAlertController(title: "", message: poruka, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
  
}
