//
//  RBSwitch.m
//  RBDrumz
//
//  Created by Rodrigo Sieiro on 15/03/2010.
//  Copyright 2010 SharpCube. All rights reserved.
//

#import "RBSwitch.h"

@implementation RBSwitch

@synthesize switchID;
@synthesize name;
@synthesize triggerID;
@synthesize midiNote;
@synthesize vendorId;
@synthesize productId;
@synthesize locationId;
@synthesize isOn;

- (id) init
{
	if (![super init]) return nil;
	
	isOn = NO;
	m_buttonCookies = [[NSMutableArray alloc] init];
	m_offCookies = [[NSMutableArray alloc] init];
	
	return self;
}

- (void) dealloc
{
	[m_buttonCookies release];
	[m_offCookies release];
	[m_trigger release];
	
	m_buttonCookies = nil;
	m_offCookies = nil;
	m_trigger = nil;
	
	[super dealloc];
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

- (void) setTrigger: (RBTrigger *) trigger
{
    if (m_trigger != trigger)
    {
        [m_trigger release];
        m_trigger = [trigger retain];
    }
}

- (NSArray *) buttonCookies
{
	return m_buttonCookies;
}

- (NSArray *) offCookies
{
	return m_offCookies;
}

- (void) switchOn
{
	isOn = YES;
	
	oldNote = m_trigger.midiNote;
	m_trigger.midiNote = self.midiNote;
	NSLog(@"Switch On:  %@", self.name);
}

- (void) switchOff
{
	isOn = NO;
	
	m_trigger.midiNote = oldNote;
	NSLog(@"Switch Off:  %@", self.name);
}

@end
