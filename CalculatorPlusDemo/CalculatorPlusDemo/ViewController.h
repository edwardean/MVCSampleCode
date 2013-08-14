//
//  ViewController.h
//  CalculatorPlusDemo
//
//  Created by Kevin McNeish on 12/9/12.
//  Copyright (c) 2012 Oak Leaf Enterprises, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) Calculator *calculator;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *operationHighlightImages;
- (IBAction)highlightOperation:(UIButton *)sender;
- (IBAction)numberTouched:(UIButton *)sender;
- (IBAction)operationTouched:(UIButton *)sender;

@end
