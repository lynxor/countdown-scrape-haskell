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
               
parse = do tags <- getTags
           let items = parseTable $ releaseTable tags
           putStrLn $ unlines (map show items)       
           
getTags = do src <- readFile local
             return $ parseTags src
             
releaseTable :: [Tag String] -> [Tag String]
releaseTable tags = takeWhile (~/= "</table>") rest
    where rest = dropWhile (~/= "<table class=\"musicTable\">" ) tags

parseTable :: [Tag String] -> [ParsedEvent]
parseTable tags = foldl foldFunc [] sameDatePart
    where sameDatePart = partitions (~== "<th>") tags
          foldFunc acc item = (parseDateSection item) ++ acc

parseDateSection :: [Tag String] -> [ParsedEvent]
parseDateSection tags = map (parseTds date) trs
    where thText = trim . innerText . (takeWhile (~/= "<td>"))
          date = millis . parseDate . thText $ tags
          trs = partitions (~== "<tr>") tags   
    
parseTds :: Integer -> [Tag String] -> ParsedEvent
parseTds date tr = ParsedEvent name date ["music"]
              where name = (inner album) ++ " by " ++ (inner artist)  
                    tds = partitions (~== "<td>") tr
                    artist = find ((~== "<td class=\"artistName\">") . head) tds
                    album = find (( ~== "<td class=\"albumTitle\">") . head) tds
                    inner (Just tdGroup) = trim $ innerText tdGroup
                    inner _ = "Unknown"
                    
trim :: String -> String
trim = f . f
       where f = reverse.dropWhile isSpace

parseDate :: String -> UTCTime
parseDate = let fmt = "%e %B %Y"
                locale = Locale.defaultTimeLocale
          in Time.readTime locale fmt