//
//  RBDrumkit.h
//  RBDrumz
//
//  Created by Rodrigo Sieiro on 20/02/2010.
//  Copyright 2010 SharpCube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DDHidLib/DDHidLib.h>

@interface RBDrumkit : DDHidDevice 
{
	NSMutableArray *m_logicalDeviceElements;
	NSMutableArray *m_joystickElements;
	NSMutableArray *m_joystickElementsToMonitor;
	NSMutableDictionary *m_joystickValues;
	id m_delegate;
}

+ (NSArray *) allJoysticks;

- (id) initLogicalWithDevice: (io_object_t) device 
         logicalDeviceNumber: (int) logicalDeviceNumber 
                       error: (NSError **) error;

- (int) logicalDeviceCount;
- (int) elementsToMonitorCount;

- (void) addElementsToQueue: (DDHidQueue *) queue;
- (void) addElementsToDefaultQueue;
- (void) addElementToMonitor: (DDHidElement *) element;
- (void) addCookieToMonitor: (unsigned) cookie;
- (void) initLogicalDeviceElements;
- (void) initJoystickElements: (NSArray *) elements;
- (void) ddhidQueueHasEvents: (DDHidQueue *) hidQueue;
- (int) valueForCookie: (unsigned) cookie;

- (void) setDelegate: (id) delegate;

@end

@interface NSObject (RBDrumkitDelegate)

- (void) rbDrumKitStateChanged: (RBDrumkit *) joystick;

@end
