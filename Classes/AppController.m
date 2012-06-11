//
//  AppController.m
//  RBDrumz
//
//  Created by Rodrigo Sieiro on 20/02/2010.
//  Copyright 2010 SharpCube. All rights reserved.
//

#import "AppController.h"

@implementation AppController

- (id) init
{
	[super init];

	[self loadMidiManager];
	[self loadDevices];
	[self loadObjectsFromFile:@"teste"];

	return self;
}

- (void) awakeFromNib
{
    [mWindow center];
    [mWindow makeKeyAndOrderFront: self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (void) loadMidiManager
{
	if (m_midiManager != nil) [m_midiManager release];
	m_midiManager = [[VVMIDIManager alloc] init];
}

- (void) loadDevices
{
    NSArray *joysticks = [RBDrumkit allJoysticks];
	[joysticks makeObjectsPerformSelector: @selector(setDelegate:) withObject: self];
	
    if (m_joysticks != joysticks)
    {
        [m_joysticks release];
        m_joysticks = [joysticks retain];
    }
	
	NSLog(@"Total Devices found: %d", [m_joysticks count]);
}

- (void) loadObjectsFromFile: (NSString *) filename
{
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *plistPath = [rootPath stringByAppendingPathComponent:@"XBOX360.plist"];
	RBTrigger *trigger;
	RBSwitch *rbswitch;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
		plistPath = [[NSBundle mainBundle] pathForResource:@"XBOX360" ofType:@"plist"];
	}
	
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
										  propertyListFromData: plistXML
										  mutabilityOption: NSPropertyListMutableContainersAndLeaves
										  format:&format										  
										  errorDescription:&errorDesc];
	
	if (!temp)
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
		return;
	}
	
	NSLog(@"Kit Name: %@", [temp objectForKey:@"Name"]);
	
	NSArray *triggers = [temp objectForKey:@"Triggers"];
	
	if (m_triggers != nil) [m_triggers release];
	m_triggers = [[NSMutableArray alloc] init];
	
	for (NSDictionary *trigger_data in triggers)
	{
		NSLog(@"Trigger Name: %@", [trigger_data objectForKey:@"Name"]);
		
		trigger = [[RBTrigger alloc] initWithMidiManager:m_midiManager];
		
		trigger.triggerID = [[trigger_data objectForKey:@"ID"] intValue];
		trigger.name = [trigger_data objectForKey:@"Name"];
		trigger.midiChannel = [[trigger_data objectForKey:@"MidiChannel"] intValue];
		trigger.midiNote = [[trigger_data objectForKey:@"MidiNote"] intValue];
		trigger.vendorId = [[trigger_data objectForKey:@"VendorID"] intValue];
		trigger.productId = [[trigger_data objectForKey:@"ProductID"] intValue];
		trigger.locationId = 0;
		trigger.minimumRawVelocity = [[trigger_data objectForKey:@"MinimumRawVelocity"] intValue];
		trigger.maximumRawVelocity = [[trigger_data objectForKey:@"MaximumRawVelocity"] intValue];
		trigger.minimumMidiVelocity = [[trigger_data objectForKey:@"MinimumMidiVelocity"] intValue];
		trigger.maximumMidiVelocity = [[trigger_data objectForKey:@"MaximumMidiVelocity"] intValue];
		trigger.invertVelocity = [[trigger_data objectForKey:@"InvertVelocity"] boolValue];
		trigger.velocityCookie = [[trigger_data objectForKey:@"VelocityCookie"] intValue];
		[trigger setButtonCookies: [trigger_data objectForKey:@"ButtonCookies"]];
		[trigger setOffCookies: [trigger_data objectForKey:@"OffCookies"]];
		
		for (RBDrumkit *joystick in m_joysticks)
		{
			if (trigger.vendorId == joystick.vendorId &&
				trigger.productId == joystick.productId &&
				trigger.locationId == 0)
			{
				trigger.locationId = joystick.locationId;
				if (trigger.velocityCookie > 0) [joystick addCookieToMonitor: trigger.velocityCookie];
				
				for (NSNumber *number in [trigger buttonCookies])
				{
					[joystick addCookieToMonitor: [number unsignedIntValue]];
				}

				for (NSNumber *number in [trigger offCookies])
				{
					[joystick addCookieToMonitor: [number unsignedIntValue]];
				}
			}
		}

		[m_triggers addObject: trigger];
		[trigger release];
	}

	NSArray *switches = [temp objectForKey:@"Switches"];
	
	if (m_switches != nil) [m_switches release];
	m_switches = [[NSMutableArray alloc] init];
	
	for (NSDictionary *switch_data in switches)
	{
		NSLog(@"Switch Name: %@", [switch_data objectForKey:@"Name"]);
		
		rbswitch = [[RBSwitch alloc] init];
		
		rbswitch.switchID = [[switch_data objectForKey:@"ID"] intValue];
		rbswitch.name = [switch_data objectForKey:@"Name"];
		rbswitch.triggerID = [[switch_data objectForKey:@"TriggerID"] intValue];
		rbswitch.midiNote = [[switch_data objectForKey:@"MidiNote"] intValue];
		rbswitch.vendorId = [[switch_data objectForKey:@"VendorID"] intValue];
		rbswitch.productId = [[switch_data objectForKey:@"ProductID"] intValue];
		rbswitch.locationId = 0;
		[rbswitch setButtonCookies: [switch_data objectForKey:@"ButtonCookies"]];
		[rbswitch setOffCookies: [switch_data objectForKey:@"OffCookies"]];
		
		for (RBTrigger *tr in m_triggers)
		{
			if (rbswitch.triggerID == tr.triggerID)
			{
				[rbswitch setTrigger: tr];
			}
		}
		
		for (RBDrumkit *joystick in m_joysticks)
		{
			if (rbswitch.vendorId == joystick.vendorId &&
				rbswitch.productId == joystick.productId &&
				rbswitch.locationId == 0)
			{
				rbswitch.locationId = joystick.locationId;
				
				for (NSNumber *number in [rbswitch buttonCookies])
				{
					[joystick addCookieToMonitor: [number unsignedIntValue]];
				}
				
				for (NSNumber *number in [rbswitch offCookies])
				{
					[joystick addCookieToMonitor: [number unsignedIntValue]];
				}
			}
		}
		
		[m_switches addObject: rbswitch];
		[rbswitch release];
	}
	
	for (RBDrumkit *joystick in m_joysticks)
	{
		if ([joystick elementsToMonitorCount] > 0)
		{
			NSLog(@"Listening to Device: %@", joystick.productName);
			[joystick startListening];
		}
	}
	
	NSLog(@"Total triggers found: %d", [m_triggers count]);
	NSLog(@"Total switches found: %d", [m_switches count]);
}

- (void) rbDrumKitStateChanged: (RBDrumkit *) joystick
{
	BOOL isOn;

	for (RBSwitch *sw in m_switches)
	{
		if (sw.vendorId == joystick.vendorId &&
			sw.productId == joystick.productId &&
			sw.locationId == joystick.locationId)
		{
			isOn = YES;
			
			for (NSNumber *number in [sw buttonCookies])
			{
				if ([joystick valueForCookie: [number unsignedIntValue]] == 0) isOn = NO;
			}
			
			for (NSNumber *number in [sw offCookies])
			{
				if ([joystick valueForCookie: [number unsignedIntValue]] == 1) isOn = NO;
			}
			
			if (sw.isOn && !isOn) [sw switchOff];
			if (!sw.isOn && isOn) [sw switchOn];
		}
	}
	
	for (RBTrigger *trigger in m_triggers)
	{
		if (trigger.vendorId == joystick.vendorId &&
			trigger.productId == joystick.productId &&
			trigger.locationId == joystick.locationId)
		{
			isOn = YES;
			
			for (NSNumber *number in [trigger buttonCookies])
			{
				if ([joystick valueForCookie: [number unsignedIntValue]] == 0) isOn = NO;
			}

			for (NSNumber *number in [trigger offCookies])
			{
				if ([joystick valueForCookie: [number unsignedIntValue]] == 1) isOn = NO;
			}
			
			if (trigger.isOn && !isOn) [trigger noteOff];
			if (!trigger.isOn && isOn) [trigger noteOn: [joystick valueForCookie: trigger.velocityCookie]];
		}
	}
}

@end
