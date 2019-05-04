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
    }
    else{
        wait_jogador(socket);
        wait(socket);
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
    writeln("asdyagwofuiwehaúfgyeuigtWU");
    return;
}

// Esperando o mestre inserir a dica e resposta
void wait(Socket socket){
    writeln("Mestre digitando");
    char[1024] buffer;
    while(true){
        auto received = socket.receive(buffer);
        if(buffer[0 .. received] == "init"){
            received = socket.receive(buffer);
            writeln(buffer[0 .. received]);
            return;
        }
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

int receber(Jogador jogador, Socket socket){
    while(true){
        if(1){
            break;
        }
        
    }
    return 1;
}

void enviar(Jogador jogador, Socket socket){
    char[1024] buffer;
    char[500] pergunta;
    char[500] resposta;
    writeln("Digite sua pergunta");
    scanf("%s", &pergunta);
    socket.send(pergunta);
    auto received = socket.receive(buffer); 
    writeln(buffer[0 .. received]);
    writeln("Digite seu chute");
    scanf("%s", &resposta);
    socket.send(resposta);
    return;
}