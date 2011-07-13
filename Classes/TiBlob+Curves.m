//
//  TiBlob+Curves.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+Curves.h"

@implementation TiBlob (TiBlob_Curves)
- (id)curves:(id)arg
{
    ENSURE_ARG_COUNT(arg, 5);
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSString     *chan  = (NSString *)[arg objectAtIndex:0];
        NSArray *start = (NSArray *)[arg objectAtIndex:1];
        NSArray *ctrl1 = (NSArray *)[arg objectAtIndex:2];
        NSArray *ctrl2 = (NSArray *)[arg objectAtIndex:3];
        NSArray *end   = (NSArray *)[arg objectAtIndex:4];
        
        BOOL r = [chan rangeOfString:@"r"].length > 0;
        BOOL g = [chan rangeOfString:@"g"].length > 0;
        BOOL b = [chan rangeOfString:@"b"].length > 0;

        int32_t start_[2];
        int32_t ctrl1_[2];
        int32_t ctrl2_[2];
        int32_t end_[2];
        int32_t bezier[256];
      
        start_[0]   = [[start objectAtIndex:0] intValue];
        start_[1]   = [[start objectAtIndex:1] intValue];
        ctrl1_[0]   = [[ctrl1 objectAtIndex:0] intValue];
        ctrl1_[1]   = [[ctrl1 objectAtIndex:1] intValue];
        ctrl2_[0]   = [[ctrl2 objectAtIndex:0] intValue];
        ctrl2_[1]   = [[ctrl2 objectAtIndex:1] intValue];
        end_[0]     = [[end objectAtIndex:0] intValue];
        end_[1]     = [[end objectAtIndex:1] intValue];

        NSLog(@"[DEBUG] curves opeartion called. start:(%d,%d) ctrl1:(%d,%d) ctrl2:(%d,%d) end:(%d,%d)", 
              start_[0], start_[1], ctrl1_[0], ctrl1_[1], ctrl2_[0], ctrl2_[1], end_[0], end_[1]);
        
        [self bezier:start_ ctrl1:ctrl1_  ctrl2:ctrl2_ end:end_ lowBound:0 highBound:255 into:bezier];

        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
                int16_t R, G, B;
                
                R = *(pixel + argb.r);
                G = *(pixel + argb.g);
                B = *(pixel + argb.b);
                
                if(r){
                    *(pixel + argb.r) = bezier[R];
                }
                if(g){
                    *(pixel + argb.g) = bezier[G];
                }
                if(b){
                    *(pixel + argb.b) = bezier[B];
                }
            }
        }
    };
    
    return [self operate:op];    
}
@end
