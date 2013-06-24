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

    // Start by setting the target, it works like a delegate, but the var 'delegate' was already taken by the UITableView so it was confusing
    self.tableView.target = self;

    // You can also create a UITableView and assign it to our INTableView like that
    //self.tableView = [[INTableView alloc] initWithTableView:{The UITableView} target:self];
    // This is the old way, I used it because I had some problem with XIB file and INTableView, but it's fixed now
    
    // By calling this method you allow the tableView to have a pullToRefresh View and to call this block when the user reloads it
    [self.tableView setPullToRefresh:YES withBlock:^(INTableView *tableView) {
        NSLog(@"Did Pull to Refresh");
        
        // Once you're over with your download and stuffs don't forget to call :
        tableView.loading = NO;
    }];
    
    //
    // Here we begin to put cells into our tableView
    //
    [self.tableView addCell:[INTableViewCell defaultCellWithTitle:@"Title" detailText:@"Detail" selectBlock:^(INTableViewCell *cell) {
        cell.textLabel.text = [[NSDate date] description];
    }]];
    [self.tableView addCell:[INTableViewInputCell inputCellWithTitle:@"Title" prompt:@"Prompt"]];
    //[self.tableView addCell:<#(INTableViewCell *)#>]
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
