{- | dblookup -- search for files in mlocate databases
-}
import Control.Monad (when)
import System.Exit
import System.Environment
import System.Console.GetOpt
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
  let (flags, rest, errs) = 
        getOpt Permute [ Option ['i'] ["ignore-case"] (NoArg 'i') "ignore case" ] args
      ignoreCase = 'i' `elem` flags
  when (not . null $ errs) (error (concat errs))
  main' rest ignoreCase



main' :: [String] -> Bool -> IO ExitCode
main' args flags = 
  case args of
    []       -> error usage
    [_]      -> error usage
    (dict:values) -> dblookup dict values flags
