//
//  ViewController.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/24.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//
import UIKit
import ActionSheetPicker_3_0
import SDWebImage
import RESideMenu

class CharacterListController: UIViewController, ActionSheetCustomPickerDelegate, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {

    var allItems = [CharacterItem]()
    var displayedItems: [CharacterItem]?

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

        self.view.backgroundColor = UIColor.clear

        initTableView()
        initNavigationBar()
        initNavigationBarButtonItem()
        initOtherButton()

        loadData()
        
        NotificationCenter.default.addObserver(self, selector:#selector(CharacterListController.patch_handler(note:)), name: NSNotification.Name(rawValue: PATCH_COMPLETE), object: nil)
    }
    
    @objc func patch_handler(note: NSNotification) {
        DispatchQueue.main.async {
            self.loadData()
        }
    }

    func initTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        self.tableView.register(CharacterListCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 111

        self.tableView.backgroundColor = UIColor.clear
        self.tableView.snp.makeConstraints {[unowned self] (make) -> Void in
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top).offset(0)
        }
    }

    func initOtherButton() {
        self.btnScrollToTop = UIButton(type: .system)
        self.btnScrollToTop.alpha = 0
        self.btnScrollToTop.setTitle("回到顶部", for: .normal)
        self.btnScrollToTop.addTarget(self, action:#selector(CharacterListController.btnScrollToTop_clickHandler(sender:)), for: .touchUpInside)
        self.view.addSubview(self.btnScrollToTop)
        self.btnScrollToTop.snp.makeConstraints {[unowned self] (make) -> Void in
            make.bottom.equalTo(self.view.snp.bottom).offset(-8)
            make.right.equalTo(self.view.snp.right).offset(-12)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }

    func initNavigationBar() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = ""
    }

    func initNavigationBarButtonItem() {
        
        self.btnLevel = UIBarButtonItem(title: "等级", style: .plain, target: self, action:#selector(CharacterListController.barButton_clickHandler(sender:)))
        self.btnFilter = UIBarButtonItem(title: "筛选", style: .plain, target: self, action: #selector(CharacterListController.barButton_clickHandler(sender:)))
        self.btnSort = UIBarButtonItem(title: "排序", style: .plain, target: self, action: #selector(CharacterListController.barButton_clickHandler(sender:)))
        
        self.btnCancel = UIBarButtonItem(title: "取消", style: .plain, target: self, action:#selector(CharacterListController.btnCancel_handler(sender:)))
        self.btnDone = UIBarButtonItem(title: "确定", style: .plain, target: self, action:#selector(CharacterListController.btnDone_handle(sender:)))
        

        self.btnSort.tag = 1
        self.btnLevel.tag = 0
        self.btnFilter.tag = 2

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_drawer"), style: UIBarButtonItem.Style.done, target: self, action: #selector(CharacterListController.menu_handler(sender:)))
        self.navigationItem.rightBarButtonItems = [self.btnFilter, self.btnSort, self.btnLevel]
    }

    func loadData() {

        postShowLoading()

        DataManager.loadJSONWithSuccess(key: "units", success: { (data) -> Void in
            for (_, each) in data! {
                let item = CharacterItem(data: each)
                self.allItems.append(item)
            }
            self.displayedItems = self.sort(&self.allItems)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                postHideLoading()
            }
        })
    }

    @objc func menu_handler(sender: AnyObject) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {

    }

    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CharacterListCell

        cell.item = displayedItems![indexPath.row] as CharacterItem

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show Detail Segue", sender: displayedItems![indexPath.row])

    }

    // MARK: - Other
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Show Detail Segue" {

            let controller: CharacterDetailController = segue.destination as! CharacterDetailController

            controller.item = sender as! CharacterItem
        }
    }

    func showScrollToTopButton() {
        if scrollToTopButtonHidden {
            scrollToTopButtonHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.btnScrollToTop.alpha = 0.5
            })
        }
    }

    func hideScrollToTopButton() {
        if !scrollToTopButtonHidden {
            scrollToTopButtonHidden = true
            UIView.animate(withDuration: 0.25, animations: {
                self.btnScrollToTop.alpha = 0
            })
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > tableView.rowHeight * 10 {
            showScrollToTopButton()
        } else {
            hideScrollToTopButton()
        }
    }

    @objc func barButton_clickHandler(sender: UIBarButtonItem) {
        for picker in pickers {
            picker.originalValue = picker.value
        }

        if actionSheetPickerShown {
            return
        }
        actionSheetPicker = ActionSheetCustomPicker(title: "", delegate: self, showCancelButton: true, origin: sender)
        actionSheetPicker.hideWithCancelAction()
        actionSheetPicker.delegate = self
        actionSheetPicker.setDoneButton(btnDone)
        actionSheetPicker.setCancelButton(btnCancel)
        actionSheetPicker.addCustomButton(withTitle: "重置", actionBlock: {
            self.btnReset_clickHandler(sender: nil)
            self.actionSheetPickerShown = false
        })
        resetPath(item: classRootPicker.child(index: sender.tag))
        actionSheetPicker.show()
        actionSheetPickerShown = true
        reloadComponents()
    }

    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        self.btnDone_handle(sender: nil)
        actionSheetPickerShown = false
    }

    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        self.btnCancel_handler(sender: nil)
        actionSheetPickerShown = false
    }

    @objc func btnScrollToTop_clickHandler(sender: AnyObject?) {
        self.tableView.setContentOffset(CGPoint(), animated: true)
    }

    func reloadComponents() {
        pickerView.reloadAllComponents()
        for component in 0 ..< numberOfComponents {
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

        return items.filter({ (item: CharacterItem) -> Bool in
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
        })
    }

    func updateLevelMode(items: [CharacterItem]) {
        if levelPicker.value != levelPicker.originalValue {
            for item in items {
                item.levelMode = levelPicker.value
            }
        }
    }

    func resetPath(item: PickerItem) {
        path.removeAll(keepingCapacity: true)
        path.append(item)
    }

    var numberOfComponents: Int {
        get {
            return picker(byComponent: 0).depth
        }
    }

    func picker(byComponent component: Int) -> PickerItem {
        if component < path.count {
            return path[component]
        } else if component == path.count {
            let last = path.last!
            let item = last.child(index: last.value)
            path.append(item)
            return item
        } else {
            return unknownPicker
        }
    }

    @objc func btnCancel_handler(sender: AnyObject?) {
        for picker in pickers {
            picker.value = picker.originalValue
        }
    }

    func btnReset_clickHandler(sender: AnyObject?) {
        picker(byComponent: 0).reset()
        btnDone_handle(sender: nil)
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
        return numberOfComponents
    }
    
    func actionSheetPicker(_ actionSheetPicker: AbstractActionSheetPicker!, configurePickerView pickerView: UIPickerView!) {
        self.pickerView = pickerView
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker(byComponent: component).children.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker(byComponent: component).child(index: row).title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let filter = picker(byComponent: component)
        filter.value = row

        while path.count > component + 1 {
            path.removeLast()
        }
        path.append(filter.child(index: row))
        reloadComponents()
    }
}
