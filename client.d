import std.stdio;
import std.socket;

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

void main() {

    auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
    char[1024] buffer;
    socket.connect(new InternetAddress("localhost", 2525));
    auto received = socket.receive(buffer); // wait for the server to say hello
    writeln(buffer[0 .. received]);
    received = socket.receive(buffer);
    writeln(received);
    Jogador jogador = new Jogador();
    int id_jogador = cast(int)buffer[0] - '0';
    writeln(id_jogador);
    jogador.setId(id_jogador);
    if(jogador.id == 1){
        wait_jogador(socket);
        mestre(jogador, socket);
        jogo_mestre(jogador, socket);
    }
    else{
        wait_jogador(socket);
        wait(socket);
        jogo_enviar(jogador, socket);
    }
    /*while(true){
    writeln("Server said: ", buffer[0 .. socket.receive(buffer)]);
    foreach(line; stdin.byLine) {
       socket.send(line);
       if(line == "exit"){
           socket.close();
           break;
       }
    }    
    }*/
    return;
}

// Esperando o mestre inserir a dica e resposta
void wait(Socket socket){
    writeln("Mestre digitando");
    char[1024] buffer;
        auto received = socket.receive(buffer);
        if(buffer[0 .. received] == "init"){
            writeln("Recebeu a buceta do init");
            return;
        }
    
}

void wait_jogador(Socket socket){
    writeln("Esperando partida começar");
    char[1024] buffer;
    while(true){
        auto received = socket.receive(buffer);
        if(buffer[0 .. received] == "start"){
            return;
        }
    }
}
/*
void wait_mestre(Jogador mestre, Socket socket){
    writeln("Quando quiser comecar a partida digite start");
    while(true){
        foreach(line; stdin.byLine){    
        if(line == "start"){
            socket.send(line);
            return;
        }
        
        }
    }
}*/
void mestre(Jogador jogador, Socket socket){
    char[50] dica;
    char[50] resposta;
    writeln("Informe a dica");
    scanf("%s", &dica);
    socket.send(dica);
    writeln("Informe a resposta");
    scanf("%s", &resposta);
    socket.send(resposta);
}


void jogo_enviar(Jogador jogador, Socket socket){
    char[50] respostaMestre;
    char[50] pergunta;
    char[50] resposta;
    char[50] result;
    writeln("Digite sua pergunta");
    scanf("%s", &pergunta);
    socket.send(pergunta);
    auto received = socket.receive(respostaMestre); 
    writeln(respostaMestre[0 .. received]);
    writeln("Digite seu chute");
    scanf("%s", &resposta);
    socket.send(resposta);

    received = socket.receive(result);
    writeln(result[0 .. received]);
    return;
}

void jogo_mestre(Jogador jogador, Socket socket){
    char[50] pergunta;
    char[50] respostaMestre;
    char[50] chute;
    while(true){
        auto received = socket.receive(pergunta);
        writeln(pergunta[0 .. received]);
        scanf("%s",&respostaMestre);
        socket.send(respostaMestre);
        received = socket.receive(chute);
        writeln(chute[0 .. received]);
    }
}