{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.Process(system)
import Test.Hspec
import Test.Hspec.Expectations
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck

import Control.Monad (liftM, void)
import Control.Monad.IO.Class (MonadIO (liftIO))
import Data.Default
import Database.LevelDB

initializeDB :: MonadResource m => m DB
initializeDB =
  open "/tmp/leveltest" defaultOptions{ createIfMissing = True
                                      , cacheSize= 2048
                                      }

main :: IO ()
main =  hspec $ do
  it "cleanup" $ cleanup >>= shouldReturn (return())

  describe "Basic DB Functionality" $ do
    it "should put items into the database and retrieve them" $  do
      runResourceT $ do
        db <- initializeDB

        put db def "zzz" "zzz"
        get db def "zzz"
      `shouldReturn` (Just "zzz")

testDBPath :: String
testDBPath = "/tmp/haskell-leveldb-tests"

cleanup :: IO ()
cleanup = system ("rm -fr " ++ testDBPath) >> return ()
