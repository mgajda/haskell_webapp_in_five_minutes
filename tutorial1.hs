{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings   #-}
module Main(main) where

import Web.Spock.Safe

main :: IO ()
main =
    runSpock 8080 $
      spockT id $
        do get root $ text "Hello world!"
