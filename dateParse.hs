import System.Locale as Locale
import Data.Time as Time
import Data.Time.Clock

getDate :: String -> UTCTime
getDate = let fmt = "%e %m %Y"
              locale = Locale.defaultTimeLocale
          in Time.readTime locale fmt
