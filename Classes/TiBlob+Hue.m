//
//  TiBlob+Hue.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/27.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Hue.h"

@interface JpMsmcTiimagefiltersModuleTiBlobHue
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobHue
@end

@implementation TiBlob (TiBlob_Hue)

- (id)hue:(id)arg
{
    ENSURE_SINGLE_ARG(arg, NSNumber);
    uint32_t adjust = [(NSNumber *)arg unsignedIntValue];
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] hue opeartion called. adjust:%d", adjust);
        
        uint32_t h_max_1_1 = (360<<7);
        uint32_t h_max_2_3 = (240<<7);
        uint32_t h_max_1_3 = (120<<7);
        uint32_t h_max_1_6 = ( 60<<7);
        
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int32_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                /* convert to HSV start */
                int32_t max = MAX(MAX(R, G), B);
                int32_t min = MIN(MIN(R, G), B);
                int32_t d = max - min;
                int32_t H;
                int32_t S, V;
                
                V = (max<<7) / 255;
                S = (max == 0) ? 0 : (d<<7) / max;
                
                if(max == min)
                {
                    H = 0;
                }
                else
                {
                    if(max == R) { H = ((60*(G - B))<<7)/d + (G < B ? h_max_1_1 : 0); }
                    if(max == G) { H = ((60*(B - R))<<7)/d + h_max_1_3; }
                    if(max == B) { H = ((60*(R - G))<<7)/d + h_max_2_3; }
                }
                /* convert to HSV end */
                
                H += h_max_1_1 * adjust / 100;
                if(H >= h_max_1_1){
                    H -= h_max_1_1;
                }

                /* convert to RGB start */
                int32_t Hi = (H / h_max_1_6)%6;
                int32_t f = H / 60 - (Hi<<7);
                int32_t p = (V * (128 - S))>>7;
                int32_t q = (V * (128 - ((f * S)>>7)))>>7;
                int32_t t = (V * (128 - (((128 - f) * S)>>7)))>>7;

                switch (Hi) {
                    case 0:
                        R = V; G = t; B = p;
                        break;
                    case 1:
                        R = q; G = V; B = p;
                        break;
                    case 2:
                        R = p; G = V; B = t;
                        break;
                    case 3:
                        R = p; G = q; B = V;
                        break;
                    case 4:
                        R = t; G = p; B = V;
                        break;
                    case 5:
                        R = V; G = p; B = q;
                        break;
                    default:
                        R = 0; G = 0; B = 0;
                        break;
                }
                /* convert to RGB end */
                
                *(pixel + argb.r) = (R * 255)>>7;
                *(pixel + argb.g) = (G * 255)>>7;
                *(pixel + argb.b) = (B * 255)>>7;
            }
        }
    };
    
    return [self operate:op];    
}
@end
