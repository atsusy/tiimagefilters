//
//  TiBlob+Vibrance.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Vibrance.h"

@interface JpMsmcTiimagefiltersModuleTiBlobVibrance
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobVibrance
@end

@implementation TiBlob (TiBlob_Vibrance)
- (id)vibrance:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    int8_t adjust = -[arg intValue];
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] saturation opeartion called. adjust:%d", adjust);
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                int16_t max = MAX(MAX(R, G), B);
                int16_t avg = (R + G + B) / 3;
                int16_t amt;
                if(max > avg){
                    amt = (max - avg) * 2 * adjust / 255;
                }else{
                    amt = (avg - max) * 2 * adjust / 255;
                }
                
                int16_t diff;
                
                if(R != max){
                    diff = max - R;
                    R += diff * amt / 100;
                }   
                
                if(G != max){
                    diff = max - G;
                    G += diff * amt / 100;
                }   
                
                if(B != max){
                    diff = max - B;
                    B += diff * amt / 100;
                }   
                
                *(pixel + argb.r) = MAX(0, MIN(255, R));
                *(pixel + argb.g) = MAX(0, MIN(255, G));
                *(pixel + argb.b) = MAX(0, MIN(255, B));
            }
        }
    };
    
    return [self operate:op];    
}
@end
