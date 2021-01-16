# haskell-conduit-example

This is an example of using Conduit with IO Monad faking calls to a real database.

With this simple program you will be able to fully, I hope understand how it works.

You can/should play a lot with the two constants pageSize and chunksSize to see how everything is handled under the hood, it will help you a lot to get what's happening at conduit & database level.

## Behaviour testing

You should try:
- pageSize = chunksSize = 20
- pageSize = 10 and chunksSize = 20
- pageSize = 20 and chunksSize = 10
 
## Testing Specs

Nothing much as unit test.

Most of the tests will cover the dummy generators and the doNothingHandler.

