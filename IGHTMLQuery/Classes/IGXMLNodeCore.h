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
- (NSString *)tag;

/**
 @param the new tag to set
 */
- (void)setTag:(NSString*)tag;

/**
 @return get text of current node.
 */
- (NSString *)text;

/**
 @param the new content of the node
 */
- (void) setText:(NSString*)text;

/**
 @return get XML of node;
 */
- (NSString *)xml;

/**
 @return get inner XML of node;
 */
- (NSString *)innerXml;

/**
 @return get last error.
 */
- (NSError*) lastError;

/**
 remove namespace of the document recursively.
 */
- (void)removeNamespaces;

@end

