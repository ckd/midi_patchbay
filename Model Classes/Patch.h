#import <AppKit/AppKit.h>
#import <CoreMIDI/CoreMIDI.h>
#import <PYMIDI/PYMIDIEndpoint.h>

@interface Patch : NSObject <NSCoding> {
    BOOL			isInLimbo;
    
    BOOL			isEnabled;
    
    PYMIDIEndpoint*	input;
    
    BOOL			shouldFilterChannel;
    NSUInteger	    channelMask;
    
    BOOL			shouldAllowNotes;
    BOOL			shouldFilterRange;
    Byte			lowestAllowedNote;
    Byte			highestAllowedNote;
    
    BOOL			shouldTranspose;
    NSInteger		transposeDistance;
    
    BOOL			shouldRemapChannel;
    NSInteger		remappingChannel;
    
    BOOL			shouldTransmitClock;
    
    PYMIDIEndpoint*	output;
}

#pragma mark Initialisation

- (Patch*)initWithInput:(PYMIDIEndpoint*)newInput output:(PYMIDIEndpoint*)newOutput;
- (Patch*)initFromPatch:(Patch*)patch;
- (void)dealloc;

- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;

#pragma mark Limbo handling

- (BOOL)isInLimbo;
- (void)banishToLimbo;
- (void)rescueFromLimbo;

#pragma mark Description

- (NSString*)description;

#pragma mark Enabling

- (BOOL)isEnabled;
- (void)setIsEnabled:(BOOL)newIsEnabled;

#pragma mark Input

- (PYMIDIEndpoint*)input;
- (void)setInput:(PYMIDIEndpoint*)newInput;

#pragma mark Filters - Filter channels

- (BOOL)shouldFilterChannel;
- (void)setShouldFilterChannel:(BOOL)newShouldFilterChannel;
- (NSUInteger)channelMask;
- (void)setChannelMask:(NSUInteger)newChannelMask;

#pragma mark Filters - Remap channels

- (BOOL)shouldRemapChannel;
- (void)setShouldRemapChannel:(BOOL)newShouldRemapChannel;
- (NSInteger)remappingChannel;
- (void)setRemappingChannel:(NSInteger)newRemappingChannel;

#pragma mark Filters - Allow notes

- (BOOL)shouldAllowNotes;
- (void)setShouldAllowNotes:(BOOL)newShouldAllowNotes;

#pragma mark Filters - Filter range

- (BOOL)shouldFilterRange;
- (void)setShouldFilterRange:(BOOL)newShouldFilterRange;
- (Byte)lowestAllowedNote;
- (void)setLowestAllowedNote:(Byte)newLowestAllowedNote;
- (Byte)highestAllowedNote;
- (void)setHighestAllowedNote:(Byte)newHighestAllowedNote;

#pragma mark Filters - Transpose

- (BOOL)shouldTranspose;
- (void)setShouldTranspose:(BOOL)newShouldTranspose;
- (NSInteger)transposeDistance;
- (void)setTransposeDistance:(NSInteger)newTransposeDistance;

#pragma mark Filters - Transmit clock

- (BOOL)shouldTransmitClock;
- (void)setShouldTransmitClock:(BOOL)newShouldTransmitClock;

#pragma mark Output

- (PYMIDIEndpoint*)output;
- (void)setOutput:(PYMIDIEndpoint*)newOutput;

#pragma mark MIDI packet handling

- (void)processMIDIPacketList:(const MIDIPacketList*)packetList sender:(id)sender;

@end
