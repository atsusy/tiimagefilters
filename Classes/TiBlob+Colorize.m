//
//  TiBlob+Colorize.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Colorize.h"

@implementation TiBlob (TiBlob_Colorize)
- (id)colorize:(id)arg
{
    ENSURE_ARG_COUNT(arg, 4);
    int16_t r, g, b;
    int32_t level;
    
    r = [[arg objectAtIndex:0] unsignedIntValue];
    g = [[arg objectAtIndex:1] unsignedIntValue];
    b = [[arg objectAtIndex:2] unsignedIntValue];
    level = [[arg objectAtIndex:3] intValue];
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] colorize opeartion called. r:%d g:%d b:%d level:%d", r, g, b, level);
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);

                R -= (R - r) * level / 100;
                G -= (G - g) * level / 100;
                B -= (B - b) * level / 100;
                
                *(pixel + argb.r) = MAX(0, MIN(255, R));
                *(pixel + argb.g) = MAX(0, MIN(255, G));
                *(pixel + argb.b) = MAX(0, MIN(255, B));
            }
        }
    };
    
    return [self operate:op];
}
@end
