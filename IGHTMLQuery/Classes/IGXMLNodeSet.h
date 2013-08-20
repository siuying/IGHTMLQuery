//
//  IGXMLNodeSet.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Array like construct allow chaining query
 */
@interface IGXMLNodeSet : NSObject <NSFastEnumeration>

@property (nonatomic, copy, readonly) NSOrderedSet* nodes;

-(id) initWithNodes:(NSArray*)nodes;

-(NSUInteger) count;

@end
