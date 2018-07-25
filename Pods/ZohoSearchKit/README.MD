**ZohoSearchKit**
---

**SearchKit** let's developer enable Search across multiple Zoho services right from their App. SearchKit is packed with rich feature sets to power better search experience. Contextual autosugguests(user suggestion, recent searches, saved searches), Multi service search result listing and easy switching between services, Powerful filter set, Quick actions are some of the features which can help user find the information they need.

**Adding ZohoSearchKit to your iOS App**
---

**Step 1: Add SDK to your Project(CocoaPods)**


*  Add ZohoSearchKit pod to your app target

>  `pod 'ZohoSearchKit'` - *Latest stable SDK*

>  `pod 'ZohoSearchKit', '1.0.0'` - *Specific SDK version*

* **Objective-C Only:** Uncomment `use_frameworks!` if not already as SearchKit is written in Swift, use_frameworks! should be uncommented. If your App is written in **Objective-C** then mostly this line will be commented in your Podfile by default.

* **Objective-C Only:** Add these lines after your App's Pod target specification. This will automatically set Swift-Version for the SearchKit to 4.0 in the Build Settings.

```
#Set Swift Compiler version to 4.0 for ZohoSearchKit
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['ZohoSearchKit'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end 
        end 
    end 
end
```

*  Install newly added Pods

>  `pod install`


**Step 2: Configure Info.plist**

*  Add these Application schemes in your App's Info.plist.

```xml
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>zohocrm</string>
        <string>zohoprojects</string>
        <string>zohosupport</string>
        <string>zohomail</string>
        <string>zohoconnect</string>
        <string>zohopeople1</string>
        <string>zohoDocs</string>
        <string>zohochat</string>
        <string>zohowriter</string>
        <string>zohoshow</string>
        <string>zohosheet</string>
    </array>

```
If you already have configured some schemes for Deeplinking, then make sure to add the remaining schemes from the above list.

**Step 3: Extend the class ZOSAuthAdapter and override methods**

```swift
import Foundation
import SSOKit
import ZohoSearchKit

class ZohoSearchKitAuthImpl : ZOSAuthAdapter {
    
    override init() {
        super.init()
    }
    
    override func getOAuthToken(_ tokenCallback: @escaping (_ token: String?, _ error: Error?) -> Void) {
        ZSSOKit.getOAuth2Token({ (token, error) in
            if let oAuthToken = token {
                tokenCallback(oAuthToken, nil)
            }
            else {
                tokenCallback(nil, error)
            }
        })
    }
    
    override func getCurrentUser() -> ZOSCurrentUser {
        let currentUser = ZSSOKit.getCurrentUser()
        return ZOSCurrentUser(zuid: (currentUser?.userZUID)!, email: (currentUser?.profile.email)!, displayName: (currentUser?.profile.email)!, photoURL: "")
    }
}
```

**Step 4: Add these lines of code in your AppDelegate**

* **Swift** - AppDelegate.swift

```swift
    //Important - Append OAuth scopes needed by SearchKit along with your App's oAuth scopes.
    //SearchKitConfig.getRequiredOAuthScopes(services: ["all"]) will return all the needed scopes for all the supported services by SearchKit.
    //If you want to add search support only for limited/fixed number of services, then pass the service list array.
    //supported services names are: mails,chat,documents,personalContacts,people,connect,support,crm,wiki
    //Check if any scopes are being duplicated and you can removed the duplicate once
    ZSSOKit.initWithClientID("1002.2DP198JW38FP392653KNN8IJA3FBTV", scope: SearchKitConfig.getRequiredOAuthScopes(services: ["all"]), urlScheme: SearchAppScheme, mainWindow: window!, buildType: .Live_SSO)
    
    //Create ZohoSearchKitAuthImpl class object
    let authImplObject = ZohoSearchKitAuthImpl()
    //Create SearchKitConfig object
    let searchKitConfig = SearchKitConfig()
    searchKitConfig.setAuthAdapter(authImplObject)
    //Initialize the SearchKit with SearchKitConfig object
    ZohoSearchKit.sharedInstance().initialize(withConfig: searchKitConfig, debugMode: .AutoDebug)
    
```

* **Objective-C** - AppDelegate.m

```objc
    //Important - Append OAuth scopes needed by SearchKit along with your App's oAuth scopes.
    //SearchKitConfig getRequiredOAuthScopesWithServices:searchSDKServices will return all the needed scopes for all the supported services by SearchKit.
    //If you want to add search support only for limited/fixed number of services, then pass the service list array.
    //supported services names are: mails,chat,documents,personalContacts,people,connect,support,crm,wiki
    //Check if any scopes are being duplicated and you can removed the duplicate once
    NSArray *searchSDKServices = @[@"all"];
    [ZSSOKit initWithClientID:@"1002.2DP198JW38FP392653KNN8IJA3FBTV" Scope:[SearchKitConfig getRequiredOAuthScopesWithServices:searchSDKServices] URLScheme:@"zohosearch://" MainWindow:[[UIApplication sharedApplication]delegate].window BuildType:Live_SSO];
    
    //Create ZohoSearchKitAuthImpl class object
    ZohoSearchKitAuthImpl *authImplObject = [[ZohoSearchKitAuthImpl alloc] init];
    //Create SearchKitConfig object
    SearchKitConfig *searchKitConfig = [[SearchKitConfig alloc] init];
    [searchKitConfig setAuthAdapter:authImplObject];
    ZohoSearchKit *sharedInstance = [ ZohoSearchKit sharedInstance];
    //Initialize the SearchKit with SearchKitConfig object
    [sharedInstance initializeWithConfig:searchKitConfig debugMode: SearchKitBuildTypeAutoDebug];
    
```

Here `ZohoSearchKitAuthImpl` is the name of the class that has been extended from `ZOSAuthAdapter`

**Step 5: Add the following line of code to open the Search UI**
* **Swift**

```swift
let currentVCInfo = AppViewControllerInfo()
currentVCInfo.storyBoardName = "Main" //Name of the Storyboard in which current view controller has been added
currentVCInfo.viewControllerIdentifier = "searchvc" //identifier for the current view controller
ZohoSearchKit.sharedInstance().openSearchUI(appViewController: self, appVCInfo: currentVCInfo)
```

* **Objective-C**

```objc
AppViewControllerInfo *currentVCInfo = [[AppViewControllerInfo alloc] init];
currentVCInfo.storyBoardName = @"Main"; //Name of the Storyboard in which current view controller has been added
currentVCInfo.viewControllerIdentifier = @"searchvc"; //identifier for the current view controller
    
ZohoSearchKit *sharedInstance = [ ZohoSearchKit sharedInstance];
[sharedInstance openSearchUIWithAppViewController:self appVCInfo:currentVCInfo];
```

**Step 6: Add the following line of code to warmup the Search SDK**
* **Swift**

```swift
ZohoSearchKit.sharedInstance().prefetchSearchWidgetData() //Should be called when the user signin succeeds for the first time.
```

* **Objective-C**

```objc
ZohoSearchKit *sharedInstance = [ ZohoSearchKit sharedInstance];
[sharedInstance prefetchSearchWidgetData]; //Should be called when the user signin succeeds for the first time.

```

**Step 7: Add the following line of code to unhide the Tab bar and Nav bar**
* **Swift**

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
    //Copy this line to viewWillAppear if this method is already overriden
    self.navigationController?.setNavigationBarHidden(false, animated: animated) //Unhide Nav bar
    self.tabBarController?.tabBar.isHidden = false //Unhide tab bar
}
```

* **Objective-C**

```
To be added
```

**Note:**

We have already removed the Storyboard and View controller identifier dependency. This we needed to restore the view controller state, once Search UI closes. We are not using this currently, later if needed we will use this.

In the later version, we will provide support for Delegates/Handler so that appropriate actions can be triggered by success or failure.

**Samples Apps:**
---

* [Swift Sample App](https://git.csez.zohocorpin.com/zohosearch/iOS_Search_SDK/tree/master/Samples/SearchKitSwiftDemo)
* [Objective-C Sample App](https://git.csez.zohocorpin.com/zohosearch/iOS_Search_SDK/tree/master/Samples/SearchKitObjCDemo)

---
**Testing in Localzoho or Multi DC support:**

* **Localzoho:** add these config property to the property list file(Info.plist):

```xml
    <key>SearchServerHost</key>
	<string>search.localzoho.com</string>
	<key>ContactsServerHost</key>
	<string>contacts.localzoho.com</string>
```

* **EU DC:** 

```xml
    <key>SearchServerHost</key>
	<string>search.zoho.eu</string>
	<key>ContactsServerHost</key>
	<string>contacts.zoho.eu</string>
```

**Make sure not to add the full server URL, rather just the host url.**

**Supported iOS Versions**
---
**iOS 9** and above is supported, if support for versions before iOS 9 is required, then reach out to us.

**Third party/External Dependencies**

* Material Snackbar - `pod 'MaterialComponents/Snackbar'`

**More Information:**
---

* [SearchKit Developer Manual](https://git.csez.zohocorpin.com/zohosearch/iOS_Search_SDK/wikis/Developer-Manual#getting-started-with-the-zoho-search-sdk-for-ios) - Detailed Developer Manual
* [Release Notes](https://git.csez.zohocorpin.com/zohosearch/iOS_Search_SDK/tags)
* [Issues or Request new feature](https://git.csez.zohocorpin.com/zohosearch/iOS_Search_SDK/issues)
* SearchKit customization wiki link
* Code documentations link
* [Contribution guidelines](https://git.csez.zohocorpin.com/zohosearch/iOS_Search_SDK/blob/master/CONTRIBUTING.md)

**Need any assistance?**
---

* [Hemant - hemantkumar.s@zohocorp.com](https://people.zoho.com/hr#home/dashboard/profile-userId:2803000004983895)
* [Manikandan - manikandan.bangaru@zohocorp.com](https://people.zoho.com/hr#home/dashboard/profile-userId:2803000073776553)