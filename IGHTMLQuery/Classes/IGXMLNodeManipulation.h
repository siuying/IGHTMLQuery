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

@protocol IGXMLNodeManipulation <IGHTMLQueryJavaScriptExport, NSObject>

-(instancetype) appendWithNode:(IGXMLNode*)child;

-(instancetype) prependWithNode:(IGXMLNode*)child;

-(instancetype) addChildWithNode:(IGXMLNode*)child;

-(instancetype) addNextSiblingWithNode:(IGXMLNode*)child;

-(instancetype) addPreviousSiblingWithNode:(IGXMLNode*)child;

-(instancetype) appendWithXMLString:(NSString*)xmlString;

-(instancetype) prependWithXMLString:(NSString*)xmlString;

-(instancetype) addChildWithXMLString:(NSString*)xmlString;

-(instancetype) addNextSiblingWithXMLString:(NSString*)xmlString;

-(instancetype) addPreviousSiblingWithXMLString:(NSString*)xmlString;

-(void) empty;

-(void) remove;

@end
