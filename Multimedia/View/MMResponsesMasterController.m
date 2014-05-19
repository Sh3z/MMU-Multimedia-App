//
//  MMResponsesMasterController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 26/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "MMResponsesTableModel.h"
#import "MMResponsesMasterController.h"
#import "MMResponseTableDataModel.h"
#import "MMCoreDataAssistant.h"
#import "MultimediaApp.h"
#import "MMCoreDataAssistant.h"
#import "MMResponseToCSV.h"
#import "MMResponseDateGroup.h"
#import "MultimediaResponse.h"
#import "CameraEngine.h"

@interface MMResponsesMasterController ()<MMResponsesTableDelegate, UIActionSheetDelegate>
{
	UIBarButtonItem* _editButton;
	UIBarButtonItem* _doneButton;
	UIBarButtonItem* _trashButton;
	UIActionSheet* _deleteSheet;
	UIActionSheet* _exportSheet;
}

@property (strong, nonatomic) MMResponsesTableModel* tableModel;

@property (strong, nonatomic) UIBarButtonItem* strongExportButtonReference;

@end

@implementation MMResponsesMasterController

@synthesize responses = _responses, responsesDelegate, responsesTitle = _responsesTitle;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.responsesDelegate = (id<MMResponsesDelegate>)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	_tableModel = [[MMResponsesTableModel alloc] init];
	_tableModel.tableView = self.tableView;
	self.tableView.dataSource = _tableModel;
	self.tableView.delegate = _tableModel;
	
	_tableModel.responsesDelegate = self;
	
	_editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didTapEditButton:)];
	_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapDoneButton:)];
	_trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(didTapTrashButton:)];
	
	self.strongExportButtonReference = _exportButton;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self updateToolbar];
	[_tableModel setResponses:_responses];
	[self.tableView reloadData];
	self.navigationItem.title = _responsesTitle;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if([self.responsesDelegate respondsToSelector:@selector(responseSource:newAvailableResponses:)])
	{
		[self.responsesDelegate responseSource:self newAvailableResponses:[[NSArray alloc] init]];
	}
}

- (void)updateToolbar
{
	NSArray* currentItems = [self.actionsToolbar items];
	NSMutableArray* items = [[NSMutableArray alloc] initWithObjects:[currentItems firstObject], nil];
	[items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
	
	if([self.tableView isEditing])
	{
		[items addObject:_trashButton];
		[items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
		[items addObject:_doneButton];
	}
	else
	{
		[items addObject:_editButton];
	}
	
	[[items firstObject] setEnabled:YES];
	[self.actionsToolbar setItems:items animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if([self.responsesDelegate respondsToSelector:@selector(responseSource:newAvailableResponses:)])
	{
		[self.responsesDelegate responseSource:self newAvailableResponses:self.responses];
	}
}

- (void)didTapEditButton:(id)sender
{
	[self.tableView setEditing:YES animated:YES];
	[self updateToolbar];
	
	_exportButton.enabled = NO;
	_trashButton.enabled = NO;
}

- (void)didTapDoneButton:(id)sneder
{
	[self.tableView setEditing:NO animated:YES];
	[self updateToolbar];
}

- (void)didTapExportButton:(id)sender
{
	if(_exportSheet || _deleteSheet)
	{
		return;
	}
	
	NSString* title;
	if([self.tableView isEditing])
	{
		// Multiselect mode
		int numSelected = [[self.tableView indexPathsForSelectedRows] count];
		NSString* pluralCatch = numSelected == 1 ? @"Response" : @"Responses";
		title = [NSString stringWithFormat:@"Export %i %@", numSelected, pluralCatch];
	}
	else
	{
		// Aggregate mode
		title = @"Export All";
	}
	
	_exportSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles:@"To Camera Roll", @"By E-mail", nil];
	[_exportSheet showFromBarButtonItem:self.exportButton animated:YES];
}

- (void)didTapTrashButton:(id)sender
{
	if([self.tableView isEditing] && !(_deleteSheet || _exportSheet))
	{
		int numSelected = [[self.tableView indexPathsForSelectedRows] count];
		NSString* pluralCatch = numSelected == 1 ? @"Response" : @"Responses";
		NSString* deleteTitle = [NSString stringWithFormat:@"Delete %i %@", numSelected, pluralCatch];
		
		_deleteSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:deleteTitle otherButtonTitles: nil];
		[_deleteSheet showFromBarButtonItem:_trashButton animated:YES];
	}
}

- (void)deleteDatedGroups:(NSMutableArray *)selectedGrouped setPostDeletionResponses:(NSMutableArray *)responses
{
	[self.tableView beginUpdates];
	
	[selectedGrouped sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"groupAcquisitionDate" ascending:NO]]];
	int section = 0;
	for(MMResponseDateGroup* group in selectedGrouped)
	{
		if([[group responses] count] == [self.tableView numberOfRowsInSection:section])
		{
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationLeft];
		}
		else
		{
			NSMutableArray* paths = [[NSMutableArray alloc] initWithCapacity:[[group responses] count]];
			for(MultimediaResponse* response in [group responses])
			{
				[paths addObject:[self.tableModel pathForResponse:response]];
			}
			
			[self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
		}
	}
	
	[self.tableModel setResponses:responses];
	[self.tableView endUpdates];
	[self.tableView setEditing:NO animated:YES];
	
	if([self.responsesDelegate respondsToSelector:@selector(currentResponse)])
	{
		if([responses containsObject:[self.responsesDelegate currentResponse]] == NO)
		{
			self.responsesDelegate.currentResponse = nil;
		}
	}
	
	if([self.responsesDelegate respondsToSelector:@selector(responseSource:newAvailableResponses:)])
	{
		[self.responsesDelegate responseSource:self newAvailableResponses:responses];
	}
}

#pragma mark - MMResponsesTableDelegate

- (void)tableModel:(MMResponsesTableModel *)model didSelectResponse:(MultimediaResponse *)response
{
	// Only pass on notifications if the table isn't editing while in selection mode
	if([self.tableView isEditing] == NO)
	{
		if([self.responsesDelegate respondsToSelector:@selector(responseSource:didSelectResponse:)])
		{
			[self.responsesDelegate responseSource:self didSelectResponse:response];
		}
	}
}

- (void)tableModel:(MMResponsesTableModel *)model isMultiselectingAndSelected:(MultimediaResponse *)response
{
	BOOL enableButtons = [[self.tableView indexPathsForSelectedRows] count] > 0;
	_exportButton.enabled = enableButtons;
	_trashButton.enabled = enableButtons;
}

- (void)tableModel:(MMResponsesTableModel *)model isMultiselectingAndDeselected:(MultimediaResponse *)response
{
	BOOL enableButtons = [[self.tableView indexPathsForSelectedRows] count] > 0;
	_exportButton.enabled = enableButtons;
	_trashButton.enabled = enableButtons;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet == _deleteSheet)
	{
		[self deleteSheetResponse:buttonIndex];
	}
	else
	{
		[self exportResponse:buttonIndex];
	}
}

- (void)exportResponsesToCameraRoll:(NSArray*)responses
{
	for(MultimediaResponse* response in responses)
	{
		if([response recordingFileIdentifier])
		{
			[[CameraEngine engine] exportVideoToCameraRoll:[response recordingFileIdentifier] waitForCompletion:YES];
		}
	}
	
	[[[UIAlertView alloc] initWithTitle:@"Recordings Exported" message:@"The recordings can be found in your Camera Roll under 'Videos'" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil] show];
}


- (NSArray*)selectedResponses
{
	NSArray* selectedPaths = [self.tableView indexPathsForSelectedRows];
	NSMutableArray* responses = [[NSMutableArray alloc] initWithCapacity:[selectedPaths count]];
	for(NSIndexPath* path in selectedPaths)
	{
		[responses addObject:[self.tableModel responseAtIndexPath:path]];
	}
	
	return responses;
}

- (void)exportResponse:(NSInteger)index
{
	_exportSheet = nil;
	
	NSArray* responses = [self.tableView isEditing] ? [self selectedResponses] : self.responses;
	if(index == 0)
	{
		NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(exportResponsesToCameraRoll:) object:responses];
		[thread start];
		
		[[[UIAlertView alloc] initWithTitle:@"Exporting Videos" message:@"Exporting videos to Camera Roll. This may take several minutes." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
	}
	else if(index == 1)
	{
		[super emailResponses:responses withFileName:@"Responses" andSubject:@"Responses"];
	}
}

- (void)deleteSheetResponse:(NSInteger)index
{
	if(index == [_deleteSheet destructiveButtonIndex])
	{
		// Delete model objects, then delete rows
		NSArray* selectedPaths = [self.tableView indexPathsForSelectedRows];
		NSMutableArray* selectedGrouped = [[NSMutableArray alloc] initWithCapacity:[selectedPaths count]];
		NSMutableArray* postDeletionResponses = [[self.tableModel responses] mutableCopy];
		for(NSIndexPath* path in selectedPaths)
		{
			MultimediaResponse* response = [self.tableModel responseAtIndexPath:path];
			[postDeletionResponses removeObject:response];
			BOOL added = NO;
			for(MMResponseDateGroup* group in selectedGrouped)
			{
				if([group doesResponseBelongInGroup:response])
				{
					[group addResponseToGroup:response];
					added = YES;
					break;
				}
			}
			
			if(!added)
			{
				MMResponseDateGroup* group = [[MMResponseDateGroup alloc] initWithDateOfAcquisition:[response timeBegan]];
				[group addResponseToGroup:response];
				[selectedGrouped addObject:group];
			}
			
			[MMCoreDataAssistant deleteResponse:response];
		}
		
		[self deleteDatedGroups:selectedGrouped setPostDeletionResponses:postDeletionResponses];
		[self updateToolbar];
	}
	
	_deleteSheet = nil;
}

@end
