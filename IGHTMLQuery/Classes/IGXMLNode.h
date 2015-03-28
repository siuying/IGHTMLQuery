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
#import "IGXMLNodeCore.h"
#import "IGXMLNodeSet.h"
#import "IGXMLNodeAttribute.h"
#import "IGXMLNodeManipulation.h"
#import "IGXMLNodeTraversal.h"
#import "IGXMLNodeQuery.h"

extern NSString* const IGXMLQueryErrorDomain;
extern NSString* const IGXMLNodeException;
extern NSString* const IGXMLQueryCSSConversionException;

@class IGXMLDocument;
@class CSSSelectorToXPathConverter;

@interface IGXMLNode : NSObject <IGXMLNodeCore, IGXMLNodeManipulation, IGXMLNodeQuery, IGXMLNodeAttribute, IGXMLNodeTraversal, NSCopying>

/**
 backed XML node,
 */
@property (nonatomic, readwrite, unsafe_unretained) xmlNodePtr node;

/**
 * The converter to convert CSS to XPath.
 *
 * By default it lazily initialized a shared instance. You can set a customized instance if needed.
 */
@property (nonatomic, strong) CSSSelectorToXPathConverter* cssConverter;

/**
 Create a node using a libxml node
 */
- (id)initWithXMLNode:(xmlNodePtr)node;

/**
 Create a node using a libxml node
 */
+ (id)nodeWithXMLNode:(xmlNodePtr)node;

@end