//
//  JSContext+IGHTMLQueryRubyAdditions.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/31/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "JSContext+IGHTMLQueryRubyAdditions.h"
#import "JSContext+OpalAdditions.h"
#import "IGXMLNode.h"

@implementation JSContext (IGHTMLQueryRubyAdditions)

-(void) configureIGHTMLQuery {
    [self configureIGHTMLQueryWithFilename:@"xml_node"];
    [self configureIGHTMLQueryWithFilename:@"xml_node_set"];
}

-(void) configureIGHTMLQueryWithFilename:(NSString*)name {
    NSString* filename = [[NSBundle bundleForClass:[IGXMLNode class]] pathForResource:name ofType:@"rb"];
    NSString* script = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    [self evaluateRuby:script];
}

@end
