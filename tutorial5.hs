{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings   #-}
-- cabal install -j4 wai-middleware-static
module Main(main) where

import           Prelude--                            hiding (id)
--import qualified Data.Aeson  as JSON
import           Control.Monad.IO.Class
import qualified Data.Vector as V
import qualified Data.Text.Lazy          as T
import qualified Data.Text.Lazy.Encoding as T
-- Spock
import           Web.Spock.Safe
-- WAI middleware
import           Network.Wai.Middleware.Static
-- blaze-html for HTML construction
import           Text.Blaze.Html4.Strict            hiding (map, html)
import           Text.Blaze.Html4.Strict.Attributes hiding (title, id)
import           Text.Blaze.Renderer.Text                  (renderMarkup)

main :: IO ()
main =
    runSpock 8080 $
      spockT id $ do
        -- Serve all files from static/ directory as-is, and only serve other endpoints afterwards.
        middleware $ staticPolicy $ hasPrefix "static"
        get root $
          html'  $ do
              toHtml ("Hello World!" :: String)
              img ! src "static/cat.jpg"
        --get (root <//> "static" <//> "cat.jpg") $
        --  file "cat.jpg" "static/cat.jpg"
        --get (root <//> "api") $
        --  json $ JSON.Array $ V.fromList [JSON.Number $ 1+1/2, JSON.String " users are ", JSON.Bool True]

-- | Send text as a response body. Content-Type will be "text/plain"
html' :: MonadIO m => Html -> ActionCtxT ctx m a
html' val =
    do setHeader "Content-Type" "text/html; charset=utf-8"
       lazyBytes $ T.encodeUtf8 $ renderMarkup val

