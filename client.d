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
    auto received = socket.receive(buffer);
    Jogador jogador = new Jogador();
    jogador.setId(int(buffer[0 .. received]));
    if(jogador.id == 1){
        mestre(socket, jogador);
    }
    else{
        jogador();
    }
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
        if(1 ou 0){
            break;
        }
        
    }
    return 1 ou 0
}

void enviar(Jogador jogador, Socket socket){
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