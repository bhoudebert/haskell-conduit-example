module Lib
    ( processingDataByChunks
    ) where

import Conduit

import qualified Data.Conduit.List as CL

-- Useless log helpers.

batchName = "TRY-CONDUIT"

startCaption = "[START] "

finishCaption = "[FINISH] "

databaseCaption = "[DATABASE] "

processorCaption = "[PROCESSING] "

-- | Starting message for our batch.
buildStartLogMessage :: String 
buildStartLogMessage = startCaption <> batchName <> " starting processing ..."

-- | EOF, batch is done!
buildFinishLogMessage :: String 
buildFinishLogMessage = finishCaption <> batchName <> " finished with success."

-- | Build a message indicating what's loaded from the database, should of a size <= pageSize
buildLoadingContentLogMessage :: Show a => Int -> [a] -> String
buildLoadingContentLogMessage page content = "\t" <> databaseCaption <> "Loading page " <> show page <> " with " <> show content <> " of size " <> sizeOfContent
  where
    sizeOfContent = show . length $ content

-- | Build a message of what will be processing, should of a size <= chunksSize
buildProcessingContentLogMessage :: Show a => [a] -> String
buildProcessingContentLogMessage content = "\t\t" <> processorCaption <> "Processing chunks " ++ show content ++ " of size " ++ (show . length $ content)

-- | Constant size of database page.
pageSize :: Int
pageSize = 30

-- | Constant defining the size of chunks that will be dealt by our processor.
-- It's a wanted design to have a smaller value than the pageSize for interesting logging.
-- Warning!
chunksSize :: Int
chunksSize = 10

-- | Handle loading page of data from the database: provide 4 complete pages and a 5th partial ending page.
-- Dummy implementation don't pay attention to anything here.
loadPageFromDatabase :: Int -> IO [Int]
loadPageFromDatabase pageNumber
  | pageNumber < 5 = logIt pageNumber pageData
  | otherwise = logIt pageNumber (return [])
  where
    pageData = loadPageFromDatabase' pageNumber
    logIt ::Show a => Int -> IO [a] -> IO [a]
    logIt page content = do
      contentPage <- liftIO content
      putStrLn $ buildLoadingContentLogMessage page contentPage
      return contentPage

-- | Not really interesting ... just a dummy data generator.
loadPageFromDatabase' :: Int -> IO [Int]
loadPageFromDatabase' 4 = return content
  where 
    start = 5*pageSize
    end = 5*pageSize + quot pageSize  2
    content = [start..end]
loadPageFromDatabase' page = return content
  where
    start = page * pageSize
    end = start + pageSize - 1
    content = [start..end]

-- | Stream and process data.
-- here we process by bunch of 10 item regardless the size of the page to be able to display interesting logs!
processingDataByChunks :: IO ()
processingDataByChunks = do 
  putStrLn buildStartLogMessage
  runConduit 
    $ recursiveLoadFromDB -- function that streaming data as a "List"
    .| CL.chunksOf chunksSize -- let's consume the returned list by chunks of chunksSize (ex: 10 regarding our constant)
    .| CL.mapM doSomethingWithThisChunks -- for each chunks of chunksSize (10) apply the function
    .| sinkList
  putStrLn buildFinishLogMessage

-- | Do something over the data coming from a whole page in our example here.
doSomethingWithThisChunks :: [Int] -> IO [Int]
doSomethingWithThisChunks page = do
  putStrLn $ buildProcessingContentLogMessage page
  return page

-- | Create Conduit streaming data from database
recursiveLoadFromDB :: ConduitT a Int IO ()
recursiveLoadFromDB = recursiveLoadFromDB' 0

-- | Internal method, starting page 1, 2 ... until the last page is empty
recursiveLoadFromDB' :: Int -> ConduitT a Int IO ()
recursiveLoadFromDB' aPage = do
  content <- lift $ loadPageFromDatabase aPage
  conduit <- yieldMany content
  if isTheLastPage content then
     return conduit
  else
    recursiveLoadFromDB' (aPage + 1)

-- | Compare the size of a chunks against the defined pageSize, inferior means we reach the last page.
isTheLastPage :: [a] -> Bool 
isTheLastPage l = length l < pageSize