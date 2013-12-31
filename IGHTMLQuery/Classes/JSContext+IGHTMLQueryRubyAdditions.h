//
//  JSContext+IGHTMLQueryRubyAdditions.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/31/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#ifdef IGHTMLQUERY_RUBY_EXPORT
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSContext (IGHTMLQueryRubyAdditions)

/**
 * Load Ruby Wrapper classes XMLNode and XMLNodeSet to the context
 */
-(void) configureIGHTMLQuery;

@end
#endif