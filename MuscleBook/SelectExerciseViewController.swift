/*
 Muscle Book
 Copyright (C) 2016  Cristian Filipov

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import UIKit
import Eureka
import SQLite

final class SelectExerciseViewController: UITableViewController, TypedRowControllerType {

    private let db = DB.sharedInstance

    var row: RowOf<ExerciseReference>!
    var completionCallback : ((UIViewController) -> ())?

    private let formatter = NSDateFormatter()
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredExercises: [ExerciseReference] = []

    var exercises: [ExerciseReference] {
        return searchController.active ? filteredExercises : allExercises
    }

    private lazy var allExercises: [ExerciseReference] = {
        return (try? self.db.all(Exercise)) ?? []
    }()
    
    init() {
        super.init(style: .Plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select an Exercise"
        
        tableView!.reloadData()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView!.tableHeaderView = searchController.searchBar
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell")
        let ex = exercises[indexPath.row]
        if cell == nil { cell = UITableViewCell() }
        cell!.textLabel?.text = ex.name
        cell!.accessoryType = .DetailButton
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ex = exercises[indexPath.row]
        row.value = ex
        completionCallback?(self)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let ref = exercises[indexPath.row]
        guard let exercise = db.dereference(ref) else { return }
        let vc = ExerciseDetailViewController(exercise: exercise)
        showViewController(vc, sender: nil)
        searchController.active = false
    }
    
    private func filterContentForSearchText(searchText: String, scope: String = "All") {
        guard !searchText.isEmpty else {
            filteredExercises = allExercises
            tableView!.reloadData()
            return
        }
        filteredExercises = Array(try! db.match(name: searchText))
        tableView!.reloadData()
    }

}

extension SelectExerciseViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
