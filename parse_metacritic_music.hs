import Text.HTML.TagSoup
import Control.Monad
import Data.List
import Data.Char (isSpace)

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
releaseTable tags = takeWhile (\tag -> tag ~/= "</table>") rest
    where rest = dropWhile (\tag -> tag ~/= "<table class=\"musicTable\">" ) tags

parseTable :: [Tag String] -> [[String]]
parseTable tags = map parseTds trs
    where trs = partitions (\tag -> tag ~== "<tr>") tags
          
parseTds :: [Tag String] -> [String]
parseTds tds = map (\td -> trim  $ innerText td) (partitions (\tag -> tag ~== "<td>") tds)

trim :: String -> String
trim = f . f
       where f = reverse.dropWhile isSpace