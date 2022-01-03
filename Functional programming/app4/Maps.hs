-- {-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Maps where

import System.Random
import System.IO.Unsafe
import JsonLike
import Lib3 (ToJsonLike)
import Data.Maybe


data MapData = MapData
    {
        mapDataBomberPosition :: (Int, Int),
        mapDataWalls :: [(Int, Int)],
        mapDataBricks :: [(Int, Int)],
        mapDataDoors :: [(Int, Int)],
        mapDataGhosts :: [(Int, Int)],
        mapDataBombPos :: Maybe (Int, Int)
    } deriving (Show)

testRecord :: MapData
testRecord = MapData { mapDataBomberPosition = (-1, -1), mapDataWalls = [], mapDataBricks = [], mapDataDoors = [], mapDataGhosts = [], mapDataBombPos = Nothing  }

fromStringToData :: (Int, Int, Int) -> String -> MapData -> MapData
fromStringToData _ [] m = m
fromStringToData (h, w, acc) (s:sx) m
  | s == '#' = fromStringToData (h, w, acc + 1) sx m{mapDataWalls = mapDataWalls m ++ [(div acc h, mod acc w)] }
  | s == 'P' = fromStringToData (h, w, acc + 1) sx m{mapDataBomberPosition = (div acc h, mod acc w)}
  | s == 'X' = fromStringToData (h, w, acc + 1) sx m{mapDataBricks = mapDataBricks m ++ [(div acc h, mod acc w)]}
  | s == 'D' = fromStringToData (h, w, acc + 1) sx m{mapDataDoors = mapDataDoors m ++  [(div acc h, mod acc w)]}
  | s == 'G' = fromStringToData (h, w, acc + 1) sx m{mapDataGhosts = mapDataGhosts m ++ [(div acc h, mod acc w)]}
  | s == '*' = fromStringToData (h, w, acc + 1) sx m{mapDataBombPos = Just (div acc h, mod acc w)}
  | otherwise = fromStringToData (h, w, acc + 1) sx m

-- testCall = fromStringToData (4, 4, 0) "#####....B..." testRecord
testCall' = fromStringToData (15, 15, 0) map2 testRecord

-- instance ToJsonLike MapData where

testToJsonLike :: [(Int, Int)] -> JsonLike
testToJsonLike (x:xs) = JsonLikeObject [("head", JsonLikeList [JsonLikeInteger (toInteger $ fst x), JsonLikeInteger (toInteger $ snd x)]),
                                                           ("tail", testToJsonLike xs ) ]
testToJsonLike [] = JsonLikeObject [("head", JsonLikeNull ),("tail", JsonLikeNull)]

fullResponse :: MapData -> JsonLike
fullResponse m =
    JsonLikeObject [
        ("bomb", if isNothing (mapDataBombPos m) then JsonLikeNull else JsonLikeList [JsonLikeInteger (fst $ f $ mapDataBombPos m), JsonLikeInteger (snd $ f $ mapDataBombPos m)]),
        ("bomb_surrounding", JsonLikeNull),
        ("surrounding", JsonLikeObject [

            ("bombermans", testToJsonLike  $ (: []) (mapDataBomberPosition m) ) ,
            ("bricks", testToJsonLike (mapDataBricks m) ),
            ("gates", testToJsonLike (mapDataDoors m) ),
            ("ghosts", testToJsonLike (mapDataGhosts m) ),
            ("wall", testToJsonLike (mapDataWalls m) )
        ])

    ]
    where 
        f (Just m) = (toInteger $ fst m, toInteger $ snd m)
        f _ = undefined 

randomNumber :: Int -> Int
randomNumber m =
    let
        r = unsafePerformIO randomIO
        n = r `mod` m
    in
        n

getMap :: (Eq a1, Num a1, Num a2, Num b) => a1 -> (a2, b, String)
getMap m
    | m == 0 = (15, 15, map1)
    | m == 1 = (15, 15, map2)
    | m == 2 = (7, 7, map3)
    | otherwise = error "Not possible to get this map"


{-
    # - Wall
    P - Player
    X - Brick
    D - Doors
    G - Ghost

    * - Bomb
-}
map1 :: String
map1 = "###############\
       \#P............#\
       \#XXXXXXXXXXXXX#\
       \#...X..G.X....#\
       \#...X....X....#\
       \#XX.XXXXXX....#\
       \#.............#\
       \#.XX.X.X......#\
       \#X..X.X.XXX...#\
       \#.X.G...X.X...#\
       \#..X.......XX.#\
       \#..........XXX#\
       \#...........X.#\
       \#............D#\
       \###############"

map2 :: String
map2 = "###############\
       \#............P#\
       \#...XXXX......#\
       \#...X.GXX.....#\
       \#X.XX..X.X....#\
       \#.X.X..X..XX..#\
       \#...X..X...X..#\
       \#...XXXX....X.#\
       \#...X.X.....X.#\
       \#..G.X......XX#\
       \#X....X.......#\
       \#.X..X........#\
       \#..X..........#\
       \#............D#\
       \###############"

map3 :: String 
map3 = "#######\
       \#....D#\
       \#..X..#\
       \#X..XX#\
       \#.XX..#\
       \#P.X.G#\
       \#######"