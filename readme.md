Пример взаимодействия «1С:Предприятие» с браузером Google Chrome
посредством протокола Chrome DevTools Protocol.
* https://chromedevtools.github.io/devtools-protocol/

----

=== Интернет ресурсы по WebSocket

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