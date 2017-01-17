//
//  MonsterDetailController.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/12.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit

class MonsterDetailController: CharacterDetailController {

	override func getPropertyDetailView() -> PropertyDetailView {
		return MonsterPropertyDetailView(frame: self.view.bounds)
	}
    
    override func getItemUrl() -> URL {
        return DataManager.getGithubURL("monsters/original/\(item.id).png")
    }
}
