//
//  IGXMLNodeSet.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGXMLNode;

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

-(id) initWithNodes:(NSArray*)nodes;

-(IGXMLNodeSet*) appendWithSet:(IGXMLNodeSet*)set;

-(NSUInteger) count;

-(NSArray *) allObjects;

-(IGXMLNode*) firstObject;

-(id) objectAtIndexedSubscript:(NSUInteger)idx;

@end

@interface IGXMLNodeSet (Query)

- (IGXMLNodeSet*) queryWithXPath:(NSString*)xpath;

@end