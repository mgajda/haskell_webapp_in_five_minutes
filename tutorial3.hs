{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings   #-}
module Main(main) where

import           Web.Spock.Safe
import qualified Data.Aeson  as JSON
import qualified Data.Vector as V
--import Web.Spock.StaticMiddleware

main :: IO ()
main =
    runSpock 8080 $
      spockT id $
        do get root $ text "Hello world!"
           get (root <//> "hello.html") $
             html "<html>Hello world!<img src=\"static/cat.jpg\"></html>"
           get (root <//> "static" <//> "cat.jpg") $
             file "cat.jpg" "static/cat.jpg"
           get (root <//> "api") $
             json $ JSON.Array $ V.fromList [JSON.Number $ 1+1/2, JSON.String " users are ", JSON.Bool True]
           -- middleware (staticPolicy (addBase "static"))
