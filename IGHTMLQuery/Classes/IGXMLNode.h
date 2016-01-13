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

NS_ASSUME_NONNULL_BEGIN
extern NSString* const IGXMLQueryErrorDomain;
extern NSString* const IGXMLNodeException;
extern NSString* const IGXMLQueryCSSConversionException;
NS_ASSUME_NONNULL_END

@class IGXMLDocument;
@class CSSSelectorToXPathConverter;

@interface IGXMLNode : NSObject <IGXMLNodeCore, IGXMLNodeManipulation, IGXMLNodeQuery, IGXMLNodeAttribute, IGXMLNodeTraversal, NSCopying>

/**
 backed XML node,
 */
@property (nullable, nonatomic, readwrite, unsafe_unretained) xmlNodePtr node;

/**
 Create a node using a libxml node
 */
- (nonnull id)initWithXMLNode:(nullable xmlNodePtr)node;

/**
 Create a node using a libxml node
 */
+ (nonnull id)nodeWithXMLNode:(nullable xmlNodePtr)node;

/**
 * per thread shared css converter
 */
+(nullable CSSSelectorToXPathConverter *) cssConverter;

@end