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

#import "IGXMLNodeSet.h"
#import "IGXMLNodeManipulation.h"
#import "IGXMLNodeQuery.h"

extern NSString* const IGXMLQueryErrorDomain;

@class IGXMLDocument;

@interface IGXMLNode : NSObject <IGXMLNodeManipulation, IGXMLNodeQuery>

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
 Append xml to the node, shorthand for [IGXMLNode appendWithNode:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^append)(NSString*);

/**
 Prepend xml to the node, shorthand for [IGXMLNode prependWithNode:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^prepend)(NSString*);

/**
 Add xml before the node, shorthand for [IGXMLNode addPreviousSiblingWithNode:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^before)(NSString*);

/**
 Add xml after the node, shorthand for [IGXMLNode addNextSiblingWithNode:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^after)(NSString*);

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

@end

@interface IGXMLNode (Traversal)

/**
  @return get parent node
 */
- (IGXMLNode *) parent;

/**
 @return get next sibling node
 */
- (IGXMLNode *) nextSibling;

/**
 @return get previous sibling node
 */
- (IGXMLNode *) previousSibling;

/**
 @return get children elements of current node as {{IGXMLNodeSet}}.
 */
- (IGXMLNodeSet*) children;

/**
 @return get first child element of current node. If no child exists, return nil.
 */
- (IGXMLNode*) firstChild;

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
 @param attName attribute name to set
 @param value value to set
 */
- (void) setAttribute:(NSString*)attName value:(NSString*)value;

/**
 @param attName attribute name to set
 @param ns namespace
 @param value value to set
 */
- (void) setAttribute:(NSString*)attName inNamespace:(NSString*)ns value:(NSString*)value;

/**
 @param attName attribute name to remove
 */
- (void) removeAttribute:(NSString*)attName;

/**
 @param attName attribute name to remove
 */
- (void) removeAttribute:(NSString*)attName inNamespace:(NSString*)ns;

/**
 subscript support
 */
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end