//
//  TiBlob+Channels.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Channels.h"

@interface JpMsmcTiimagefiltersModuleTiBlobChannels
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobChannels
@end


@implementation TiBlob (TiBlob_Channels)
- (id)channels:(id)arg
{
    ENSURE_ARG_COUNT(arg, 3);

    int32_t r = [[arg objectAtIndex:0] intValue];
    int32_t g = [[arg objectAtIndex:1] intValue];
    int32_t b = [[arg objectAtIndex:2] intValue];
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] channels opeartion called. r:%d g:%d b:%d", r, g, b);

        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                if(r > 0){
                    *(pixel + argb.r) = MAX(0, MIN(255, R + (255-R) * r / 100));
                }else{
                    *(pixel + argb.r) = MAX(0, MIN(255, R + R * r / 100));
                }
                
                if(g > 0){
                    *(pixel + argb.g) = MAX(0, MIN(255, G + (255-G) * g / 100));
                }else{
                    *(pixel + argb.g) = MAX(0, MIN(255, G + G * g / 100));
                }
                
                if(b > 0){
                    *(pixel + argb.b) = MAX(0, MIN(255, B + (255-B) * b / 100));
                }else{
                    *(pixel + argb.b) = MAX(0, MIN(255, B + B * b / 100));
                }
            }
        }
    };
    
    return [self operate:op];
}
@end

