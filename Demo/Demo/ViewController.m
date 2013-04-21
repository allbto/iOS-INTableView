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
    
    //
    // Here we begin to put cells into our tableView
    //
    
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
