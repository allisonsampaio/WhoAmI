import std.socket;
import std.stdio;

class Jogador{
    int id;
    enum tipo_jogador{
        mestre, player}
    string nome;
    int pontuacao;

void setId(int id){
    this.id = id;
}
}

class Partida{
    Jogador[] jogadores;
    char[] resposta;
    char[] dica;

void setDica(char[] dica){
    this.dica = dica;
}
void setResposta(char[] resposta){
    this.resposta = resposta;
}
char[] getResposta(){
    return this.resposta;
}
char[] getDica(){
    return this.dica;
}
}

void main() {
   
   auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
   listener.bind(new InternetAddress("localhost", 2525)); //conecta o listener a uma porta e IP
   listener.listen(10);
   int i; 
   auto readSet = new SocketSet();
   Socket[] connectedClients; //array de clientes conectados
   char[1024] buffer; //buffer usado para recebimentos de mensagens
   readSet.add(listener);  
   while(true){
      if(Socket.select(readSet, null, null)){
      if(readSet.isSet(listener)) {
             auto newSocket = listener.accept();
             newSocket.send("Bem-vindo ao servidor!\n");
             connectedClients ~= newSocket;
             if(connectedClients.length == 1){
                newSocket.send("1");
                readSet.add(newSocket);
             }
             else{
                newSocket.send("0");
                readSet.add(newSocket);
             }
          }
         if(connectedClients.length == 3){
            foreach(client; connectedClients){
               client.send("start");
            }
            break;
         }
   /*
          if(readSet.isSet(connectedClients[0])){
              writeln("Entrou 1");
             auto got = connectedClients[0].receive(buffer);
             writeln("Entrou 2");
             if(buffer[0 .. got] == "start"){
                writeln("Entrou");
                break;
             }
             else {
                  writeln("Entrou 3");
             }
          
          }
     */  
   }
   }
   Partida partida = new Partida();
   char[1024] resposta;
   char[1024] dica;
         writeln("Recebendo info");
         auto got = connectedClients[0].receive(dica);
         partida.dica = (dica[0 .. got]);
         got = connectedClients[0].receive(resposta);
         partida.resposta = (resposta[0 .. got]);
         
         writeln(partida.dica);
         writeln(partida.resposta);
         
         foreach(client; connectedClients){
            client.send("init");
            client.send(partida.getDica());
         }
}
/*
   while(true) {
       i = 0;
       readSet.reset(); //tira todos os sockets da variavel
       readSet.add(listener); //adiciona o socket que aceita conexões na lista de Sockets
        //Adiciona todos os sockets conectados na lista do readSet
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
          
       }
   }
*/

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