//
//  NSString+StringHelper.h
//  CommonLibrary
//
//  Created by rang on 13-1-7.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (TPCategory)
/** Returns a `NSString`.
 @return a guid string.
 */
+(NSString*)createGUID;
/** 向前查找字符串.
 @return 查找到字符串的位置,否则返回-1
 */
-(NSInteger)indexOf:(NSString*)search;
/** 向后查找字符串.
 @return 查找到字符串的位置,否则返回-1
 */
-(NSInteger)lastIndexOf:(NSString*)search;
/** 去除字符串前后空格.
 @return 去除字符串前后空格的字符串
 */
-(NSString*)Trim;
/** 根据字体与宽度计算字符串的大小.
 @return 获取文本大小
 */
-(CGSize)textSize:(UIFont*)f withWidth:(CGFloat)w;
/** Returns an MD5 string of from the given `NSString`.
 @return A MD5 string.
 */
- (NSString *) stringFromMD5;
/**
 Returns a string of the SHA1 sum of the receiver.
 @return The string of the SHA1 sum of the receiver.
 */
- (NSString *)SHA1Sum;
/**
 Returns a string of the SHA256 sum of the receiver.
 
 @return The string of the SHA256 sum of the receiver.
 */
- (NSString *)SHA256Sum;
/** Returns a `NSString` that is URL friendly.
 @return A URL encoded string.
 */
-(NSString*)URLEncode;
/**
 Returns a new string encoded for a URL parameter. (Deprecated)
 
 The following characters are encoded: `:/=,!$&'()*+;[]@#?`.
 
 @return A new string escaped for a URL parameter.
 */
- (NSString *)URLEncodedParameterString;

/**
 Returns a new string decoded from a URL.
 
 @return A new string decoded from a URL.
 */
- (NSString *)URLDecodedString;

/** Returns `YES` if a string is a valid email address, otherwise `NO`.
 @return True if the string is formatted properly as an email address.
 */
- (BOOL) isEmail;
- (BOOL) isURLString;
/** Returns a `NSString` that properly replaces HTML specific character sequences.
 @return An escaped HTML string.
 */
- (NSString *) escapeHTML;

/** Returns a `NSString` that properly formats text for HTML.
 @return An unescaped HTML string.
 */
- (NSString *) unescapeHTML;
///----------------------------------
/// @name URL Escaping and Unescaping
///----------------------------------

/**
 Returns a new string escaped for a URL query parameter.
 
 The following characters are escaped: `\n\r:/=,!$&'()*+;[]@#?%`. Spaces are escaped to the `+` character. (`+` is
 escaped to `%2B`).
 
 @return A new string escaped for a URL query parameter.
 
 @see stringByUnescapingFromURLQuery
 */
- (NSString *)stringByEscapingForURLQuery;

/**
 Returns a new string unescaped from a URL query parameter.
 
 `+` characters are unescaped to spaces.
 
 @return A new string escaped for a URL query parameter.
 
 @see stringByEscapingForURLQuery
 */
- (NSString *)stringByUnescapingFromURLQuery;

/** Returns a `NSString` that removes HTML elements.
 @return Returns a string without the HTML elements.
 */
- (NSString*) stringByRemovingHTML;
/** Returns `YES` is a string has the substring, otherwise `NO`.
 @param substring The substring.
 @return `YES` if the substring is contained in the string, otherwise `NO`.
 */
- (BOOL) hasString:(NSString*)substring;

///----------------------
/// @name Base64 Encoding
///----------------------

/**
 Returns a string representation of the receiver Base64 encoded.
 
 @return A Base64 encoded string
 */
- (NSString *)base64EncodedString;

/**
 Returns a new string contained in the Base64 encoded string.
 
 This uses `NSData`'s `dataWithBase64String:` method to do the conversion then initializes a string with the resulting
 `NSData` object using `NSUTF8StringEncoding`.
 
 @param base64String A Base64 encoded string
 
 @return String contained in `base64String`
 */
+ (NSString *)stringWithBase64String:(NSString *)base64String;
@end
