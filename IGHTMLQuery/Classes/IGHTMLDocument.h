//
//  IGHTMLDocument.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <libxml2/libxml/HTMLparser.h>

#import "IGXMLDocument.h"

@interface IGHTMLDocument : IGXMLDocument

- (id)initFromHTMLString:(NSString *)xmlString encoding:(NSStringEncoding)encoding;

- (id)initFromHTMLFile:(NSString *)filename;

- (id)initFromHTMLFile:(NSString *)filename fileExtension:(NSString*)extension;

- (id)initFromHTMLFilePath:(NSString *)fullPath;

- (id)initFromHTMLData:(NSData *)data;

- (id)initFromHTMLData:(NSData *)data forceEncoding:(NSString*)encoding options:(htmlParserOption)options;

@end
