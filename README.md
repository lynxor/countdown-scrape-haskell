Countdown scraping with haskell
-----------------------

To get running you will need the haskell-platform.
Using cabal install the following packages:

- tagsoup
- Network
- MissingH
- HTTP
For now just call the parse function in parse_metacritic_music.hs.  This will parse the html and push it to localhost:55555/countdown/upsert
