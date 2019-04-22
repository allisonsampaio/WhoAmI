import std.socket;
import std.stdio;

void main() {
   
   auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
   listener.bind(new InternetAddress("localhost", 2525)); //conecta o listener a uma porta e IP
   listener.listen(10);
   int i; 
   auto readSet = new SocketSet();
   Socket[] connectedClients; //array de clientes conectados
   char[1024] buffer; //buffer usado para recebimentos de mensagens
   bool isRunning = true; //1 é true
   while(isRunning) {
       i = 0;
       readSet.reset(); //tira todos os sockets da variavel
       readSet.add(listener); //adiciona o socket que aceita conexões na lista de Sockets
       foreach(client; connectedClients) readSet.add(client); //Adiciona todos os sockets conectados na lista do readSet
       if(Socket.select(readSet, null, null)) {
          foreach(client; connectedClients)
            if(readSet.isSet(client)) {
                auto got = client.receive(buffer);
                if(buffer[0 .. got] == "exit"){
                   connectedClients = remove(connectedClients, i);
                }
                writeln(buffer[0 .. got]);
                client.send(buffer[0 .. got]);
                }
               i += 1; 
            }
      
          if(readSet.isSet(listener)) {
             auto newSocket = listener.accept();
             newSocket.send("Bem-vindo ao servidor!\n");
             connectedClients ~= newSocket;
          }
       }
   }


Socket[] remove(Socket[] connectedClients, int indice){
   int i;
   for(i = indice; i<(connectedClients.length-1);i++){
      connectedClients[i] = connectedClients[i+1];
   }
   return connectedClients;
}