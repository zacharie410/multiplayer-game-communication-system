MGCS API GUIDELINE
Introduction:
This API is designed to allow clients to interact with a server and perform certain functions through remote events and remote functions. It also includes a calculation system that can be run on both the server and the client.

Functionality:
The API allows clients to send RemoteEvents to the server and invoke RemoteFunctions on the server. The server processes these requests and calls the appropriate functions from the Events.lua and Functions.lua modules. Additionally, the server can call a calculation function from the Calculations.lua module either on the server or on an available client.

Usage:
To use the API, the client should call the server's RemoteEvent or RemoteFunction with the appropriate event or function name and arguments. The server then processes the request and calls the appropriate function from the Events.lua or Functions.lua modules. The server can also call a calculation function from the Calculations.lua module either on the server or on an available client.

Authentication:
Each request must be authenticated by a token that identifies the client making the request. The token must be provided with each request, and the server will validate the token before processing the request. If the token is not valid, the server will reject the request and the client will be kicked from the game.

Error Handling:
If an error occurs during the processing of a request, the server will kick the client from the game and log the error. Clients should be prepared to handle errors and retry requests if necessary.

Conclusion:
This API provides a simple and secure way for clients to interact with a server and perform certain functions. It is designed to be easy to use and provide robust error handling.

Naming Convention
Convention: camelCase
Variables: use lowercase for the first word, and capitalize the first letter of each subsequent word.
For example: playerName, healthPoints, inventoryList.
Functions: use lowercase for the first word, and capitalize the first letter of each subsequent word.
For example: getPlayerName(), updateHealthPoints(), addToInventoryList().
Classes: use uppercase for the first letter of each word.
 For example: Player, Enemy, Item.
Constants: use all uppercase letters with underscores between words.
 For example: MAX_HEALTH, DEFAULT_INVENTORY_SIZE, STARTING_PLAYER_POSITION.
