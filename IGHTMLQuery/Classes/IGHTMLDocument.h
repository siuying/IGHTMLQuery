//
//  IGHTMLDocument.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 21/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <libxml2/libxml/HTMLparser.h>

#import "IGXMLDocument.h"
#import "IGHTMLQueryJavaScriptExport.h"

@interface IGHTMLDocument : IGXMLDocument <IGHTMLQueryJavaScriptExport>

- (nullable id)initWithHTMLString:(nonnull NSString *)xmlString error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithHTMLFragmentString:(nonnull NSString *)xmlString error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithHTMLFile:(nonnull NSString *)filename encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithHTMLResource:(nonnull NSString *)filename ofType:(nonnull NSString*)extension encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithHTMLFilePath:(nonnull NSString *)fullPath encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithHTMLData:(nonnull NSData *)data encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithHTMLFragmentData:(nonnull NSData *)data encoding:(nonnull NSString*)encoding error:(NSError * _Nullable * _Nullable)outError;

- (nullable id)initWithHTMLData:(nonnull NSData *)data encoding:(nonnull NSString*)encoding options:(htmlParserOption)options error:(NSError * _Nullable * _Nullable)outError;

@end
