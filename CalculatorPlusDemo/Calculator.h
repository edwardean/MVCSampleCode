//
//  Calculator.h
//  CalculatorPlus
//
//  Created by Kevin McNeish on 4/24/12.
//  Copyright (c) 2012 Oak Leaf Enterprises, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface Calculator : NSObject

@property (strong, nonatomic) NSString *value;

- (NSString *)processNumber:(NSString *)character;
- (NSString *)performOperation:(Operation)operation;

@end
