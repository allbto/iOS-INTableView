//
//  ViewController.h
//  Demo
//
//  Created by Allan Barbato on 4/12/13.
//  Copyright (c) 2013 Allan Barbato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTableView.h"

@interface ViewController : UIViewController
<INTableViewDelegate> // We want our view controller to be the delegate of our INTableView

// Our demo INTableView
@property (retain, nonatomic) IBOutlet INTableView*          tableView;

@end
