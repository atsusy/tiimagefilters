//
//  TiBlob+Brightness.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Brightness.h"

@interface JpMsmcTiimagefiltersModuleTiBlobBrightness
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobBrightness
@end

@implementation TiBlob (TiBlob_Brightness)
- (id)brightness:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    int32_t adjust = 255 * [arg intValue] / 100;
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] brightness opeartion called. adjust:%d", adjust);
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                *(pixel + argb.r) = MAX(0, MIN(255, R + adjust));
                *(pixel + argb.g) = MAX(0, MIN(255, G + adjust));
                *(pixel + argb.b) = MAX(0, MIN(255, B + adjust));
            }
        }
    };
    
    return [self operate:op];
}
@end
