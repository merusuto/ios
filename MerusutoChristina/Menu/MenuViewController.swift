//
//  MenuViewController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/2/22.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import Closures
import UIKit

// 菜单栏
public enum MenuList: Int {
    case character // 人物图鉴
    case monster // 魔宠图鉴
    case simulator // 模拟抽卡
    case download // 下载
    case clearCache // 清除缓存
    case help // 帮助
}

class MenuViewController: UIViewController {
    typealias TitleType = (icon: String, name: String, menuType: MenuList)
    typealias ArrayType = [TitleType]

    // MARK: 属性列表

    var tableView: UITableView!

    // 菜单栏
    let title1: TitleType = (icon: "icon_character.png", name: "人物图鉴", menuType: .character)
    let title2: TitleType = (icon: "icon_monster.png", name: "魔宠图鉴", menuType: .monster)

    let title3: TitleType = (icon: "icon_simulator.png", name: "模拟抽卡", menuType: .simulator)
    let title4: TitleType = (icon: "icon_download.png", name: "下载资源包", menuType: .download)
    let title5: TitleType = (icon: "icon_help.png", name: "帮助", menuType: .help)
    let title6: TitleType = (icon: "icon_help.png", name: "清除缓存", menuType: .clearCache)

    lazy var titles = [[title1, title2], [title4, title5], [title6]]

    // MARK: 方法

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: .zero, style: .plain)
        tableView!.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "test")
        tableView!.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        tableView!.tableFooterView = UIView(frame: .zero)
        tableView!.isScrollEnabled = false

        view.addSubview(tableView!)
        tableView!.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            $0.bottom.equalTo(self.bottomLayoutGuide.snp.top)
        }

        tableView!
            .numberOfSectionsIn { [unowned self] in self.titles.count }
            .numberOfRows { [unowned self] in self.titles[$0].count }
            .heightForHeaderInSection { $0 == 0 ? 0 : 20 }
            .cellForRow { [unowned self] indexPath in
                let cell = self.tableView!.dequeueReusableCell(withIdentifier: "test", for: indexPath)

                let title = self.titles[indexPath.section][indexPath.row].name
                cell.textLabel?.text = title

                let iconName = self.titles[indexPath.section][indexPath.row].icon
                cell.imageView?.image = UIImage(named: iconName)

                return cell
            }
            .didSelectRowAt { [unowned self] indexPath in
                guard
                    let cell = self.tableView!.cellForRow(at: indexPath),
                    let mainController = self.sideMenuViewController as? RootViewController
                else { return }

                cell.isSelected = false

                let clickMenu = self.titles[indexPath.section][indexPath.row].menuType

                switch clickMenu {
                case .character: mainController.switchToController(index: 0)
                case .monster: mainController.switchToController(index: 1)
                case .simulator: mainController.switchToController(index: 2)
                case .download: mainController.downloadAllResource()
                case .clearCache: mainController.clearAllResource()
                case .help: UIApplication.shared.open(URL(string: "https://merusuto.github.io/readme/")!, options: [:], completionHandler: nil)
                }
            }
    }
}
