//
//  ViewController.m
//  Demo
//
//  Created by Allan Barbato on 4/12/13.
//  Copyright (c) 2013 Allan Barbato. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Start by setting the indelegate, it works like a delegate, but the var 'delegate' was already taken by the UITableView so it was confusing
    self.tableView.indelegate = self;
    
    // By calling this method you allow the tableView to have a pullToRefresh View and to call this block when the user reloads it
    [self.tableView setPullToRefresh:YES withBlock:^(INTableView *tableView) {
        NSLog(@"Did Pull to Refresh");
        
        // Once you're over with your downloads and stuffs don't forget to call :
        tableView.loading = NO;
    }];
    
    //
    // Here we begin to put cells into our tableView
    //
    
    // First let's create a section to hold the default cells
    // Note: If you use -addCell: without creating a section first, INTableView creates one for you
    [self.tableView addSectionWithTitle:@"Default cells" andFooter:nil];

    // Now we add a default cell with a selection block that change the title
    [self.tableView addCell:[INTableViewCell defaultCellWithTitle:@"Default Title" detailText:@"Default Detail" selectBlock:^(INTableViewCell *cell) {
        cell.textLabel.text = [[NSDate date] description];
    }]];

    // There is all of the default cells available in INTableViewCell.h
    [self.tableView addCell:[INTableViewCell subtitledCellWithTitle:@"Subtitled Title" subtitleText:@"Subtitled Subtitle" selectBlock:nil]];
    [self.tableView addCell:[INTableViewCell actionCellWithTitle:@"Action Title" selectBlock:nil]];
    [self.tableView addCell:[INTableViewCell pushCellWithTitle:@"Push Title" subtitleText:@"Push Subtitle" selectBlock:^(INTableViewCell *cell) {
        NSLog(@"Did use push cell"); 
    }]];
    [self.tableView addCell:[INTableViewCell imageCellWithImage:[UIImage imageNamed:@"happy-cat.jpg"] title:@"Image Title" detailText:@"Image detail" selectBlock:nil]];

    // Now the second section. The other built in cells
    [self.tableView addSectionWithTitle:@"Other cells" andFooter:nil];

    [self.tableView addCell:[INTableViewInputCell inputCellWithTitle:@"Input Title" prompt:@"Prompt"]];
    [self.tableView addCell:[INTableViewSwitchCell defaultCell]];
    [self.tableView addCell:[INTableViewLoadingCell loadingCell]];
    //INTableViewTextCell* textCell = [INTableViewTextCell textCellWithText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque dictum eros id nunc iaculis ultricies. Aenean at purus tortor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Quisque sit amet arcu nisi. Donec aliquam diam non lectus feugiat a ultrices tellus hendrerit. Curabitur tincidunt interdum arcu ut porttitor. Mauris eget ante sapien, at eleifend lorem. Nunc sem risus, tempus ac sodales vel, vulputate ac lacus. Sed eget lacus orci. Phasellus quis felis quis erat scelerisque ultricies quis vel turpis. Donec sapien arcu, pharetra vel posuere vitae, malesuada eu sem. Integer nisl urna, rutrum ut sodales at, convallis a felis." editable:YES];
    //textCell.expendWhenTextChanges = YES;
    //[self.tableView addCell:textCell];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    self.tableView = nil;
    [super viewDidUnload];
}
@end
