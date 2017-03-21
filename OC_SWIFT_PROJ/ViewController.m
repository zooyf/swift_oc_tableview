//
//  ViewController.m
//  OC_SWIFT_PROJ
//
//  Created by 澳达国际 on 17/3/16.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

#import "ViewController.h"
#import "OC_SWIFT_PROJ-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnAction:(UIButton *)sender {
    
    TMCountryCodeController *countryCodeController = [[TMCountryCodeController alloc] initWithNibName:@"TMCountryCodeController" bundle:nil];
//    countryCodeController
    [countryCodeController setSelectBlock:^(NSArray<NSString *> * countryArray) {
        NSLog(@"%@", countryArray);
        [sender setTitle:countryArray[2] forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:countryCodeController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
