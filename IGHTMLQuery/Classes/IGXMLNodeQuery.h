//
//  IGXMLNodeQuery.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IGHTMLQueryJavaScriptExport.h"

@class IGXMLNodeSet;

@protocol IGXMLNodeQuery <IGHTMLQueryJavaScriptExport>

/**
 Query a node with XPath
 @param xpath used to query the document
 @return elements matched by supplied XPath query.
 */
- (IGXMLNodeSet*) queryWithXPath:(NSString*)xpath;

/**
 Query a node with CSS Selector (Level 3)
 @param css selector used to query the document
 @return elements matched by supplied css selector.
 @ref Check CSSSelectorConverter (https://github.com/siuying/CSSSelectorConverter) to see how this works.
 @throw IGXMLQueryCSSConversionException when cannot convert css to xpath.
 */
- (IGXMLNodeSet*) queryWithCSS:(NSString*)cssSelector;

@end