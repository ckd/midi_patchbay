#import <Cocoa/Cocoa.h>
#import <PYMIDI/PYMIDI.h>


@interface EndpointTableDataSource : NSObject {
    Class			endpointClass;
    NSMutableArray*	endpointArray;
    NSUndoManager*  undoManager;
}

- (EndpointTableDataSource*)initWithEndpointClass:(Class)newEndpointClass endpointArray:(NSMutableArray*)newEndpointArray undoManager:(NSUndoManager*)newUndoManager;
- (void)dealloc;

- (void)setEndpointArray:(NSMutableArray*)newEndpointArray;

- (NSInteger)numberOfRowsInTableView:(NSTableView*)tableView;
- (id)tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn*)column row:(NSInteger)rowIndex;
- (BOOL)control:(NSControl*)control isValidObject:(id)value;
- (void)tableView:(NSTableView*)tableView setObjectValue:(id)value forTableColumn:(NSTableColumn*)column row:(NSInteger)rowIndex;
- (void)deleteSelection:(NSTableView*)tableView;

- (BOOL)tabView:(NSTabView*)tabView shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem;

- (void)tableView:(NSTableView*)tableView newEndpointWithName:(NSString*)name;
- (void)tableView:(NSTableView*)tableView addEndpoint:(PYMIDIVirtualEndpoint*)endpoint atIndex:(NSInteger)index;
- (void)tableView:(NSTableView*)tableView removeEndpointAtIndex:(NSInteger)index;
- (void)tableView:(NSTableView*)tableView setName:(NSString*)name forEndpointAtIndex:(NSInteger)index;

@end
