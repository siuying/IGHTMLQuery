//
//  IGXMLNodeSet.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGXMLNode;

typedef void (^IGXMLNodeSetEnumerateBlock)(IGXMLNode* node, NSUInteger idx, BOOL *stop);

typedef void (^IGXMLNodeSetEachBlock)(IGXMLNode* node);

/**
 Array like construct allow chaining query
 */
@interface IGXMLNodeSet : NSObject <NSFastEnumeration>

/**
 nodes in this node set
 */
@property (nonatomic, copy, readonly) NSOrderedSet* nodes;

/**
 Shorthand for [IGXMLNodeSet queryWithXPath:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^query)(NSString*);

/**
 Shorthand for [IGXMLNodeSet enumerateNodessUsingBlock:]
 */
@property (nonatomic, copy, readonly) void (^each)(IGXMLNodeSetEachBlock);

-(id) initWithNodes:(NSArray*)nodes;

/**
 @return number of nodes in the set
 */
-(NSUInteger) count;

/**
 @return return an array of all objects in the node set.
 */
-(NSArray *) allObjects;

/**
 @return return first object in the node set.
 */
-(IGXMLNode*) firstObject;

/**
 @return add support of subscript syntax.
 */
-(id) objectAtIndexedSubscript:(NSUInteger)idx;

-(void) enumerateNodesUsingBlock:(IGXMLNodeSetEnumerateBlock)block;

@end

@interface IGXMLNodeSet (Query)

/**
 Query set of nodes with XPath
 @param xpath used to query the nodes.
 @return elements matched by supplied XPath query on the node set.
 */
- (IGXMLNodeSet*) queryWithXPath:(NSString*)xpath;

@end