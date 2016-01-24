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
#import "IGHTMLQueryJavaScriptExport.h"

@interface IGXMLDocument : IGXMLNode <IGHTMLQueryJavaScriptExport>

@property (nullable, nonatomic, readonly, unsafe_unretained) xmlDocPtr doc;

- (nullable id)initWithXMLString:(nonnull NSString *)xmlString error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithXMLFilePath:(nonnull NSString *)fullPath encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithXMLFile:(nonnull NSString *)filename encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithXMLResource:(nonnull NSString *)resource ofType:(nonnull NSString *)extension encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithURL:(nonnull NSURL *)url encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithXMLData:(nonnull NSData *)data encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithXMLData:(nonnull NSData *)data encoding:(nonnull NSString*)encoding options:(xmlParserOption)options error:(NSError * _Nullable * _Nullable)outError;

@end
