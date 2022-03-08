module Parser where


import Data.Char
-- import qualified Data.Maybe
import qualified Data.Either as Data
import Data.Either (isRight)
import JsonLike (JsonLike (JsonLikeObject, JsonLikeNull, JsonLikeInteger, JsonLikeString, JsonLikeList))


deleteWs :: String -> String
deleteWs = dropWhile isSpace

deleteSeperator :: String -> String
deleteSeperator (':' : r) = r
deleteSeperator (',' : r) = r
deleteSeperator a = a

f :: String -> String
f xs = [x | x <- xs, x `notElem` "\""]

parseWord :: String -> (String, String)
parseWord s =
  let
    -- w = takeWhile isAlpha s -- w = word
    w = takeWhile (\c -> isAlphaNum c || c == '-' || c == '_') s
    l = drop (length w) s -- l = left
  in
    (w, l)

parseInt :: String -> (String, String)
parseInt s =
  let
    w = takeWhile isDigit s
    l = drop (length w) s
  in
      if head l == ',' || head l == ']' || head l == '}' then (w, l) else ("", s)

parseJsonInt :: String -> Either String (JsonLike, String)
parseJsonInt s =
    let
        (a,b) = parseInt s
    in
        if a == "" then Left "Not an integer"
        else Right (JsonLikeInteger (read a), b)

removeEither :: Either String (JsonLike, String) -> [(JsonLike, String)]
removeEither (Left a) = []
removeEither (Right a) = [a]

parseTillEndOfList :: String -> [JsonLike] -> ([JsonLike], String)
parseTillEndOfList (']': x) a =  (reverse a, x)
parseTillEndOfList ('}': x) a =  (reverse a, x)
parseTillEndOfList (',': x) a =  parseTillEndOfList x a
parseTillEndOfList s a =
    let
        s' = deleteWs s
        (int, left1) = (\x -> if null x then (JsonLikeNull, "") else head x) (removeEither (parseJsonInt s'))
        (str, left2) = (\x -> if null x then (JsonLikeNull, "") else head x) (removeEither (parseJsonString s'))
    in
        if int == JsonLikeNull && JsonLikeNull == str then ([JsonLikeNull], s)
        else
            if int == JsonLikeNull
                then  parseTillEndOfList left2 (str : a)
                else parseTillEndOfList left1 (int : a)


parseJsonString :: String -> Either String (JsonLike, String)
parseJsonString s =
    let
        (a, b) = parseWord s
    in
        if a == "" then Left "Not a string"
        else if a == "null" then Right (JsonLikeNull, b)
        else Right (JsonLikeString a, b)

parseJsonList :: String -> Either String (JsonLike, String)
parseJsonList ('[' : r) =
    let
        (a, b) = parseTillEndOfList r []
    in
        if head a == JsonLikeNull then Left "List error"
        else Right (JsonLikeList a, b)
parseJsonList [] = Left "List error, no ending"
parseJsonList _ = Left "List error"


parseValue :: String -> (JsonLike, String)
parseValue s =
    let
        s' = deleteWs s
        int = parseJsonInt s'
        str = parseJsonString s'
        list = parseJsonList s'
        obj = parseJsonObject s' []
    in
        if isRight int  then (\(x1, x2) -> (x1, x2)) (head $ removeEither int)
        else if isRight str  then (\(x1, x2) -> (x1, x2)) (head $ removeEither str)
        else if isRight list  then (\(x1, x2) -> (x1, x2)) (head $ removeEither list)
        else if isRight obj  then (\(x1, x2) -> (x1, deleteWs $ x2)) (head $ removeEither obj)
        else (JsonLikeNull, s)


parseJsonObject :: String -> [(String, JsonLike)] -> Either String (JsonLike, String)
parseJsonObject ('{' : r) acc =
    let
        (w, r1) = parseWord $ deleteWs r
        (v, r2) = parseValue $ deleteWs (deleteSeperator $ deleteWs r1)
    in
        parseJsonObject r2 ((w, v) : acc)
parseJsonObject (',' : r) acc =
    let
        (w, r1) = parseWord $ deleteWs r
        (v, r2) = parseValue $ deleteWs (deleteSeperator $ deleteWs r1)
    in
        parseJsonObject r2 ((w, v) : acc)
parseJsonObject ('}' : r ) acc = Right (JsonLikeObject(reverse acc), r)
parseJsonObject [] acc = Right (JsonLikeObject(reverse acc), "")
parseJsonObject _ _ = Left "Object error"

parseJson :: String -> Either String JsonLike
parseJson s = 
    let 
         a = parseJsonObject (f s) []
    in
       case a of 
           (Right (d, _)) -> Right d
           (Left m) -> Left m
    
