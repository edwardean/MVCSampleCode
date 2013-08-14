//
//  ViewController.m
//  CalculatorPlusDemo
//
//  Created by Kevin McNeish on 12/9/12.
//  Copyright (c) 2012 Oak Leaf Enterprises, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark -
#pragma mark View Controller methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Create the calculator and register the updateDisplay callback method
	self.calculator = [[Calculator alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Calculator User Interface
// Highlight the specified operation button
- (IBAction)highlightOperation:(UIButton *)sender {
	
	for (UIImageView *imageView in self.operationHighlightImages) {
		if (imageView.tag == sender.tag) {
			imageView.alpha = 1;
		}
		else {
			imageView.alpha = 0;
		}
	}
}

// Hide any operation button highlight
-(void)hideOperationHighlight
{
	for (UIImageView *imageView in self.operationHighlightImages) {
		
		imageView.alpha = 0;
	}
}

// Action method for number buttons
- (IBAction)numberTouched:(UIButton *)sender {
	
	[self hideOperationHighlight];
	NSString *numberString;
	NSInteger tagNumber = [sender tag];
	if (tagNumber == -1) {
		numberString = @".";
	}
	else {
		numberString = [NSString stringWithFormat:@"%i", tagNumber];
	}
	
	self.lblTotal.text =
	[self.calculator processNumber:numberString];
}

// Action method for operation buttons
- (IBAction)operationTouched:(UIButton *)sender {
	
	NSInteger tagNumber = [sender tag];
	if (tagNumber == OperationClear) {
		[self hideOperationHighlight];
	}
	
	self.lblTotal.text =
	[self.calculator performOperation:tagNumber];
}

// Calculator callback method. This method updates
// the display when called by the Calculator
-(void)updateDisplay:(NSString *)value
{
	self.lblTotal.text = value;
}

@end

