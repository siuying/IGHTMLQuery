//
//  IGHTMLDocument.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "IGHTMLDocument.h"

@interface IGHTMLDocument ()
@property (nonatomic, unsafe_unretained) xmlDocPtr doc;
@end

@implementation IGHTMLDocument

- (id)initFromHTMLString:(NSString *)xmlString encoding:(NSStringEncoding)encoding {
    return [self initFromHTMLData:[xmlString dataUsingEncoding:encoding]];
}

- (id)initFromHTMLFile:(NSString *)filename {
    NSString *fullPath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:filename];
    return [self initFromHTMLData:[NSData dataWithContentsOfFile:fullPath]];
}

- (id)initFromHTMLFile:(NSString *)filename fileExtension:(NSString*)extension {
    NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:extension];
    return [self initFromHTMLData:[NSData dataWithContentsOfFile:fullPath]];
}

- (id)initFromHTMLFilePath:(NSString *)fullPath {
    return [self initFromHTMLData:[NSData dataWithContentsOfFile:fullPath]];
}

- (id)initFromHTMLData:(NSData *)data {
    return [self initFromHTMLData:data forceEncoding:nil options:(HTML_PARSE_RECOVER | HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR | HTML_PARSE_NOIMPLIED)];
}

- (id)initFromHTMLData:(NSData *)data forceEncoding:(NSString*)encoding options:(htmlParserOption)options {
    if ((self = [super init])) {
        xmlKeepBlanksDefault(false);

        self.doc = htmlReadMemory([data bytes], (int)[data length], "", encoding ? [encoding UTF8String] : nil, options);
        if (self.doc) {
            self.node = xmlDocGetRootElement(self.doc);
            if (!self.node) {
                self.doc = nil;
            }
        }
    }
    return self;
}

@end
