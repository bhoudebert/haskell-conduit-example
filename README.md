# haskell-conduit-example

This is an example of using Conduit usage over IO Monad faking calling pages of data from a fake database.

With this simple program you will be able to fully, I hope understand how it works.

You can/should play a lot with the two constants pageSize and chunksSize to see how everything is handled under the hood, it will help you a lot to get what's happening at conduit & database level.

## Behavior testing

You should try:
- pageSize = chunksSize = 20
- pageSize = 10 and chunksSize = 20
- pageSize = 20 and chunksSize = 10
 
Each of these will produce different logs to help you get what's happening.

## Testing Specs

Nothing much as unit test.

Most of the tests will cover the dummy generators and the doNothingHandler.

## Running

**REPL** for testing: 
```shell script
  zsh/bash/sh > stack repl --test
```
```ghci script
  Prelude > :l Lib
  Prelude Lib > processingDataByChunks
```
Just edit the two size constant and see what's happening.

**Corverage**: stack clean --full && stack test --coverage