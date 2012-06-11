//
//  RBDrumkit.m
//  RBDrumz
//
//  Created by Rodrigo Sieiro on 20/02/2010.
//  Copyright 2010 SharpCube. All rights reserved.
//

#import "RBDrumkit.h"

@interface RBDrumkit (RBDrumkitDelegate)

- (void) rbDrumKitStateChanged: (RBDrumkit *) joystick;

@end


@implementation RBDrumkit

+ (NSArray *) allJoysticks;
{
    NSArray * joysticks =
	[DDHidDevice allDevicesMatchingUsagePage: kHIDPage_GenericDesktop
									 usageId: kHIDUsage_GD_Joystick
								   withClass: self
						   skipZeroLocations: YES];
    NSArray * gamepads =
	[DDHidDevice allDevicesMatchingUsagePage: kHIDPage_GenericDesktop
									 usageId: kHIDUsage_GD_GamePad
								   withClass: self
						   skipZeroLocations: YES];
	
    NSMutableArray * allJoysticks = [NSMutableArray arrayWithArray: joysticks];
    [allJoysticks addObjectsFromArray: gamepads];
    [allJoysticks sortUsingSelector: @selector(compareByLocationId:)];
    return allJoysticks;
}

- (id) initLogicalWithDevice: (io_object_t) device 
         logicalDeviceNumber: (int) logicalDeviceNumber
                       error: (NSError **) error;
{
    self = [super initLogicalWithDevice: device
                    logicalDeviceNumber: logicalDeviceNumber
                                  error: error];
    if (self == nil)
        return nil;
    
    m_logicalDeviceElements = [[NSMutableArray alloc] init];
	m_joystickElements = [[NSMutableArray alloc] init];
	m_joystickElementsToMonitor = [[NSMutableArray alloc] init];
	m_joystickValues = [[NSMutableDictionary alloc] initWithCapacity:10];
	
    [self initLogicalDeviceElements];
    int logicalDeviceCount = [m_logicalDeviceElements count];
    if (logicalDeviceCount ==  0)
    {
        [self release];
        return nil;
    }
	
    mLogicalDeviceNumber = logicalDeviceNumber;
    if (mLogicalDeviceNumber >= logicalDeviceCount) mLogicalDeviceNumber = logicalDeviceCount - 1;
    
    [self initJoystickElements: [m_logicalDeviceElements objectAtIndex: mLogicalDeviceNumber]];
	m_delegate = nil;
	
    return self;
}

- (void) initLogicalDeviceElements;
{
    NSArray * topLevelElements = [self elements];
    if ([topLevelElements count] == 0)
    {
        [m_logicalDeviceElements addObject: topLevelElements];
        return;
    }
    
    NSEnumerator * e = [topLevelElements objectEnumerator];
    DDHidElement * element;
    while (element = [e nextObject])
    {
        unsigned usagePage = [[element usage] usagePage];
        unsigned usageId = [[element usage] usageId];
        if (usagePage == kHIDPage_GenericDesktop &&
            (usageId == kHIDUsage_GD_Joystick || usageId == kHIDUsage_GD_GamePad)) 
        {
            [m_logicalDeviceElements addObject: [NSArray arrayWithObject: element]];
        }
    }
}

- (void) initJoystickElements: (NSArray *) elements;
{
    NSEnumerator *e = [elements objectEnumerator];
    DDHidElement *element;
	
	while (element = [e nextObject])
    {
		unsigned usagePage = [[element usage] usagePage];
		unsigned usageId = [[element usage] usageId];
		NSArray * subElements = [element elements];
		NSNumber *value = [NSNumber numberWithInt:0];
		
		if ([subElements count] > 0)
		{
			[self initJoystickElements: subElements];
		}
		else
		{
			if (usagePage == kHIDPage_GenericDesktop)
			{
				switch (usageId)
				{
					case kHIDUsage_GD_X:
					case kHIDUsage_GD_Y:
					case kHIDUsage_GD_Z:
					case kHIDUsage_GD_Rx:
					case kHIDUsage_GD_Ry:
					case kHIDUsage_GD_Rz:
						[m_joystickElements addObject: element];
						[m_joystickValues setObject:value forKey:[NSNumber numberWithUnsignedInt:[element cookieAsUnsigned]]];
						break;
				}
			}
			else if (usagePage == kHIDPage_Button)
			{
				[m_joystickElements addObject: element];
				[m_joystickValues setObject:value forKey:[NSNumber numberWithUnsignedInt:[element cookieAsUnsigned]]];
			}
		}
    }
}

- (void) dealloc
{
    [m_logicalDeviceElements release];
	[m_joystickElements release];
	[m_joystickElementsToMonitor release];
	[m_joystickValues release];
	
    m_logicalDeviceElements = nil;
	m_joystickElements = nil;
	m_joystickElementsToMonitor = nil;
	m_joystickValues = nil;

    [super dealloc];
}

- (int) logicalDeviceCount;
{
    return [m_logicalDeviceElements count];
}

- (int) elementsToMonitorCount;
{
    return [m_joystickElementsToMonitor count];
}

- (void) addElementsToQueue: (DDHidQueue *) queue;
{
	[queue addElements: m_joystickElementsToMonitor];
}

- (void) addElementsToDefaultQueue;
{
    [self addElementsToQueue: mDefaultQueue];
}

- (void) addElementToMonitor: (DDHidElement *) element
{
	NSLog(@"Monitoring Element: %@, Cookie: %d", [[element usage] usageName], [element cookieAsUnsigned]);
	[m_joystickElementsToMonitor addObject: element];
}

- (void) addCookieToMonitor: (unsigned) cookie
{
	DDHidElement *element;
	element = [self elementForCookie: (IOHIDElementCookie) cookie];
	[self addElementToMonitor:element];
}

- (void) ddhidQueueHasEvents: (DDHidQueue *) hidQueue
{
    DDHidEvent *event;
	DDHidElement *element;
	
    while ((event = [hidQueue nextEvent]))
	{
		IOHIDElementCookie cookie = [event elementCookie];
		element = [self elementForCookie: cookie];
		
		NSNumber *value = [NSNumber numberWithInt:[event value]];
		[m_joystickValues setObject:value forKey:[NSNumber numberWithUnsignedInt:[element cookieAsUnsigned]]];
		
		//NSLog(@"Element: %@, value: %d", [[element usage] usageName], [event value]);
    }
	
	[self rbDrumKitStateChanged: self];
}

- (int) valueForCookie: (unsigned) cookie
{
	NSNumber *numberCookie = [NSNumber numberWithInt:cookie];
	NSNumber *value = [m_joystickValues objectForKey: numberCookie];
	return [value intValue];
}

- (void) setDelegate: (id) delegate;
{
    m_delegate = delegate;
}

@end

@implementation RBDrumkit (RBDrumkitDelegate)

- (void) rbDrumKitStateChanged: (RBDrumkit *) joystick
{
    if ([m_delegate respondsToSelector: _cmd])
        [m_delegate rbDrumKitStateChanged: joystick];
}

@end

