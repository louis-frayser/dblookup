module DB (htFile,DB,spawn, dblookup,mkdb)
where
import Control.Monad (liftM)
import System.Directory
import System.FilePath
import System.Process
import System.Exit
import System.Environment
import qualified System.IO.Strict as Strict
import qualified Data.HashMap.Strict as HT
import Config ( theConfig, Config(..))

type DB = HT.HashMap String [FilePath]

db_root::FilePath
db_root=(data_prefix theConfig) </> "dblookup"
htFile = db_root </> "dblookup.ht"

-- | spawn cmd
--   Run cmd in a subshell
spawn :: String -> IO ExitCode
spawn cmd = putStrLn cmd >> system cmd

updatedb :: DB -> String -> [FilePath] -> IO ExitCode
updatedb ht key paths =
  let updatedb' (p:paths) =
         do path <- canonicalizePath p
            let dbdir = db_root ++ path
            let dbfspec=dbdir ++ "/dblookup.db"
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
  1. for each path create a database ([mp]locate.db, or dblookup.db") at 
     $MLOCATEDIR/path
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

dblookup :: String-> [String] -> IO ExitCode
dblookup key [search_str] = error "This command is not implemented yet!"
