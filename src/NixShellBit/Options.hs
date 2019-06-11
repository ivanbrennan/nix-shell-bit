module NixShellBit.Options
  ( CmdLine(..)
  , Options(..)
  , Project(..)
  , Version(..)
  , cmdline
  ) where

import Data.Semigroup ((<>))
import Options.Applicative (Parser, command, help, info, long, many,
                            metavar, progDesc, short, strArgument,
                            strOption, subparser, (<|>))


data CmdLine
  = Exec Options
  | List Options
  deriving Show


data Options = Options
  { projects :: [Project]
  , versions :: [Version]
  , args     :: [Arg]
  } deriving Show


newtype Project
  = Project String
  deriving Show


newtype Version
  = Version String
  deriving Show


newtype Arg
  = Arg String
  deriving Show


cmdline :: Parser CmdLine
cmdline =
    subparser (exec <> list)
   <|>
    (defaultCommand <$> opts)
  where
    exec = command "exec" $
      info (Exec <$> opts) (progDesc "Enter project's nix-shell")

    list = command "list" $
      info (List <$> opts) (progDesc "List available version(s)")

    defaultCommand = Exec


opts :: Parser Options
opts = Options
    <$> many (Project <$> project)
    <*> many (Version <$> version)
    <*> many (Arg <$> arg)
  where
    project = strOption
      ( long "project"
     <> short 'p'
     <> metavar "PROJECT"
     <> help "Use PROJECT instead of the current project"
      )
    version = strOption
      ( long "version"
     <> short 'v'
     <> metavar "VERSION"
     <> help "Use VERSION instead of the current version"
      )
    arg = strArgument
      ( metavar "ARG..."
     <> help "Args to pass to nix-shell"
      )
