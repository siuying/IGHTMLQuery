//
//  IGXMLNode.m
//  IGHTMLQuery
//
//  Created by Francis Chong on 20/8/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import "IGXMLNode.h"
#import "IGXMLDocument.h"
#import "IGHTMLDocument.h"
#import "CSSSelectorConverter.h"
#import <libxml2/libxml/HTMLtree.h>

NSString* const IGXMLQueryErrorDomain   = @"IGHTMLQueryError";
NSString* const IGXMLNodeException      = @"IGXMLNodeException";
NSString* const IGXMLQueryCSSConversionException = @"IGXMLQueryCSSConversionException";
static NSString* const CSSSelectorToXPathConverterCacheKey = @"CSSSelectorToXPathConverter";

/**
 * extracted from Nokigiri
 * @see https://github.com/sparklemotion/nokogiri/blob/master/ext/nokogiri/xml_document.c
 */
static void recursively_remove_namespaces_from_node(xmlNodePtr node)
{
    xmlNodePtr child ;
    xmlAttrPtr property ;
    xmlSetNs(node, NULL);
    
    for (child = node->children ; child ; child = child->next)
        recursively_remove_namespaces_from_node(child);
    
    if (((node->type == XML_ELEMENT_NODE) ||
         (node->type == XML_XINCLUDE_START) ||
         (node->type == XML_XINCLUDE_END)) &&
        node->nsDef) {
        xmlFreeNsList(node->nsDef);
        node->nsDef = NULL;
    }
    
    if (node->type == XML_ELEMENT_NODE && node->properties != NULL) {
        property = node->properties ;
        while (property != NULL) {
            if (property->ns) property->ns = NULL ;
            property = property->next ;
        }
    }
}

@interface IGXMLNode ()
@property (nonatomic, assign) BOOL removed;
@property (nonatomic, assign) BOOL shouldFreeNode;
- (id)initWithXMLNode:(xmlNodePtr)node shouldFreeNode:(BOOL)shouldFreeNode;
+ (id)nodeWithXMLNode:(xmlNodePtr)node shouldFreeNode:(BOOL)shouldFreeNode;
@end

@implementation IGXMLNode

- (id)initWithXMLNode:(xmlNodePtr)node {
    return [self initWithXMLNode:node shouldFreeNode:NO];
}

- (id)initWithXMLNode:(xmlNodePtr)node shouldFreeNode:(BOOL)shouldFreeNode {
    if ((self = [super init])) {
        NSParameterAssert(node);
        _shouldFreeNode = shouldFreeNode;
        _node = node;
        _removed = false;
    }
    return self;
}

+ (id)nodeWithXMLNode:(xmlNodePtr)node {
    return [self nodeWithXMLNode:node shouldFreeNode:NO];
}

+ (id)nodeWithXMLNode:(xmlNodePtr)node shouldFreeNode:(BOOL)shouldFreeNode {
    return [[self alloc] initWithXMLNode:node shouldFreeNode:shouldFreeNode];
}

-(void) dealloc {
    if (_node && _shouldFreeNode) {
        xmlFreeNode(_node);
        _shouldFreeNode = NO;
        _node = nil;
    }
}

#pragma mark -

- (NSString *)tag {
    NSAssert(!_removed, @"cannot access a removed node");

    if (_node && _node->name) {
        return [NSString stringWithUTF8String:(const char *)_node->name];
    } else {
        return nil;
    }
}

- (void)setTag:(NSString*)tag {
    NSParameterAssert(tag);
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodeSetName(_node, (xmlChar*) [tag cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)text {
    NSAssert(!_removed, @"cannot access a removed node");

    xmlChar *key = xmlNodeGetContent(_node);
    NSString *text = (key ? [NSString stringWithUTF8String:(const char *)key] : @"");
    xmlFree(key);
    return text;
}

- (void) setText:(NSString*) text {
    NSParameterAssert(text);
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodeSetContent(_node, (xmlChar*) [text cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)xml {
    NSAssert(!_removed, @"cannot access a removed node");

    xmlBufferPtr buffer = xmlBufferCreate();
    xmlNodeDump(buffer, self.node->doc, self.node, 0, false);
    NSString *text = [NSString stringWithUTF8String:(const char *)xmlBufferContent(buffer)];
    xmlBufferFree(buffer);
    return text;
}

- (NSString *)html {
    NSAssert(!_removed, @"cannot access a removed node");

    xmlBufferPtr buffer = xmlBufferCreate();
    htmlNodeDump(buffer, self.node->doc, self.node);
    NSString *text = [NSString stringWithUTF8String:(const char *)xmlBufferContent(buffer)];
    xmlBufferFree(buffer);
    return text;
}

- (NSString *)innerXml {
    NSAssert(!_removed, @"cannot access a removed node");

    NSMutableString* innerXml = [NSMutableString string];
    xmlNodePtr cur = self.node->children;
    
    while (cur != nil) {
        if (cur->type == XML_TEXT_NODE) {
            xmlChar *key = xmlNodeGetContent(cur);
            NSString *text = (key ? [NSString stringWithUTF8String:(const char *)key] : @"");
            xmlFree(key);
            [innerXml appendString:text];
        } else {
            xmlBufferPtr buffer = xmlBufferCreate();
            xmlNodeDump(buffer, self.node->doc, cur, 0, false);
            NSString *text = [NSString stringWithUTF8String:(const char *)xmlBufferContent(buffer)];
            xmlBufferFree(buffer);
            [innerXml appendString:text];
        }
        cur = cur->next;
    }
    return innerXml;
}

- (NSString *)innerHtml {
    NSAssert(!_removed, @"cannot access a removed node");

    NSMutableString* innerHtml = [NSMutableString string];
    xmlNodePtr cur = self.node->children;
    
    while (cur != nil) {
        if (cur->type == XML_TEXT_NODE) {
            xmlChar *key = xmlNodeGetContent(cur);
            NSString *text = (key ? [NSString stringWithUTF8String:(const char *)key] : @"");
            xmlFree(key);
            [innerHtml appendString:text];
        } else {
            xmlBufferPtr buffer = xmlBufferCreate();
            htmlNodeDump(buffer, self.node->doc, cur);
            NSString *text = [NSString stringWithUTF8String:(const char *)xmlBufferContent(buffer)];
            xmlBufferFree(buffer);
            [innerHtml appendString:text];
        }
        cur = cur->next;
    }
    return innerHtml;
}

- (NSError*) lastError {
    xmlErrorPtr error = xmlGetLastError();
    if (error) {
        NSDictionary* userInfo = @{
                                   @"domain": [NSString stringWithFormat:@"%i", error->domain],
                                   @"code": [NSString stringWithFormat:@"%i", error->code],
                                   @"message": error->message ? [NSString stringWithCString:error->message encoding:NSUTF8StringEncoding] : @"",
                                   @"file": error->file ? [NSString stringWithCString:error->file encoding:NSUTF8StringEncoding] : @"",
                                   @"line": [NSString stringWithFormat:@"%i", error->line],
                                   @"column": [NSString stringWithFormat:@"%i", error->int2]
                                   };
        return [NSError errorWithDomain:IGXMLQueryErrorDomain code:error->code userInfo:userInfo];
    } else {
        return nil;
    }
}

- (void)removeNamespaces {
    NSAssert(!_removed, @"cannot access a removed node");

    recursively_remove_namespaces_from_node(self.node);
}

-(id)copyWithZone:(NSZone *)zone{
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr newNode = xmlCopyNode(_node, 1);
    return [IGXMLNode nodeWithXMLNode:newNode shouldFreeNode:YES];
}

#pragma mark - Traversal

- (IGXMLNode *) parent {
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr parent = _node->parent;
    if (!parent) {
        return nil;
    } else {
        return [IGXMLNode nodeWithXMLNode:parent];
    }
}

- (IGXMLNode *) nextSibling {
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr sibling = xmlNextElementSibling(_node);
    if (!sibling) {
        return nil;
    } else {
        return [IGXMLNode nodeWithXMLNode:sibling];
    }
}

- (IGXMLNode *) previousSibling {
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr sibling = xmlPreviousElementSibling(_node);
    if (!sibling) {
        return nil;
    } else {
        return [IGXMLNode nodeWithXMLNode:sibling];
    }
}

- (IGXMLNodeSet *)children {
    NSAssert(!_removed, @"cannot access a removed node");

    NSMutableArray* children = [NSMutableArray array];
    xmlNodePtr cur = _node->children;
    
    while (cur != nil) {
        if (cur->type == XML_ELEMENT_NODE) {
            [children addObject:[IGXMLNode nodeWithXMLNode:cur]];
        }
        cur = cur->next;
    }
    
    return [[IGXMLNodeSet alloc] initWithNodes:children];
}

-(IGXMLNode*) firstChild {
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr cur = xmlFirstElementChild(_node);
    if (cur != nil) {
        return [IGXMLNode nodeWithXMLNode:cur];
    }
    
    return nil;
}

- (NSString*) uniqueKey {
    NSAssert(!_removed, @"cannot access a removed node");

    return [NSString stringWithFormat:@"%x", (int) self.node];
}

- (BOOL) isEqual:(id)object {
    NSAssert(!_removed, @"cannot access a removed node");

    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    IGXMLNode* another = object;
    return another.node == self.node;
}

- (NSUInteger)hash {
    NSAssert(!_removed, @"cannot access a removed node");

    return (NSUInteger) self.node;
}

#pragma mark - IGXMLNodeManipulation

-(instancetype) appendWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr newNode = xmlDocCopyNode(child.node, self.node->doc, 1);
    xmlAddChild(self.node, newNode);
    return [IGXMLNode nodeWithXMLNode:newNode];
}

-(instancetype) prependWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr cur = self.node;
    cur = cur->children;
    
    while (cur != nil && cur->type != XML_ELEMENT_NODE && cur->type != XML_TEXT_NODE) {
        cur = cur->next;
    }
    
    xmlNodePtr newNode = xmlDocCopyNode(child.node, self.node->doc, 1);
    if (cur) {
        xmlAddPrevSibling(cur, newNode);
    } else {
        xmlAddChild(self.node, newNode);
    }
    
    return [IGXMLNode nodeWithXMLNode:newNode];
}

-(IGXMLNode*) addChildWithNode:(IGXMLNode*)child {
    return [self appendWithNode:child];
}

-(IGXMLNode*) addNextSiblingWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr newNode = xmlDocCopyNode(child.node, self.node->doc, 1);
    xmlAddNextSibling(self.node, newNode);
    return [IGXMLNode nodeWithXMLNode:newNode];
}

-(IGXMLNode*) addPreviousSiblingWithNode:(IGXMLNode*)child {
    NSParameterAssert(child);
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr newNode = xmlDocCopyNode(child.node, self.node->doc, 1);
    xmlAddPrevSibling(self.node, newNode);
    return [IGXMLNode nodeWithXMLNode:newNode];
}

-(instancetype) appendWithXMLString:(NSString*)xmlString {
    NSParameterAssert(xmlString);
    NSAssert(!_removed, @"cannot access a removed node");

    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self appendWithNode:node];
    } else {
        return nil;
    }
}

-(instancetype) prependWithXMLString:(NSString*)xmlString {
    NSParameterAssert(xmlString);
    NSAssert(!_removed, @"cannot access a removed node");

    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self prependWithNode:node];
    } else {
        return nil;
    }
}

-(instancetype) addChildWithXMLString:(NSString*)xmlString {
    NSParameterAssert(xmlString);
    NSAssert(!_removed, @"cannot access a removed node");

    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self addChildWithNode:node];
    } else {
        return nil;
    }
}

-(instancetype) addNextSiblingWithXMLString:(NSString*)xmlString {
    NSParameterAssert(xmlString);
    NSAssert(!_removed, @"cannot access a removed node");

    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self addNextSiblingWithNode:node];
    } else {
        return nil;
    }
}

-(instancetype) addPreviousSiblingWithXMLString:(NSString*)xmlString {
    NSParameterAssert(xmlString);
    NSAssert(!_removed, @"cannot access a removed node");

    NSError* error = nil;
    IGXMLNode* node = [[IGXMLDocument alloc] initWithXMLString:xmlString
                                                         error:&error];
    if (node) {
        return [self addPreviousSiblingWithNode:node];
    } else {
        return nil;
    }
}

-(void) empty {
    NSAssert(!_removed, @"cannot access a removed node");

    xmlNodePtr cur = _node;
    cur = cur->children;
    
    while (cur != nil) {
        xmlNodePtr next = cur->next;
        xmlUnlinkNode(cur);
        xmlFreeNode(cur);
        cur = next;
    }
}

-(void)remove {
    NSAssert(!_removed, @"cannot access a removed node");

    if (_node->type == XML_NAMESPACE_DECL) {
        @throw [NSException exceptionWithName:IGXMLNodeException
                                       reason:@"Cannot remove a namespace"
                                     userInfo:nil];
        return;
    }
    
    xmlUnlinkNode(_node);
    xmlFreeNode(_node);
    _node = nil;
    _removed = true;
}

#pragma mark - Query

-(IGXMLNodeSet*) queryWithXPath:(NSString*)xpath {
    NSParameterAssert(xpath);
    NSAssert(!_removed, @"cannot access a removed node");

    if (!xpath) {
        return [IGXMLNodeSet emptyNodeSet];
    }
    
    if (!_node || !_node->doc) {
        return [IGXMLNodeSet emptyNodeSet];
    }
    
    xmlXPathContextPtr context = xmlXPathNewContext(self.node->doc);
    if (context == NULL) {
        return [IGXMLNodeSet emptyNodeSet];
    }
    
    context->node = self.node;
    
    xmlResetLastError();
    
    xmlXPathObjectPtr object = xmlXPathEvalExpression((xmlChar *)[xpath UTF8String], context);
    if (object == NULL) {
        return [IGXMLNodeSet emptyNodeSet];
    }
    
    xmlNodeSetPtr nodes = object->nodesetval;
    NSMutableArray *resultNodes = [NSMutableArray array];
    if (nodes != NULL) {
        for (NSInteger i = 0; i < nodes->nodeNr; i++) {
            [resultNodes addObject:[IGXMLNode nodeWithXMLNode:nodes->nodeTab[i]]];
        }
    }
    xmlXPathFreeObject(object);
    xmlXPathFreeContext(context);
    
    return [[IGXMLNodeSet alloc] initWithNodes:resultNodes];
}

+ (CSSSelectorToXPathConverter *)cssConverter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary] ;
    CSSSelectorToXPathConverter *cssConverter = [threadDictionary objectForKey:CSSSelectorToXPathConverterCacheKey];
    if (!cssConverter) {
        cssConverter = [[CSSSelectorToXPathConverter alloc] init];
        [threadDictionary setObject:cssConverter forKey:CSSSelectorToXPathConverterCacheKey];
    }
    return cssConverter;
}

- (IGXMLNodeSet*) queryWithCSS:(NSString*)cssSelector {
    NSParameterAssert(cssSelector);

    NSError* cssError = nil;
    NSString* xpath = [[[self class] cssConverter] xpathWithCSS:cssSelector error:&cssError];
    if (!xpath) {
        if (cssError) {
            [NSException raise:IGXMLQueryCSSConversionException format:@"Cannot convert CSS into XPath: %@", [cssError localizedDescription]];
        } else {
            [NSException raise:IGXMLQueryCSSConversionException format:@"Cannot convert CSS into XPath: unknown error"];
        }
    }
    return [self queryWithXPath:[@"." stringByAppendingString:xpath]];
}

- (IGXMLNodeSet*) query:(NSString*)xpathOrCssSelector {
    NSParameterAssert(xpathOrCssSelector);

    if ([xpathOrCssSelector hasPrefix:@"./"] || [xpathOrCssSelector hasPrefix:@"/"] || [xpathOrCssSelector hasPrefix:@"../"]) {
        return [self queryWithXPath:xpathOrCssSelector];
    } else {
        return [self queryWithCSS:xpathOrCssSelector];
    }
}

#pragma mark - Attributes

- (NSString *)attribute:(NSString *)attName {
    return [self attribute:attName inNamespace:nil];
}

- (NSString *)attribute:(NSString *)attName inNamespace:(NSString *)ns {
    NSParameterAssert(attName);
    NSAssert(!_removed, @"cannot access a removed node");

    unsigned char *attCStr = ns ?
    xmlGetNsProp(self.node, (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding], (const xmlChar *)[ns cStringUsingEncoding:NSUTF8StringEncoding]) :
    xmlGetProp(self.node, (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding]) ;
    
    if (attCStr) {
        NSString* attibuteValue = [NSString stringWithUTF8String:(const char *)attCStr];
        xmlFree(attCStr);
        return attibuteValue;
    }
    
    return nil;
}

- (void) setAttribute:(NSString*)attName value:(NSString*)value {
    [self setAttribute:attName inNamespace:nil value:value];
}

- (void) setAttribute:(NSString*)attName inNamespace:(NSString*)ns value:(NSString*)value {
    NSParameterAssert(attName);
    NSParameterAssert(value);
    NSAssert(!_removed, @"cannot access a removed node");
    
    if (ns) {
        xmlNsPtr nsPtr = xmlSearchNs(self.node->doc, self.node, (const xmlChar *)[ns cStringUsingEncoding:NSUTF8StringEncoding]);
        xmlSetNsProp(self.node,
                     nsPtr,
                     (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding],
                     (const xmlChar *)[value cStringUsingEncoding:NSUTF8StringEncoding]);
    } else {
        xmlSetProp(self.node,
                   (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding],
                   (const xmlChar *)[value cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

- (void) removeAttribute:(NSString*)attName {
    [self removeAttribute:attName inNamespace:nil];
}

- (void) removeAttribute:(NSString*)attName inNamespace:(NSString*)ns {
    NSParameterAssert(attName);
    NSAssert(!_removed, @"cannot access a removed node");

    xmlAttrPtr attr = NULL;
    if (ns) {
        attr = xmlHasNsProp(self.node,
                            (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding],
                            (const xmlChar *)[ns cStringUsingEncoding:NSUTF8StringEncoding]);
    } else {
        attr = xmlHasProp(self.node, (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    
    if (attr != NULL) {
        xmlRemoveProp(attr);
    }
}

- (NSArray *)attributeNames {
    NSAssert(!_removed, @"cannot access a removed node");

    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    for(xmlAttrPtr attr = self.node->properties; attr != nil; attr = attr->next) {
        [names addObject:[[NSString alloc] initWithCString:(const char *)attr->name encoding:NSUTF8StringEncoding]];
    }
    
    return names;
}

- (id)objectForKeyedSubscript:(id)key {
    return [self attribute:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    [self setAttribute:(NSString*)key value:obj];
}

@end
