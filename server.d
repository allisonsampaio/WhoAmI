import std.socket;
import std.stdio;
import std.file;
import std.string;
import std.conv;

class Jogador{
   public:
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
   public:
   string[] nomes; 
   char[] resposta;
   char[] dica;
   string ganhador;

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

   void setNome(string nome){
      this.nomes ~= nome;
   }
   void setGanhador(string ganhador){
      this.ganhador = ganhador;
   }
   string getGanhador(){
      return this.ganhador;
   }
}

void main(string[] args) {

   writeln("Servidor iniciado . . ");
   File file_ganhador = File("ganhador.txt", "w");
   file_ganhador.write("");
   int i = 0;
   string name;
   Partida partida = new Partida();
   
   ushort porta = parse!ushort(args[1]);
   writeln(porta);

   auto listener = new Socket(AddressFamily.INET, SocketType.STREAM);
   listener.bind(new InternetAddress("localhost", porta)); //conecta o listener a uma porta e IP
   listener.listen(10);
   auto readSet = new SocketSet();
   Socket[] connectedClients; //array de clientes conectados
   File file = File("nomes.txt", "a");
   char[50] nome;
   char[50] buffer; //buffer usado para recebimentos de mensagens
   readSet.add(listener);  
   while(true){
      if(Socket.select(readSet, null, null)){
      if(readSet.isSet(listener)) {
             auto newSocket = listener.accept();
             auto res = newSocket.receive(nome);
             file.write(cast(string)(nome[0 .. res]));
             newSocket.send("\n*** Bem-vindo ao WhoAmI! ***\n");
             res = newSocket.receive(buffer);
             connectedClients ~= newSocket;write("Dica da partida: ");
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
               file = File("nomes.txt", "r");
               while(!file.eof()){
                  string line = chomp(file.readln());
                  if(line != ""){
                     partida.setNome(line);
                  }
               }
               
               sendStart(connectedClients);
               //sendNames(connectedClients,partida);
            break;
         }
   }
   }
   
   char[50] resposta;
   char[20] dica;
   auto got = connectedClients[0].receive(dica);
   partida.dica = (dica[0 .. got]);
   got = connectedClients[0].receive(resposta);
   partida.resposta = (resposta[0 .. got]);
   writeln("Dica da partida: ");
   writeln(partida.dica);
   writeln("Resposta da partida");
   writeln(partida.resposta);
    foreach(client; connectedClients){
         if(client != connectedClients[0]){
               client.send(dica);
         }
   }
   

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
               partida.setGanhador(partida.nomes[i]);
               break;
            }else{
               connectedClients[i].send("Você errou :( \n Aguarde sua vez.");
               i +=1;
            }
         }   
   
   }
   file_ganhador = File("ganhador.txt", "a");
   file_ganhador.write(partida.getGanhador());
   foreach(client; connectedClients){
      client.send("acabou");
   }
   
   
   file = File("nomes.txt", "w");
               file.write("");
               file.close();
               file_ganhador.close();
}

void sendStart(Socket[] clients){
   foreach(client; clients){
               client.send("start");
            }
   return;
}
/*
void sendNames(Socket[] connectedClients, Partida partida){
   char[] buffer;
   foreach(client; connectedClients){
      if(client != connectedClients[0]){
      foreach(nome; partida.nomes){
         client.send(nome);
         client.receive(buffer);
      }
      client.send("start");
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
}*/