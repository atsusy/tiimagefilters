/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "JpMsmcTiimagefiltersModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBlob.h"
#import "ImageLoader.h"
#import "TiBlob+Greyscale.h"

@implementation JpMsmcTiimagefiltersModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"b3235ec0-a107-41b7-b1b6-88060a4e6df5";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"jp.msmc.tiimagefilters";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs
- (id)load:(id)arg
{	
    UIImage *image = nil;
    
    arg = [arg objectAtIndex:0];
    
	if ([arg isKindOfClass:[UIImage class]]) 
	{
        NSLog(@"[DEBUG] argument is UIImage.");
        image = arg;
	}
    
    if([arg isKindOfClass:[TiBlob class]])
    {
        NSLog(@"[DEBUG] argument is TiBlob.");
        image = [arg image];
    }
	
    if ([arg isKindOfClass:[NSString class]])
    {
        NSLog(@"[DEBUG] argument is NSString.");

		NSURL *url_ = [TiUtils toURL:arg proxy:self];
        
        if([url_ isFileURL]){
            image = [[ImageLoader sharedLoader] loadImmediateImage:url_];
        }else{
            image = [[ImageLoader sharedLoader] loadRemote:url_];
        }
    }
    
    if ([arg isKindOfClass:[NSURL class]])
    {
        NSLog(@"[DEBUG] argument is NSURL.");
        NSURL *url_ = (NSURL *)arg;
        image = [UIImage imageWithContentsOfFile:[url_ path]];
	}    
    
    return [[[TiBlob alloc] initWithImage:image] autorelease];
}

@end
