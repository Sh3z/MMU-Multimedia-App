//
//  MMMediaController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMMediaController.h"
#import "MultimediaResponse.h"
#import "MediaResponse.h"
#import "MMMultimediaPresenter.h"
#import "MMPresenterFactory.h"
#import "MMResponseTableDataModel.h"
#import "XYPieChart.h"
#import "MMMediaResponseChartDataSource.h"

@interface MMMediaController ()
{
	/// Contains the model used to populate the tabel.
	MMResponseTableDataModel* _tableModel;
}

@end

@implementation MMMediaController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_tableModel = [[MMResponseTableDataModel alloc] init];
	[_informationTable setDataSource:_tableModel];
	[_informationTable setDelegate:_tableModel];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[_tableModel setParentResponse:_parentResponse];
	[_tableModel setMediaResponse:_mediaResponse];
	[_informationTable reloadData];
	
	if(_parentResponse && _mediaResponse)
	{
		MMMediaResponseChartDataSource* dataSource = [MMMediaResponseChartDataSource createWithResponse:_mediaResponse];
		[dataSource calculateInformation];
		self.responsesPieChart.dataSource = dataSource;
		self.responsesPieChart.showPercentage = NO;
		
		[self.responsesPieChart reloadData];
	}
}

- (void)onSetAsCurrentView
{
	[_informationTable reloadData];
}

- (void)onHiddenFromView
{
}

@end
