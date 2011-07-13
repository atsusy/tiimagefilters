//
//  TiBlob+Template.h
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/27.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TiBlob.h"

typedef struct tagARGBIndex {
    u_char a;
    u_char r;
    u_char g;
    u_char b;
} ARGBIndex;

typedef void (^FilterOperation)(uint8_t *,size_t,ARGBIndex,uint32_t,uint32_t);

#define IS_ALPHA_LAST(alphaInfo) (alphaInfo==kCGImageAlphaPremultipliedLast \
                               || alphaInfo==kCGImageAlphaLast \
                               || alphaInfo==kCGImageAlphaNoneSkipLast)

#define IS_LITTLE_ENDIAN(bitmapInfo) (((bitmapInfo&kCGBitmapByteOrderMask)==kCGBitmapByteOrder32Little) \
                                    ||((bitmapInfo&kCGBitmapByteOrderMask)==kCGBitmapByteOrder16Little))

@interface TiBlob (TiBlob_Template)
- (id)operate:(FilterOperation)op;

- (void)bezier:(int32_t *)start
         ctrl1:(int32_t *)ctrl1
         ctrl2:(int32_t *)ctrl2 
           end:(int32_t *)end 
      lowBound:(int32_t)lowBound
     highBound:(int32_t)highBound
          into:(int32_t *)table;
@end
