//
//  IGXMLDocument.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>

#import <Foundation/Foundation.h>
#import "IGXMLNode.h"

@interface IGXMLDocument : IGXMLNode

@property (nonatomic, readonly, unsafe_unretained) xmlDocPtr doc;

- (id)initWithXMLString:(NSString *)xmlString error:(NSError**)outError;

- (id)initWithXMLFilePath:(NSString *)fullPath encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithXMLFile:(NSString *)filename encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithXMLResource:(NSString *)resource ofType:(NSString *)extension encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithURL:(NSURL *)url encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithXMLData:(NSData *)data encoding:(NSString*)encoding error:(NSError**)outError;

- (id)initWithXMLData:(NSData *)data encoding:(NSString*)encoding options:(xmlParserOption)options error:(NSError**)outError;

@end
