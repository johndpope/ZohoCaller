//
//  ColorConstants.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 02/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit

extension SearchKitConstants {
    struct ColorConstants {
        
        static var ResultImageBackgroundColor  : UIColor {  return   UIColor(rgb: 0xF9F9F9)}
        static var ResultImageBorderColor  : UIColor {  return   UIColor(rgb: 0xD9D9D9)}
        static var SnackbarActionButtonColor  : UIColor {  return   UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)}
        static var CalloutMetaContainerBGColor  : UIColor {  return   UIColor(rgb: 0xF4f4f4)}
        static var ResultHighlightColor  : UIColor {  return   UIColor(rgb: 0xBFEEFF)}
        static var SettingsSearchBarTintColor  : UIColor {  return   UIColor(rgb: 0xEAEAEA)}
        static var SelectedServiceTableBGColor  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor.lighterColor(removeSaturation: 0.5, resultAlpha: 0.4)
            
        }  //UIColor( UIColor(rgb: 0xE8EFFC) // highlight the tableview cell by filling bg color}
        static var SelectedStateServiceBgColor  : UIColor {  return   UIColor(rgb: 0x5EA2EF)}
        static var UnSelectedStateServiceBgColor  : UIColor {  return   UIColor(rgb: 0xF9F9F9)}
        static var UnSelectedStateServiceBorderColor  : UIColor {  return   UIColor(rgb: 0xD9D9D9)}
        static var SkyBlueColorForSelectionIndication  : UIColor {  return   UIColor(red: 0.2, green: 0.6, blue: 1, alpha: 1)}
        //Original gradient colors Difference  is  DEB0E
        static var SelectedServiceGradientTopColor : UIColor  {
            
            let BottomColor = ThemeService.sharedInstance().theme.navigationBarBackGroundColor.toHex!
            let bottomhex = Int(BottomColor, radix: 16)
            let diff = Int("D0000",radix: 16)
            let xor = bottomhex! | diff! //.reduce(0, "{$0^$1}")
            
            let result = String(format: "%02x", xor)
            
            return result.hexStringToUIColor
        }
//            ThemeService.sharedInstance().theme.navigationBarBackGroundColor.lighterColor(removeSaturation: 0.5, resultAlpha: -1) //UIColor(rgb: 0x50b7e1)
        static var SelectedServiceGradientBottomColor  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor}// UIColor(rgb: 0x5ea2ef)
//        static var CheckBoxBorderColor : CGColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        // Result View Controller Colors
        static var NavigationBar_BackGround_Color  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor}// UIColor(rgb: 0x5DA5F8)
        static var NavigationBar_Items_Tint_Color  : UIColor {  return   UIColor.white}
        
        static var AllService_SectionsSeparatorView_BackGround_Color  : UIColor {  return   UIColor(rgb: 0xF1F1F1)}
        static var AtMension_NameLabel_BackGround_Color  : UIColor {  return   UIColor(rgb: 0xF1F1F1)}
        static var TabBarView_Selection_Indicator_Color: UIColor
        {
            return ThemeService.sharedInstance().theme.navigationBarBackGroundColor//UIColor(rgb: 0x5DA5F8)
        }
        static var TabBarView_BackGround_Color  : UIColor {  return   UIColor.white}
        static var TabBarView_Non_SelectedCell_Text_Color  : UIColor {  return   UIColor(red: 138/255.0, green: 138/255.0, blue: 144/255.0, alpha: 1.0)}
        static var TabBarView_SelectedCell_Text_Color  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor}//UIColor(rgb: 0x5DA5F8)
        static var Bold_Text_Color  : UIColor {  return   UIColor.black}
        static var Normal_Text_Color  : UIColor {  return   UIColor.darkGray}
        
        //People CalloutVC
        static var PeopleInBorderColor  : UIColor {  return   UIColor(rgb: 0x44bc37)}
        static var PeopleOutBorderColor  : UIColor {  return   UIColor(rgb: 0xf9553a)}
        static var PeopleMetaViewBGColor  : UIColor {  return   UIColor(rgb: 0xf4f4f4)}
        static var PeopleMetaTitleColor  : UIColor {  return   UIColor(rgb: 0x303030)}
        static var PeopleMetaSubtitleColor  : UIColor {  return   UIColor(rgb: 0x606060)}
        static var PeopleDataLabelColor  : UIColor {  return   UIColor(rgb: 0x909090)}
        static var PeopleDataValueColor  : UIColor {  return   UIColor(rgb: 0x303030)}

        //Detailed Callout View Controller
        static var CalloutVC_HeaderView_BackgroundColor  : UIColor {  return   UIColor(rgb: 0xF1F1F1)}
        
        //Filter View Controller
        static var FilterVC_TileHeaderView_BackGround_Color  : UIColor {  return   UIColor(rgb: 0xF1F1F1)}
        static var FilterVC_ToggleArrow_TintColor  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor}//UIColor(rgb: 0x5DA5F8)
        static var FilterVC_header_Text_Color  : UIColor {  return   UIColor.black}
        static var FilterVC_Content_Text_Color  : UIColor {  return   UIColor.darkGray}
        static var FilterVC_Selected_Text_Color  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor}//UIColor(rgb: 0x5DA5F8)//UIColor.black
        static var FilterVC_SelectedIndicator_TickImage_TintColor  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor}// UIColor(rgb: 0x5DA5F8)
        
        static var FilterVC_CheckBox_BorderColor  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor}// UIColor(rgb: 0x5DA5F8)
        static var FilterVC_CheckBox_Selection_TickColor  : UIColor {  return   ThemeService.sharedInstance().theme.navigationBarBackGroundColor}
        
        
        static var Clear_Button_BGColor  : UIColor {  return   UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)}
      
        static var SeparatorLine_BackGroundColor  : UIColor {  return   #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)}
    }
}
