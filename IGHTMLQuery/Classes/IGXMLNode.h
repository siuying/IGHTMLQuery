//
//  IGXMLNode.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>
#import <libxml2/libxml/HTMLparser.h>

#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>
#import <Foundation/Foundation.h>

#import "IGXMLNodeSet.h"

@class IGXMLDocument;

@interface IGXMLNode : NSObject {
@protected
    xmlNodePtr _node;
}

@property (nonatomic, strong, readonly) IGXMLDocument* root;

- (id)initFromRoot:(IGXMLDocument*)root node:(xmlNodePtr)node;

/**
 @return get tag name of current node.
 */
- (NSString *)tag;

/**
 @return get text of current node.
 */
- (NSString *)text;

/**
 @return get first child element of current node. If no child exists, return nil.
 */
- (IGXMLNode*) firstChild;

/**
 @return get children elements of current node as {{IGXMLNodeSet}}.
 */
- (IGXMLNodeSet*) children;

@end

@interface IGXMLNode (Query)

- (IGXMLNodeSet*) queryWithXPath:(NSString*)xpath;

@end

@interface IGXMLNode (Attributes)

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
 subscript support
 */
- (id)objectForKeyedSubscript:(id)key;

@end