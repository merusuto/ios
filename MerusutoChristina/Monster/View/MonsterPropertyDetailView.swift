//
//  MonsterDetailView.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/14.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class MonsterPropertyDetailView: PropertyDetailView {
    var titleLabel = UILabel()
    var rareLabel = UILabel()
    var detailLabel1 = UILabel()
    var detailLabel2 = UILabel()
    var detailLabel3 = UILabel()
    var detailLabel4 = UILabel()
    var detailLabel5 = UILabel()
    var detailLabel6 = UILabel()
    var detailLabel7 = UILabel()
    var detailLabel8 = UILabel()

    var contentView: UIView!
    override var item: CharacterItem! {
        didSet {
            let monsterItem = item as! MonsterItem

            titleLabel.text = "\(item.name) \(item.rareString)"
            rareLabel.text = "ID：\(item.id)"

            detailLabel1.text = "攻距：\(item.aarea)\n韧性：\(item.tenacity)\n移速：\(item.mspd)\n溅射距离：\(monsterItem.sarea)"
            detailLabel2.text = "攻数：\(item.anum)\n多段：\(item.hits)\n皮肤：\(monsterItem.skin)\n攻速：\(item.aspd)"

            detailLabel3.text = "技能"
            detailLabel4.text = "\(monsterItem.skill)\n技能消耗：\(monsterItem.sklsp)\n技能CD：\(monsterItem.sklcd)"

            detailLabel5.text = "获得方式"
            detailLabel6.text = item.obtain

            detailLabel7.text = item.remark == "" ? "" : "简介"
            detailLabel8.text = item.remark

            setConstraints()
        }
    }

    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView = UIView()
        addSubview(contentView)

        let array = [titleLabel, rareLabel, detailLabel1, detailLabel2, detailLabel3, detailLabel4, detailLabel5, detailLabel6, detailLabel7, detailLabel8]
        array.forEach {
            contentView.addSubview($0)
            $0.numberOfLines = 0
            $0.textColor = .lightText
        }

        setFontSize(value: 14)
        setConstraints()
    }

    override func setFontSize(value: CGFloat) {
        [rareLabel, detailLabel1, detailLabel2, detailLabel4, detailLabel6, detailLabel8].forEach {
            $0.font = .boldSystemFont(ofSize: value)
        }

        [titleLabel, detailLabel3, detailLabel5, detailLabel7].forEach {
            $0.font = .boldSystemFont(ofSize: value * 1.28)
        }
    }

    override func setConstraints() {
        contentView.snp.updateConstraints {
            $0.edges.equalTo(self.snp.edges)
            $0.width.equalTo(self.snp.width)
            $0.bottom.equalTo(self.detailLabel8.snp.bottom)
        }

        titleLabel.snp.updateConstraints {
            $0.top.equalTo(self.contentView.snp.top).offset(0)
            $0.left.equalTo(self.contentView.snp.left).offset(8)
            $0.right.equalTo(self.contentView.snp.right).offset(-8)
        }

        rareLabel.snp.updateConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.left.equalTo(self.titleLabel.snp.left)
            $0.right.equalTo(self.titleLabel.snp.right)
        }

        detailLabel1.snp.updateConstraints {
            $0.top.equalTo(self.rareLabel.snp.bottom).offset(12)
            $0.left.equalTo(self.rareLabel.snp.left)
            $0.width.equalTo(self.detailLabel2.snp.width)
        }

        detailLabel2.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel1.snp.top)
            $0.left.equalTo(self.detailLabel1.snp.right)
            $0.width.equalTo(self.detailLabel1.snp.width)
            $0.right.equalTo(self.contentView.snp.right).offset(-8)
        }

        // 技能
        detailLabel3.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel1.snp.bottom).offset(12)
            $0.left.equalTo(self.detailLabel1.snp.left)
            $0.right.equalTo(self.detailLabel2.snp.right)
        }

        // 技能描述
        detailLabel4.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel3.snp.bottom).offset(4)
            $0.left.equalTo(self.detailLabel3.snp.left)
            $0.right.equalTo(self.detailLabel3.snp.right)
        }

        // 获取方式
        detailLabel5.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel4.snp.bottom).offset(12)
            $0.left.equalTo(self.detailLabel4.snp.left)
            $0.right.equalTo(self.detailLabel4.snp.right)
        }

        // 获取方式详情
        detailLabel6.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel5.snp.bottom).offset(4)
            $0.left.equalTo(self.detailLabel5.snp.left)
            $0.right.equalTo(self.detailLabel5.snp.right)
        }

        // 简介
        detailLabel7.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel6.snp.bottom).offset(12)
            $0.left.equalTo(self.detailLabel6.snp.left)
            $0.right.equalTo(self.detailLabel6.snp.right)
        }

        // 简介详情
        detailLabel8.snp.updateConstraints {
            $0.top.equalTo(self.detailLabel7.snp.bottom).offset(4)
            $0.left.equalTo(self.detailLabel7.snp.left)
            $0.right.equalTo(self.detailLabel7.snp.right)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
