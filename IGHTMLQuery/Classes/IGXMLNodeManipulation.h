//
//  IGXMLNodeManipulation.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGXMLNode;

@protocol IGXMLNodeManipulation <NSObject>

-(instancetype) appendWithNode:(IGXMLNode*)child;

-(instancetype) prependWithNode:(IGXMLNode*)child;

-(instancetype) addChildWithNode:(IGXMLNode*)child;

-(instancetype) addNextSiblingWithNode:(IGXMLNode*)child;

-(instancetype) addPreviousSiblingWithNode:(IGXMLNode*)child;

-(void) empty;

-(void) remove;

@end
