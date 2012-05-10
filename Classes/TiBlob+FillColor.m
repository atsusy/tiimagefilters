//
//  TiBlob+FillColor.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/28.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiBlob+Template.h"
#import "TiBlob+FillColor.h"

@interface JpMsmcTiimagefiltersModuleTiBlobFillColor
@end
@implementation JpMsmcTiimagefiltersModuleTiBlobFillColor
@end

@implementation TiBlob (TiBlob_FillColor)
- (id)fillColor:(id)arg
{
    ENSURE_ARG_COUNT(arg, 1);
    int16_t r, g, b;
    
    if([[arg objectAtIndex:0] isKindOfClass:[NSString class]]){
        NSScanner *scanner = [NSScanner scannerWithString:(NSString *)[arg objectAtIndex:0]];
        
        uint32_t rgb;
        [scanner scanHexInt:&rgb];
        
        r = (rgb >> 16) & 0xff;
        g = (rgb >>  8) & 0xff;
        b = (rgb >>  0) & 0xff;
    }else if([[arg objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
        NSDictionary *rgb = (NSDictionary *)[arg objectAtIndex:0];
        r = [[rgb valueForKey:@"r"] unsignedCharValue];
        g = [[rgb valueForKey:@"g"] unsignedCharValue];
        b = [[rgb valueForKey:@"b"] unsignedCharValue];
    }else {
        [self throwException:TiExceptionNotEnoughArguments 
                   subreason:@"expected single string or dictionary arguments"
                    location:CODELOCATION];
    }
    
    FilterOperation op = ^(uint8_t *buf, size_t bpr, ARGBIndex argb, uint32_t w, uint32_t h)
    {
        NSLog(@"[DEBUG] fillColor opeartion called. r:%d g:%d b:%d", r, g, b);
        for(int y = 0; y < h; y++){
            for(int x = 0; x < w; x++){
                uint8_t *pixel = buf + y * bpr + x * 4;
            
                *(pixel + argb.r) = r;
                *(pixel + argb.g) = g;
                *(pixel + argb.b) = b;
            }
        }
    };
    
    return [self operate:op];
}
@end
