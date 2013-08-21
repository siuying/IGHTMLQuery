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

- (id)initFromXMLString:(NSString *)xmlString encoding:(NSStringEncoding)encoding;

- (id)initFromXMLFilePath:(NSString *)fullPath;

- (id)initFromXMLFile:(NSString *)filename;

- (id)initFromXMLFile:(NSString *)filename fileExtension:(NSString *)extension;

- (id)initFromURL:(NSURL *)url;

- (id)initFromXMLData:(NSData *)data;

@end
