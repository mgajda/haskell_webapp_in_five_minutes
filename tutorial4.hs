{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings   #-}
-- cabal install -j4 wai-middleware-static
module Main(main) where

import           Web.Spock.Safe
import qualified Data.Aeson  as JSON
import qualified Data.Vector as V
import           Network.Wai.Middleware.Static
--import Web.Spock.StaticMiddleware

main :: IO ()
main =
    runSpock 8080 $
      spockT id $ do
        -- Serve all files from static/ directory as-is, and only serve other endpoints afterwards.
        middleware $ staticPolicy $ hasPrefix "static"
        get root $
          html "<html>Hello world!<img src=\"static/cat.jpg\"></html>"
        --get (root <//> "static" <//> "cat.jpg") $
        --  file "cat.jpg" "static/cat.jpg"
        --get (root <//> "api") $
        --  json $ JSON.Array $ V.fromList [JSON.Number $ 1+1/2, JSON.String " users are ", JSON.Bool True]

