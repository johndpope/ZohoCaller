//
//  ConnectCommentsTableViewCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 16/05/18.
//

import UIKit

class ConnectCommentsTableViewCell: UITableViewCell   {
    @IBOutlet weak var dividerLine: UIView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    static  var commentsData = [ConnectCommentData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        dividerLine.backgroundColor = SearchKitConstants.ColorConstants.SeparatorLine_BackGroundColor
        self.tableView.register(ConnectCommentCell.nib, forCellReuseIdentifier: ConnectCommentCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false

    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    static var identifier: String {
        return String(describing: self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame.size = tableView.contentSize
        tableviewHeight.constant = tableView.contentSize.height
    }
}
extension ConnectCommentsTableViewCell : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ConnectCommentsTableViewCell.commentsData.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConnectCommentCell.identifier) as! ConnectCommentCell
        cell.commentData = ConnectCommentsTableViewCell.commentsData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let superTV = self.superview as! UITableView
//        superTV.beginUpdates()
//        superTV.endUpdates()
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
