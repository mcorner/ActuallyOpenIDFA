
ActuallyOpenIDFA for iOS


##Synopsis
A take on Yann Lechelle's "OpenIDFA": https://github.com/ylechelle/OpenIDFA But this one is actually open source.

##What can I not do with this?
If you use it for identifying individual users of your app, it is terrible (as you say, this is not some kind of UDID replacement).

##What can I do with this?
If you are looking inside a 14 day conversion window to match a click to conversion, this will likely have a very high level of accuracy and precision.  However, it is only "semi-stable".  Upgrade your OS => new id.  Should you use this?  Not really sure, you should proably wait and see what happens.

##Use
Build the library for iOS and look at the header file.

## Rejected ideas
* GPS: requires permissions
* Accelerometer, compass: changes all the time
* advertisingTrackingEnabled Requires the ADSupport.framework
* UDID, MAC: deprecated
* UIPasteBoard: per app now
