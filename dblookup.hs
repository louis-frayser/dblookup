{- | dblookup -- search for files in mlocate databases
import Control.Monad (liftM)
import System.Directory
import System.FilePath
import System.Process


import qualified System.IO.Strict as Strict
import qualified Data.HashMap.Strict as HT
-}
import System.Exit
import System.Environment
import DB

usage =
  "\nUsage: dblookup dbname search-term...\n\
    \   where dbname is  key into a set of mlocate dbases\n\
    \      declared in /var/lib/mlocate/dblookup.tab\n\
    \      See: mkdb(1)\n"
      
main :: IO ExitCode
main = do args <- getArgs
          if  length args < 2 then  error usage
              else let (k:v) = args in dblookup k v
