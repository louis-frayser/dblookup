import System.Directory
import System.FilePath
import System.Process
import System.Exit
-- import Data.Bits
import qualified Data.HashMap.Strict as HT


mlocateDir = "/var/lib/mlocate"


-- FIXME:  Let's share the mlocate files among
-- the databses. Prototype with given src path,
-- but refine to realpath(2)
-- 1. The databse will contain a list of the dbfiles
--   it's a hashtable name -> [FilePath]
--   it is written to /var/lib/mlocate/dblookup.tab
-- 2. The files are the mlocate data in
--  /var/lib/mlocate/<realpath>/<relative-to>/<root: file:///>

type DB = HT.HashMap String [FilePath]

updatedb :: DB ->String -> [FilePath] -> IO ExitCode
updatedb ht dbname paths =
  let updatedb' (p:paths) =
        let dbdir=mlocateDir ++ '/':(takeDirectory p) -- FIXME: make abs; rem /
            dbfspec=dbdir ++ '/':dbname
         in do createDirectoryIfMissing True dbdir
               system $ "echo updatedb -d " ++
                    dbfspec ++ " -U " ++ p
               updatedb' paths
      updatedb' [] =
        do writeFile (mlocateDir ++ '/':dbname ++ ".lst")
             (show ht)
           return ExitSuccess
   in updatedb' paths

main :: IO ExitCode
main=
  let paths=[ "/usr/lucho/src", "/usr/src" ]
      dbname = "src"
      ht=HT.empty::DB
   in updatedb ht dbname paths
      
