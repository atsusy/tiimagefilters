//
//  TiBlob+Noise.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Noise.h"

@interface JpMsmcTiimagefiltersModuleTiBlobNoise
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobNoise
@end

#define LIMIT(v, min, max) MAX(MIN(max, v), min)

@implementation TiBlob (TiBlob_Noise)
- (id)noise:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    
    int32_t adjust = [arg intValue] * 255 / 100;
    
    // initialize random seed
    srand(time(NULL));
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] noise opeartion called. adjust:%d", adjust);
        
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                                
                int8_t of = (int8_t)(-adjust + (rand()%(adjust*2+1)));
                *(pixel + argb.r) = LIMIT(R + of, 0, 255);
                *(pixel + argb.g) = LIMIT(G + of, 0, 255);
                *(pixel + argb.b) = LIMIT(B + of, 0, 255);
            }
        }
    };
    
    return [self operate:op];
}
@end
