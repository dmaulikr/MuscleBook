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

class SettingsViewController : FormViewController {

    private let db = DB.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        
        form

        +++ Section()

        <<< ButtonRow() {
            $0.title = "Export to CSV"
        }.onCellSelection { _, _ in
            let url = NSURL.cacheUUID()
            try! self.db.exportCSV(Workset.self, toURL: url)
            let vc = UIActivityViewController(
                activityItems: [url],
                applicationActivities: nil
            )
            self.presentViewController(vc, animated: true, completion: nil)
        }

        +++ Section()

        <<< PushViewControllerRow() {
            $0.title = "About"
            $0.controller = { AboutViewController() }
        }

        +++ Section()

        <<< PushViewControllerRow() {
            $0.title = "Debug Menu"
            $0.controller = { DebugMenuViewController() }
        }

    }

}
