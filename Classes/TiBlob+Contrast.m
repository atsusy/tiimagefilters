//
//  TiBlob+Contrast.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Contrast.h"

@interface JpMsmcTiimagefiltersModuleTiBlobContrast
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobContrast
@end

@implementation TiBlob (TiBlob_Contrast)
- (id)contrast:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    int32_t adjust = [(NSNumber *)arg intValue];
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] contrast opeartion called. adjust:%d", adjust);
        
        int16_t adjust_ = (adjust + 100) * 256 / 100;
        adjust_ = adjust_ * adjust_ / 256;
        
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                int16_t R_, G_, B_;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                if(*(pixel+argb.a) == 0){
                    continue;
                }
         
                R_ = (R - 128) * adjust_ / 256 + 128;
                if(R_ > 255) { R_ = 255; };
                if(R_ < 0) { R_ = 0; }

                G_ = (G - 128) * adjust_ / 256 + 128;
                if(G_ > 255) { G_ = 255; };
                if(G_ < 0) { G_ = 0; }

                B_ = (B - 128) * adjust_ / 256 + 128;
                if(B_ > 255) { B_ = 255; };
                if(B_ < 0) { B_ = 0; }
                
                *(pixel + argb.r) = (uint8_t)R_;
                *(pixel + argb.g) = (uint8_t)G_;
                *(pixel + argb.b) = (uint8_t)B_;
            }
        }
    };
    
    return [self operate:op];
}
@end
