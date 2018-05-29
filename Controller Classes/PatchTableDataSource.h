#import <Cocoa/Cocoa.h>

@class Patch;
@class PatchbayDocument;


@interface PatchTableDataSource : NSObject {
    PatchbayDocument*	document;
    NSMutableArray*		patchArray;
}

- (PatchTableDataSource*)initWithDocument:(PatchbayDocument*)newDocument patchArray:(NSMutableArray*)newPatchArray;
- (void)dealloc;

- (void)setPatchArray:(NSMutableArray*)newPatchArray;

- (NSInteger)numberOfRowsInTableView:(NSTableView*)tableView;
- (id)tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn*)column row:(NSInteger)rowIndex;
- (void)tableView:(NSTableView*)tableView setObjectValue:(id)value forTableColumn:(NSTableColumn*)column row:(NSInteger)rowIndex;
- (void)deleteSelection:(NSTableView*)tableView;

@end
