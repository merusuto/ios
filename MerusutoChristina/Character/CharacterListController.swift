//
//  ViewController.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/24.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//
import ActionSheetPicker_3_0
import RESideMenu
import SDWebImage
import UIKit

class CharacterListController: UIViewController, ActionSheetCustomPickerDelegate, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {
    var allItems = [CharacterItem]()
    var displayedItems: [CharacterItem] = []

    var tableView: UITableView!

    var actionSheetPicker: ActionSheetCustomPicker!
    var actionSheetPickerShown: Bool = false

    var scrollToTopButtonHidden = true

    var path: [PickerItem] = []
    var pickers = [levelPicker, sortPicker, rarePicker, elementPicker, weaponPicker, typePicker]
    var classRootPicker = rootPicker

    var pickerView: UIPickerView!

    var btnScrollToTop: UIButton!

    // MARK: UIBarButtons

    var btnMenu: UIBarButtonItem!
    var btnFilter: UIBarButtonItem!
    var btnSort: UIBarButtonItem!
    var btnCancel: UIBarButtonItem!
    var btnDone: UIBarButtonItem!
    var btnLevel: UIBarButtonItem!

    var cellIdentifier: String = "Character Cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear

        self.initTableView()
        self.initNavigationBar()
        self.initNavigationBarButtonItem()
        self.initOtherButton()

        self.loadData()

        NotificationCenter.default.addObserver(self, selector: #selector(CharacterListController.patch_handler(note:)), name: NSNotification.Name(rawValue: PATCH_COMPLETE), object: nil)
    }

    @objc func patch_handler(note: NSNotification) {
        DispatchQueue.main.async {
            self.loadData()
        }
    }

    func initTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        self.tableView.register(CharacterListCell.classForCoder(), forCellReuseIdentifier: self.cellIdentifier)
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 111

        self.tableView.backgroundColor = .clear
        self.tableView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
    }

    func initOtherButton() {
        self.btnScrollToTop = UIButton(type: .system)
        self.btnScrollToTop.alpha = 0
        self.btnScrollToTop.setTitle("回到顶部", for: .normal)
        self.btnScrollToTop.addTarget(self, action: #selector(CharacterListController.btnScrollToTop_clickHandler(sender:)), for: .touchUpInside)
        self.view.addSubview(self.btnScrollToTop)
        self.btnScrollToTop.snp.makeConstraints { 
            $0.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-8)
            $0.right.equalTo(self.view.snp.right).offset(-12)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
    }

    func initNavigationBar() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = ""
    }

    func initNavigationBarButtonItem() {
        self.btnLevel = UIBarButtonItem(title: "等级", style: .plain, target: self, action: #selector(CharacterListController.barButton_clickHandler(sender:)))
        self.btnFilter = UIBarButtonItem(title: "筛选", style: .plain, target: self, action: #selector(CharacterListController.barButton_clickHandler(sender:)))
        self.btnSort = UIBarButtonItem(title: "排序", style: .plain, target: self, action: #selector(CharacterListController.barButton_clickHandler(sender:)))

        self.btnCancel = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(CharacterListController.btnCancel_handler(sender:)))
        self.btnDone = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(CharacterListController.btnDone_handle(sender:)))

        self.btnSort.tag = 1
        self.btnLevel.tag = 0
        self.btnFilter.tag = 2

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_drawer"), style: .done, target: self, action: #selector(CharacterListController.menu_handler(sender:)))
        self.navigationItem.rightBarButtonItems = [self.btnFilter, self.btnSort, self.btnLevel]
    }

    func loadData() {
        postShowLoading()

        DataManager.loadJSONWithSuccess(key: "units") { (data) -> Void in
            for (_, each) in data! {
                let item = CharacterItem(data: each)
                self.allItems.append(item)
            }
            self.displayedItems = self.sort(&self.allItems)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                postHideLoading()
            }
        }
    }

    @objc func menu_handler(sender: AnyObject) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    }

    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CharacterListCell

        cell.item = displayedItems[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show Detail Segue", sender: self.displayedItems[indexPath.row])
    }

    // MARK: - Other

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Detail Segue",
            let controller = segue.destination as? CharacterDetailController,
            let item = sender as? CharacterItem {
            controller.item = item
        }
    }

    func showScrollToTopButton() {
        if self.scrollToTopButtonHidden {
            self.scrollToTopButtonHidden = false
            UIView.animate(withDuration: 0.25) {
                self.btnScrollToTop.alpha = 0.5
            }
        }
    }

    func hideScrollToTopButton() {
        if !self.scrollToTopButtonHidden {
            self.scrollToTopButtonHidden = true
            UIView.animate(withDuration: 0.25) {
                self.btnScrollToTop.alpha = 0
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > self.tableView.rowHeight * 10 {
            self.showScrollToTopButton()
        } else {
            self.hideScrollToTopButton()
        }
    }

    @objc func barButton_clickHandler(sender: UIBarButtonItem) {
        for picker in self.pickers {
            picker.originalValue = picker.value
        }

        if self.actionSheetPickerShown {
            return
        }
        self.actionSheetPicker = ActionSheetCustomPicker(title: "", delegate: self, showCancelButton: true, origin: sender)
        self.actionSheetPicker.hideWithCancelAction()
        self.actionSheetPicker.delegate = self
        self.actionSheetPicker.setDoneButton(self.btnDone)
        self.actionSheetPicker.setCancelButton(self.btnCancel)
        self.actionSheetPicker.addCustomButton(withTitle: "重置") {
            self.btnReset_clickHandler(sender: nil)
            self.actionSheetPickerShown = false
        }
        self.resetPath(item: self.classRootPicker.child(index: sender.tag))
        self.actionSheetPicker.show()
        self.actionSheetPickerShown = true
        self.reloadComponents()
    }

    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        self.btnDone_handle(sender: nil)
        self.actionSheetPickerShown = false
    }

    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        self.btnCancel_handler(sender: nil)
        self.actionSheetPickerShown = false
    }

    @objc func btnScrollToTop_clickHandler(sender: AnyObject?) {
        self.tableView.setContentOffset(CGPoint(), animated: true)
    }

    func reloadComponents() {
        self.pickerView.reloadAllComponents()
        for component in 0 ..< self.numberOfComponents {
            let filter = self.picker(byComponent: component)
            pickerView.selectRow(filter.value, inComponent: component, animated: false)
        }
    }

    func sort(_ items: inout [CharacterItem]) -> [CharacterItem] {
        //        var items = items
        items.sort { (lhs: CharacterItem, rhs: CharacterItem) -> Bool in
            switch sortPicker.value {
            case 0:
                return lhs.rare > rhs.rare
            case 1:
                return lhs.dps > rhs.dps
            case 2:
                return lhs.mdps > rhs.mdps
            case 3:
                return lhs.life > rhs.life
            case 4:
                return lhs.atk > rhs.atk
            case 5:
                return lhs.aarea > rhs.aarea
            case 6:
                return lhs.anum > rhs.anum
            case 7:
                return lhs.aspd < rhs.aspd
            case 8:
                return lhs.tenacity > rhs.tenacity
            case 9:
                return lhs.mspd > rhs.mspd
            case 10:
                return lhs.id > rhs.id
            case 11:
                return lhs.hits > rhs.hits
            default:
                return true
            }
        }

        return items
    }

    func filter(_ items: [CharacterItem]) -> [CharacterItem] {
        return items.filter { (item: CharacterItem) -> Bool in
            if rarePicker.check(item.rare) ||
                elementPicker.check(item.element) ||
                weaponPicker.check(item.weapon) ||
                typePicker.check(item.type) ||
                aareaPicker.check(item.aarea) ||
                anumPicker.check(item.anum) ||
                genderPicker.check(item.gender) ||
                serverPicker.check(item.server) ||
                exchangePicker.check(item.exchange) ||
                countryPicker.checkString(item.country) {
                return false
            }
            return true
        }
    }

    func updateLevelMode(items: [CharacterItem]) {
        if levelPicker.value != levelPicker.originalValue {
            for item in items {
                item.levelMode = levelPicker.value
            }
        }
    }

    func resetPath(item: PickerItem) {
        self.path.removeAll(keepingCapacity: true)
        self.path.append(item)
    }

    var numberOfComponents: Int {
        return self.picker(byComponent: 0).depth
    }

    func picker(byComponent component: Int) -> PickerItem {
        if component < self.path.count {
            return self.path[component]
        } else if component == self.path.count {
            let last = path.last!
            let item = last.child(index: last.value)
            path.append(item)
            return item
        } else {
            return unknownPicker
        }
    }

    @objc func btnCancel_handler(sender: AnyObject?) {
        for picker in self.pickers {
            picker.value = picker.originalValue
        }
    }

    func btnReset_clickHandler(sender: AnyObject?) {
        self.picker(byComponent: 0).reset()
        self.btnDone_handle(sender: nil)
    }

    @objc func btnDone_handle(sender: AnyObject?) {
        var items = allItems
        updateLevelMode(items: items)
        items = filter(items)
        items = sort(&items)

        displayedItems = items
        tableView.reloadData()
    }

    // MARK: - PickerView Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }

    func actionSheetPicker(_ actionSheetPicker: AbstractActionSheetPicker!, configurePickerView pickerView: UIPickerView!) {
        self.pickerView = pickerView
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.picker(byComponent: component).children.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.picker(byComponent: component).child(index: row).title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let filter = picker(byComponent: component)
        filter.value = row

        while self.path.count > component + 1 {
            self.path.removeLast()
        }
        self.path.append(filter.child(index: row))
        self.reloadComponents()
    }
}
