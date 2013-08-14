//
//  ViewController.h
//  CalculatorDemo
//
//  Created by Kevin McNeish on 12/8/12.
//  Copyright (c) 2012 Oak Leaf Enterprises, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

typedef enum {
	OperationNone,
	OperationAdd,
	OperationSubtract,
	OperationMultiply,
	OperationDivide,
	OperationEquals,
	OperationClear,
	OperationMemoryPlus,
	OperationMemoryMinus,
	OperationMemoryRead,
	OperationMemoryClear,
	OperationPositiveNegative
} Operation;

@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *operationHighlightImages;
@property (strong, nonatomic) NSString *value;

- (IBAction)operationTouched:(UIButton *)sender;
- (IBAction)highlightOperation:(UIButton *)sender;
- (IBAction)numberTouched:(UIButton *)sender;

@end
