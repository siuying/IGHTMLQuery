//
//  IGXMLNode.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>
#import <libxml2/libxml/xmlerror.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

#import <Foundation/Foundation.h>
#import "IGHTMLQueryJavaScriptExport.h"
#import "IGXMLNodeSet.h"
#import "IGXMLNodeAttribute.h"
#import "IGXMLNodeManipulation.h"
#import "IGXMLNodeTraversal.h"
#import "IGXMLNodeQuery.h"

extern NSString* const IGXMLQueryErrorDomain;
extern NSString* const IGXMLNodeException;

@class IGXMLDocument;

@protocol IGXMLNodeCore <IGHTMLQueryJavaScriptExport, NSObject>

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

@interface IGXMLNode : NSObject <IGXMLNodeCore, IGXMLNodeManipulation, IGXMLNodeQuery, IGXMLNodeAttribute, IGXMLNodeTraversal, NSCopying>

/**
 backed XML node,
 */
@property (nonatomic, readwrite, unsafe_unretained) xmlNodePtr node;

/**
 Create a node using a libxml node
 */
- (id)initWithXMLNode:(xmlNodePtr)node;

/**
 Create a node using a libxml node
 */
+ (id)nodeWithXMLNode:(xmlNodePtr)node;

@end