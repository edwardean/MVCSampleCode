//
//  Calculator.m
//  CalculatorPlus
//
//  Created by Kevin McNeish on 4/24/12.
//  Copyright (c) 2012 Oak Leaf Enterprises, Inc. All rights reserved.
//

#import "Calculator.h"

@interface Calculator ()

- (void)clear;
- (double)add:(double)value1 plus:(double)value2;
- (double)subtract:(double)value1 minus:(double)value2;
- (double)multiply:(double)value1 times:(double)value2;
- (double)divide:(double)dividend by:(double)divisor;
- (void)memoryClear;
- (void)memoryPlus:(double)value;
- (void)memoryRead;
- (void)makePositiveNegative;

@end

@implementation Calculator

// Previous value
double previousValue;
// The current memory value
double currentMemoryValue;
// Specifies if the last key pressed was a memory operation
BOOL isLastActionMemoryOperation;
// Specifies if the last key pressed was an operation
BOOL isLastActionOperation = true;
// Previous memory operation
Operation previousMemoryOperation;
// Previous operation key pressed
Operation previousOperation = OperationNone;
// Previous operation actually performed
Operation previousOperationPerformed = OperationNone;
// Number formatter
NSNumberFormatter *formatter;

// Properties
@synthesize value = value_;

// Constants
const int maxDigits = 9;
const int maxFractionDigits = 8;

// Default initialization
- (id)init
{
	self = [super init];
    if (self) {
		// Create an instance of the NSNumberFormatter
		formatter = [[NSNumberFormatter alloc] init];
		// Convert to an NSNumber, adding commas in formatting
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[formatter setMaximumFractionDigits:maxFractionDigits];
    }
	return self;
}

#pragma mark -
#pragma mark Calculator Core Logic

// Appends the specified character to the current display value

- (NSString *)processNumber:(NSString *)character
{	
	// Clear the display value if the last key was an operation
	if (isLastActionOperation) {
		self.value = @"";
	}
	
	// Make sure haven't reach maximum digits
	// First, remove all commas, then check length
	NSString *tempString = [self.value stringByReplacingOccurrencesOfString:@"," withString:@""];
	if ([tempString rangeOfString:@"."].location == NSNotFound) {
		if (tempString.length == maxDigits) {
			return self.value;
		}
	}
	else {
		if (tempString.length == maxDigits + 1) {
			return self.value;
		}
	}
	
	// Decimal point processing
	if ([character isEqualToString:@"."]) {
		
		// Don't allow multiple decimal points
		if ([self.value rangeOfString:@"."].location != NSNotFound) {
			return self.value;
		}
		
		// Prepend a zero if the display is empty 
		// and the user entered a decimal point
		if (self.value.length == 0)
		{
			self.value = @"0";
		}
		
		// Append the decimal point to the current string value
		self.value = [self.value stringByAppendingString:character];
	}
	else {
		
		// Remove all commas
		self.value = [self.value stringByReplacingOccurrencesOfString:@"," withString:@""];
		
		// Append the specified character to the current value
		self.value = [self.value stringByAppendingString:character];
		
		// Convert string to an NSNumber, adding commas in formatting
		NSNumber *number = [formatter numberFromString:self.value];
		
		// Convert back to a string
		self.value = [formatter stringFromNumber:number];
	}
	
	isLastActionOperation = false;
	isLastActionMemoryOperation = false;    
	
	return self.value;
}

// Performs the specified operation, if it's an operation
// that should be performed immediately, otherwise,
// performs any previous operation
- (NSString *)performOperation:(Operation)operation
{
	// Convert the display value from string to double
	double currentValue = [[self.value stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
	
	Operation doOperation;	// Operation to be performed
	if (previousOperation == OperationEquals) {
		doOperation = previousOperationPerformed;
	}
	else {
		doOperation = previousOperation;
	}
	
	@try {
		switch (operation) {
				
				// Check first for operations that should be 
				// performed immediately
			case OperationClear:
				[self clear];
				isLastActionMemoryOperation = false;
				break;
				
			case OperationMemoryPlus:
				[self memoryPlus:currentValue];
				isLastActionMemoryOperation = true;
				previousMemoryOperation = OperationMemoryPlus;
				break;
				
			case OperationMemoryMinus:
				[self memoryMinus:currentValue];
				isLastActionMemoryOperation = true;
				previousMemoryOperation = OperationMemoryMinus;
				break;
				
			case OperationMemoryClear:
				[self memoryClear];
				break;
				
			case OperationMemoryRead:
				[self memoryRead];
				break;
				
			case OperationPositiveNegative:
				[self makePositiveNegative];
				break;
				
			default:
				// If the previous key pressed was not an operation
				// or it was a memory operation, perform the previous
				// operation
				if (!isLastActionOperation || isLastActionMemoryOperation || operation == OperationEquals) {
					bool operationPerformed = true;
					double result = 0;
					
					switch (doOperation) {
						case OperationDivide:
							if (isLastActionOperation) {
								result = [self divide:currentValue by:previousValue];
							}
							else {
								result = [self divide:previousValue by:currentValue];
							}
							break;
						case OperationMultiply:
							result = [self multiply:previousValue times:currentValue];
							break;
						case OperationAdd:
							result = [self add:previousValue plus:currentValue];
							break;
						case OperationSubtract:
							if (isLastActionOperation) {
								result = [self subtract:currentValue minus:previousValue];
								
							}
							else {
								result = [self subtract:previousValue minus:currentValue];
							}
							break;
						default:
							operationPerformed = false;
							break;
					}
					
					// If a basic operation was performed, store the 
					// result in the current value
					if (operationPerformed) {
						NSNumber *number = [NSNumber numberWithDouble:result];
						self.value = [formatter stringFromNumber:number];
						previousOperationPerformed = doOperation;
					}
					
					// The following statement allows the calculator to perform the typical functionality
					// where pressing the equal sign multiple times repeats the previous operation
					
					// If the current operation is not Equals, store the curent value in the previous value
					if (operation != OperationEquals) {
						previousValue = [[self.value stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
						
					}
					else if (previousOperation != OperationEquals) {
						// The current operation is Equals, but the previous operation is not
						// Store the current value in the previous value
						previousValue = currentValue;
					}
				}
				
				// Store the current operation as the previous operation 
				previousOperation = operation;
				
				isLastActionMemoryOperation = false;
				break;
		}
	}
	// Catches errors that occur executing operations
	@catch (NSException *exception) {
		self.value = @"Error";
		previousValue = 0;
		previousOperation = OperationNone;
	}
	
	isLastActionOperation = true;
	
	return self.value;
}

// Clears the current and previous values
- (void)clear
{
	self.value = @"0";
	previousValue = 0;
	currentMemoryValue = 0;
	isLastActionMemoryOperation = false;
	isLastActionOperation = false;
	previousMemoryOperation = OperationNone;
	previousOperation = OperationNone;
	previousOperationPerformed = OperationNone;
}

// Adds two values and returns the result
- (double)add:(double)value1 plus:(double)value2
{
	return value1 + value2;
}

// Subtracts two values and returns the result
- (double)subtract:(double)value1 minus:(double)value2
{
	return value1 - value2;
}

// Multiplies two values and returns the result
- (double)multiply:(double)value1 times:(double)value2
{
	return value1 * value2;
}

// Divides two values and returns the results
- (double)divide:(double)dividend by:(double)divisor
{
	if (divisor == 0) {
		// Can't divide by zero. This is an error
		[NSException raise:@"DivideByZero" format:@"Cannot divide by zero", nil];
	}
	return dividend / divisor;
}

// Clears the current memory value
- (void)memoryClear
{
	currentMemoryValue = 0;
}

// Subtracts the specified value from memory
- (void) memoryMinus:(double)value
{
	currentMemoryValue -= value;
}

// Adds the specified value to memory
- (void) memoryPlus:(double)value
{
	currentMemoryValue += value;
}

// Reads the current memory value and stores it in the current value
- (void) memoryRead
{
	NSNumber *number = [NSNumber numberWithDouble:currentMemoryValue];
	self.value = [formatter stringFromNumber:number];
}

// Makes a postive number negative and a negative number positive
- (void) makePositiveNegative
{
	// Convert the current string value to double, then multiply times -1
	double valueDouble = [[self.value stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
	valueDouble = valueDouble * -1;
	
	// Convert new value to a formatted string
	NSNumber *number = [NSNumber numberWithDouble:valueDouble];
	self.value = [formatter stringFromNumber:number];
}

@end

