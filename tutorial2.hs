{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings   #-}
module Main(main) where

import Web.Spock.Safe
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
           -- middleware (staticPolicy (addBase "static"))
