module KMonad.Domain.App


where

import KMonad.Prelude

import KMonad.Domain.Daemon
import KMonad.Domain.KeyIO
import KMonad.Domain.Message.Server
import KMonad.Domain.Types

--------------------------------------------------------------------------------


-- executeCommand :: HasLogFunc e => Command ->  RIO e ()
-- executeCommand (StartServer cfg)   = startDaemon cfg
-- executeCommand (SendMessage p msg) = sendMsg p msg
-- executeCommand (TestConfig _)      = undefined


--------------------------------------------------------------------------------


-- | Run is the entrypoint of KMonad that is always called. It is responsible
-- for setting up the very first environment (essentially just the
-- logging-function), and then dispatching to different functionality based on
-- the requested 'Command' to be run.
runCommand :: MonadUnliftIO m => RunCfg -> m ()
runCommand cfg = do

  -- Configure logging
  logOptions <- logOptionsHandle (cfg^.logHandle) (cfg^.verbose)
  let logOptions' = setLogMinLevel (cfg^.logLevel) logOptions
  withLogFunc logOptions' $ \lf -> do

    -- Dispatch on the command to run
    case cfg^.command of
      StartDaemon dcfg  -> runRIO lf (startDaemon dcfg)
      SendMessage p msg -> runRIO lf (sendMsg p msg)
      TestConfig  mcfg  -> error "not implemented yet"

