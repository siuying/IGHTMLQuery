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

- (id)initWithHTMLString:(NSString *)xmlString error:(NSError**)outError;

- (id)initWithHTMLFile:(NSString *)filename error:(NSError**)outError;

- (id)initWithHTMLFile:(NSString *)filename fileExtension:(NSString*)extension error:(NSError**)outError;

- (id)initWithHTMLFilePath:(NSString *)fullPath error:(NSError**)outError;

- (id)initWithHTMLData:(NSData *)data error:(NSError**)outError;

- (id)initWithHTMLData:(NSData *)data forceEncoding:(NSString*)encoding options:(htmlParserOption)options error:(NSError**)outError;

@end
