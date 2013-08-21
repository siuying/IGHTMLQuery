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
@end

@implementation IGXMLDocument

- (id)initWithXMLString:(NSString *)xmlString error:(NSError**)outError{
    return [self initWithXMLData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] error:outError];
}

- (id)initWithXMLFilePath:(NSString *)fullPath error:(NSError**)outError{
    return [self initWithXMLData:[NSData dataWithContentsOfFile:fullPath] error:outError];
}

- (id)initWithXMLFile:(NSString *)filename error:(NSError**)outError{
    NSString *fullPath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:filename];
    return [self initWithXMLData:[NSData dataWithContentsOfFile:fullPath] error:outError];
}

- (id)initWithXMLFile:(NSString *)filename fileExtension:(NSString *)extension error:(NSError**)outError{
    NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:extension];
    return [self initWithXMLData:[NSData dataWithContentsOfFile:fullPath] error:outError];
}

- (id)initWithURL:(NSURL *)url error:(NSError**)outError{
    return [self initWithXMLData:[NSData dataWithContentsOfURL:url] error:outError];
}

- (id)initWithXMLData:(NSData *)data error:(NSError**)outError {
    return [self initWithXMLData:data forceEncoding:nil options:XML_PARSE_RECOVER|XML_PARSE_NOBLANKS error:outError];
}

- (id)initWithXMLData:(NSData *)data forceEncoding:(NSString*)encoding options:(xmlParserOption)options error:(NSError**)outError {
    if ((self = [super init])) {
        _doc = xmlReadMemory([data bytes], (int)[data length], encoding ? [encoding UTF8String] : nil, nil, options);
        if (_doc) {
            self.node = xmlDocGetRootElement(_doc);
            if (!self.node) {
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
    self.node = nil;
}

#pragma mark - Override super class

/**
 Get the root node of the node, which is always itself.
 */
-(IGXMLDocument*) root {
    return self;
}

@end
