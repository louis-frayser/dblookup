module DB (ht_path,DB, dblookup,mkdb)
where
import Prelude hiding (lookup)
import Data.List (intercalate)
import Control.Monad (liftM)
import System.Directory
import System.FilePath
import System.Exit
import System.Environment
import qualified System.IO.Strict as Strict
import qualified Data.HashMap.Strict as HT
import Config ( theConfig, Config(..))
import Cmd

type DB = HT.HashMap String [FilePath]

db_root::FilePath
db_root=(data_prefix theConfig) </> "dblookup"

db_basename::FilePath
db_basename = "dblookup.db"

ht_path :: FilePath
ht_path = db_root </> "dblookup.ht"

readHTfile :: IO DB
readHTfile=
  do exists <- doesFileExist ht_path
     ht <- if exists then liftM read $ Strict.readFile ht_path
           else return HT.empty
     return ht
     
updatedb :: DB -> String -> [FilePath] -> IO ExitCode
{-| Create locate databases under key in paths (relative to
    db_root.
    Note: we need an absolute path for each of paths.
-}
updatedb ht key paths =
  let updatedb' (p:paths') =
        do let dbdir=db_root ++ "/" ++ p 
           let dbfspec=dbdir </> db_basename
           createDirectoryIfMissing True dbdir
           spawn $ "updatedb -o " ++ dbfspec ++ 
                   " --prunepaths=''" ++ 
                   " -U "++ p
           updatedb' paths'
      updatedb' [] =
        do cpaths <- mapM canonicalizePath paths
           writeFile ht_path (show $ HT.insert key cpaths ht)
           return ExitSuccess
   in updatedb' paths

{- | mkdb key paths
$MLOCATEDIR/dblookup.ht is updated to
  1. for each path create a database ([mp]locate.db, or dblookup.db") at 
     $MLOCATEDIR/path
  2. insert an assoc: (key paths) :: String [FilePath]
     into ht :: HashMap k v and write ht to disk at
     $MLOCATEDIR/dblookup.ht
  NOTE: MLOCATEDIR is configurable.
-}


mkdb :: String -> [FilePath] ->  IO ExitCode
mkdb key paths = 
  do ht <- readHTfile
     updatedb ht key paths

dblookup :: String-> [String] -> IO ExitCode
dblookup key search_patterns =
  do ht <- readHTfile :: IO DB
     let maybe_dbrelpaths =  (HT.lookup key ht)
     case maybe_dbrelpaths of
          Nothing -> error $
                        "Database name `" ++ key ++
                           "` not found!"::IO ExitCode
          Just dbrelpaths ->
            let dbpaths = map (\p -> db_root ++
                                p ++ "/" ++ db_basename) dbrelpaths
                in do spawn $ "locate -d " ++
                        (intercalate ":" dbpaths ) ++
                        " " ++ (intercalate " " search_patterns)
     return ExitSuccess     
