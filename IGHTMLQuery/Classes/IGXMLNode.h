//
//  IGXMLNode.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//
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
 return true if the node has removed (by [node remove]). 
 Any action performed on removed node will result a runtime exception.
 */
@property (nonatomic, assign, readonly) BOOL removed;

/**
 * per thread shared css converter
 */
+(nullable CSSSelectorToXPathConverter *) cssConverter;

@end