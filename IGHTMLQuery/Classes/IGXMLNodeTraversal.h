//
//  IGXMLNodeTraversal.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/21/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGHTMLQueryJavaScriptExport.h"

@class IGXMLNode;
@class IGXMLNodeSet;

@protocol IGXMLNodeTraversal <IGHTMLQueryJavaScriptExport, NSObject>

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

/**
 @return It returns a key guaranteed to be unique for this node, and to always be the same value for this node. In other words, two node objects return the same key if and only if isSameNode indicates that they are the same node.
 */
- (NSString*) uniqueKey;

@end
