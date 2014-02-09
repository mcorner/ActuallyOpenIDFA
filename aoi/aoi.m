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
    NSArray *apps = [NSArray arrayWithObjects:@"fb://",@"twitter://",nil];
    NSString* a;
    NSMutableString* installed = [NSMutableString string];

    for (a in apps){
        NSURL* url = [NSURL URLWithString:a];
        [[UIApplication sharedApplication] canOpenURL:url] ? [installed appendString:@"YES,"] : [installed appendString:@"NO,"];
    }
    return installed;
}

+(NSString*) hasCydia {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        return @"CYDIA";
    } else {
        return @"NOCYDIA";
    }
}

+(NSString*)languageList {
    return [[NSLocale preferredLanguages] componentsJoinedByString:@","];
}

+ (NSString*) buildRawString{
    NSMutableArray* rawComponents = [NSMutableArray array];

    [rawComponents addObject:[self getSysInfoByName:"hw.machine"]];
    [rawComponents addObject:[[UIDevice currentDevice] name]];
    [rawComponents addObject:[[UIDevice currentDevice] systemName]];
    [rawComponents addObject:[[UIDevice currentDevice] systemVersion]];
    [rawComponents addObject:[[UIDevice currentDevice] model]];
    [rawComponents addObject:[[NSTimeZone systemTimeZone] name]];
    [rawComponents addObject:[self diskSpace]];
    [rawComponents addObject:[[NSLocale autoupdatingCurrentLocale] localeIdentifier]];
    [rawComponents addObject:[self canOpenFB]];
    [rawComponents addObject:[self hasCydia]];
    [rawComponents addObject:[self languageList]];

    return [rawComponents componentsJoinedByString:@"|"];
}

+ (NSString*) aoi{
    NSString* rawString = [self buildRawString];
    NSLog(@"Raw aoi: %@", rawString);
    
    NSData *data = [rawString dataUsingEncoding: NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
