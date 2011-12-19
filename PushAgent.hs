module PushAgent
( ParsedEvent(..)
, push
, asString
) where

import Network.HTTP
import Network.HTTP.Base
import Data.String.Utils
import Data.Time.Calendar

data ParsedEvent = ParsedEvent String Integer [String] deriving (Show)

url = "http://localhost:55555/countdown/upsert/?"

params :: ParsedEvent -> String
params (ParsedEvent name date tags) = urlEncodeVars paramList
    where paramList = [("name", name), ("eventDate", show date), ("tags", (join "," tags))]  

push :: ParsedEvent -> IO String
push event = do resp <- simpleHTTP (postRequest (url ++ (params event) ))
                return "done ..."


asString :: String -> IO [Char]
asString reqUrl = do
  resp <- simpleHTTP (getRequest reqUrl)
  getResponseBody resp
               