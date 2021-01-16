{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE TypeFamilies #-}

module LibSpec where

import Lib

import Test.Hspec

import Test.QuickCheck
import GHC.IO (liftIO)

spec :: Spec
spec = do
  describe "Testing lib" $ do
    -- testing borders.
    it "should be the last page" $
      isTheLastPage [1..(quot pageSize 2)] `shouldBe` True
    it "shouldn't be the last page" $
      isTheLastPage [1..pageSize] `shouldBe` False
    -- testing page generator.
    it "page 1 should be full" $ do
      content <- loadPageFromDatabase 1
      length content `shouldBe` pageSize
    it "page 2 should be full" $ do
      content <- loadPageFromDatabase 2
      length content `shouldBe` pageSize
    it "page 3 should be full" $ do
      content <- loadPageFromDatabase 3
      length content `shouldBe` pageSize
    it "page 4 should not be full" $ do
      content <- loadPageFromDatabase 4
      length content `shouldNotBe` pageSize
    it "page 5 should be empty" $ do
      content <- loadPageFromDatabase 5
      content `shouldBe` []
    -- test fake handler
    it "should do nothing at all" $ do
      result <- doSomethingWithThisChunks inputData
      result `shouldBe` inputData
      where
          inputData = [1..10]