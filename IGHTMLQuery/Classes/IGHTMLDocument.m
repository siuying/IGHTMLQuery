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

- (id)initWithHTMLString:(NSString *)xmlString error:(NSError**)outError {
    return [self initWithHTMLData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] error:outError];
}

- (id)initWithHTMLFile:(NSString *)filename error:(NSError**)outError{
    NSString *fullPath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:filename];
    return [self initWithHTMLData:[NSData dataWithContentsOfFile:fullPath] error:outError];
}

- (id)initWithHTMLFile:(NSString *)filename fileExtension:(NSString*)extension error:(NSError**)outError{
    NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:extension];
    return [self initWithHTMLData:[NSData dataWithContentsOfFile:fullPath] error:outError];
}

- (id)initWithHTMLFilePath:(NSString *)fullPath error:(NSError**)outError{
    return [self initWithHTMLData:[NSData dataWithContentsOfFile:fullPath] error:outError];
}

- (id)initWithHTMLData:(NSData *)data error:(NSError**)outError{
    return [self initWithHTMLData:data forceEncoding:nil options:(HTML_PARSE_RECOVER | HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR | HTML_PARSE_NOIMPLIED | HTML_PARSE_NONET) error:outError];
}

- (id)initWithHTMLData:(NSData *)data forceEncoding:(NSString*)encoding options:(htmlParserOption)options error:(NSError**)outError{
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
