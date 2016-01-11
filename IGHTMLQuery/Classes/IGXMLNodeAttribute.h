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

@protocol IGXMLNodeAttribute <IGHTMLQueryJavaScriptExport>

/**
 @param attName attribute name to get
 @return attribute value
 */
- (nullable NSString *)attribute:(nonnull NSString *)attName;

/**
 @param attName attribute name
 @param ns namespace
 @return attribute value
 */
- (nullable NSString *)attribute:(nonnull NSString *)attName inNamespace:(nullable NSString *)ns;

/**
 @param attName attribute name to set
 @param value value to set
 */
- (void) setAttribute:(nonnull NSString*)attName value:(nonnull NSString*)value;

/**
 @param attName attribute name to set
 @param ns namespace
 @param value value to set
 */
- (void) setAttribute:(nonnull NSString*)attName inNamespace:(nullable NSString*)ns value:(nonnull NSString*)value;

/**
 @param attName attribute name to remove
 */
- (void) removeAttribute:(nonnull NSString*)attName;

/**
 @param attName attribute name to remove
 */
- (void) removeAttribute:(nonnull NSString*)attName inNamespace:(nullable NSString*)ns;

- (nonnull NSArray *)attributeNames;

/**
 subscript support
 */
- (nullable id)objectForKeyedSubscript:(nonnull id)key;

- (void)setObject:(nonnull id)obj forKeyedSubscript:(nonnull id <NSCopying>)key;

@end
