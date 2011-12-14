module DateLib(
  sast,
  millis
  ) where

import Data.Time
import Data.Time.Format
import Data.Time.Clock
import Data.Time.LocalTime
import System.Locale as Locale

sast = hoursToTimeZone 2

millis :: UTCTime -> Integer
millis = (* 1000) . read . seconds 
  where seconds = formatTime defaultTimeLocale "%s" 




