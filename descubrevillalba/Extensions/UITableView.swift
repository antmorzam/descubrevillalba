//
//  UITableView.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 08/03/2022.
//

import Foundation
import UIKit

extension UITableView {
  //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
  func setAndLayoutTableHeaderView(header: UIView) {
    self.tableHeaderView = header
    header.setNeedsLayout()
    header.layoutIfNeeded()
    let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    var frame = header.frame
    frame.size.height = height
    header.frame = frame
    self.tableHeaderView = header
  }
}
