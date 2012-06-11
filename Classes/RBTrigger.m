//
//  RBTrigger.m
//  RBDrumz
//
//  Created by Rodrigo Sieiro on 21/02/2010.
//  Copyright 2010 SharpCube. All rights reserved.
//

#import "RBTrigger.h"

@implementation RBTrigger

@synthesize triggerID;
@synthesize name;
@synthesize midiNote;
@synthesize midiChannel;
@synthesize vendorId;
@synthesize productId;
@synthesize locationId;
@synthesize minimumRawVelocity;
@synthesize maximumRawVelocity;
@synthesize minimumMidiVelocity;
@synthesize maximumMidiVelocity;
@synthesize velocityCookie;
@synthesize invertVelocity;
@synthesize isOn;

- (id) initWithMidiManager: (VVMIDIManager *) midiManager
{
	if (![super init]) return nil;
	
	isOn = NO;
	m_midiManager = [midiManager retain];
	m_buttonCookies = [[NSMutableArray alloc] init];
	m_offCookies = [[NSMutableArray alloc] init];
	
	return self;
}

- (id) init
{
	return [self initWithMidiManager:nil];
}

- (void) dealloc
{
	[m_buttonCookies release];
	[m_offCookies release];
	[m_midiManager release];
	
	m_buttonCookies = nil;
	m_offCookies = nil;
	m_midiManager = nil;
	
	[super dealloc];
}

- (void) setMidiManager: (VVMIDIManager *) midiManager
{
	m_midiManager = [midiManager retain];
}

- (void) addButtonCookie: (unsigned) cookie
{
	NSNumber *cookieNumber = [NSNumber numberWithUnsignedInt:cookie];
	[m_buttonCookies addObject:cookieNumber];
}

- (void) setButtonCookies: (NSMutableArray *) cookies
{
    if (m_buttonCookies != cookies)
    {
        [m_buttonCookies release];
        m_buttonCookies = [cookies retain];
    }
}

- (void) addOffCookie: (unsigned) cookie
{
	NSNumber *cookieNumber = [NSNumber numberWithUnsignedInt:cookie];
	[m_offCookies addObject:cookieNumber];
}

- (void) setOffCookies: (NSMutableArray *) cookies
{
    if (m_offCookies != cookies)
    {
        [m_offCookies release];
        m_offCookies = [cookies retain];
    }
}

- (int) normalizeVelocity: (int) velocity
{
	int normV;
	
	if (self.velocityCookie == 0)
	{
		// Random Velocity
		normV = arc4random() % (self.maximumMidiVelocity - self.minimumMidiVelocity);
		normV = normV + self.minimumMidiVelocity;
	}
	else
	{
		// Normal Velocity
		normV = (((self.maximumMidiVelocity - self.minimumMidiVelocity) * 
				  (velocity - self.minimumRawVelocity)) / 
				 (self.maximumRawVelocity - self.minimumRawVelocity));
		normV = normV + self.minimumMidiVelocity;
	}
	
	if (self.invertVelocity) normV = (self.maximumMidiVelocity + self.minimumMidiVelocity) - normV;
	if (normV > self.maximumMidiVelocity) normV = self.maximumMidiVelocity;
	if (normV < self.minimumMidiVelocity) normV = self.minimumMidiVelocity;
	return normV;
}

- (NSArray *) buttonCookies
{
	return m_buttonCookies;
}

- (NSArray *) offCookies
{
	return m_offCookies;
}

- (void) noteOn: (int) velocity
{
	VVMIDIMessage *msg = nil;
	int normalizedVelocity = [self normalizeVelocity: velocity];
	
	isOn = YES;
	msg = [VVMIDIMessage createFromVals: VVMIDINoteOnVal: midiChannel: midiNote: normalizedVelocity];
	if (msg != nil) [m_midiManager sendMsg:msg];
	NSLog(@"Note On:  %@ [%d] (%d)", self.name, self.midiNote, normalizedVelocity);
}

- (void) noteOff
{
	VVMIDIMessage *msg = nil;
	
	isOn = NO;
	msg = [VVMIDIMessage createFromVals: VVMIDINoteOffVal: midiChannel: midiNote: 0];
	if (msg != nil) [m_midiManager sendMsg:msg];
}

@end
