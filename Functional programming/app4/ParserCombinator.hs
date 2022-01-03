module ParserCombinator where

import Data.Char
import Control.Applicative
import JsonLike


-- NOTE: no proper error reporting
newtype Parser a = Parser { runParser :: String -> Maybe (String, a)}

instance Functor Parser where
  fmap f (Parser p) =
    Parser $ \input -> do
      (input', x) <- p input
      Just (input', f x)

instance Applicative Parser where
  pure x = Parser $ \input -> Just (input, x)
  (Parser p1) <*> (Parser p2) =
    Parser $ \input -> do
      (input', f) <- p1 input
      (input'', a) <- p2 input'
      Just (input'', f a)

instance Alternative Parser where
  empty = Parser $ \_ -> Nothing
  (Parser p1) <|> (Parser p2) =
      Parser $ \input -> p1 input <|> p2 input

-- instance Monad Parser where
--     (Parser (Just a)) >>= f = f a
--     return a         = Parser a

jsonNull :: Parser JsonLike
jsonNull = (\_ -> JsonLikeNull) <$> parseSequence "null"

parseChar :: Char -> Parser Char
parseChar x = Parser f
  where
    f (y:ys)
      | y == x = Just (ys, x)
      | otherwise = Nothing
    f [] = Nothing

parseSequence :: String -> Parser String
parseSequence = sequenceA . map parseChar


parseWhile :: (Char -> Bool) -> Parser String
parseWhile f =
  Parser $ \input ->
    let (token, rest) = span f input
     in Just (rest, token)

notNull :: Parser [a] -> Parser [a]
notNull (Parser p) =
  Parser $ \input -> do
    (input', xs) <- p input
    if null xs
      then Nothing
      else Just (input', xs)

jsonNumber :: Parser JsonLike
jsonNumber = f <$> notNull (parseWhile isDigit)
    where f ds = JsonLikeInteger $ read ds

-- NOTE: no escape support
parseWord :: Parser String
parseWord = parseChar '"' *> parseWhile (/= '"') <* parseChar '"'

jsonString :: Parser JsonLike
jsonString = JsonLikeString <$> parseWord

ws :: Parser String
ws = parseWhile isSpace

sepBy :: Parser a -> Parser b -> Parser [b]
sepBy sep element = (:) <$> element <*> many (sep *> element) <|> pure []

jsonArray :: Parser JsonLike
jsonArray = JsonLikeList <$> (parseChar '[' *> ws *>
                           elements
                           <* ws <* parseChar ']')
  where
    elements = sepBy (ws *> parseChar ',' <* ws) jsonValue

jsonObject :: Parser JsonLike
jsonObject =
  JsonLikeObject <$> (parseChar '{' *> ws *> sepBy (ws *> parseChar ',' <* ws) pair <* ws <* parseChar '}')
  where
    pair =
      (\key _ value -> (key, value)) <$> parseWord <*>
      (ws *> parseChar ':' <* ws) <*>
      jsonValue

jsonValue :: Parser JsonLike
jsonValue = jsonNull <|> jsonNumber <|> jsonString <|> jsonArray <|> jsonObject

