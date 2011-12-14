import Text.HTML.TagSoup
import Control.Monad
import Data.List
import Data.Char (isSpace)
import DateLib
import Data.Time as Time
import Data.Time.Clock
import System.Locale as Locale
import PushAgent

url = "http://www.metacritic.com/browse/albums/release-date/coming-soon/date?view=detailed"
local = "examples/metacritic_music_dates.html"

-- download = do src <- openURL url
--             writeFile local src
               
parse = do tags <- getTags
           let items = parseTable $ releaseTable tags
               filtered = filter (\item -> length item > 2) items
               combined = map (\item -> (item !! 0) ++ " - " ++ (item !! 1)) filtered
           putStrLn $ unlines combined
          
           
getTags = do src <- readFile local
             return $ parseTags src
             
releaseTable :: [Tag String] -> [Tag String]
releaseTable tags = takeWhile (~/= "</table>") rest
    where rest = dropWhile (~/= "<table class=\"musicTable\">" ) tags

parseTable :: [Tag String] -> [[String]]
parseTable tags = map parseDateSection trs
    where sameDatePart = partitions (~== "<th>") tags
          
parseDateSection :: [Tag String] -> [ParsedEvent]
parseDateSection tags = 
    where thText = trim . innerText . takeWhile $ (~/= "<td>") 
          date = millis . parseDate . thText
 
parseTds :: [Tag String] -> Integer -> ParsedEvent
parseTds tr date = ParsedEvent (map inner [inner, artist]) date ["music"]
              where tds = partition (~== "<td>") tr
                    artist = find (\tdGroup = (head tdGroup) ~== "<td class=\"artistName\">") tds
                    album = find (\tdGroup = (head tdGroup) ~== "<td class=\"albumTitle\">") tds
                    inner (Just tdGroup) = trim . innerText tdGroup
                    inner _ = "Unknown"

createEvent ::  [String] -> Integer -> ParsedEvent
createEvent = 
 
trim :: String -> String
trim = f . f
       where f = reverse.dropWhile isSpace

parseDate :: String -> UTCTime
parseDate = let fmt = "%e %M %Y"
              locale = Locale.defaultTimeLocale
          in Time.readTime locale fmt