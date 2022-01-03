module Lib1 where

import GHC.StableName (StableName)
import Data.List
import Data.Char (isDigit)


data InitData = InitData
  { gameWidth :: Int,
    gameHeight :: Int
  }
  deriving (Show)

-- | Change State the way need but please keep
--  the name of the type, i.e. "State"
data State = State String InitData
  deriving (Show)

-- | Is called in a very beginning of a game
init ::
  -- | Initial data of the game
  InitData ->
  -- | First json message before any moves performed
  String ->
  -- | An initial state based on initial data and first message
  State
init i j = State j i


-- | Is called after every user interaction (key pressed)
update ::
  -- | Current state
  State ->
  -- | Json message from server
  String ->
  -- | A new state, probably based on the message arrived
  State
-- update (State s i) j = State j i
update (State s i) j =
  let
    s1 = wordsWhen (==':') s--returns array of strings
    s2 = wordsWhen (==':') j

    b = nub $ getPairs ( (s1 !! 3) ++ (s2 !! 3) )
    g = nub $ getPairs ( (s1 !! 4) ++ (s2 !! 4) )
    gh = nub $ getPairs ( (s1 !! 5) ++ (s2 !! 5) )
    w = nub $ getPairs ( (s1 !! 6) ++ (s2 !! 6) )

    ans = (s2 !! 0) : ":" : (s2 !! 1) : "bombermans:" : (s2 !! 2) : "bricks:" : concat(formatArray b) : "gates:" : concat(formatArray g) : "ghosts:" : concat(formatArray gh) : "wall:" : formatArray w
  in
    State (show ans) i
   
wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s = case dropWhile p s of
      "" -> []
      s' -> w:wordsWhen p s''
          where (w, s'') = break p s'


getPairs :: String -> [String]
getPairs ('[' : h) = getPairs h
getPairs (',' : h) = getPairs h
getPairs (x : h) =
  let
    firstHalf = takeWhile isDigit h
    firstNr = x : firstHalf
    fLen = length firstHalf

    leftText = drop (fLen + 1) h
    secondHalf = ',' : takeWhile isDigit leftText
    sLen = length secondHalf

  in
  (firstNr ++ secondHalf) : getPairs (drop sLen leftText)
getPairs _ = []

formatArray :: [String] -> [String]
formatArray [] = [""]
formatArray s = 
  let 
    newS = '[' : filterOut (head s) ++ "],"
  in 
    if newS == "[,],"
      then formatArray (tail s)
      else newS : formatArray (tail s)

filterOut :: String ->  [Char]
filterOut = filter (`elem` ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '[', ']', ',' ])


-- | Renders the current state
render ::
  -- | A state to be rendered
  State ->
  -- | A string which represents the state. The String is rendered from the upper left corner of terminal.
  String
render (State i j) = createMaze 0 0 (getHeight j - 1) (getWidth j - 1) i 

getWidth :: InitData -> Int
getWidth (InitData i j) = i

getHeight :: InitData -> Int
getHeight (InitData i j) = j

createMaze :: Int -> Int -> Int -> Int -> String -> String
createMaze x y height width s |height == x && y == width = createMaze' [] (getElement height width s) 
                              |y == width                = createMaze' (createMaze' (createMaze (x + 1) 0 height width s) '\n') (getElement x width s) 
                              |otherwise                 = createMaze' (createMaze x (y + 1) height width s) (getElement x y s)

createMaze' :: String -> Char -> String
createMaze' [] c = [c]
createMaze' s c = c : s

getElement :: Int -> Int -> String -> Char
getElement x y s
  | checkBlock x y 2 s = 'B'  --Bomberman
  | checkBlock x y 3 s = '▒'  -- Brick
  | checkBlock x y 4 s = '╬'  -- Gate
  | checkBlock x y 5 s = 'G'  -- Ghost
  | checkBlock x y 6 s = '█'  -- Wall
  | otherwise = ' '

checkBlock :: Int -> Int -> Int -> String -> Bool
checkBlock x y z s =
    let
        str = filterOut $ wordsWhen (==':') (show s) !! z
        p = getPairs str
        c =  concat(show x : "," : [show y])
    in
    isEqual p c

isEqual :: [String] -> String -> Bool
isEqual [] _ = False
isEqual s p = (head s == p) || isEqual (tail s) p
