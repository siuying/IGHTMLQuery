//
//  IGHTMLQueryJavaScriptExport.h
//  IGHTMLQuery
//
//  Created by Francis Chong on 12/21/13.
//  Copyright (c) 2013 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef IGHTMLQUERY_RUBY_EXPORT
    #ifudef IGHTMLQUERY_JAVSCRIPT_EXPORT
        #define IGHTMLQUERY_JAVSCRIPT_EXPORT
    #end
#endif

#ifdef IGHTMLQUERY_JAVSCRIPT_EXPORT
#import <JavaScriptCore/JavaScriptCore.h>
#define IGHTMLQueryJavaScriptExport JSExport
#else
@protocol IGHTMLQueryJavaScriptExport NSObject
@end
#endif