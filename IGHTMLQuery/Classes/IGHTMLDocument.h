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

- (id)initWithHTMLFile:(NSString *)filename encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithHTMLResource:(NSString *)filename ofType:(NSString*)extension encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithHTMLFilePath:(NSString *)fullPath encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithHTMLData:(NSData *)data encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithHTMLData:(NSData *)data encoding:(NSString*)encoding options:(htmlParserOption)options error:(NSError**)outError;

@end
