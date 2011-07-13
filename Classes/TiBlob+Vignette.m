//
//  TiBlob+Vignette.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Vignette.h"

@implementation TiBlob (TiBlob_Vignette)
- (id)vignette:(id)arg
{
    NSNumber *size;
    NSNumber *strength;
    
    ENSURE_ARG_AT_INDEX(size, arg, 0, NSNumber);
    ENSURE_ARG_AT_INDEX(strength, arg, 1, NSNumber);
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        int32_t center[2] = { w / 2, h / 2};
        int32_t start[2] = {   0,  1 };
        int32_t ctrl1[2] = {  30, 30 };
        int32_t ctrl2[2] = {  70, 60 };
        int32_t end[2]   = { 100, 80 };
        int32_t bezier[256];
        
        [self bezier:start 
               ctrl1:ctrl1 
               ctrl2:ctrl2 
                 end:end 
            lowBound:0 
           highBound:255 
                into:bezier];
        
        int32_t opSize = 100 - [size intValue];
        opSize = MIN(w, h) * opSize / 100;
        
        int32_t opStart = (int32_t)sqrtf(center[0]*center[0]+center[1]*center[1]);
        int32_t opEnd = opStart - opSize;
        float opStrength = [strength intValue] / 100.f;
        
        NSLog(@"[DEBUG] vignette operation called. size:%d strength:%f", opSize, opStrength);

        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                int32_t dist = (int32_t)sqrtf(((x-center[0])*(x-center[0]))+((y-center[1])*(y-center[1])));
                
                if(dist <= opEnd){
                    continue;
                }

                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                    
                int32_t index = (int32_t)((dist - opEnd) * 100.f / opSize);

                float div = MAX(1.f, bezier[index] / 10.f * opStrength);
                
                *(pixel + argb.r) = (uint8_t)(powf(R / 255.f, div) * 255.f);
                *(pixel + argb.g) = (uint8_t)(powf(G / 255.f, div) * 255.f);
                *(pixel + argb.b) = (uint8_t)(powf(B / 255.f, div) * 255.f);
            }
        }
    };
    
    return [self operate:op];    
}
@end
