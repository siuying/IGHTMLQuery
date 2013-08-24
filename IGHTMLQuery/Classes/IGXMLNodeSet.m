//
//  IGXMLNodeSet.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "IGXMLNodeSet.h"
#import "IGXMLNode.h"
#import "IGXMLDocument.h"

@interface IGXMLNodeSet()
@property (nonatomic, copy) NSOrderedSet* nodes;
@end

@implementation IGXMLNodeSet

-(id) initWithNodes:(NSArray*)nodes {
    self = [super init];
    if (self) {
        if (nodes) {
            _nodes = [NSOrderedSet orderedSetWithArray:nodes];
        }
    }
    return self;
}

+(id) nodeSetWithNodes:(NSArray*)nodes {
    return [[self alloc] initWithNodes:nodes];
}

+(id) emptyNodeSet {
    return [[self alloc] initWithNodes:nil];
}

-(NSUInteger) count {
    return [_nodes count];
}

- (BOOL) isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    IGXMLNodeSet* another = object;
    if (self.nodes == nil && another.nodes == nil)  {
        return YES;
    }

    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self.nodes isEqual:another.nodes];
}

- (NSUInteger)hash {
    return self.nodes.hash;
}

#pragma NSFastEnumeration -

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.nodes countByEnumeratingWithState:state objects:buffer count:len];
}

-(NSArray *) allObjects {
    if (self.nodes) {
        return [self.nodes array];
    } else {
        return @[];
    }
}

-(IGXMLNode*) firstObject {
    if ([self.nodes count] > 0) {
        return self.nodes[0];
    } else {
        return nil;
    }
}

#pragma mark -

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self.nodes objectAtIndexedSubscript:idx];
}

-(void) enumerateNodesUsingBlock:(IGXMLNodeSetEnumerateBlock)block {
    [[self.nodes reversedOrderedSet] enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        block(node, idx, stop);
    }];
}

#pragma mark - IGXMLNodeManipulation

-(instancetype) appendWithNode:(IGXMLNode*)child {
    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node appendWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) prependWithNode:(IGXMLNode*)child {
    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node prependWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) addChildWithNode:(IGXMLNode*)child {
    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node prependWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) addNextSiblingWithNode:(IGXMLNode*)child {
    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node addNextSiblingWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) addPreviousSiblingWithNode:(IGXMLNode*)child {
    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node addPreviousSiblingWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) appendWithXMLString:(NSString*)xmlString {
    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self appendWithNode:node];
    } else {
        return nil;
    }
}

-(instancetype) prependWithXMLString:(NSString*)xmlString {
    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self prependWithNode:node];
    } else {
        return [IGXMLNodeSet emptyNodeSet];
    }
}

-(instancetype) addChildWithXMLString:(NSString*)xmlString {
    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self addChildWithNode:node];
    } else {
        return [IGXMLNodeSet emptyNodeSet];
    }
}

-(instancetype) addNextSiblingWithXMLString:(NSString*)xmlString {
    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self addNextSiblingWithNode:node];
    } else {
        return [IGXMLNodeSet emptyNodeSet];
    }
}

-(instancetype) addPreviousSiblingWithXMLString:(NSString*)xmlString {
    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self addPreviousSiblingWithNode:node];
    } else {
        return [IGXMLNodeSet emptyNodeSet];
    }
}

-(void) empty {
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [node empty];
    }];
}

-(void) remove {
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [node remove];
    }];
}

#pragma mark - Query

- (IGXMLNodeSet*) queryWithXPath:(NSString*)xpath {
    NSMutableOrderedSet* nodes = [[NSMutableOrderedSet alloc] init];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        IGXMLNodeSet* nodeSet = [node queryWithXPath:xpath];
        if (nodeSet && nodeSet.nodes) {
            [nodes unionOrderedSet:nodeSet.nodes];
        }
    }];
    return [[IGXMLNodeSet alloc] initWithNodes:[nodes array]];
}

@end
