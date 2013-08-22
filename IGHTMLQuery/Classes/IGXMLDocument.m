//
//  IGXMLDocument.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "IGXMLDocument.h"

@interface IGXMLDocument ()
@property (nonatomic, unsafe_unretained) xmlDocPtr doc;
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
    if (!data) {
        if (outError) {
            *outError = [NSError errorWithDomain:IGXMLQueryErrorDomain code:0 userInfo:@{@"reason": @"data cannot be nil"}];
        }
        return nil;
    }
    return [self initWithXMLData:data encoding:encoding options:XML_PARSE_RECOVER|XML_PARSE_NOBLANKS|XML_PARSE_NONET error:outError];
}

- (id)initWithXMLData:(NSData *)data encoding:(NSString*)encoding options:(xmlParserOption)options error:(NSError**)outError {
    if ((self = [super init])) {
        _doc = xmlReadMemory([data bytes], (int)[data length], encoding ? [encoding UTF8String] : nil, nil, options);
        if (_doc) {
            xmlNodePtr root = xmlDocGetRootElement(_doc);
            if (root) {
                self.node = root;
                self.shouldFreeNode = NO;
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

#pragma mark - Lifecycle

-(void) dealloc {
    if (_doc) {
        xmlFreeDoc(_doc);
    }
    _doc = nil;
}

#pragma mark - Override super class

/**
 Get the root node of the node, which is always itself.
 */
-(IGXMLDocument*) root {
    return self;
}

@end
