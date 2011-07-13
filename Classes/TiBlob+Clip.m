//
//  TiBlob+Clip.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Clip.h"


@implementation TiBlob (TiBlob_Clip)
- (id)clip:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    uint8_t adjust = [arg intValue] * 255 / 100;
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] clip opeartion called. adjust:%d", adjust);
        
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                if(R > 255 - adjust){
                    R = 255;
                }else if (R < adjust){
                    R = 0;
                }
                
                if(G > 255 - adjust){
                    G = 255;
                }else if (G < adjust){
                    G = 0;
                }

                if(B > 255 - adjust){
                    B = 255;
                }else if (B < adjust){
                    B = 0;
                }
                
                *(pixel + argb.r) = R;
                *(pixel + argb.g) = G;
                *(pixel + argb.b) = B;
            }
        }
    };
    
    return [self operate:op];
}
@end
