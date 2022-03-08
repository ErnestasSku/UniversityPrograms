{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Spock
import Web.Spock.Config

import Control.Monad (forM_, replicateM)
import Control.Monad.IO.Class (liftIO)
import Data.Semigroup ((<>))
import Data.Text (Text, pack, unpack)
import Data.IORef
import Data.UUID.V1
import Data.UUID.V4
import Data.UUID
import Data.Maybe
-- import Data.Time
import Data.Time.Clock.System
import Data.Int
import Data.List

import System.IO.Unsafe
import System.Random

import Maps
import Lib3 (Commands (command, additional, Commands), Command (MoveBomberman, PlantBomb, FetchSurrounding, FetchBombStatus, FetchBombSurrounding), Direction (Up, Down, Right, Left), fromJsonToCommands)

--Note: not needed for finral project, used only for testing purposes
import Web.Spock.Lucid (lucid)
import Lucid
import JsonLike
import ParserCombinator
import qualified Data.ByteString.Char8 as C8
import qualified Parser
import Control.Concurrent


-- data Game = Game {width :: Int, uuid :: String, height :: Int, gameMap :: String}
-- Alternative way of saving the data in the MapData instead of a String
data Game = Game
    {
        width :: Int,
        uuid :: String,
        height :: Int,
        gameMap :: MapData,
        bombPlantTime :: Maybe Int64
    }
    deriving (Show)
newtype GameState = GameState { games :: IORef [Game] }

type Server a = SpockM () () GameState a



app :: Server ()
app = do
    get root $ do
        activeGames <- getState >>= (liftIO . readIORef . games)
        lucid $ do
            h1_ "Active games"
            ul_ $ forM_ activeGames $ \game -> li_ $ do
                toHtml (uuid game)

    post "v1/game/new/random" $ do
        rn <- liftIO newInt
        uuid' <- liftIO newUUID
        let (h, w, m) = getMap $ rn `mod` 2
        let uuid = toString uuid'
        gamesRef <- games <$> getState
        liftIO $ atomicModifyIORef' gamesRef $ \games -> (games <> [Game h uuid w (fromStringToData (h, w, 0) m testRecord) Nothing ], ())

        let jsonResponse = JsonLikeObject [
                ("height", JsonLikeInteger (toInteger h) ),
                ("uuid", JsonLikeString uuid ),
                ("width", JsonLikeInteger (toInteger w) )
                ]

        text $ pack $ show jsonResponse

    post ("v1/game" <//> var) $ \id -> do

        bd <- body
        let str = C8.unpack bd :: String
        -- let requestCommands = fromJsonToCommands $ (\(Prelude.Right b) -> b) (Parser.parseJson str)
        let requestCommands = fromJsonToCommands $ (\(Prelude.Just (a, b) ) -> b) (runParser jsonValue str)

        gamesRef <- games <$> getState
        gamesList <- liftIO $ readIORef gamesRef

        let currGame = findByUUID gamesList (unpack id)
        t <- liftIO newTime
        let curTime = systemSeconds t

        let explosionState = explode currGame curTime

        let currGame' = moveGhosts explosionState

        let (response, updatedGame) = performCommands currGame' requestCommands ""

        --Update game in the state
        let gameList' = filterGameList gamesList (unpack id)
        liftIO $ atomicModifyIORef' gamesRef $ const (gameList' <> [updatedGame], ())

        text $ pack response

    get ("game" <//> var) $ \id -> do

        gamesRef <- games <$> getState

        v <- liftIO $ readIORef gamesRef
        let game = findByUUID v (unpack id)
        t <- liftIO newTime
        let curTime = systemSeconds t

        text $ pack (show game) <> "    " <> pack (show curTime)

filterGameList :: [Game] -> String -> [Game]
filterGameList (g:gx) id = if uuid g == id then filterGameList gx id else g : filterGameList gx id
filterGameList [] _ = []

findByUUID :: [Game] -> String -> Game
findByUUID (x:xs) id = if uuid x == id then x else findByUUID xs id
findByUUID [] _ = undefined

main :: IO()
main = do
    st <- GameState <$> newIORef []
    cfg <- defaultSpockCfg () PCNoDatabase st
    runSpock 8080 (spock cfg app)

generateRandomGame :: IO (Int, String, Int, String)
generateRandomGame =
    let
        r = randomNumber 2
        (h, w, m) = getMap r
        uuid = f (unsafePerformIO nextUUID)
            where
                  f (Just a) = toString a
                  f Nothing = ""
    in
        return (h, uuid, w, m)

newInt :: IO Int
newInt = randomIO :: IO Int

newUUID :: IO UUID
newUUID = nextRandom

newTime :: IO SystemTime
newTime = getSystemTime


performCommands :: Game -> Commands -> String -> (String, Game)
performCommands g Commands {command = com, additional = add} res
    | com == MoveBomberman Up           = if isJust add then performCommands (moveBomberman g (-1, 0)) ((\(Just a) -> a) add) res else (res, moveBomberman g (-1, 0))
    | com == MoveBomberman Down         = if isJust add then performCommands (moveBomberman g ( 1,0)) ((\(Just a) -> a) add) res else (res, moveBomberman g ( 1,0))
    | com == MoveBomberman Lib3.Right   = if isJust add then performCommands (moveBomberman g ( 0,1)) ((\(Just a) -> a) add) res else (res, moveBomberman g ( 0,1))
    | com == MoveBomberman Lib3.Left    = if isJust add then performCommands (moveBomberman g (0,-1)) ((\(Just a) -> a) add) res else (res, moveBomberman g (0,-1))

    | com == FetchSurrounding = if isJust add then performCommands g ((\(Just a) -> a) add) (show $ fullResponse $ gameMap g) else (show $ fullResponse $ gameMap g, g)
    | com == PlantBomb = if isJust add then performCommands (unsafePerformIO $ plant g) ((\(Just a) -> a) add) res  else (res, unsafePerformIO $ plant g)
    | com == FetchBombStatus = if isJust add then performCommands g ((\(Just a) -> a) add) res else (res, g)
    | otherwise = (res, g)

    -- where

tg :: Game
tg = Game 15 "uuid" 15 (fromStringToData (15, 15, 0) map2  testRecord) Nothing

moveGhosts :: Game -> Game
moveGhosts g =
    let
        gm = gameMap g
        ghosts = mapDataGhosts gm
    in
       g{gameMap = gm {mapDataGhosts = [move x gm | x <- ghosts] }}

    where
        move :: (Int, Int) -> MapData -> (Int, Int)
        move (x, y) g =
            let
                (bomX, bomY) = mapDataBomberPosition g
                possiblePaths = [(x + 1,y), (x - 1,y), (x,y + 1), (x,y - 1)]
                possibleDistances = sort [ distance l (bomX, bomY) | l <- possiblePaths]

                newPos = firstValid possibleDistances g
            in
                if isJust newPos
                    then (\(Just a) -> a) newPos
                    else (x, y)
                -- firstValid possiblePaths g
        
        firstValid :: [(Float, Int, Int)] -> MapData -> Maybe (Int, Int)
        firstValid ((_, x, y):rs) md =
            let
                walls = mapDataWalls md
                bricks = mapDataBricks md
            in
                if not(tplFind walls (x, y) || tplFind bricks (x, y))
                    then Just (x, y)
                    else firstValid rs md
        firstValid [] _ = Nothing 

        distance :: (Int, Int) -> (Int, Int) -> (Float, Int, Int)
        distance (x2, y2) (x1, y1) = (sqrt ( (fromIntegral x2 - fromIntegral x1)**2 + (fromIntegral y2 - fromIntegral y1)**1 ), x2, y2)



--Note: Evil part of the code. Think of a away to un-evil it.
plant :: Game -> IO Game
plant g = do
        let md = gameMap g
        let (curX, curY) = mapDataBomberPosition md

        time <- newTime
        -- liftIO does not work on Int64 for some reason
        -- curTime = liftIO time :: Maybe Int64
        let curTime = systemSeconds time

        return g{gameMap = md{mapDataBombPos = Just (curX, curY)}, bombPlantTime = Just curTime }

explode :: Game -> Int64 -> Game
explode g t =
    let
        md = gameMap g
        bt = bombPlantTime g

        new = case bt of
            Nothing -> g
            (Just a) -> do
                let explodedPositions = (\(x, y) -> [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]) $ (\(Just a) -> a) (mapDataBombPos md)
                if abs (t - a) >= 4
                then g{ gameMap = md{mapDataBombPos = Nothing, mapDataBricks = [x | x <- mapDataBricks md, not $ tplFind explodedPositions x  ]}, bombPlantTime = Nothing }
                else g
    in
        new

moveBomberman :: Game -> (Int, Int) -> Game
moveBomberman g (x, y) =
    let

        md = gameMap g
        (curX, curY) = mapDataBomberPosition md
        newPos = (curX + x, curY + y)
    in
        if validSpot newPos g
        then g{gameMap=md{mapDataBomberPosition=newPos}}
        else g
    where
        validSpot :: (Int, Int) -> Game -> Bool
        validSpot coord g =
            let
                md = gameMap g
                walls = mapDataWalls md
                bricks = mapDataBricks md
            in
                not (tplFind walls coord || tplFind bricks coord)

tplFind :: [(Int, Int)] -> (Int, Int) -> Bool
tplFind (x:xs) coord = if x == coord then True  else tplFind xs coord
tplFind [] _ = False

