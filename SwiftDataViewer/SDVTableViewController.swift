//
//  SDVTableViewController.swift
//  SwiftDataViewer
//
//  Created by Guillermo Zafra on 20/06/16.
//
//

import UIKit

class SDVTableViewController: UITableViewController, SDVDataManagerDelegate {
    
    var listOfItems = [SDVJsonItem]()
    var isLoading = false
    var didFail = false
    
    struct TableViewCellIdentifiers {
        static let loadingCell = "LoadingTableViewCell"
        static let dataCell = "TableViewCell"
        static let errorCell = "ErrorTableViewCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.errorCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.errorCell)
        
        self.refreshControl?.addTarget(self, action: #selector(SDVTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SDVDataManagerDelegate
    
    func dataDidLoad(data: NSArray) {
        tableView.rowHeight = 40
        isLoading = false
        self.listOfItems = data as! [SDVJsonItem];
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func dataDidFailToLoad() {
        isLoading = false
        self.refreshControl?.endRefreshing()
        
        // Show error only if no data, otherwise show last successful request
        if self.listOfItems.count==0 {
            didFail = true
            listOfItems.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func refreshingData() {
        didFail = false
        tableView.rowHeight = 80
        isLoading = true
        listOfItems.removeAll()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isLoading || didFail {
            return 1
        } else {
            return self.listOfItems.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath:indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if didFail {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.errorCell, forIndexPath:indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.dataCell, forIndexPath: indexPath)
            
            // Configure the cell...
            
            let item = self.listOfItems[indexPath.row]
            
            cell.textLabel?.text = item.itemName
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("PresentDetail", sender: indexPath)
    }
    
    

    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataManager.getData()
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PresentDetail" {
            let itemDetailViewController = segue.destinationViewController as! SDVDetailViewController
            
            // Get the cell that generated this segue.
            let indexPath = sender as! NSIndexPath
            let selectedItem = self.listOfItems[indexPath.row]
            itemDetailViewController.jsonItem = selectedItem
            
        }
    }

}
