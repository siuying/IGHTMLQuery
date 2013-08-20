//
//  IGXMLNodeSet.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "IGXMLNodeSet.h"

@interface IGXMLNodeSet()
@property (nonatomic, copy) NSOrderedSet* nodes;
@end

@implementation IGXMLNodeSet

-(id) initWithNodes:(NSArray*)nodes {
    self = [super init];
    if (self) {
        _nodes = [NSOrderedSet orderedSetWithArray:nodes];
    }
    return self;
}

-(NSUInteger) count {
    return [_nodes count];
}

#pragma NSFastEnumeration -

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.nodes countByEnumeratingWithState:state objects:buffer count:len];
}

@end