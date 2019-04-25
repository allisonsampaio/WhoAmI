import std.stdio;
import std.socket;

void main() {

    auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
    char[1024] buffer;
    socket.connect(new InternetAddress("localhost", 2525));
    auto received = socket.receive(buffer); // wait for the server to say hello
    writeln(buffer[0 .. received]);
    while(true){
    writeln("Server said: ", buffer[0 .. socket.receive(buffer)]);

    foreach(line; stdin.byLine) {
       socket.send(line);
       if(line == "exit"){

           socket.close();
           break;
       }
    }
       
    
    }
}