//
//  AttachmentsTableViewCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 11/05/18.
//

import UIKit


class AttachmentsTableViewCell: UITableViewCell   {

    @IBOutlet weak var dividerLine: UIView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
  static  var attachedFiles = [AttachmentData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        dividerLine.backgroundColor = SearchKitConstants.ColorConstants.SeparatorLine_BackGroundColor
        self.tableView.register(AttachmentCell.nib, forCellReuseIdentifier: AttachmentCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
extension AttachmentsTableViewCell : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AttachmentsTableViewCell.attachedFiles.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentCell.identifier) as! AttachmentCell
        cell.attachmentDetails = AttachmentsTableViewCell.attachedFiles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let superTV = self.superview as! UITableView
        superTV.beginUpdates()
        superTV.endUpdates()
        return UITableViewAutomaticDimension
    }
   
}
