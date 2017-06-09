//
//  HexMap.h
//  HexLib
//
//  Created by Peter Easdown on 2/05/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import <Foundation/Foundation.h>
#import "Hex.h"
#import "Layout.h"

@interface HexMap : NSObject

@property (nonatomic) NSSet<Hex*> *hexes;

+ (HexMap*) parallelogramWithDimensions:(CGSize)dimensions;

+ (HexMap*) triangleWithMapSize:(NSInteger)mapSize andLayout:(Layout*)layout;

+ (HexMap*) hexagonWithMapRadius:(NSInteger)mapRadius andLayout:(Layout*)layout;

+ (HexMap*) rectangleWithDimensions:(CGSize)dimensions andLayout:(Layout*)layout;

- (BOOL) isHexCoordinateValid:(HexCoordinate)coordinate;

@end
