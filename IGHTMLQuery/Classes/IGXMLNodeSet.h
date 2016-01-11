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

typedef void (^IGXMLNodeSetEnumerateBlock)(IGXMLNode* _Nonnull node, NSUInteger idx, BOOL* _Nullable stop);

typedef void (^IGXMLNodeSetEachBlock)(IGXMLNode* _Nonnull node);

@protocol IGXMLNodeSetCore <IGHTMLQueryJavaScriptExport>

/**
 nodes in this node set
 */
@property (nullable, nonatomic, copy, readonly) NSOrderedSet* nodes;

/**
 @return number of nodes in the set
 */
-(NSUInteger) count;

/**
 @return return an array of all objects in the node set.
 */
-(nonnull NSArray *) allObjects;

/**
 @return return first object in the node set.
 */
-(nullable IGXMLNode*) firstObject;

/**
 Enumerator
 */
-(void) enumerateNodesUsingBlock:(nonnull IGXMLNodeSetEnumerateBlock)block;

@end

/**
 Array like construct allow chaining query
 */
@interface IGXMLNodeSet : NSObject <NSFastEnumeration, IGXMLNodeSetCore, IGXMLNodeManipulation, IGXMLNodeQuery>

-(nullable id) initWithNodes:(nullable NSArray*)nodes;

+(nullable id) nodeSetWithNodes:(nullable NSArray*)nodes;

+(nullable id) emptyNodeSet;

/**
 @return add support of subscript syntax.
 */
-(nonnull id) objectAtIndexedSubscript:(NSUInteger)idx;

@end