import std.socket;
import std.stdio;

class Jogador{
   int id;
   string nome;
   int pontuacao;

   void setId(int id){
      this.id = id;
   }

   void setNome(string nome){
      this.nome = nome;
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
   int i = 0;
   auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
   listener.bind(new InternetAddress("localhost", 2525)); //conecta o listener a uma porta e IP
   listener.listen(10);
   auto readSet = new SocketSet();
   Socket[] connectedClients; //array de clientes conectados
   char[50] buffer; //buffer usado para recebimentos de mensagens
   readSet.add(listener);  
   while(true){
      if(Socket.select(readSet, null, null)){
      if(readSet.isSet(listener)) {
             auto newSocket = listener.accept();

             auto res = newSocket.receive(buffer);
             Jogador jogador = new Jogador();
             jogador.setNome(cast(string)(buffer[0 .. res]));

             newSocket.send("Bem-vindo ao servidor!\n");
             res = newSocket.receive(buffer);
             connectedClients ~= newSocket;
             if(connectedClients.length == 1){
                newSocket.send("1");
                res = newSocket.receive(buffer);
                readSet.add(newSocket);
             }
             else{
                newSocket.send("0");
                res = newSocket.receive(buffer);
                readSet.add(newSocket);
             }
          }
         if(connectedClients.length == 3){
               sendStart(connectedClients);
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
   char[50] resposta;
   char[50] dica;
   writeln("Recebendo info");
   auto got = connectedClients[0].receive(dica);
   partida.dica = (dica[0 .. got]);
   got = connectedClients[0].receive(resposta);
   partida.resposta = (resposta[0 .. got]);
   
   writeln(partida.dica);
   writeln(partida.resposta);
   writeln("printou");
   

   while(true){
         if(i >= 3){
            i = 1;
         }
         if(i == 0){
            i = 1;
         }
         else {
            char[50] pergunta;
            char[50] respostaMestre;
            char[50] chute;

            connectedClients[i].send("suavez");

            got = connectedClients[i].receive(pergunta);
            connectedClients[0].send(pergunta[0 .. got]);
            got = connectedClients[0].receive(respostaMestre);
            connectedClients[i].send(respostaMestre[0 .. got]);
            got = connectedClients[i].receive(chute);
            connectedClients[0].send(chute[0 .. got]);

            if(chute[0 .. got] == partida.resposta){
               connectedClients[i].send("Você acertou!");
               break;
            }else{
               connectedClients[i].send("Você errou :( \n Aguarde sua vez.");
               i +=1;
            }
         }   
   }
   foreach(client; connectedClients){
      client.send("acabou");
   }
}

void sendStart(Socket[] clients){
   foreach(client; clients){
               client.send("start");
            }
   return;
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