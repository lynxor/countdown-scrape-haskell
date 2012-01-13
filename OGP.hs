module OGP
( OGPType
) where

import qualified Data.Map as Map

data OGPType = 
  Activity | Sport -- Activities
  | Bar | Company | Cafe | Hotel | Restaurant -- Businesses
  | Cause | SportsLeague | SportsTeam -- Groups
  | Band | Government | NonProfit | School | University --Organizations
  | Actor | Athlete | Author | Director | Musician | Politician | PublicFigure -- People
  | City | Country | Landmark | StateProvince -- Places
  | Album | Book | Drink | Food | Game | Product | Song | Movie | TVShow  -- Products and Entertainment
  | Article -- Other 
  deriving (Ord, Eq)
                                                                     
-- When using it add it             
instance Show OGPType where
  show Album = "album"
  show Book = "book"
  show Drink = "drink"
  show Food = "food"
  show Game = "game"
  show Product = "product"
  show Song = "song"
  show Movie = "movie"
  show TVShow = "tv_show"
  show _ = "article"


