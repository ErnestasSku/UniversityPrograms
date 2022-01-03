-- {-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- {-# OPTIONS_GHC -Wno-overlapping-patterns #-}
module Lib2 where
import Data.Char (isAlpha, isDigit, isAlphaNum, digitToInt)
import Data.List (intercalate, delete, nub)
import GHC.IO.Handle.Text (commitBuffer')

import JsonLike (JsonLike (JsonLikeList, JsonLikeObject, JsonLikeInteger, JsonLikeNull))
import Parser



data InitData = InitData
  { gameWidth :: Int,
    gameHeight :: Int
  }
  deriving (Show)


-- | Change State the way need but please keep
--  the name of the type, i.e. "State"
data State = State JsonLike InitData
  

-- | Is called in a very beginning of a game
init ::
  -- | Initial data of the game
  InitData ->
  -- | First json message before any moves performed
  JsonLike ->
  -- | An initial state based on initial data and first message
  State
init i j = State (formatData j) i

-- | Is called after every user interaction (key pressed)
update ::
  -- | Current state
  State ->
  -- | Json message from server
  JsonLike ->
  -- | A new state, probably based on the message arrived
  State
update (State old i) j = State ( updateState old (formatData j)) i

-- | Renders the current state
render ::
  -- | A state to be rendered
  State ->
  -- | A string which represents the state. The String is rendered from the upper left corner of terminal.
  String
render (State i j) = createMaze 0 0 (getHeight j - 1) (getWidth j - 1) (jsonLikeToString i)


parseJsonMessage :: String -> Either String JsonLike
parseJsonMessage = parseJson

--___________________________________________________________________
--                         Data utilities functions
--___________________________________________________________________

getJsonLikeObject :: String -> JsonLike -> JsonLike
getJsonLikeObject s (JsonLikeObject o) = findJsonLikeObject s o
getJsonLikeObject _ _ = undefined

findJsonLikeObject :: String -> [(String, JsonLike)] -> JsonLike
findJsonLikeObject v ((s, l) : r) = if v == s then l else findJsonLikeObject v r
findJsonLikeObject _ _ = undefined

removeObject :: JsonLike -> [JsonLike] -> JsonLike
removeObject JsonLikeNull acc = if null acc then JsonLikeList[] else JsonLikeList acc
removeObject a acc=
    let
        b = getJsonLikeObject "head" a
        c = getJsonLikeObject "tail" a
    in
        if b /= JsonLikeNull then removeObject c (b : acc) else removeObject c acc


formatData :: JsonLike -> JsonLike
formatData d =
    let
        bomb = JsonLikeObject[("bomb", (\x -> if x == JsonLikeNull then JsonLikeNull else JsonLikeList [x]) ( getJsonLikeObject "bomb" d))]
        bomberman = JsonLikeObject[("bombermans", removeObject (getJsonLikeObject "bombermans"$ getJsonLikeObject "surrounding" d) [])]
        bricks = JsonLikeObject[("bricks", removeObject (getJsonLikeObject "bricks"$ getJsonLikeObject "surrounding" d) [])]
        gates = JsonLikeObject[("gates", removeObject (getJsonLikeObject "gates"$ getJsonLikeObject "surrounding" d) [])]
        ghosts = JsonLikeObject[("ghosts", removeObject (getJsonLikeObject "ghosts"$ getJsonLikeObject "surrounding" d) [])]
        wall = JsonLikeObject[("wall", removeObject (getJsonLikeObject "wall"$ getJsonLikeObject "surrounding" d) [])]
    in
    JsonLikeList [bomb, bomberman, bricks, gates, ghosts, wall]

--___________________________________________________________________
--                         UPDATE FUNCTIONS
--___________________________________________________________________

updateState :: JsonLike -> JsonLike -> JsonLike
updateState s1 s2 =
  let
  (bomb, l1, r1) = updateDynamic s1 s2
  (bomberman, l2, r2) = updateDynamic l1 r1
  brick = updateDestructable (unwrapDestructable l2) (unwrapDestructable r2) (getBombermanPos $ unwrapDestructable r1)
  (_, l3, r3) = updateStatic l2 r2
  (gates, l4, r4)= updateStatic l3 r3
  ghosts = updateDestructable (unwrapDestructable l4) (unwrapDestructable r4) (getBombermanPos $ unwrapDestructable r1)
  (_, l5, r5)= updateStatic l4 r4
  (wall, l6, r6) = updateStatic l5 r5

  in
  JsonLikeList[bomb, bomberman, brick, gates, ghosts, wall]

updateDynamic :: JsonLike -> JsonLike -> (JsonLike, JsonLike, JsonLike)
updateDynamic (JsonLikeList ((JsonLikeObject h1 ): t1)) (JsonLikeList ((JsonLikeObject h2) : t2)) = (JsonLikeObject h2, JsonLikeList t1, JsonLikeList t2)
updateDynamic _ _ = undefined

updateStatic :: JsonLike -> JsonLike -> (JsonLike, JsonLike, JsonLike)
updateStatic (JsonLikeList (JsonLikeObject h1 : t1)) (JsonLikeList (JsonLikeObject h2 : t2)) =
  (updateStatic' (JsonLikeObject h1) (JsonLikeObject h2),  JsonLikeList t1,  JsonLikeList t2)
updateStatic _ _ = undefined

updateStatic' :: JsonLike -> JsonLike -> JsonLike
updateStatic' (JsonLikeObject[( k1, JsonLikeList l1)]) (JsonLikeObject[( k2, JsonLikeList l2)]) =
  JsonLikeObject [(k1, compareLists (JsonLikeList l1) (JsonLikeList l2))]                                                                                                                          --  else JsonLikeString "not same" -- k - key, l - list
updateStatic' _ _ = undefined

compareLists :: JsonLike -> JsonLike -> JsonLike
compareLists (JsonLikeList[]) (JsonLikeList l2) = JsonLikeList l2
compareLists (JsonLikeList ((JsonLikeList h):t))   (JsonLikeList ((JsonLikeList h2):t2)) =
   if  JsonLikeList h `elem` (JsonLikeList h2:t2)
     then compareLists (JsonLikeList t) (JsonLikeList(JsonLikeList h2 : t2))
    else compareLists (JsonLikeList t) (JsonLikeList (JsonLikeList h:JsonLikeList h2:t2))
compareLists (JsonLikeList l2) (JsonLikeList[]) = JsonLikeList l2
compareLists _ _ = undefined


-- temp1 :: Either String JsonLike -> a
temp1 :: Either a p -> p
temp1 a =
  case a of
    Left b -> undefined
    Right b ->  b

getBombermanPos :: JsonLike -> (Integer, Integer)
getBombermanPos (JsonLikeObject [(_, JsonLikeList[JsonLikeList[JsonLikeInteger x, JsonLikeInteger y]])]) = (x, y)
getBombermanPos _ = undefined

--Utility function
unwrapDestructable :: JsonLike -> JsonLike
unwrapDestructable a =
  let d = case a of
        (JsonLikeList b) -> b
        _ -> []

  in
    head d
    -- otherwise -> []

updateDestructable :: JsonLike -> JsonLike -> (Integer, Integer) -> JsonLike
-- o = old, n = new c = coords
updateDestructable (JsonLikeObject[(_, JsonLikeList o)]) (JsonLikeObject [(_, JsonLikeList n)]) c =
  let
    a =  nub (mergeLists n o c)
  in
    JsonLikeObject [("bricks", JsonLikeList a)]
updateDestructable _ _ _ = undefined

mergeLists :: [JsonLike] -> [JsonLike] -> (Integer, Integer) -> [JsonLike]
mergeLists n (JsonLikeList o@[JsonLikeInteger x, JsonLikeInteger y]: os) c =
      if not (ifInRange o c)
        then JsonLikeList[JsonLikeInteger x, JsonLikeInteger y] : mergeLists n os c
        else n ++ mergeLists n os c
mergeLists n _ _ = n


ifInRange :: [JsonLike] -> (Integer, Integer) -> Bool
ifInRange [JsonLikeInteger x1, JsonLikeInteger y1] (x2, y2) =
  x2 + 6 >= x1 && x2 - 6 <= x1  && y2 + 6 >= y1 && y2 - 6 <= y1
ifInRange _ _ = False

--___________________________________________________________________
--                         RENDERING FUNCTIONS
--___________________________________________________________________


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
  | checkBlock x y 1 s = 'O'  --Bomb
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
isEqual s p = head s == p || isEqual (tail s) p


getJObj :: JsonLike -> (String, JsonLike)
getJObj (JsonLikeObject a) = listTupl a
getJObj _ = undefined

listTupl :: [(String, JsonLike)] -> (String, JsonLike)
listTupl (h:t) = h
listTupl _ = undefined


getJList :: JsonLike -> [JsonLike]
getJList (JsonLikeList a) = a
getJList _ = []


objectToString :: (String, JsonLike) -> String
objectToString (a, b) =
  case b of
    JsonLikeNull -> a ++ ":[]"
    (JsonLikeList c) ->  a ++ ":[" ++ intercalate "," (getMultipleInteger (getJList (JsonLikeList c))) ++ "]"
    _ -> undefined


getAllList :: [JsonLike]  -> [String]
getAllList = map (objectToString . getJObj)

getMultipleInteger :: [JsonLike] -> [String]
getMultipleInteger = map (show . getIntFromList . getJList)

getIntFromList :: [JsonLike] -> [Integer]
getIntFromList = map getInt
--
getInt :: JsonLike -> Integer
getInt (JsonLikeInteger a) = a
getInt _ = 0


jsonLikeToString :: JsonLike -> String
jsonLikeToString a = intercalate "," (getAllList(getJList a))

filterOut :: String ->  String
filterOut = filter (`elem` ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '[', ']', ',' ])

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

wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s = case dropWhile p s of
      "" -> []
      s' -> w:wordsWhen p s''
          where (w, s'') = break p s'
