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
   while(true) {
       i = 0;
       readSet.reset(); //tira todos os sockets da variavel
       readSet.add(listener); //adiciona o socket que aceita conexões na lista de Sockets
       foreach(client; connectedClients) readSet.add(client); //Adiciona todos os sockets conectados na lista do readSet
       if(Socket.select(readSet, null, null)) {
          foreach(client; connectedClients){
            if(readSet.isSet(client))  {
                auto got = client.receive(buffer);
                if(buffer[0 .. got] == "exit"){
                   connectedClients = remove(connectedClients, i);
                   break;
                }
                else{
                foreach(sender; connectedClients){
                   writeln("Enviou");
                   sender.send(buffer[0 .. got]);
                }
                writeln(buffer[0 .. got]);
                }
                }
               i += 1; 
            }
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
   Socket[] novalista;
   connectedClients[indice] = null;
   if(connectedClients.length == 1){    
      return novalista;
   }
   for(i=0; i<(connectedClients.length);i++){
      if(connectedClients[i] !is null){   
      novalista ~= connectedClients[i];
      }
   }
   return novalista;
}