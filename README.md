INTableView
===========

Simplify the Apple's UITableView Usage, by creating easy to use TableViews and Cells

A simple usage :

```Obj-C

    //Where self.tableView is an outlet on an INTableView inside a XIB or a Storyboard

    // By calling this method you allow the tableView to have a pullToRefresh View and to call this block when the user reloads it
    [self.tableView setPullToRefresh:YES withBlock:^(INTableView *tableView) {
        NSLog(@"Did Pull to Refresh");
        
        // Once you're over with your download and stuffs don't forget to call :
        tableView.loading = NO;
    }];
    
    // Putting cells into the tableView
    [self.tableView addCell:[INTableViewCell defaultCellWithTitle:@"Title" detailText:@"Detail" selectBlock:^(INTableViewCell *cell) {
        cell.textLabel.text = [[NSDate date] description];
    }]];
    [self.tableView addCell:[INTableViewInputCell inputCellWithTitle:@"Title" prompt:@"Prompt"]];
    [self.tableView addCell:[INTableViewSwitchCell defaultCell]];
    [self.tableView addCell:[INTableViewLoadingCell defaultCell]];
    
```

Will produce :

![ScreenShot](https://github.com/bartaba666/INTableView/blob/master/Demo/Demo/ScreenShot.png?raw=true)

===========

This is totally in development, nothing finished yet.
A tutorial and a demo will come.
