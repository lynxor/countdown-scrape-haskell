module PushAgent
( ParsedEvent(..)
, push
) where

import Network.HTTP
import Network.HTTP.Base
import Data.String.Utils
import Data.Time.Calendar

data ParsedEvent = ParsedEvent String Integer [String] deriving (Show)

url = "http://localhost:55555/upsert"

params :: ParsedEvent -> String
params (ParsedEvent name date tags) = urlEncodeVars paramList
    where paramList = [("name", name), ("eventDate", show date), ("tags", (join "," tags))]  

push :: ParsedEvent -> IO ()
push event = do resp <- simpleHTTP (getRequest (url ++ (params event) ))
                putStrLn "done"