//
//  IGXMLNodeAttribute.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/21/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGHTMLQueryJavaScriptExport.h"

@class IGXMLNode;

@protocol IGXMLNodeAttribute <IGHTMLQueryJavaScriptExport, NSObject>

/**
 @param attName attribute name to get
 @return attribute value
 */
- (NSString *)attribute:(NSString *)attName;

/**
 @param attName attribute name
 @param ns namespace
 @return attribute value
 */
- (NSString *)attribute:(NSString *)attName inNamespace:(NSString *)ns;

/**
 @param attName attribute name to set
 @param value value to set
 */
- (void) setAttribute:(NSString*)attName value:(NSString*)value;

/**
 @param attName attribute name to set
 @param ns namespace
 @param value value to set
 */
- (void) setAttribute:(NSString*)attName inNamespace:(NSString*)ns value:(NSString*)value;

/**
 @param attName attribute name to remove
 */
- (void) removeAttribute:(NSString*)attName;

/**
 @param attName attribute name to remove
 */
- (void) removeAttribute:(NSString*)attName inNamespace:(NSString*)ns;

- (NSArray *)attributeNames;

/**
 subscript support
 */
- (id)objectForKeyedSubscript:(id)key;

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
