module Cmd (spawn)
  where
import System.Process
import System.Exit
-- | spawn cmd
--   Run cmd in a subshell
spawn :: String -> IO ExitCode
spawn cmd = putStrLn cmd >> system cmd
