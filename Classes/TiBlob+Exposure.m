//
//  TiBlob+Exposure.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Exposure.h"

@interface JpMsmcTiimagefiltersModuleTiBlobExposure
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobExposure
@end

@implementation TiBlob (TiBlob_Exposure)
- (id)exposure:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    int32_t adjust = [(NSNumber *)arg intValue];
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] exposure opeartion called. adjust:%d", adjust);
        
        int32_t p = ((adjust < 0) ? adjust * -1 : adjust ) * 256 / 100;
        int32_t bezier[256];
        int32_t start[2] = {0, 0};
        int32_t ctrl1[2], ctrl2[2];
        int32_t end[2] = {255, 255};
        
        ctrl1[(adjust >= 0) ? 0 : 1] = 0;
        ctrl1[(adjust >= 0) ? 1 : 0] = 255 * p / 256;
        
        ctrl2[(adjust >= 0) ? 0 : 1] = 255 - (255 * p / 256);
        ctrl2[(adjust >= 0) ? 1 : 0] = 255;
        
        [self bezier:start 
               ctrl1:ctrl1 
               ctrl2:ctrl2 
                 end:end 
            lowBound:0 
           highBound:0 
                into:bezier];
        
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                *(pixel + argb.r) = bezier[R];
                *(pixel + argb.g) = bezier[G];
                *(pixel + argb.b) = bezier[B];
            }
        }
    };
    
    return [self operate:op];        
}
@end
