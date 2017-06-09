//
//  Layout.h
//  HexLib
//
//  Created by Peter Easdown on 29/04/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import <Foundation/Foundation.h>
#import "Orientation.h"
#import "Hex.h"
#import "FractionalHex.h"
#import <UIKit/UIKit.h>

@interface Layout : NSObject

@property (assign) Orientation orientation;
@property (assign) CGPoint origin;
@property (assign) CGSize size;

+ (Layout*) pointyLayoutWithSize:(CGSize)size at:(CGPoint)origin;
+ (Layout*) flatLayoutWithSize:(CGSize)size at:(CGPoint)origin;

+ (float) widthWithRadius:(float)radius andOrientaton:(OrientationType)orientationType;
+ (float) heightWithRadius:(float)radius andOrientaton:(OrientationType)orientationType;

- (CGPoint) convertHexToPoint:(Hex*)hex;

- (FractionalHex*) convertPointToFractionalHex:(CGPoint)point;

- (CGPoint) hexOffsetOfCorner:(NSInteger)corner;

- (NSArray<NSValue*>*) corners:(Hex*)hex;

- (float) widthOfHex;

- (float) heightOfHex;

@end
