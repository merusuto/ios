//
//  MonsterDetailView.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/14.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class MonsterPropertyDetailView: PropertyDetailView {

	var titleLabel: UILabel!
	var rareLabel: UILabel!
	var detailLabel1: UILabel!
	var detailLabel2: UILabel!
	var detailLabel3: UILabel!
	var detailLabel4: UILabel!
	var detailLabel5: UILabel!
	var detailLabel6: UILabel!
	var detailLabel7: UILabel!
	var detailLabel8: UILabel!

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

	required init? (coder aDecoder : NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)


		contentView = UIView()
		self.addSubview(contentView)

		titleLabel = UILabel();
		rareLabel = UILabel()
		detailLabel1 = UILabel();
		detailLabel2 = UILabel();
		detailLabel3 = UILabel();
		detailLabel4 = UILabel();
		detailLabel5 = UILabel();
		detailLabel6 = UILabel();
		detailLabel7 = UILabel();
		detailLabel8 = UILabel();

		contentView.addSubview(titleLabel)
		contentView.addSubview(rareLabel)
		contentView.addSubview(detailLabel1)
		contentView.addSubview(detailLabel2)
		contentView.addSubview(detailLabel3)
		contentView.addSubview(detailLabel4)
		contentView.addSubview(detailLabel5)
		contentView.addSubview(detailLabel6)
		contentView.addSubview(detailLabel7)
		contentView.addSubview(detailLabel8)

		titleLabel.numberOfLines = 0;
		rareLabel.numberOfLines = 0;
		detailLabel1.numberOfLines = 0;
		detailLabel2.numberOfLines = 0;
		detailLabel3.numberOfLines = 0;
		detailLabel4.numberOfLines = 0;
		detailLabel5.numberOfLines = 0;
		detailLabel6.numberOfLines = 0;
		detailLabel7.numberOfLines = 0;
		detailLabel8.numberOfLines = 0;

		titleLabel.textColor = UIColor.lightText
		rareLabel.textColor = UIColor.lightText
		detailLabel1.textColor = UIColor.lightText
		detailLabel2.textColor = UIColor.lightText
		detailLabel3.textColor = UIColor.lightText
		detailLabel4.textColor = UIColor.lightText
		detailLabel5.textColor = UIColor.lightText
		detailLabel6.textColor = UIColor.lightText
		detailLabel7.textColor = UIColor.lightText
		detailLabel8.textColor = UIColor.lightText

		setFontSize(value: 14)
		setConstraints()
	}

	override func setFontSize(value: CGFloat) {
		let font: UIFont = UIFont.boldSystemFont(ofSize: value)

		rareLabel.font = font;
		detailLabel1.font = font;
		detailLabel2.font = font;
		detailLabel4.font = font;
		detailLabel6.font = font;
		detailLabel8.font = font;

		let titleFont = UIFont.systemFont(ofSize: value * 1.28)
		titleLabel.font = titleFont
		detailLabel3.font = titleFont
		detailLabel5.font = titleFont
		detailLabel7.font = titleFont
	}

	override func setConstraints() {

		contentView.snp.updateConstraints {[unowned self] (make) -> Void in
			make.edges.equalTo(self.snp.edges)
			make.width.equalTo(self.snp.width)
			make.bottom.equalTo(self.detailLabel8.snp.bottom)
		}

		titleLabel.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.contentView.snp.top).offset(0)
			make.left.equalTo(self.contentView.snp.left).offset(8)
			make.right.equalTo(self.contentView.snp.right).offset(-8)
		}

		rareLabel.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.titleLabel.snp.bottom)
			make.left.equalTo(self.titleLabel.snp.left)
			make.right.equalTo(self.titleLabel.snp.right)
		}

		detailLabel1.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.rareLabel.snp.bottom).offset(12)
			make.left.equalTo(self.rareLabel.snp.left)
			make.width.equalTo(self.detailLabel2.snp.width)
		}

		detailLabel2.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.detailLabel1.snp.top)
			make.left.equalTo(self.detailLabel1.snp.right)
			make.width.equalTo(self.detailLabel1.snp.width)
			make.right.equalTo(self.contentView.snp.right).offset(-8)
		}

		// 技能
		detailLabel3.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.detailLabel1.snp.bottom).offset(12)
			make.left.equalTo(self.detailLabel1.snp.left)
			make.right.equalTo(self.detailLabel2.snp.right)
		}

		// 技能描述
		detailLabel4.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.detailLabel3.snp.bottom).offset(4)
			make.left.equalTo(self.detailLabel3.snp.left)
			make.right.equalTo(self.detailLabel3.snp.right)
		}

		// 获取方式
		detailLabel5.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.detailLabel4.snp.bottom).offset(12)
			make.left.equalTo(self.detailLabel4.snp.left)
			make.right.equalTo(self.detailLabel4.snp.right)
		}

		// 获取方式详情
		detailLabel6.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.detailLabel5.snp.bottom).offset(4)
			make.left.equalTo(self.detailLabel5.snp.left)
			make.right.equalTo(self.detailLabel5.snp.right)
		}

		// 简介
		detailLabel7.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.detailLabel6.snp.bottom).offset(12)
			make.left.equalTo(self.detailLabel6.snp.left)
			make.right.equalTo(self.detailLabel6.snp.right)
		}

		// 简介详情
		detailLabel8.snp.updateConstraints {[unowned self] (make) -> Void in
			make.top.equalTo(self.detailLabel7.snp.bottom).offset(4)
			make.left.equalTo(self.detailLabel7.snp.left)
			make.right.equalTo(self.detailLabel7.snp.right)
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}
}
