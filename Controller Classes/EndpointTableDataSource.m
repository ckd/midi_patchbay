#import "EndpointTableDataSource.h"
#import <PYMIDI/PYMIDI.h>


@implementation EndpointTableDataSource


- (EndpointTableDataSource*)initWithEndpointClass:(Class)newEndpointClass endpointArray:(NSMutableArray*)newEndpointArray undoManager:(NSUndoManager*)newUndoManager;
{
    self = [super init];
    
    if (self != nil) {
        endpointClass = newEndpointClass;
        endpointArray = [newEndpointArray retain];
        undoManager = [newUndoManager retain];
    }
    
    return self;
}


- (void)dealloc
{
    [endpointArray release];
    [undoManager release];
    
    [super dealloc];
}


- (void)setEndpointArray:(NSMutableArray*)newEndpointArray
{
    [newEndpointArray retain];
    [endpointArray release];
    endpointArray = newEndpointArray;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView*)tableView
{
    return [endpointArray count];
}


- (id)tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn*)column row:(NSInteger)rowIndex
{
    PYMIDIVirtualEndpoint* endpoint = [endpointArray objectAtIndex:rowIndex];
    
    return [endpoint name];
}



- (BOOL)control:(NSControl*)control isValidObject:(id)value
{
    if (PYMIDIIsEndpointNameTaken (value)) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Please choose a different name.";
        alert.informativeText = [NSString stringWithFormat:@"The name \"%@\" is already taken.", value];
        [alert runModal];
        return NO;
    }
    else
        return YES;
}


- (void)tableView:(NSTableView*)tableView setObjectValue:(id)value forTableColumn:(NSTableColumn*)column row:(NSInteger)rowIndex
{
    PYMIDIVirtualEndpoint* endpoint = [endpointArray objectAtIndex:rowIndex];

    if (![value isEqualToString:@""] && ![value isEqualToString:[endpoint name]]) {
        if (PYMIDIIsEndpointNameTaken (value)) {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"Please choose a different name.";
            alert.informativeText = [NSString stringWithFormat:@"The name \"%@\" is already taken.", value];
            [alert runModal];
        }
        else {
            [self tableView:tableView setName:(NSString*)value forEndpointAtIndex:rowIndex];
        }
    }
}


- (void)deleteSelection:(NSTableView*)tableView
{
    PYMIDIVirtualEndpoint* endpoint = [endpointArray objectAtIndex:[tableView selectedRow]];
    
    if ([endpoint isInUse]) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"";
        alert.informativeText = @"The selection is in use by one or more patches and cannot be deleted.";
        [alert runModal];
    }
    else {
        [self tableView:tableView removeEndpointAtIndex:[tableView selectedRow]];
    }
}


// This is a hack to make sure we don't switch tabs if the editing of an endpoint
// failed.  I would have thought that NSTabView would do this for us, but it doesn't.
- (BOOL)tabView:(NSTabView*)tabView shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem
{
    return [[tabView window] makeFirstResponder:nil];
}


- (void)tableView:(NSTableView*)tableView newEndpointWithName:(NSString*)name
{
    int 			i;
    NSString*		newName;
    PYMIDIVirtualEndpoint*	newEndpoint;
    
    NSWindow* window = [tableView window];
    if ([window isKeyWindow] && ![window makeFirstResponder:nil]) return;
    
    // Find a name for the endpoint that isn't taken
    i = 0;
    newName = name;
    while (PYMIDIIsEndpointNameTaken (newName)) {
        newName = [NSString stringWithFormat:@"%@ %d", name, ++i];
    }
    
    // Allocate the new endpoint and add it to the endpoint array
    newEndpoint = [[endpointClass alloc] initWithName:newName];
    
    [self tableView:tableView addEndpoint:newEndpoint atIndex:[endpointArray count]];

    [newEndpoint release];
}


- (void)tableView:(NSTableView*)tableView addEndpoint:(PYMIDIVirtualEndpoint*)endpoint atIndex:(NSInteger)index
{
    NSWindow* window = [tableView window];
    if ([window isKeyWindow] && ![window makeFirstResponder:nil]) return;
    
    [endpoint makePrivate:NO];
    [endpointArray insertObject:endpoint atIndex:index];
    
    [tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PYMIDISetupChanged" object:self];

    [[undoManager prepareWithInvocationTarget:self]
        tableView:tableView removeEndpointAtIndex:index
    ];
}


- (void)tableView:(NSTableView*)tableView removeEndpointAtIndex:(NSInteger)index
{
    NSWindow* window = [tableView window];
    if ([window isKeyWindow] && ![window makeFirstResponder:nil]) return;
    
    PYMIDIVirtualEndpoint* endpoint = [[endpointArray objectAtIndex:index] retain];
    
    [endpoint makePrivate:YES];
    [endpointArray removeObjectAtIndex:index];
    
    [tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PYMIDISetupChanged" object:self];
    
    [[undoManager prepareWithInvocationTarget:self]
        tableView:tableView addEndpoint:endpoint atIndex:index
    ];
    
    [endpoint release];
}


- (void)tableView:(NSTableView*)tableView setName:(NSString*)name forEndpointAtIndex:(NSInteger)index
{
    PYMIDIVirtualEndpoint* endpoint = [endpointArray objectAtIndex:index];
    NSString* oldName = [[endpoint name] retain];
    
    [endpoint setName:name];
    [tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PYMIDISetupChanged" object:self];
    
    [[undoManager prepareWithInvocationTarget:self]
        tableView:tableView setName:oldName forEndpointAtIndex:index
    ];
}


@end
