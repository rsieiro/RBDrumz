//
//  RBTrigger.h
//  RBDrumz
//
//  Created by Rodrigo Sieiro on 21/02/2010.
//  Copyright 2010 SharpCube. All rights reserved.
//

#import <stdlib.h>
#import <Cocoa/Cocoa.h>
#import <VVMIDI/VVMIDI.h>

@interface RBTrigger : NSObject
{
	int triggerID;
	NSString *name;
	int midiNote;
	int midiChannel;
	long vendorId;
	long productId;
	long locationId;
	int minimumRawVelocity;
	int maximumRawVelocity;
	int minimumMidiVelocity;
	int maximumMidiVelocity;
	BOOL invertVelocity;
	BOOL isOn;
	
	VVMIDIManager *m_midiManager;
	NSMutableArray *m_buttonCookies;
	NSMutableArray *m_offCookies;
	unsigned velocityCookie;
}

@property (readwrite, assign) int triggerID;
@property (readwrite, copy) NSString *name;
@property (readwrite, assign) int midiNote;
@property (readwrite, assign) int midiChannel;
@property (readwrite, assign) long vendorId;
@property (readwrite, assign) long productId;
@property (readwrite, assign) long locationId;
@property (readwrite, assign) int minimumRawVelocity;
@property (readwrite, assign) int maximumRawVelocity;
@property (readwrite, assign) int minimumMidiVelocity;
@property (readwrite, assign) int maximumMidiVelocity;
@property (readwrite, assign) unsigned velocityCookie;
@property (readwrite, assign) BOOL invertVelocity;
@property (readonly, assign) BOOL isOn;

- (id) initWithMidiManager: (VVMIDIManager *) midiManager;
- (void) setMidiManager: (VVMIDIManager *) midiManager;
- (void) addButtonCookie: (unsigned) cookie;
- (void) setButtonCookies: (NSArray *) cookies;
- (void) addOffCookie: (unsigned) cookie;
- (void) setOffCookies: (NSArray *) cookies;
- (int) normalizeVelocity: (int) velocity;
- (NSArray *) buttonCookies;
- (NSArray *) offCookies;
- (void) noteOn: (int) velocity;
- (void) noteOff;

@end
