//
//  Hex.h
//  HexLib
//
//  Created by Peter Easdown on 29/04/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import <Foundation/Foundation.h>
#import "FractionalHex.h"

@interface Hex : NSObject

@property (nonatomic) HexCoordinate coordinate;
@property (assign) NSInteger q;
@property (assign) NSInteger r;
@property (assign) NSInteger s;
@property (nonatomic, retain) NSArray<Hex*> *neighbors;

+ (Hex*) hexWithQ:(NSInteger)newQ r:(NSInteger)newR andS:(NSInteger)newS;
+ (Hex*) hexWithQ:(NSInteger)newQ andR:(NSInteger)newR;
+ (Hex*) hexWithHex:(Hex*)other;
+ (Hex*) hexWithFractionalHex:(FractionalHex*)fractionalHex;
+ (Hex*) hexWithHexCoordinate:(HexCoordinate)coordinate;

+ (NSUInteger) hashForQ:(NSUInteger)q andR:(NSUInteger)r;

- (BOOL) isEqual:(Hex*)other;

- (void) add:(Hex*)other;

- (void) addHexCoordinate:(HexCoordinate)other;

- (void) subtract:(Hex*)other;

- (void) multiplyBy:(NSInteger)k;

- (NSInteger) length;

- (NSInteger) distanceTo:(Hex*)other;

+ (HexCoordinate) directionFor:(NSInteger)directionIndex;

- (Hex*) neighborInDirection:(NSInteger)directionIndex;

- (NSArray<Hex*>*) neighbors;

- (FractionalHex*) lerpTo:(Hex*)other withDistance:(float)distance;

- (NSArray<Hex*>*) hexLineTo:(Hex*)other;

@end
