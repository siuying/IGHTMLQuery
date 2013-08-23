//
//  IGXMLNodeSet.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGXMLNodeManipulation.h"
#import "IGXMLNodeQuery.h"

@class IGXMLNode;

typedef void (^IGXMLNodeSetEnumerateBlock)(IGXMLNode* node, NSUInteger idx, BOOL *stop);

typedef void (^IGXMLNodeSetEachBlock)(IGXMLNode* node);

/**
 Array like construct allow chaining query
 */
@interface IGXMLNodeSet : NSObject <NSFastEnumeration, IGXMLNodeManipulation, IGXMLNodeQuery>

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

/**
 Append xml to the node, shorthand for [IGXMLNodeSet appendWithNode:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^append)(NSString*);

/**
 Prepend xml to the node, shorthand for [IGXMLNodeSet prependWithNode:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^prepend)(NSString*);

/**
 Add xml before the node, shorthand for [IGXMLNodeSet addPreviousSiblingWithNode:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^before)(NSString*);

/**
 Add xml after the node, shorthand for [IGXMLNodeSet addNextSiblingWithNode:]
 */
@property (nonatomic, copy, readonly) IGXMLNodeSet* (^after)(NSString*);

-(id) initWithNodes:(NSArray*)nodes;

+(id) nodeSetWithNodes:(NSArray*)nodes;

+(id) emptyNodeSet;

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

/**
 Enumerator
 */
-(void) enumerateNodesUsingBlock:(IGXMLNodeSetEnumerateBlock)block;

@end