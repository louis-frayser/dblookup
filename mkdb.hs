{- | mkdb -- create a dblookup database
import Control.Monad (liftM)
import System.Directory
import System.FilePath
import System.Process


import qualified System.IO.Strict as Strict
import qualified Data.HashMap.Strict as HT
-}
import System.Environment
import System.Exit
import DB

usage =
  "\nUsage: mkdb dbname path...\n\
    \   where dbname is  key into a list of files for each\n\
    \      path in path...\n\
    \      The lists can be later searched with\n\
    \      'dblookup key search-term...'"
      
main :: IO ExitCode
main = do args <- getArgs
          if  length args < 2 then  error usage
              else let (k:v) = args in mkdb k v
