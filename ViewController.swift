//
//  ViewController.swift
//  myNotes
//
//  Created by Phan Dang July 12th,2018
//  Copyright © 2018 Phan Dang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    //Declare data as string
    var data:[String]=[]
    var selectedRow:Int = -1
    var newRowText:String = ""
    
    
    //Load application
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add navigation and add buttons
        table.dataSource=self
        table.delegate=self
        self.title="Notes"
        self.navigationController?.navigationBar.prefersLargeTitles=true
        self.navigationItem.largeTitleDisplayMode = .always
        let addButton=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem=addButton
        self.navigationItem.leftBarButtonItem=editButtonItem
        load()
        /*
        //Save data to file
        let baseURL=try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        fileURL=baseURL.appendingPathComponent("note.txt")
        load()
        */
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1{
            return
        }
        data[selectedRow]=newRowText
        if newRowText == ""{
            data.remove(at: selectedRow)
        }
        table.reloadData()
        save()
    }
    //Add data
    @objc func addNote(){
        if table.isEditing{
            return
        }
        let name:String=""
        data.insert(name, at: 0)
        let indexPath:IndexPath=IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=(table.dequeueReusableCell(withIdentifier: "cell"))!
        cell.textLabel?.text=data[indexPath.row]
        return cell
    }
    //Allow editing data
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    //Deleting Data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .automatic)
        save()
    }
    //Select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController=segue.destination as! DetailViewController
        selectedRow=table.indexPathForSelectedRow!.row
        detailView.masterView=self
        detailView.setText(t: data[selectedRow])
    }
    
// Store and load data
    //Save data
    func save(){
        UserDefaults.standard.set(data, forKey: "notes")
//        let a=NSArray(array:data)
//        do {
//            try a.write(to: fileURL)
//        } catch  {
//            print("Error writing file!")
//        }
    }
    func load(){
        //execute the codes and cast the data when data is not nil
       if let loadedData:[String]=UserDefaults.standard.value(forKey: "notes") as? [String]{
//        if let loadedData:[String]=NSArray(contentsOf: fileURL) as? [String]{
        data=loadedData
        table.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

