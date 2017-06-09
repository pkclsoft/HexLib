//
//  HexMap.m
//  HexLib
//
//  Created by Peter Easdown on 2/05/2016.
//  Inspired by the great work by Amit Patel at: http://www.redblobgames.com/grids/hexagons/

#import "HexMap.h"
#import <UIKit/UIKit.h>
#import "Layout.h"

@interface  HexMap()

@property (nonatomic, retain) Hex *testHex;

@end

@implementation HexMap

- (id) initWithHexes:(NSArray<Hex*>*)hexes {
    self = [super init];
    
    if (self != nil) {
        self.hexes = [NSSet setWithArray:hexes];
        self.testHex = [Hex hexWithHexCoordinate:MakeHexCoordinate(0, 0, 0)];
    }
    
    return self;
}

+ (HexMap*) parallelogramWithDimensions:(CGSize)dimensions {
    // Need to center it.
    //
    NSInteger qBound = dimensions.width / 2;
    NSInteger rBound = dimensions.height / 2;
    
    NSMutableArray *hexArray = [NSMutableArray array];
    
    for (NSInteger q = -qBound; q <= qBound; q++) {
        for (NSInteger r = -rBound; r <= rBound; r++) {
            [hexArray addObject:[Hex hexWithQ:q andR:r]];
        }
    }
    
    return [[HexMap alloc] initWithHexes:hexArray];
}

+ (HexMap*) northSouthTriangleWithMapSize:(NSInteger)mapSize {
    NSMutableArray *hexArray = [NSMutableArray array];
    
    NSInteger qBound = mapSize / 2;
    
    for (NSInteger q = 0; q <= mapSize; q++) {
        for (NSInteger r = 0; r <= mapSize - q; r++) {
            [hexArray addObject:[Hex hexWithQ:q - qBound + 2 andR:r - qBound + 1]];
        }
    }
    
    return [[HexMap alloc] initWithHexes:hexArray];
}

+ (HexMap*) eastWestTriangleWithMapSize:(NSInteger)mapSize {
    NSMutableArray *hexArray = [NSMutableArray array];
    
    NSInteger rBound = mapSize / 2;

    for (NSInteger q = 0; q <= mapSize; q++) {
        for (NSInteger r = mapSize - q; r <= mapSize; r++) {
            [hexArray addObject:[Hex hexWithQ:q - rBound - 1 andR:r - mapSize + 3]];
        }
    }
    
    return [[HexMap alloc] initWithHexes:hexArray];
}

+ (HexMap*) triangleWithMapSize:(NSInteger)mapSize andLayout:(Layout*)layout {
    if (layout.orientation.orientationType == kOrientationPointy) {
        return [HexMap northSouthTriangleWithMapSize:mapSize];
    } else {
        return [HexMap eastWestTriangleWithMapSize:mapSize];
    }
}

+ (HexMap*) hexagonWithMapRadius:(NSInteger)mapRadius andLayout:(Layout*)layout {
    NSMutableArray *hexArray = [NSMutableArray array];
    
    for (NSInteger q = -mapRadius; q <= mapRadius; q++) {
        NSInteger r1 = MAX(-mapRadius, -q - mapRadius);
        NSInteger r2 = MIN(mapRadius, -q + mapRadius);
        
        for (NSInteger r = r1; r <= r2; r++) {
            [hexArray addObject:[Hex hexWithQ:q andR:r]];
        }
    }
    
    return [[HexMap alloc] initWithHexes:hexArray];
}

+ (HexMap*) rectangleWithDimensions:(CGSize)dimensions andLayout:(Layout*)layout {
    // Reposition the rectangle so that the 0,0 hex is bottom left.
    //
    layout.origin = CGPointMake([layout widthOfHex] / 2.0, [layout heightOfHex] / 2.0);
    
    NSMutableArray *hexArray = [NSMutableArray array];
    
    if (layout.orientation.orientationType == kOrientationPointy) {
        for (NSInteger r = 0; r < dimensions.height; r++) {
            NSInteger r_offset = floor(r/2); // or r>>1
            
            for (NSInteger q = -r_offset; q < dimensions.width - r_offset; q++) {
                [hexArray addObject:[Hex hexWithQ:q andR:r]];
            }
        }
    } else {
        for (NSInteger q = 0; q <= dimensions.width; q++) {
            NSInteger q_offset = floor(q/2); // or q>>1
            
            for (NSInteger r = -q_offset; r <= dimensions.height - q_offset; r++) {
                [hexArray addObject:[Hex hexWithQ:q andR:r]];
            }
        }
    }
    
    return [[HexMap alloc] initWithHexes:hexArray];
}

#pragma mark - utilities

- (BOOL) isHexCoordinateValid:(HexCoordinate)coordinate {
    _testHex.coordinate = coordinate;
    
    return ([self.hexes member:_testHex] != nil) ? YES : NO;
}


@end
