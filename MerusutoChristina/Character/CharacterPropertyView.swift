//
//  CharacterPropertyDetailController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/2/24.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class CharacterPropertyView: PropertyDetailView {
    let titleLabel1 = UILabel()
    let titleLabel2 = UILabel()
    let detailLabel1 = UILabel()
    let detailLabel2 = UILabel()
    let detailLabel3 = UILabel()
    let detailLabel4 = UILabel()
    let detailLabel5 = UILabel()
    let detailLabel6 = UILabel()
    let detailLabel7 = UILabel()
    let detailLabel8 = UILabel()
    let detailLabel9 = UILabel()

    let contentView = UIView()

    var allLabels: [UILabel] {
        return [titleLabel1, titleLabel2,
                detailLabel1, detailLabel2, detailLabel3, detailLabel4,
                detailLabel5, detailLabel6, detailLabel7, detailLabel8, detailLabel9]
    }

    override var item: CharacterItem! {
        didSet {
            let atk0 = item.originalAtk
            let life0 = item.originalLife
            let dps0 = item.calcDPS(atk0)
            let mdps0 = item.calcMDPS(atk0)

            let atk1 = item.calcMaxLv(atk0)
            let life1 = item.calcMaxLv(life0)
            let dps1 = item.calcDPS(atk1)
            let mdps1 = item.calcMDPS(atk1)

            let atk2 = item.calcMaxLvAndGrow(atk0)
            let life2 = item.calcMaxLvAndGrow(life0)
            let dps2 = item.calcDPS(atk2)
            let mdps2 = item.calcMDPS(atk2)

            titleLabel1.text = item.rareString + "  \(item.title)\(item.name)"
            titleLabel2.text = "ID: \(item.id)"

            detailLabel1.text = "初始生命: \(life0)\n满级生命: \(life1)\n满觉生命: \(life2)\n初始攻击: \(atk0)\n满级攻击: \(atk1)\n满觉攻击: \(atk2)"
            detailLabel2.text = "攻距: \(item.aarea)\n攻数: \(item.anum)\n攻速: \(item.aspd)\n韧性: \(item.tenacity)\n移速: \(item.mspd)\n成长: \(item.typeString)"
            detailLabel3.text = "初始DPS: \(dps0)\n满级DPS: \(dps1)\n满觉DPS: \(dps2)\n初始总DPS: \(mdps0)\n满级总DPS: \(mdps1)\n满觉总DPS: \(mdps2)"
            detailLabel4.text = "火: \(Int(item.fire * 100))%\n水: \(Int(item.aqua * 100))%\n风: \(Int(item.wind * 100))%\n光: \(Int(item.light * 100))%\n暗: \(Int(item.dark * 100))%\n攻击段数: \(item.hits)"
            detailLabel5.text = "国家: \(item.country)\n性别: \(item.genderString)\n年龄: \(item.ageString)"
            detailLabel6.text = "职业: \(item.career)\n兴趣: \(item.interest)\n性格: \(item.nature)"
            detailLabel7.text = item.obtain.count > 0 ? "获取方式: \(item.obtain)" : ""
            detailLabel8.text = item.remark.count > 0 ? "备注: \(item.remark)" : ""
            detailLabel9.text = item.contributorsString.count > 0 ? "数据提供者: \(item.contributorsString)" : ""
        }
    }

    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(contentView)

        allLabels.forEach {
            contentView.addSubview($0)
            $0.numberOfLines = 0
            $0.textColor = .lightText
        }

        setFontSize(value: 14)
        setConstraints()
    }

    override func setFontSize(value: CGFloat) {
        allLabels.forEach {
            $0.font = .boldSystemFont(ofSize: value)
        }
    }

    override func setConstraints() {
        contentView.snp.updateConstraints {
            $0.edges.equalTo(self.snp.edges)
            $0.width.equalTo(self.snp.width)
            $0.bottom.equalTo(self.detailLabel9.snp.bottom)
        }

        titleLabel1.snp.updateConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(0)
            $0.left.equalTo(self.contentView.snp.left).offset(8)
            $0.right.equalTo(self.contentView.snp.right).offset(-8)
        }

        titleLabel2.snp.updateConstraints {
            $0.top.equalTo(self.titleLabel1.snp.bottom)
            $0.left.equalTo(self.titleLabel1.snp.left)
            $0.right.equalTo(self.titleLabel1.snp.right)
        }

        // 初始生命 满级生命 满觉生命 初始攻击 满级攻击 满觉攻击
        detailLabel1.snp.updateConstraints {
            $0.top.equalTo(self.titleLabel2.snp.bottom).offset(12)
            $0.left.equalTo(self.titleLabel2.snp.left)
            $0.width.equalTo(self.detailLabel2.snp.width)
        }

        // 攻距 攻数 攻速 韧性 移速 成长
        detailLabel2.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel1.snp.top)
            $0.left.equalTo(self.detailLabel1.snp.right)
            $0.width.equalTo(self.detailLabel1.snp.width)
            $0.right.equalTo(self.contentView.snp.right).offset(-8)
        }

        // 初始DPS 满级DPS 满觉DPS 初始总DPS 满级总DPS 满觉总DPS
        detailLabel3.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel1.snp.bottom).offset(8)
            $0.left.equalTo(self.detailLabel1.snp.left)
            $0.right.equalTo(self.detailLabel1.snp.right)
        }

        // 五属性 + 多段攻击
        detailLabel4.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel2.snp.bottom).offset(8)
            $0.left.equalTo(self.detailLabel2.snp.left)
            $0.right.equalTo(self.detailLabel2.snp.right)
        }

        // 国家 性别 年龄
        detailLabel5.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel3.snp.bottom).offset(8)
            $0.left.equalTo(self.detailLabel3.snp.left)
            $0.right.equalTo(self.detailLabel4.snp.right)
        }

        if isPortrait {
            // 职业 兴趣 性格
            detailLabel6.snp.updateConstraints {
                $0.top.equalTo(self.detailLabel5.snp.bottom).offset(8)
                $0.left.equalTo(self.detailLabel5.snp.left)
                $0.right.equalTo(self.detailLabel5.snp.right)
            }
        }
        else {
            detailLabel6.snp.updateConstraints {
                $0.top.equalTo(self.detailLabel4.snp.bottom).offset(8)
                $0.left.equalTo(self.detailLabel4.snp.left)
                $0.right.equalTo(self.detailLabel4.snp.right)
            }
        }

        // 获取方式
        detailLabel7.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel6.snp.bottom).offset(8)
            $0.left.equalTo(self.contentView.snp.left).offset(8)
            $0.right.equalTo(self.contentView.snp.right).offset(-8)
        }

        // 备注
        detailLabel8.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel7.snp.bottom).offset(8)
            $0.left.equalTo(self.detailLabel7.snp.left)
            $0.right.equalTo(self.detailLabel7.snp.right)
        }

        detailLabel9.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel8.snp.bottom).offset(8)
            $0.left.equalTo(self.detailLabel8.snp.left)
            $0.right.equalTo(self.detailLabel8.snp.right)
        }
    }
}
