Пример взаимодействия «1С:Предприятие» с браузером Google Chrome
посредством протокола Chrome DevTools Protocol.
* https://chromedevtools.github.io/devtools-protocol/

----

### Интернет ресурсы по WebSocket

WebSocket library
* https://stackoverflow.com/questions/34423092/websocket-library
* https://github.com/zaphoyd/websocketpp
* https://github.com/Microsoft/cpprestsdk
* https://docs.websocketpp.org/

```cpp
#include <iostream>
#include <cpprest/ws_client.h>

using namespace std;
using namespace web;
using namespace web::websockets::client;

int main() {
  websocket_client client;
  client.connect("ws://echo.websocket.org").wait();

  websocket_outgoing_message out_msg;
  out_msg.set_utf8_message("test");
  client.send(out_msg).wait();

  client.receive().then([](websocket_incoming_message in_msg) {
    return in_msg.extract_string();
  }).then([](string body) {
    cout << body << endl; // test
  }).wait();

  client.close().wait();

  return 0;
}
```

Websocket Client in C++
* https://stackoverflow.com/questions/9528811/websocket-client-in-c
* https://github.com/vinniefalco/Beast/
```cpp
#include <beast/websocket.hpp>
#include <beast/buffers_debug.hpp>
#include <boost/asio.hpp>
#include <iostream>
#include <string>

int main()
{
    // Normal boost::asio setup
    std::string const host = "echo.websocket.org";
    boost::asio::io_service ios;
    boost::asio::ip::tcp::resolver r(ios);
    boost::asio::ip::tcp::socket sock(ios);
    boost::asio::connect(sock,
        r.resolve(boost::asio::ip::tcp::resolver::query{host, "80"}));

    using namespace beast::websocket;

    // WebSocket connect and send message using beast
    stream<boost::asio::ip::tcp::socket&> ws(sock);
    ws.handshake(host, "/");
    ws.write(boost::asio::buffer("Hello, world!"));

    // Receive WebSocket message, print and close using beast
    beast::streambuf sb;
    opcode op;
    ws.read(op, sb);
    ws.close(close_code::normal);
    std::cout <<
        beast::debug::buffers_to_string(sb.data()) << "\n";
}
```

Ограничение 7790 байт

```javascript
{"id":0,"method":"Runtime.enable"}

{"id":1,"method":"Runtime.compileScript","params":{"expression":"S()","sourceURL":"c:\\Chrome\\javascript.js","persistScript":true}}

{"id":2,"method":"Runtime.runScript","params":{"scriptId":"5"}}

{"id":0,"method":"Runtime.compileScript","params":{"expression":"eval(a())","sourceURL":"file:///C:/Cpp/WebSocket/leader-line.min.js","persistScript":true}}

{"id":0,"method":"Page.captureScreenshot","params":{"format":"png"}}

eval.apply(null, ["var testvalue10 = 15;"]);
```

```
Page.createIsolatedWorld

Page.enable
Page.addScriptToEvaluateOnNewDocument, {source: scpt}
Page.navigate, {url: "http://localhost:4567/test"}
```

Инициализация окружения
```javascript
(function (base, files) {
    files.forEach(file => fetch(base + file)
        .then(response => response.text())
        .then(text => eval.apply(null, [text]))
    )
}("http://localhost/vanessa/", [
    "jquery.min.js",
    "leader-line.min.js",
    "library.js",
]));
```
