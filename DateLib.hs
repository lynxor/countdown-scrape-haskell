module DateLib(
  sast,
  getMillis
  ) where

import Data.Time
import Data.Time.Format
import Data.Time.Clock
import Data.Time.LocalTime
import System.Locale as Locale

sast = hoursToTimeZone 2

getMillis :: UTCTime -> Integer
getMillis = (* 1000) . read . seconds 
  where seconds = formatTime defaultTimeLocale "%s" 




