//
//  TiBlob+Sobel.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/07/06.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Sobel.h"

@interface JpMsmcTiimagefiltersModuleTiBlobSobel
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobSobel
@end

@implementation TiBlob (TiBlob_Sobel)
- (id)sobel:(id)arg
{
    NSArray *matrix_;
    NSNumber *divisor_ = nil;
   
    ENSURE_ARG_AT_INDEX(matrix_, arg, 0, NSArray);
    if([arg count] == 2){
        ENSURE_ARG_AT_INDEX(divisor_, arg, 1, NSNumber);
    }
    
    ENSURE_VALUE_CONSISTENCY([matrix_ count]%2, 1);
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        uint32_t size = (uint32_t)sqrt([matrix_ count]);
        int32_t divisor = [divisor_ intValue];
        if(divisor == 0){
            divisor = 1;
        }
        
        NSLog(@"[DEBUG] sobel operation called. size:%dx%d divisor:%d",
              size, size, divisor); 
        
        int32_t matrix[size*size];
        for(int i = 0; i < size*size; i++){
            matrix[i] = [[matrix_ objectAtIndex:i] intValue];
        }
        
        int cx, cy;
        int32_t R, G, B;
        int32_t factor;
        uint8_t *pixel;
        
        uint8_t *dst = malloc(bpr * h);
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                R = G = B = 0;
                for(int dy = 0; dy < size; dy++){
                    for(int dx = 0; dx < size; dx++){
                        cx = x + (dx-size/2);
                        if(cx < 0)  { cx = 0; }
                        if(cx >= w) { cx = w - 1; }

                        cy = y + (dy-size/2);
                        if(cy < 0)  { cy = 0; }
                        if(cy >= h) { cy = h - 1; }
                        
                        factor = matrix[dy*size+dx];
                        if(factor == 0){
                            continue;
                        }

                        pixel = buf + cy * bpr + cx * 4;
                        R += (int32_t)(*(pixel + argb.r)) * factor;
                        G += (int32_t)(*(pixel + argb.g)) * factor;
                        B += (int32_t)(*(pixel + argb.b)) * factor;
                    }
                }

                R /= divisor;
                if(R < 0) { R = 0; }
                if(R > 255) { R = 255; }
                
                G /= divisor;
                if(G < 0) { G = 0; }
                if(G > 255) { G = 255; }

                B /= divisor;
                if(B < 0) { B = 0; }
                if(B > 255) { B = 255; }
                
                pixel = dst + y * bpr + x * 4;
                *(pixel + argb.r) = R;
                *(pixel + argb.g) = G;
                *(pixel + argb.b) = B;
            }
        }
        memcpy(buf, dst, bpr * h);
        free(dst);
    };
    
    return [self operate:op];
}
@end
