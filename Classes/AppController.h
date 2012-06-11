//
//  AppController.h
//  RBDrumz
//
//  Created by Rodrigo Sieiro on 20/02/2010.
//  Copyright 2010 SharpCube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DDHidLib/DDHidLib.h>
#import <VVMIDI/VVMIDI.h>
#import "RBDrumkit.h"
#import "RBTrigger.h"
#import "RBSwitch.h"

@interface AppController : NSObject
{
	IBOutlet NSWindow *mWindow;
	
    NSArray *m_joysticks;
	VVMIDIManager *m_midiManager;
	NSMutableArray *m_triggers;
	NSMutableArray *m_switches;
}

- (void) loadMidiManager;
- (void) loadDevices;
- (void) loadObjectsFromFile: (NSString *) filename;

@end
