
ActuallyOpenIDFA for iOS


##Synopsis
A take on Yann Lechelle's "OpenIDFA": https://github.com/ylechelle/OpenIDFA But this one is open source.

##What *can't* I do with this?
Do not use this for identifying individual users of your app, there will be collisions.  You should use some other identifier (like identifierForVendor).

##What *can* I do with this?
If you are looking inside a 14 day conversion window to match a click to conversion, this will likely have a very high level of accuracy and precision.  However, it is only "semi-stable".  Upgrade your OS => new id.  Should you use this yet?  No, it is a work in development and is open for the purposes of discussion.

##Building the library
* Select "Universal Build -> iOS Device
* Build it
* You should find the universal build in something like: 
* /Users/yourname/Library/Developer/Xcode/DerivedData/aoi-csguuzeedepqimeoefdmyhpvhehh/Build/Products/Debug-universal/libaoi.a
* Drag the .a and .h into your project
* Include the following frameworks: MessageUI, CoreTelephony in your app.  

## Rejected ideas
* GPS: requires permissions
* Accelerometer, compass: changes all the time
* advertisingTrackingEnabled: requires the ADSupport.framework
* UDID, MAC: deprecated
* UIPasteBoard: per app now
