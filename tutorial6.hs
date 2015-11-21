{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings   #-}
-- cabal install -j4 wai-middleware-static
module Main(main) where

-- Standard libraries
import           Prelude
--import qualified Data.Aeson  as JSON
import           Control.Monad.IO.Class
import qualified Data.Vector as V
import qualified Data.Text.Lazy          as T
import qualified Data.Text.Lazy.Encoding as T
import           Network.HTTP.Types.Status(unauthorized401)
-- Spock
import           Web.Spock.Safe
-- WAI middleware
import           Network.Wai.Middleware.Static
-- blaze-html for HTML construction
import           Text.Blaze.Html4.Strict            hiding (map, html)
import           Text.Blaze.Html4.Strict.Attributes hiding (title, id)
import           Text.Blaze.Renderer.Text                  (renderMarkup)

main :: IO ()
main  =
    runSpock 8080 $
      spockT id $ do
        -- Serve all files from static/ directory as-is, and only serve other endpoints afterwards.
        middleware $ staticPolicy $ hasPrefix "static"
        get root $
          lazyHtml $ do
              toHtml ("Hello World!" :: String)
              img ! src "static/cat.jpg"
        get "admin" $
          requireBasicAuth "Enter admin credentials" checkCredentials credentialsOk
  where
    checkCredentials "admin" "topSECRETpassword" =
            lazyHtml $ toHtml ("Admin logged in." :: String)
    checkCredentials _       _                   = do
            setStatus unauthorized401
            lazyHtml $ toHtml ("Incorrect admin credentials." :: String)
    credentialsOk () = lazyHtml $ toHtml ("Credentials correct." :: String)

lazyHtml result =
    do setHeader "Content-Type" "text/html; charset=utf-8"
       lazyBytes $ T.encodeUtf8 $ renderMarkup result

