import std.stdio;
import std.socket;

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
    string getNome(){
        return this.nome;
    }
}

void main() {
    Jogador jogador = new Jogador();
    char[] nomeJogador;
    writeln("Digite seu user");
    readln(nomeJogador);
    jogador.setNome(cast(string)nomeJogador);

    auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
    socket.connect(new InternetAddress("localhost", 2525));

    socket.send(jogador.getNome());

    char[50] buffer;
    auto received = socket.receive(buffer); // wait for the server to say hello
    writeln(buffer[0 .. received]);
    socket.send("ok");
    received = socket.receive(buffer);
    socket.send("ok");
    int id_jogador = cast(int)buffer[0] - '0';
    jogador.setId(id_jogador);
    if(jogador.id == 1){
        wait_jogador(socket);
        mestre(jogador, socket);
        jogo_mestre(jogador, socket);
    }
    else{
        int isDone = 0;
        wait_jogador(socket);
        writeln("Mestre digitando");
        while(true){
            auto rec = socket.receive(buffer);
            writeln(buffer[0 .. rec]);
            if(buffer[0 .. rec] == "suavez"){
                isDone = jogo_enviar(jogador, socket);
                if(isDone == 1){
                writeln("Voce ganhou");
                break;
            }
            }
            
            if(buffer[0 .. rec] == "acabou"){
                writeln("O jogo acabou !!");
                break;
            }
        }
        
    }
    return;
}

void wait_jogador(Socket socket){
    writeln("Esperando partida começar");
    char[50] buffer;
    while(true){
        auto received = socket.receive(buffer);
        if(buffer[0 .. received] == "start"){
            return;
        }
    }
}

void mestre(Jogador jogador, Socket socket){
    char[] dica;
    char[] resposta;
    writeln("Informe a dica");
    readln(dica);
    socket.send(dica);
    writeln("Informe a resposta");
    readln(resposta);
    socket.send(resposta);
}


int jogo_enviar(Jogador jogador, Socket socket){
    char[50] respostaMestre;
    char[] pergunta;
    char[] resposta;
    char[50] result;
    writeln("Digite sua pergunta");
    readln(pergunta);
    socket.send(pergunta);
    auto received = socket.receive(respostaMestre); 
    writeln(respostaMestre[0 .. received]);
    writeln("Digite seu chute");
    readln(resposta);
    socket.send(resposta);

    received = socket.receive(result);
    writeln(result[0 .. received]);
    if(result[0 .. received] == "Você acertou!"){
        return 1;
    }
    return 0;
}

void jogo_mestre(Jogador jogador, Socket socket){
    char[50] pergunta;
    char[] respostaMestre;
    char[50] chute;
    while(true){
        auto received = socket.receive(pergunta);
        if(pergunta[0 .. received] == "acabou"){
            break;
        }
        writeln(pergunta[0 .. received]);
        readln(respostaMestre);
        socket.send(respostaMestre);
        received = socket.receive(chute);
        writeln(chute[0 .. received]);
    }
    return;
}