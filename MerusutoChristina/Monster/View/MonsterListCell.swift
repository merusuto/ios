//
//  MonsterListCell.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/5.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class MonsterListCell: UITableViewCell {

	var rareLabel: UILabel!
	var titleLabel: UILabel!
	var thumbImageView: UIImageView!
	var detailLabel1: UILabel!
	var detailLabel2: UILabel!
	var detailLabel3: UILabel!

	required init? (coder aDecoder : NSCoder) {
		super.init(coder: aDecoder)
	}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

		super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none


		rareLabel = UILabel()
        titleLabel = UILabel();
		thumbImageView = UIImageView(image: UIImage(named: "thumbnail"))
		detailLabel1 = UILabel();
		detailLabel2 = UILabel();
		detailLabel3 = UILabel();

		self.addSubview(rareLabel)
		self.addSubview(titleLabel)
		self.addSubview(thumbImageView)
		self.addSubview(detailLabel1)
		self.addSubview(detailLabel2)
		self.addSubview(detailLabel3)

//		rareLabel.backgroundColor = UIColor.redColor()
//		titleLabel.backgroundColor = UIColor.greenColor()
//		thumbImageView.backgroundColor = UIColor.redColor()
//		detailLabel1.backgroundColor = UIColor.redColor()
//		detailLabel2.backgroundColor = UIColor.yellowColor()
//		detailLabel3.backgroundColor = UIColor.blueColor()

		detailLabel1.numberOfLines = 0;
		detailLabel2.numberOfLines = 0;
		detailLabel3.numberOfLines = 0;
        
        let font = UIFont.systemFont(ofSize: 14);
        rareLabel.font = font;
        titleLabel.font = font;
        detailLabel1.font = font;
        detailLabel2.font = font;
        detailLabel3.font = font;

	}    
    
	var item: MonsterItem! {
		didSet {

			rareLabel.text = item.rareString
			titleLabel.text = item.title + item.name
			detailLabel1.text = "攻距: \(item.aarea)\n韧性: \(item.tenacity)\n移速: \(item.mspd)\n溅射距离: \(item.sareaString)"
			detailLabel2.text = "攻数: \(item.anum)\n多段: \(item.hits)\n皮肤: \(item.skinString)\n攻速: \(item.aspdString)"
			detailLabel3.text = "极限值: \(item.sklmax)%\n技能: \(item.skillType)\n技能CD: \(item.sklcd)\n技能SP: \(item.sklsp)"

			let imageUrl = DataManager.getGithubURL("monsters/thumbnail/\(item.id).png")
			thumbImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "thumbnail"), options: SDWebImageOptions.retryFailed)

			setConstraints()
		}
	}

	func setConstraints() {
		rareLabel.snp.updateConstraints {[unowned self] (make) -> Void in
			make.left.equalTo(self).offset(8)
			make.top.equalTo(self).offset(8)
			make.height.equalTo(21)

			let width = getStringWidth(value: self.rareLabel.text!, font: self.rareLabel.font) + 2
			make.width.equalTo(width)
		}

		titleLabel.snp.updateConstraints {[unowned self] (make) -> Void in
			make.left.equalTo(self.rareLabel.snp.right).offset(8)
			make.right.equalTo(self.snp.right).offset(-8)
			make.height.equalTo(self.rareLabel.snp.height)
			make.top.equalTo(self.rareLabel.snp.top)
		}

		thumbImageView.snp.updateConstraints {[unowned self] (make) -> Void in
			make.width.equalTo(54)
			make.height.equalTo(72)
			make.left.equalTo(self.snp.left).offset(8);
			make.centerY.equalTo(self.detailLabel1.snp.centerY)
		}

		detailLabel1.snp.updateConstraints {[unowned self] (make) -> Void in
			make.left.equalTo(self.thumbImageView.snp.right).offset(8)
			make.top.equalTo(self.titleLabel.snp.bottom)
			make.bottom.equalTo(self.snp.bottom)
			// make.width.equalTo(100)
			make.width.equalTo(self.detailLabel2.snp.width)
		}

		detailLabel2.snp.updateConstraints {[unowned self] (make) -> Void in
			make.left.equalTo(self.detailLabel1.snp.right)
			make.top.equalTo(self.titleLabel.snp.bottom)
			make.bottom.equalTo(self.snp.bottom)
			make.width.equalTo(self.detailLabel3.snp.width)
		}

		detailLabel3.snp.updateConstraints {[unowned self] (make) -> Void in
			make.left.equalTo(self.detailLabel2.snp.right)
			make.top.equalTo(self.titleLabel.snp.bottom)
			make.bottom.equalTo(self.snp.bottom)
			make.width.equalTo(self.detailLabel1.snp.width)
			make.right.equalTo(self.snp.right).offset(-8)
		}
	}
}
