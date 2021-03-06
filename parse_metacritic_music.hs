import Text.HTML.TagSoup
import Control.Monad
import Data.List
import Data.Char (isSpace)
import DateLib
import Data.Time as Time
import Data.Time.Clock
import System.Locale as Locale
import PushAgent
import Data.Maybe
import Data.Traversable
import Data.String.Utils (strip)
import OGP

fromUrl = "http://www.metacritic.com/browse/albums/release-date/coming-soon/date?view=detailed"
local = "examples/metacritic_music_dates.html"
pushUrl = "http://localhost:55555/countdown/upsert/?"

parse tags = do
               let items = parseTable $ releaseTable tags
               pushed <- sequenceA $ map (push pushUrl) items
               return ()

getOnline = do respStr <- asString fromUrl
               parse $ parseTags respStr

getOffline = do src <- readFile local
                parse $ parseTags src
             
releaseTable :: [Tag String] -> [Tag String]
releaseTable tags = takeWhile (~/= "</table>") rest
    where rest = dropWhile (~/= "<table class=\"musicTable\">" ) tags

parseTable :: [Tag String] -> [ParsedEvent]
parseTable tags = foldl foldFunc [] sameDatePart
    where sameDatePart = partitions (~== "<th>") tags
          foldFunc acc item = (parseDateSection item) ++ acc

parseDateSection :: [Tag String] -> [ParsedEvent]
parseDateSection tags = catMaybes $ map (parseTds date) trs
    where thText = strip . innerText . (takeWhile (~/= "<td>"))
          date = millis . parseDate . thText $ tags
          trs = partitions (~== "<tr>") tags   
    
parseTds :: Integer -> [Tag String] -> Maybe ParsedEvent
parseTds date tr = event albumM artistM
  where event (Just alb) (Just art) = Just ParsedEvent {name = (alb ++ " by " ++ art), 
                                                        eventDate = date, 
                                                        tags = ["music"],
                                                        ogpType = Album,
                                                        originUrl = fromUrl}
        event _ _ = Nothing 
        tds = partitions (~== "<td>") tr
        artistM = inner $ find ((~== "<td class=\"artistName\">") . head) tds
        albumM = inner $ find (( ~== "<td class=\"albumTitle\">") . head) tds
        inner = fmap (strip . innerText )
        
parseDate :: String -> UTCTime
parseDate = let fmt = "%e %B %Y"
                locale = Locale.defaultTimeLocale
            in Time.readTime locale fmt
 
