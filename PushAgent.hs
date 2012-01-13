module PushAgent
( ParsedEvent(..)
, push
, asString
) where

import Network.HTTP
import Network.HTTP.Base
import Data.String.Utils
import Data.Time.Calendar
import OGP

data ParsedEvent = ParsedEvent { name :: String
                               , eventDate :: Integer 
                               , tags :: [String] 
                               , ogpType :: OGPType
                               , originUrl :: String } deriving (Show)

params :: ParsedEvent -> String
params (ParsedEvent name date tags ogpType originUrl) = urlEncodeVars paramList
    where paramList = [("name", name), ("eventDate", show date), ("tags", (join "," tags)), ("ogpType", show ogpType), ("originUrl", originUrl)]  

push :: String -> ParsedEvent -> IO String
push url event = do resp <- simpleHTTP (postRequest (url ++ (params event) ))
                    return "done ..."


asString :: String -> IO [Char]
asString reqUrl = do
  resp <- simpleHTTP (getRequest reqUrl)
  getResponseBody resp
