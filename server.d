import std.socket;
import std.stdio;

class Jogador{
    int id;
    enum tipo_jogador{
        mestre, player}
    string nome;
    int pontuacao;
}

class Partida{
    int id;
    Jogador[] jogadores;
    string resposta;
    string dica;
}

void main() {
   
   auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
   listener.bind(new InternetAddress("localhost", 2525));
   listener.listen(10);
   auto readSet = new SocketSet();
   Socket[] connectedClients;
   char[1024] buffer;
   bool isRunning = true;
   while(isRunning) {
       readSet.reset();
       readSet.add(listener);
       foreach(client; connectedClients) readSet.add(client);
       if(Socket.select(readSet, null, null)) {
          foreach(client; connectedClients)
            if(readSet.isSet(client)) {
                auto got = client.receive(buffer);
                writeln(buffer[0 .. got]);
                client.send(buffer[0 .. got]);
            }
          if(readSet.isSet(listener)) {
             auto newSocket = listener.accept();
             newSocket.send("Bem-vindo ao servidor!\n");
             connectedClients ~= newSocket;
          }
       }
   }
}
