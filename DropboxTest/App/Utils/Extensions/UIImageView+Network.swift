//
//  UIImageView+Network.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension UIImageView {
    @discardableResult func download(url: URL) -> DataRequest {
        let request = Alamofire.request(url)
            .responseImage { [weak self] response in
                self?.image = response.result.value
        }
        return request
    }
}
