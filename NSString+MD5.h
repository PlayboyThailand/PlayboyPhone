//
//  NSString+MD5.h
//  iMobile

//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
@interface NSString (MD5)
-(NSString*) HMACWithSecret:(NSString*) secret;
@end
