module JsonLike where
import Data.List
import Data.Char
import Numeric

data JsonLike
  = JsonLikeInteger Integer
  | JsonLikeString String
  | JsonLikeObject [(String, JsonLike)]
  | JsonLikeList [JsonLike]
  | JsonLikeNull
  deriving (Eq)

instance Show JsonLike where
  show value = case value of
    JsonLikeNull -> "null"
    JsonLikeString s -> showJsonString s
    JsonLikeInteger i -> show i
    JsonLikeList l -> "[" ++ intercalate ", " (map show l) ++ "]"
    JsonLikeObject o -> "{" ++ intercalate ", " (map showKv o) ++ "}"
    where
      showKv (k, v) = showJsonString k ++ ": " ++ show v

showJsonString :: String -> String
showJsonString s = "\"" ++ concatMap showJSONChar s ++ "\""

showJSONChar :: Char -> String
showJSONChar c = case c of
  '\'' -> "'"
  '\"' -> "\\\""
  '\\' -> "\\\\"
  '/'  -> "\\/"
  '\b' -> "\\b"
  '\f' -> "\\f"
  '\n' -> "\\n"
  '\r' -> "\\r"
  '\t' -> "\\t"
  _ | isControl c -> "\\u" ++ showJSONNonASCIIChar c
  _ -> [c]
  where
    showJSONNonASCIIChar c =
      let a = "0000" ++ showHex (ord c) "" in drop (length a - 4) a