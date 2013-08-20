//
//  IGXMLDocument.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>
#import <libxml2/libxml/HTMLparser.h>

#import "IGXMLDocument.h"

@interface IGXMLDocument () {
    xmlDocPtr _doc;
}
@end

@implementation IGXMLDocument

- (id)initFromXMLString:(NSString *)xmlString encoding:(NSStringEncoding)encoding {
    return [self initFromXMLData:[xmlString dataUsingEncoding:encoding]];
}

- (id)initFromXMLFilePath:(NSString *)fullPath {
    return [self initFromXMLData:[NSData dataWithContentsOfFile:fullPath]];
}

- (id)initFromXMLFile:(NSString *)filename {
    NSString *fullPath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:filename];
    return [self initFromXMLFilePath:fullPath];
}

- (id)initFromXMLFile:(NSString *)filename fileExtension:(NSString *)extension {
    NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:extension];
    return [self initFromXMLData:[NSData dataWithContentsOfFile:fullPath]];
}

- (id)initFromURL:(NSURL *)url {
    return [self initFromXMLData:[NSData dataWithContentsOfURL:url]];
}

- (id)initFromXMLData:(NSData *)data {
    if ((self = [super init])) {
        _doc = xmlReadMemory([data bytes], (int)[data length], "", nil, XML_PARSE_RECOVER | XML_PARSE_NOBLANKS);
        if (_doc) {
            _node = xmlDocGetRootElement(_doc);
            if (!_node) {
                _doc = nil;
            }
        }
    }
    return self;
}

#pragma mark - Lifecycle

-(void) dealloc {
    if (_doc) {
        xmlFreeDoc(_doc);
    }
    _doc = nil;
    _node = nil;
}

#pragma mark - Override super class

/**
 Get the root node of the node, which is always itself.
 */
-(IGXMLDocument*) root {
    return self;
}

@end
