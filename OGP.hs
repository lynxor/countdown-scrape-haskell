module OGP
( OGPType
) where

import qualified Data.Map as Map

data OGPType = 
     --Activies
     Activity | Sport 
     -- Businesses
     | Bar | Company | Cafe | Hotel | Restaurant 
     -- Groups
     | Cause | SportsLeague | SportsTeam 
     -- Organizations
     | Band | Government | NonProfit | School | University
     -- People
     | Actor | Athlete | Author | Director | Musician | Politician | PublicFigure 
     -- Places
     | City | Country | Landmark | StateProvince 
     -- Products and Entertainment
     | Album | Book | Drink | Food | Game | Product | Song | Movie | TVShow 
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


