{- | dblookup -- search for files in mlocate databases
-}
import System.Exit
import System.Environment
import Config (theConfig, Config(..))
import DB

usage :: String
usage =
  "\nUsage: dblookup dbname search-term...\n\
    \   where dbname is  key into a set of mlocate dbases\n\
    \      declared in " ++ data_prefix theConfig ++ "/dblookup.tab\n\
    \      See: mkdb(1)\n"
      
main :: IO ExitCode
main = do
  args <- getArgs
  case args of
    []       -> error usage
    [_]      -> error usage
    (k:rest) -> dblookup k rest
