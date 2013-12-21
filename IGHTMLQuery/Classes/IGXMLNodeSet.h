//
//  IGXMLNodeSet.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGHTMLQueryJavaScriptExport.h"
#import "IGXMLNodeManipulation.h"
#import "IGXMLNodeQuery.h"

@class IGXMLNode;

typedef void (^IGXMLNodeSetEnumerateBlock)(IGXMLNode* node, NSUInteger idx, BOOL *stop);

typedef void (^IGXMLNodeSetEachBlock)(IGXMLNode* node);

@protocol IGXMLNodeSetCore <IGHTMLQueryJavaScriptExport, NSObject>

/**
 nodes in this node set
 */
@property (nonatomic, copy, readonly) NSOrderedSet* nodes;

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
 Enumerator
 */
-(void) enumerateNodesUsingBlock:(IGXMLNodeSetEnumerateBlock)block;

@end

/**
 Array like construct allow chaining query
 */
@interface IGXMLNodeSet : NSObject <NSFastEnumeration, IGXMLNodeSetCore, IGXMLNodeManipulation, IGXMLNodeQuery>

-(id) initWithNodes:(NSArray*)nodes;

+(id) nodeSetWithNodes:(NSArray*)nodes;

+(id) emptyNodeSet;

/**
 @return add support of subscript syntax.
 */
-(id) objectAtIndexedSubscript:(NSUInteger)idx;

@end