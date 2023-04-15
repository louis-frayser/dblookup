{- | dblookup -- search for files in mlocate databases
-}
import System.Exit
import System.Environment
import Config (theConfig, Config(..))
import DB


usage =
  "\nUsage: dblookup dbname search-term...\n\
    \   where dbname is  key into a set of mlocate dbases\n\
    \      declared in " ++ data_prefix theConfig ++ "/dblookup.tab\n\
    \      See: mkdb(1)\n"
      
main :: IO ExitCode
main = do args <- getArgs
          if  length args < 2 then  error usage
              else let (k:v) = args in dblookup k v
