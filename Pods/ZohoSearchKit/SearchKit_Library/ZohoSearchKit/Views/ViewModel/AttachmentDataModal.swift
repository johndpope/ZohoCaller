//
//  AttachmentDataModal.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 14/05/18.
//

import Foundation
enum AttachmentType : String{
    case pdf
    case documents
    case presentations
    case pictures
    case musics
    case videos
    case zip
    case spreadSheets
    case others
    case text
}

class AttachmentData{
    var type : AttachmentType? {
        didSet{
            switch type {
            case .text?:
                self.imageName =  SearchKitConstants.ImageNameConstants.DocsTextFileImage
            case .pdf?:
                self.imageName =  SearchKitConstants.ImageNameConstants.DocsPDFFileImage
            case .documents?:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsWordFileImage
            case .presentations?:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsPPTFileImage
            case .pictures?:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsImageFileImage
            case .musics?:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsAudioFileImage
            case .videos?:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsVideoFileImage
            case .zip?:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsZIPFileImage
            case .spreadSheets?:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsShowFileImage
            case .others?:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsUnknownFileImage
            case .none:
                self.imageName = SearchKitConstants.ImageNameConstants.DocsUnknownFileImage
            }
        }
    }
    var index = Int()
    var name = String()
    var size = String(){
        didSet{
            if size.isEmpty == false
            {
                if let _ =  Int64(size)
                {
                    size = convertBytesString(bytes: Int64(size)!)
                }
            }
        }
    }
    func convertBytesString(bytes : Int64)->String
    {
        
        let kilobytes: Int64 = {
            return bytes / 1024
        }()
        
        let megabytes: Int64 =  {
            return kilobytes / 1024
        }()
        
        let gigabytes: Int64 = {
            return megabytes / 1024
        }()
        switch bytes {
        case 0..<1024:
            return "\(bytes) bytes"
        case 1024..<(1024 * 1024):
            return "\(String( kilobytes)) KB"
        case 1024..<(1024 * 1024 * 1024):
            return "\(String( megabytes)) MB"
        case (1024 * 1024 * 1024)...Int64.max:
            return "\(String( gigabytes)) GB"
        default:
            return "\(bytes) bytes"
        }
    }
    var imageName = String()
    var attURLParameters = [String : AnyObject]()
}
