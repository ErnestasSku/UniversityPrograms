module Main where

import Control.Exception (bracket)
import Control.Lens ((^.))
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import Data.Either as E (either, Either (Left, Right))
import Data.Function ((&))
import Data.List as L (concat, (++))
import Data.String.Conversions (cs)
import Lib3
import Network.Wreq (post, responseBody)
import Network.Wreq.Lens (Response (..))
import qualified Network.Wreq.Session as Sess
import System.Console.ANSI as ANSI
  ( clearScreen,
    hideCursor,
    setCursorPosition,
    showCursor,
  )
import System.IO (BufferMode (..), hSetBuffering, hSetEcho, stderr, stdin, stdout)
import Prelude hiding (Left, Right)
import qualified Parser
import Control.Concurrent
import Parser (parseJson)
import Control.Concurrent (forkIO)

-- MANDATORY CODE
host :: String
-- host = "http://bomberman.homedir.eu"
host = "http://localhost:8080"

createGame ::
  (FromJsonLike a) =>
  Sess.Session ->
  IO a
createGame sess = do
  r <- Sess.post sess (host ++ "/v1/game/new/random") B.empty
  let resp = cs $ r ^. responseBody :: String
  -- putStrLn $ "resp:" ++ resp
  -- putStrLn $ toJsonLike resp & e & fromJsonLike & e
  return $ toJsonLike resp & e & fromJsonLike & e

postCommands ::
  (FromJsonLike a, ToJsonLike a, FromJsonLike b, ToJsonLike b) =>
  GameId ->
  Sess.Session ->
  a ->
  IO b
postCommands uuid sess commands = do
  let str = toJsonLike commands & e & fromJsonLike & e :: String
  let req = cs str :: B.ByteString
  r <- Sess.post sess (L.concat [host, "/v1/game/", uuid]) req
  let respStr = cs $ r ^. responseBody :: String
  -- print respStr
  return $ toJsonLike respStr & e & fromJsonLike & e

e :: Either String a -> a
e = E.either error id

-- MANDATORY CODE END

main :: IO ()
main = do
  hSetBuffering stdin NoBuffering
  hSetBuffering stderr NoBuffering
  hSetBuffering stdout NoBuffering
  hSetEcho stdin False
  bracket
    (ANSI.hideCursor >> Sess.newAPISession)
    (const showCursor)
    ( \sess -> do
        -- you are free to do whatever you want but:
        -- a) reuse sess (connection to the server)
        -- b) use createGame and postCommands to interact with the game server

        game <- createGame sess :: IO NewGame
        -- print game
        let commands = Commands FetchSurrounding Nothing :: Commands
        -- print $ toJsonLike commands
        bombSurr <- postCommands (gameId game) sess commands :: IO CommandsResponse
        -- print bombSurr

        let initData = Lib3.InitData {gameWidth = width game, gameHeight = height game}
        case parseJson ((\(CommandsResponse a) -> a) bombSurr) of
          E.Left s -> error s
          E.Right jl -> do
            let initialState = Lib3.init initData jl
            draw initialState
            loop (uuid game) sess initialState

        case parseJson (show bombSurr) of
          E.Left e -> error e
          E.Right j -> do
            let initialState = Lib3.init initData j
            draw initialState
            loop (uuid game) sess initialState


    )


getAllInfo :: Maybe Commands
getAllInfo = Just (Commands FetchSurrounding (Just (Commands FetchBombStatus Nothing)))

draw :: Lib3.State -> IO()
draw state = do
  _ <- ANSI.clearScreen
  _ <- ANSI.setCursorPosition 0 0
  putStrLn $ render state

loop :: String -> Sess.Session -> State -> IO ()
loop uuid sess state = do
  t <- forkIO $ backgroundChecker uuid sess state
  c <- getChar
  let commands = case c of
        'a' -> Commands (MoveBomberman Lib3.Left) getAllInfo
        's' -> Commands (MoveBomberman Lib3.Down) getAllInfo
        'd' -> Commands (MoveBomberman Lib3.Right) getAllInfo
        'w' -> Commands (MoveBomberman Lib3.Up) getAllInfo
        'b' -> Commands (PlantBomb) getAllInfo
        _ -> Commands FetchSurrounding getAllInfo
  killThread t
  r <- postCommands uuid sess commands
  case parseJson ((\(CommandsResponse a) -> a) r) of
    E.Left e -> error e
    E.Right jl -> do
      let newState = Lib3.update state jl
      _ <- draw newState
      loop uuid sess newState

backgroundChecker :: String -> Sess.Session -> State -> IO()
backgroundChecker uuid sess state = do
  
  threadDelay 1000000 --Wait for 1 second before updating
  let command = Commands FetchSurrounding getAllInfo
  r <- postCommands uuid sess command

  case parseJson ((\(CommandsResponse a) -> a) r) of
    E.Left e -> error e
    E.Right jl -> do
      let newState = Lib3.update state jl
      _ <- draw newState
      backgroundChecker uuid sess state
