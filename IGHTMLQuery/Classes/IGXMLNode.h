//
//  IGXMLNode.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

#import <Foundation/Foundation.h>

#import "IGXMLNodeSet.h"

@class IGXMLDocument;

@interface IGXMLNode : NSObject

/**
 backed XML node,
 */
@property (nonatomic, readwrite, unsafe_unretained) xmlNodePtr node;

/**
 Root node of the current node.
 */
@property (nonatomic, strong, readonly) IGXMLDocument* root;

/**
 Shorthand for [IGXMLNode queryWithXPath:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^query)(NSString*);

/**
 Create a node using a root node and a xml node pointer.
 */
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

/**
 Query a node with XPath
 @param xpath used to query the document
 @return elements matched by supplied XPath query.
 */
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