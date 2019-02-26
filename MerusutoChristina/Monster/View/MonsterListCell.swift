//
//  MonsterListCell.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/5.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import SDWebImage
import SnapKit
import UIKit

class MonsterListCell: UITableViewCell {
    lazy var rareLabel = UILabel()
    lazy var titleLabel = UILabel()
    lazy var thumbImageView = UIImageView(image: UIImage(named: "thumbnail"))
    lazy var detailLabel1 = UILabel()
    lazy var detailLabel2 = UILabel()
    lazy var detailLabel3 = UILabel()

    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubview(rareLabel)
        addSubview(titleLabel)
        addSubview(thumbImageView)
        addSubview(detailLabel1)
        addSubview(detailLabel2)
        addSubview(detailLabel3)

        detailLabel1.numberOfLines = 0
        detailLabel2.numberOfLines = 0
        detailLabel3.numberOfLines = 0

        let font = UIFont.systemFont(ofSize: 14)
        rareLabel.font = font
        titleLabel.font = font
        detailLabel1.font = font
        detailLabel2.font = font
        detailLabel3.font = font
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
        rareLabel.snp.updateConstraints {
            $0.left.equalTo(self).offset(8)
            $0.top.equalTo(self).offset(8)
            $0.height.equalTo(21)

            let width = getStringWidth(value: self.rareLabel.text!, font: self.rareLabel.font) + 2
            $0.width.equalTo(width)
        }

        titleLabel.snp.updateConstraints {
            $0.left.equalTo(self.rareLabel.snp.right).offset(8)
            $0.right.equalTo(self.snp.right).offset(-8)
            $0.height.equalTo(self.rareLabel.snp.height)
            $0.top.equalTo(self.rareLabel.snp.top)
        }

        thumbImageView.snp.updateConstraints {
            $0.width.equalTo(54)
            $0.height.equalTo(72)
            $0.left.equalTo(self.snp.left).offset(8)
            $0.centerY.equalTo(self.detailLabel1.snp.centerY)
        }

        detailLabel1.snp.updateConstraints {
            $0.left.equalTo(self.thumbImageView.snp.right).offset(8)
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.bottom.equalTo(self.snp.bottom)
            $0.width.equalTo(self.detailLabel2.snp.width)
        }

        detailLabel2.snp.updateConstraints {
            $0.left.equalTo(self.detailLabel1.snp.right)
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.bottom.equalTo(self.snp.bottom)
            $0.width.equalTo(self.detailLabel3.snp.width)
        }

        detailLabel3.snp.updateConstraints {
            $0.left.equalTo(self.detailLabel2.snp.right)
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.bottom.equalTo(self.snp.bottom)
            $0.width.equalTo(self.detailLabel1.snp.width)
            $0.right.equalTo(self.snp.right).offset(-8)
        }
    }
}
