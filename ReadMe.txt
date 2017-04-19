To run: open workspace, choose Demo Scheme and click "play" button. Tested on Xcode 8

• > Describe features and limitations of serve/client implementation
Client. Basically it's a HTTP that can parse only json requests. It has poor error handling, no unit tests because of the time constraint and Easter.
User of the class has a full control fo flow because every added requests is returned by NSOperation

Server is tested and fully documented. Writing my own http server was something new for me, but I think that I managed to create very simple to use architecture.

• > What mechanizm would you add to your server/client implementation to prevent ddos attacks?
Closing connection if client sends requests without waiting for reponses.

• > What other ideas do you have for future development of server/client?
more/new unit tests, support for encryption (and focus on security), better requestes handling (variables with slashes in url), logger, redicrections, returning files
