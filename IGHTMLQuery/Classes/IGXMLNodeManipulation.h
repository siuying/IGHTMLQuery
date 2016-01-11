//
//  IGXMLNodeManipulation.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IGHTMLQueryJavaScriptExport.h"

@class IGXMLNode;

@protocol IGXMLNodeManipulation <IGHTMLQueryJavaScriptExport>

-(nullable instancetype) appendWithNode:(nonnull IGXMLNode*)child;

-(nullable instancetype) prependWithNode:(nonnull IGXMLNode*)child;

-(nullable instancetype) addChildWithNode:(nonnull IGXMLNode*)child;

-(nullable instancetype) addNextSiblingWithNode:(nonnull IGXMLNode*)child;

-(nullable instancetype) addPreviousSiblingWithNode:(nonnull IGXMLNode*)child;

-(nullable instancetype) appendWithXMLString:(nonnull NSString*)xmlString;

-(nullable instancetype) prependWithXMLString:(nonnull NSString*)xmlString;

-(nullable instancetype) addChildWithXMLString:(nonnull NSString*)xmlString;

-(nullable instancetype) addNextSiblingWithXMLString:(nonnull NSString*)xmlString;

-(nullable instancetype) addPreviousSiblingWithXMLString:(nonnull NSString*)xmlString;

-(void) empty;

-(void) remove;

@end
