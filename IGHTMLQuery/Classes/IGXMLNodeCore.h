//
//  IGXMLNodeCore.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/26/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGHTMLQueryJavaScriptExport.h"

@protocol IGXMLNodeCore <IGHTMLQueryJavaScriptExport>

/**
 @return get tag name of current node.
 */
- (nullable NSString *)tag;

/**
 @param the new tag to set
 */
- (void)setTag:(nonnull NSString*)tag;

/**
 @return get text of current node.
 */
- (nullable NSString *)text;

/**
 @param the new content of the node
 */
- (void) setText:(nonnull NSString*)text;

/**
 @return get XML of node;
 */
- (nullable NSString *)xml;

/**
 @return get HTML of node;
 */
- (nullable NSString *)html;

/**
 @return get inner XML of node;
 */
- (nullable NSString *)innerXml;

/**
 @return get inner HTML of node;
 */
- (nullable NSString *)innerHtml;

/**
 @return get last error.
 */
- (nullable NSError*) lastError;

@end

