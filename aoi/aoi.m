//  aoi.m

#import "aoi.h"
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonDigest.h>

@implementation aoi

+ (NSString*) getSysInfoByName:(char*) typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+(NSString*) diskSpace {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    return [[dictionary objectForKey: NSFileSystemSize] stringValue];
}

+(NSString*) canOpenFB {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        return @"FB";
    } else {
        return @"NOFB";
    }
}

+(NSString*) hasCydia {
    NSString *filePath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return @"CYDIA";
    } else {
        return @"NOCYDIA";
    }
}

+ (NSString*) buildRawString{

    NSMutableString *raw = [NSMutableString string];
    
    [raw appendString:[self getSysInfoByName:"hw.machine"]];
    [raw appendString:@"|"];

    [raw appendString:[[UIDevice currentDevice] name]];
    [raw appendString:@"|"];

    [raw appendString:[[UIDevice currentDevice] systemName]];
    [raw appendString:@"|"];
    
    [raw appendString:[[UIDevice currentDevice] systemVersion]];
    [raw appendString:@"|"];

    [raw appendString:[[UIDevice currentDevice] model]];
    [raw appendString:@"|"];

    [raw appendString:[[NSTimeZone systemTimeZone] name]];
    [raw appendString:@"|"];
    
    [raw appendString:[self diskSpace]];
    [raw appendString:@"|"];

    [raw appendString:[[NSLocale autoupdatingCurrentLocale] localeIdentifier]];
    [raw appendString:@"|"];

    [raw appendString:[self canOpenFB]];
    [raw appendString:@"|"];
    
    [raw appendString:[self hasCydia]];
    [raw appendString:@"|"];
    
    return raw;
}

+ (NSString*) aoi{
    NSString* rawString = [self buildRawString];

    NSData *data = [rawString dataUsingEncoding: NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
