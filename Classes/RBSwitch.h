//
//  RBSwitch.h
//  RBDrumz
//
//  Created by Rodrigo Sieiro on 15/03/2010.
//  Copyright 2010 SharpCube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RBTrigger.h"

@interface RBSwitch : NSObject
{
	int switchID;
	NSString *name;
	int triggerID;
	int midiNote;
	int oldNote;
	long vendorId;
	long productId;
	long locationId;
	BOOL isOn;
	
	NSMutableArray *m_buttonCookies;
	NSMutableArray *m_offCookies;
	RBTrigger *m_trigger;
}

@property (readwrite, assign) int switchID;
@property (readwrite, copy) NSString *name;
@property (readwrite, assign) int triggerID;
@property (readwrite, assign) int midiNote;
@property (readwrite, assign) long vendorId;
@property (readwrite, assign) long productId;
@property (readwrite, assign) long locationId;
@property (readonly, assign) BOOL isOn;

- (void) addButtonCookie: (unsigned) cookie;
- (void) setButtonCookies: (NSArray *) cookies;
- (void) addOffCookie: (unsigned) cookie;
- (void) setOffCookies: (NSArray *) cookies;
- (void) setTrigger: (RBTrigger *) trigger;
- (NSArray *) buttonCookies;
- (NSArray *) offCookies;
- (void) switchOn;
- (void) switchOff;

@end
