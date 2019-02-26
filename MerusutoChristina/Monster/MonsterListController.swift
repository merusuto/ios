//
//  MonsterListController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/5.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import ActionSheetPicker_3_0
import RESideMenu
import SDWebImage
import SnapKit
import UIKit

class MonsterListController: CharacterListController {
    override func viewDidLoad() {
        pickers = [rarePicker, monster_rarePicker, elementPicker, monster_skinPicker, monster_skillPicker, aareaPicker, serverPicker]

        cellIdentifier = "monster cell"

        classRootPicker = monster_rootPicker

        super.viewDidLoad()
    }

    override func initTableView() {
        super.initTableView()

        self.tableView.register(MonsterListCell.classForCoder(), forCellReuseIdentifier: "monster cell")
    }

    override func loadData() {
        postShowLoading()

        DataManager.loadJSONWithSuccess(key: "monsters") { (data) -> Void in
            for (_, each) in data! {
                let item = MonsterItem(data: each)
                self.allItems.append(item)
            }

            self.displayedItems = self.sort(&self.allItems)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                postHideLoading()
            }
        }
    }

    override func initNavigationBarButtonItem() {
        super.initNavigationBarButtonItem()

        self.btnSort.tag = 0
        self.btnFilter.tag = 1

        self.navigationItem.rightBarButtonItems = [self.btnFilter, self.btnSort]
    }

    override func updateLevelMode(items: [CharacterItem]) {
        // 空实现，不执行等级计算
    }

    // MARK: - UITableView Delegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MonsterListCell = tableView.dequeueReusableCell(withIdentifier: "monster cell") as! MonsterListCell

        cell.item = self.displayedItems[indexPath.row] as? MonsterItem

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show Monster Detail Segue", sender: displayedItems[indexPath.row])
    }

    // MARK: - Other

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Monster Detail Segue",
            let controller = segue.destination as? MonsterDetailController,
            let item = sender as? MonsterItem {
            controller.item = item
        }
    }

    override func filter(_ items: [CharacterItem]) -> [CharacterItem] {
        return items.filter { (item: CharacterItem) -> Bool in

            let temp: MonsterItem = item as! MonsterItem

            if monster_rarePicker.check(temp.rare) || elementPicker.check(temp.element) || monster_skinPicker.check(temp.skin) || monster_skillPicker.checkString(temp.skill) || aareaPicker.check(temp.aarea) || serverPicker.check(temp.server) {
                return false
            }
            return true
        }
    }

    override func sort(_ items: inout [CharacterItem]) -> [CharacterItem] {
        items.sort { (lhs: CharacterItem, rhs: CharacterItem) -> Bool in

            let lhsTemp: MonsterItem = lhs as! MonsterItem
            let rhsTemp: MonsterItem = rhs as! MonsterItem

            switch monster_sortPicker.value {
            case 0:
                return lhsTemp.rare > rhsTemp.rare
            case 1:
                return lhsTemp.sklmax > rhsTemp.sklmax
            case 2:
                return lhsTemp.aarea > rhsTemp.aarea
            case 3:
                return lhsTemp.anum > rhsTemp.anum
            case 4:
                return lhsTemp.aspd > rhsTemp.aspd
            case 5:
                return lhsTemp.tenacity < rhsTemp.tenacity
            case 6:
                return lhsTemp.mspd > rhsTemp.mspd
            case 7:
                return lhsTemp.hits > rhsTemp.hits
            default:
                return true
            }
        }

        return items
    }
}
