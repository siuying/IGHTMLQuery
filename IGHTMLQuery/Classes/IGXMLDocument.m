//
//  IGXMLDocument.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>
#import "IGXMLDocument.h"
#import <CSSSelectorConverter/CSSSelectorToXPathConverter.h>


@interface IGXMLDocument ()
@property (nonatomic, unsafe_unretained) xmlDocPtr doc;
@property (nullable, nonatomic, readwrite, unsafe_unretained) xmlNodePtr node;
@property (nonatomic, assign) BOOL shouldFreeNode;
@end

@implementation IGXMLDocument

- (id)initWithXMLString:(NSString *)xmlString error:(NSError**)outError{
    return [self initWithXMLData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] encoding:@"utf8" error:outError];
}

- (id)initWithXMLFilePath:(NSString *)fullPath encoding:(NSString*)encoding error:(NSError**)outError{
    return [self initWithXMLData:[NSData dataWithContentsOfFile:fullPath] encoding:encoding error:outError];
}

- (id)initWithXMLFile:(NSString *)filename encoding:(NSString*)encoding error:(NSError**)outError{
    NSString *fullPath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:filename];
    return [self initWithXMLData:[NSData dataWithContentsOfFile:fullPath] encoding:encoding error:outError];
}

- (id)initWithXMLResource:(NSString *)resource ofType:(NSString *)extension encoding:(NSString*)encoding error:(NSError**)outError{
    NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:resource ofType:extension];
    return [self initWithXMLData:[NSData dataWithContentsOfFile:fullPath] encoding:encoding error:outError];
}

- (id)initWithURL:(NSURL *)url encoding:(NSString*)encoding error:(NSError**)outError{
    return [self initWithXMLData:[NSData dataWithContentsOfURL:url] encoding:encoding error:outError];
}

- (id)initWithXMLData:(NSData *)data encoding:(NSString*)encoding error:(NSError**)outError {
    return [self initWithXMLData:data encoding:encoding options:XML_PARSE_RECOVER|XML_PARSE_NOBLANKS|XML_PARSE_NONET error:outError];
}

- (id)initWithXMLData:(NSData *)data encoding:(NSString*)encoding options:(int)options error:(NSError**)outError {
    if ((self = [super init])) {
        NSParameterAssert(data);

        _doc = xmlReadMemory([data bytes], (int)[data length], encoding ? [encoding UTF8String] : nil, nil, options);
        if (_doc) {
            xmlNodePtr root = xmlDocGetRootElement(_doc);
            if (root) {
                self.node = root;
                self.shouldFreeNode = YES;
            } else {
                xmlFreeDoc(_doc);
                _doc = nil;
            }
        }

        // error handling
        if (!_doc || !self.node){
            if (outError) {
                *outError = [self lastError];
            }
            self = nil;
        }
    }
    return self;
}

- (IGXMLNodeSet*) queryWithCSS:(NSString*)cssSelector {
    NSError* cssError = nil;
    NSString* xpath = [[[self class] cssConverter] xpathWithCSS:cssSelector error:&cssError];
    if (!xpath) {
        if (cssError) {
            [NSException raise:IGXMLQueryCSSConversionException format:@"Cannot convert CSS into XPath: %@", [cssError localizedDescription]];
        } else {
            [NSException raise:IGXMLQueryCSSConversionException format:@"Cannot convert CSS into XPath: unknown error"];
        }
    }
    return [self queryWithXPath:xpath];
}

#pragma mark - Lifecycle

-(void) dealloc {
    if (_doc && _shouldFreeNode) {
        xmlFreeDoc(_doc);
        _doc = nil;
        self.node = nil;
    }
}

#pragma mark - Override super class

/**
 Get the root node of the node, which is always itself.
 */
-(IGXMLDocument*) root {
    return self;
}

@end
