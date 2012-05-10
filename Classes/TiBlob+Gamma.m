//
//  TiBlob+Gamma.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Gamma.h"

@interface JpMsmcTiimagefiltersModuleTiBlobGamma
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobGamma
@end

@implementation TiBlob (TiBlob_Gamma)
- (id)gamma:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    
    float adjust = [arg floatValue];
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] gamma opeartion called. adjust:%f", adjust);
        
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                *(pixel + argb.r) = (uint8_t)(powf(R / 255.f, adjust) * 255.f);
                *(pixel + argb.g) = (uint8_t)(powf(G / 255.f, adjust) * 255.f);
                *(pixel + argb.b) = (uint8_t)(powf(B / 255.f, adjust) * 255.f);
            }
        }
    };
    
    return [self operate:op];
    
}
@end
