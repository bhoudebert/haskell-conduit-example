# condouit

This is an example of using Conduit with Monad IO faking call to a real something with IO effect (could be database for example).

You can play a lot with the two variable pageSize and chunksSize to see how everything is handled, it will help you a lot to get what's happening under the hood.

You should try:
- pageSize = chunksSize = 20
- pageSize = 10 and chunksSize = 20
- pageSize = 20 and chunksSize = 10
 
