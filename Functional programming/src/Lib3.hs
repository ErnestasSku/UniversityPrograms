{-# LANGUAGE FlexibleInstances #-}


module Lib3 where

import Data.Either as E (Either (..), isRight)
import Data.List as L (lookup, intercalate, nub)
-- import Lib2 (JsonLike (..), parseJsonMessage)
import JsonLike(JsonLike (..))
import Parser (parseJson)
import Data.Char
import Numeric
import qualified Data.Maybe

-- Keep this type as is
type GameId = String

-- Keep these classes as is:
-- You will want to implement instances for them
class ToJsonLike a where
  toJsonLike :: a -> Either String JsonLike

class FromJsonLike a where
  fromJsonLike :: JsonLike -> Either String a

class ContainsGameId a where
  gameId :: a -> GameId

-- Further it is your code: you can change whatever you wish



-- Converts a JsonLike into a String: renders json
instance FromJsonLike String where
  fromJsonLike a = E.Right (show a)


-- Acts as a parser from a String
instance ToJsonLike String where
  toJsonLike = Parser.parseJson

-- newtype NewGame = NewGame GameId
--   deriving (Show)

data NewGame = NewGame
 {
   uuid :: String,
   width :: Int,
   height :: Int
 }
  deriving(Show)

instance ContainsGameId NewGame where
  gameId (NewGame gid _ _) = gid

-- instance FromJsonLike NewGame where
--   fromJsonLike o@(JsonLikeObject m) =
--     case L.lookup "uuid" m of
--       Nothing -> E.Left $ "no uuid field in " ++ show o
--       Just (JsonLikeString s) -> E.Right $ NewGame s (getWidth' o) (getHeight' o)
--       _ -> E.Left "Invalid value type for uuid"
--   fromJsonLike v = E.Left $ "Unexpected value: " ++ show v

instance FromJsonLike NewGame where
  fromJsonLike o@(JsonLikeObject m) =
    let
      w = getWidth' o
      uuid = getUuid o
      h = getHeight' o
   in
     if uuid == "" || w == 0 || h == 0 then E.Left "Wrong values"
     else E.Right $ NewGame uuid w h
  fromJsonLike v = E.Left $ "Unexpected value: " ++ show v



getWidth' :: JsonLike -> Int
getWidth' (JsonLikeObject m) =
  case L.lookup "width" m of
    Nothing  -> error "no width"
    Just (JsonLikeInteger a) -> fromIntegral a
    _ -> 0
getWidth' _ = undefined --Should not happen/be called

getHeight' :: JsonLike -> Int
getHeight' (JsonLikeObject m) =
  case L.lookup "height" m of
    Nothing  -> error "no heigth"
    Just (JsonLikeInteger a) -> fromInteger a
    _ -> 0
getHeight' _ = undefined --Should not happen/be called

getUuid :: JsonLike -> String
getUuid (JsonLikeObject m) =
  case L.lookup "uuid" m of
    Nothing  -> error "no uuid"
    Just (JsonLikeString a) -> a
    _ -> ""
getUuid _ = undefined --Should not happen/be called


data Direction = Right | Left | Up | Down
  deriving (Show, Eq)

data Command
  = MoveBomberman Direction
  | FetchSurrounding
  | PlantBomb
  | FetchBombStatus
  | FetchBombSurrounding
  deriving (Show, Eq)

data Commands = Commands
  { command :: Command,
    additional :: Maybe Commands
  }
  deriving (Show)

instance ToJsonLike Commands where
  toJsonLike comms =
    let
      t = commandToList (command comms) (additional comms)
    in
      E.Right $ JsonLikeObject t


commandToList :: Command -> Maybe Commands -> [(String, JsonLike)]
commandToList (MoveBomberman d) comms = if Data.Maybe.isJust comms then ("additional", JsonLikeObject (commandToList (command $ e1 comms) (additional $ e1 comms))) : [("command", JsonLikeObject [("name", JsonLikeString "MoveBomberman"), ("direction", JsonLikeString (show d))])] else [("command", JsonLikeObject [("name", JsonLikeString "MoveBomberman"), ("direction", JsonLikeString (show d))])]
commandToList FetchSurrounding comms = if Data.Maybe.isJust comms then ("additional", JsonLikeObject (commandToList (command $ e1 comms) (additional $ e1 comms))) : [("command", JsonLikeObject [("name", JsonLikeString "FetchSurrounding")])] else [("command", JsonLikeObject [("name", JsonLikeString "FetchSurrounding")])]
commandToList PlantBomb comms = if Data.Maybe.isJust comms then ("additional", JsonLikeObject (commandToList (command $ e1 comms) (additional $ e1 comms))) : [("command", JsonLikeObject [("name", JsonLikeString "PlantBomb")])] else [("command", JsonLikeObject [("name", JsonLikeString "PlantBomb")])]
commandToList FetchBombStatus comms = if Data.Maybe.isJust comms then ("additional", JsonLikeObject (commandToList (command $ e1 comms) (additional $ e1 comms))) : [("command", JsonLikeObject [("name", JsonLikeString "FetchBombStatus")])] else [("command", JsonLikeObject [("name", JsonLikeString "FetchBombStatus")])]
commandToList FetchBombSurrounding comms = if Data.Maybe.isJust comms then ("additional", JsonLikeObject (commandToList (command $ e1 comms) (additional $ e1 comms))) : [("command", JsonLikeObject [("name", JsonLikeString "FetchBombSurrounding")])] else [("command", JsonLikeObject [("name", JsonLikeString "FetchBombSurrounding")])]

--Removes maybe from an element
e1 :: Maybe a -> a
e1 (Just a) = a

instance FromJsonLike Commands where

  fromJsonLike a = E.Right $ fromJsonToCommands a
  -- fromJsonLike _ = E.Left "Implement me"

fromJsonToCommands :: JsonLike -> Commands
fromJsonToCommands (JsonLikeObject o) =
  let
     a = lookup "command" o
     b = lookup "additional" o
  in
    if Data.Maybe.isJust b
      then Commands (toCommand a) (Just (fromJsonToCommands ((\(Just a) -> a) b)))
      else Commands (toCommand a) Nothing


fromJsonToCommands _ = undefined
-- fromJsonToCommands Nothing

toCommand :: Maybe JsonLike -> Command
toCommand (Just (JsonLikeObject a)) = 
  let
    name = lookup "name" a
    dir = lookup "direction" a
  in
    f ((\(JsonLikeString a) -> a) $ (\(Just a) -> a) name) dir
  where

    f "FetchSurrounding" _ = FetchSurrounding
    f "PlantBomb" _ = PlantBomb
    f "FetchBombStatus" _ = FetchBombStatus
    f "FetchBombSurrounding" _ = FetchBombSurrounding
    f "MoveBomberman" d  = MoveBomberman (g ((\(JsonLikeString a) -> a) $ (\(Just a) -> a) d)) 
    f _ _  = undefined 

    g "Up" = Up
    g "Down" = Down
    g "Left" = Lib3.Left
    g "Right" = Lib3.Right
    g _ = undefined 
    
toCommand Nothing = FetchBombStatus
toCommand _ = undefined 



data CommandsResponse = CommandsResponse String
  deriving (Show)

instance ToJsonLike CommandsResponse where
  toJsonLike _ = E.Right JsonLikeNull


instance FromJsonLike CommandsResponse where
  fromJsonLike a = E.Right (CommandsResponse $ show a)


data InitData = InitData
  { gameWidth :: Int,
    gameHeight :: Int
  }
  deriving (Show)

data State = State JsonLike InitData
  deriving (Show)

init ::
  -- | Initial data of the game
  InitData ->
  -- | First json message before any moves performed
  JsonLike ->
  -- | An initial state based on initial data and first message
  State
init i j = State (formatData j) i

update ::
  -- | Current state
  State ->
  -- | Json message from server
  JsonLike ->
  -- | A new state, probably based on the message arrived
  State
-- update (State old i) j = State j i
update (State old i) j = State ( updateState old (formatData j)) i

render :: State -> String
-- render = show
render (State i j) = createMaze 0 0 (getHeight j - 1) (getWidth j - 1) (jsonLikeToString i)




---- Everything copied from the Lib2.hs bellow

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
    E.Left b -> undefined
    E.Right b ->  b

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
ifInRange _ _ = True
-- ifInRange [JsonLikeInteger x1, JsonLikeInteger y1] (x2, y2) =
--   x2 + 20 >= x1 && x2 - 20 <= x1  && y2 + 20 >= y1 && y2 - 20 <= y1
-- ifInRange _ _ = False

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
