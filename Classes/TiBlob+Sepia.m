//
//  TiBlob+Sepia.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/27.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Sepia.h"


@implementation TiBlob (TiBlob_Sepia)
- (id)sepia:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    float adjust = [arg floatValue] / 100.f;
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] sepia opeartion called. adjust:%f", adjust);
        
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
#if 1
                *(pixel + argb.r) = (uint8_t)(MIN(255,(R*(1-(0.607f*adjust))+G*(0.769f*adjust)+B*(0.189f*adjust))));
                *(pixel + argb.g) = (uint8_t)(MIN(255,(R*(0.349f*adjust)+G*(1-(0.314f*adjust))+B*(0.168f*adjust))));              
                *(pixel + argb.b) = (uint8_t)(MIN(255,(R*(0.272f*adjust)+G*(0.534f*adjust)+B*(1-(0.869f*adjust))))); 
#else
                UInt8 brightness;
                brightness = (77 * R + 28 * G + 151 * B) / 256;
                
                *(pixel + argb.r) = brightness;
                *(pixel + argb.g) = brightness * 70 / 100;
                *(pixel + argb.b) = brightness * 40 / 100;
#endif
            }
        }
    };
    
    return [self operate:op];    
}

@end
