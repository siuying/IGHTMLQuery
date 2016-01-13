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
        } else {
            _nodes = [NSOrderedSet orderedSet];
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
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    IGXMLNodeSet* another = object;
    NSAssert(self.nodes != nil, @"self.nodes should never be nil");
    NSAssert(another.nodes != nil, @"another.nodes should never be nil");
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
    return [self.nodes array];
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
    NSParameterAssert(block);

    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        block(node, idx, stop);
    }];
}

#pragma mark - IGXMLNodeManipulation

-(instancetype) appendWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);

    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node appendWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) prependWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);

    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node prependWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) addChildWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);

    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node prependWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) addNextSiblingWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);

    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node addNextSiblingWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) addPreviousSiblingWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);

    NSMutableArray* newNodes = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        [newNodes addObject:[node addPreviousSiblingWithNode:child]];
    }];
    return [IGXMLNodeSet nodeSetWithNodes:newNodes];
}

-(instancetype) appendWithXMLString:(NSString*)xmlString {
    NSParameterAssert(xmlString);

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
    NSParameterAssert(xmlString);

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
    NSParameterAssert(xmlString);

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
    NSParameterAssert(xmlString);

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
    NSParameterAssert(xmlString);

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

- (IGXMLNodeSet*) queryWithCSS:(NSString*)cssSelector {
    NSMutableOrderedSet* nodes = [[NSMutableOrderedSet alloc] init];
    [self.nodes enumerateObjectsUsingBlock:^(IGXMLNode* node, NSUInteger idx, BOOL *stop) {
        IGXMLNodeSet* nodeSet = [node queryWithCSS:cssSelector];
        if (nodeSet && nodeSet.nodes) {
            [nodes unionOrderedSet:nodeSet.nodes];
        }
    }];
    return [[IGXMLNodeSet alloc] initWithNodes:[nodes array]];
}

- (IGXMLNodeSet*) query:(NSString*)xpathOrCssSelector {
    if ([xpathOrCssSelector hasPrefix:@"./"] || [xpathOrCssSelector hasPrefix:@"/"] || [xpathOrCssSelector hasPrefix:@"../"]) {
        return [self queryWithXPath:xpathOrCssSelector];
    } else {
        return [self queryWithCSS:xpathOrCssSelector];
    }
}

@end
