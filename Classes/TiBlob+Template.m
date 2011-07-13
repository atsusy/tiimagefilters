//
//  TiBlob+Template.m
//  tiimagefilters
//
//  Created by KATAOKA,Atsushi on 11/06/27.
//  Copyright 2011 MARSHMALLOW MACHINE. All rights reserved.
//

#import "TiUtils.h"
#import "TiBlob+Template.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <mach/mach_time.h> 

@implementation TiBlob (TiBlob_Template)

- (void)bezier:(int32_t *)start
         ctrl1:(int32_t *)ctrl1
         ctrl2:(int32_t *)ctrl2 
           end:(int32_t *)end 
      lowBound:(int32_t)lowBound
     highBound:(int32_t)highBound
          into:(int32_t *)table
{
    int32_t Ax, Bx, Cx, Ay, By, Cy;
    int32_t x0 = start[0],  y0 = start[1];
    int32_t x1 = ctrl1[0],  y1 = ctrl1[1];
    int32_t x2 = ctrl2[0],  y2 = ctrl2[1];
    int32_t x3 = end[0],    y3 = end[1];
    
    Cx = 3 * (x1 - x0);
    Bx = 3 * (x2 - x1) - Cx;
    Ax = x3 - x0 - Cx - Bx;
    
    Cy = 3 * (y1 - y0);
    By = 3 * (y2 - y1) - Cy;
    Ay = y3 - y0 - Cy - By;
    
    uint32_t curveX, curveY;
    uint32_t minX, maxX;
    
    minX = 255;
    maxX = 0;
    for(int i = 0; i < 1024; i++){
        curveX = ((Ax * ((i * i * i) >> 20)) + (Bx * ((i * i) >> 10)) + (Cx * i) + (x0 << 10)) >> 10;
        curveY = ((Ay * ((i * i * i) >> 20)) + (By * ((i * i) >> 10)) + (Cy * i) + (y0 << 10)) >> 10;
        
        if(lowBound > 0 && curveY < lowBound){
            curveY = lowBound;
        } else if(highBound > 0 && curveX > highBound){
            curveY = highBound;
        }
        table[curveX] = curveY;
        
        if(minX > curveX){
            minX = curveX;
        }
        if(maxX < curveX){
            maxX = curveX;
        }
    }
    
    for(int i = 0; i < minX; i++){
        table[i] = table[minX];
    }
    
    for(int i = maxX+1; i < 256; i++){
        table[i] = table[maxX];
    }
}

- (ARGBIndex)detectARGBIndexFromBitmapInfo:(CGBitmapInfo)bitmapInfo
                              AndAlphaInfo:(CGImageAlphaInfo)alphaInfo
{
    ARGBIndex argb;
    
    if(IS_ALPHA_LAST(alphaInfo)){
        if(IS_LITTLE_ENDIAN(bitmapInfo)){
            // ABGR
            argb.a = 0;
            argb.r = 3;
            argb.g = 2;
            argb.b = 1;
        }else{
            // RGBA
            argb.a = 3;
            argb.r = 0;
            argb.g = 1;
            argb.b = 2;
        }
    }else{
        if(IS_LITTLE_ENDIAN(bitmapInfo)){
            // BGRA
            argb.a = 3;
            argb.r = 2;
            argb.g = 1;
            argb.b = 0;
        }else{
            // ARGB
            argb.a = 0;
            argb.r = 1;
            argb.g = 2;
            argb.b = 3;
        }
    }
    return argb;
}

- (id)operate:(FilterOperation)op 
{
    CGImageRef cgImage = [image CGImage];
    
    if(cgImage == nil)
    {
        return self;
    }
    
    CGDataProviderRef cgDataProvider = CGImageGetDataProvider(cgImage);
    CFDataRef cfData = CGDataProviderCopyData(cgDataProvider);
    uint8_t *buffer = (uint8_t *)CFDataGetBytePtr(cfData);
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cgImage);
	BOOL shouldInterpolate = CGImageGetShouldInterpolate(cgImage);
	CGColorRenderingIntent intent = CGImageGetRenderingIntent(cgImage);
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage);
    
    assert(CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelRGB &&
           bitsPerPixel == 32 && 
           bitsPerComponent == 8);
    
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    uint64_t start = mach_absolute_time();

    // exec operation
    ARGBIndex argb = [self detectARGBIndexFromBitmapInfo:bitmapInfo 
                                            AndAlphaInfo:alphaInfo];
    op(buffer, bytesPerRow, argb, width, height);
    
    uint64_t duration = mach_absolute_time() - start;
    duration *= info.numer;
    duration /= info.denom;
    
    NSLog(@"[DEBUG] operation took %fms width:%d height:%d bpp:%d bpc:%d alpha:%d bmi:%d", 
          duration / 1000.f / 1000.f, width, height, bitsPerPixel, bitsPerComponent, alphaInfo, bitmapInfo);
    
	CFDataRef effectedData;
	effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(cfData));
    
	CGDataProviderRef effectedDataProvider;
	effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
	CGImageRef effectedCgImage = CGImageCreate(width, height, 
                                               bitsPerComponent, bitsPerPixel, bytesPerRow, 
                                               colorSpace, bitmapInfo, effectedDataProvider, 
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[[UIImage alloc] initWithCGImage:effectedCgImage] autorelease];
    
	CGImageRelease(effectedCgImage);
	CFRelease(effectedDataProvider);
	CFRelease(effectedData);
	CFRelease(cfData);	

    return [[[TiBlob alloc] initWithImage:effectedImage] autorelease];
}
@end
