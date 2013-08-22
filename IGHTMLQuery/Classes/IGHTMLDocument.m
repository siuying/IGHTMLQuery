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
@property (nonatomic, assign) BOOL shouldFreeNode;
@end

@implementation IGHTMLDocument

- (id)initWithHTMLString:(NSString *)xmlString error:(NSError**)outError {
    return [self initWithHTMLData:[xmlString dataUsingEncoding:NSUTF8StringEncoding] encoding:@"utf8" error:outError];
}

- (id)initWithHTMLFile:(NSString *)filename encoding:(NSString*)encoding error:(NSError**)outError{
    NSString *fullPath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:filename];
    return [self initWithHTMLData:[NSData dataWithContentsOfFile:fullPath] encoding:encoding error:outError];
}

- (id)initWithHTMLResource:(NSString *)resource ofType:(NSString*)extension encoding:(NSString*)encoding error:(NSError**)outError{
    NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:resource ofType:extension];
    return [self initWithHTMLData:[NSData dataWithContentsOfFile:fullPath] encoding:encoding error:outError];
}

- (id)initWithHTMLFilePath:(NSString *)fullPath encoding:(NSString*)encoding error:(NSError**)outError{
    return [self initWithHTMLData:[NSData dataWithContentsOfFile:fullPath] encoding:encoding error:outError];
}

- (id)initWithHTMLData:(NSData *)data encoding:(NSString*)encoding error:(NSError**)outError{
    return [self initWithHTMLData:data encoding:encoding options:(HTML_PARSE_RECOVER | HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR | HTML_PARSE_NOIMPLIED | HTML_PARSE_NONET) error:outError];
}

- (id)initWithHTMLData:(NSData *)data encoding:(NSString*)encoding options:(htmlParserOption)options error:(NSError**)outError{
    if ((self = [super init])) {
        xmlKeepBlanksDefault(false);

        self.doc = htmlReadMemory([data bytes], (int)[data length], "", encoding ? [encoding UTF8String] : nil, options);
        if (self.doc) {
            xmlNodePtr root = xmlDocGetRootElement(self.doc);
            if (root) {
                self.node = root;
                self.shouldFreeNode = NO;
            } else {
                xmlFreeDoc(self.doc);
                self.doc = nil;
            }
        }

        // error handling
        if (!self.doc || !self.node){
            if (outError) {
                *outError = [self lastError];
            }
            self = nil;
        }
    }
    return self;
}

-(void) dealloc {
    if (self.doc) {
        xmlFreeDoc(self.doc);
    }
    self.doc = nil;
}

@end
