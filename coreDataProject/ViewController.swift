//
//  ViewController.swift
//  coreDataProject
//
//  Created by wendy manrique on 25/05/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let myCountries = ["España", "Mexico", "Perú", "Colombia", "Argentina", "EEUU", "Francia", "Italia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func add(_ sender: Any) {
        print("Añadir datos")
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCountries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
            if cell == nil {
               
                cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
                
            }
            cell!.textLabel?.text = myCountries[indexPath.row]
            return cell!
      
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(myCountries[indexPath.row])
    }
    
}

