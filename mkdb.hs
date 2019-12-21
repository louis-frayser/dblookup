import Control.Monad (liftM)
import System.Directory
import System.FilePath
import System.Process
import System.Exit
import System.Environment
import qualified System.IO.Strict as Strict
import qualified Data.HashMap.Strict as HT


mlocateDir = "/var/lib/mlocate"
htFile = mlocateDir </> "dblookup.ht"

-- 1. The databse will contain a list of the dbfiles
--   it's a hashtable name -> [FilePath]
--   it is written to /var/lib/mlocate/dblookup.tab
-- 2. The files are the mlocate data in
--  /var/lib/mlocate/<realpath>/<relative-to>/<root: file:///>
-- FIXME:Prototype with given src path but refine to realpath(2)

type DB = HT.HashMap String [FilePath]

spawn :: String -> IO ExitCode
spawn cmd = putStrLn cmd >> system cmd

updatedb :: DB -> String -> [FilePath] -> IO ExitCode
updatedb ht key paths =
  let updatedb' (p:paths) =
         do path <- canonicalizePath p
            let dbdir = mlocateDir ++ path
            let dbfspec=dbdir ++ "/mlocate.db"
            createDirectoryIfMissing True dbdir
            let cmd = "updatedb -o " ++ dbfspec++" -U "++path
            spawn cmd
            updatedb' paths
      updatedb' [] =
        do writeFile htFile (show $ HT.insert key paths ht)
           return ExitSuccess
   in updatedb' paths

{- | mkdb key paths
$MLOCATEDIR/dblookup.ht is updated to
  1. for each path create an mloate.db at $MLOCATEDIR/path
  2. insert an assoc: (key paths) :: String [FilePath]
     into ht :: HashMap k v and write ht to disk at
     $MLOCATEDIR/dblookup.ht
-}
mkdb :: String -> [FilePath] ->  IO ExitCode
mkdb key paths = 
  do exists <- doesFileExist htFile
     ht <- if exists then liftM read $ Strict.readFile htFile::IO DB
           else return HT.empty
     updatedb ht key paths

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
