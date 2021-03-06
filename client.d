import std.stdio;
import std.socket;
import std.file;
import std.string;
import std.conv;

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

void main(string[] args) {
    Jogador jogador = new Jogador();
    char[] nomeJogador;
    writeln("Para entrar no jogo digite seu user:");
    write("> ");
    readln(nomeJogador);
    jogador.setNome(cast(string)nomeJogador);

    ushort porta = parse!ushort(args[1]);
    writeln(porta);

    auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
    socket.connect(new InternetAddress("localhost", porta));

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
        jogadores();
        mestre(jogador, socket);
        jogo_mestre(jogador, socket);
        writeln("O jogo acabou!");  
    }
    else{
        int isDone = 0;
        wait_jogador(socket);
        jogadores();
        writeln("Mestre digitando . .");
        wait_mestre(socket);
        

        while(true){
            auto rec = socket.receive(buffer);
            if(buffer[0 .. rec] == "suavez"){
                isDone = jogo_enviar(jogador, socket);
                if(isDone == 1){
                writeln("Voce ganhou!");
                break;
            }
            }
            
            if(buffer[0 .. rec] == "acabou"){
                writeln("O jogo acabou!");        
                break;
            }
        }
        
    }
    return;
}

void wait_jogador(Socket socket){
    writeln("Esperando partida começar . .");
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
    write("> ");
    readln(dica);
    socket.send(dica);
    writeln("Informe a resposta");
    write("> ");
    readln(resposta);
    socket.send(resposta);
}

int jogo_enviar(Jogador jogador, Socket socket){
    char[50] respostaMestre;
    char[] pergunta;
    char[] resposta;
    char[50] result;
    writeln("Digite sua pergunta");
    write("> ");
    readln(pergunta);
    socket.send(pergunta);
    auto received = socket.receive(respostaMestre); 
    writeln(respostaMestre[0 .. received]);
    writeln("Digite seu chute");
    write("> ");
    readln(resposta);
    socket.send(resposta);

    received = socket.receive(result);
    writeln(result[0 .. received]);
    if(result[0 .. received] == "Você acertou!acabou"){
        return 1;
    }
    return 0;
}

void jogo_mestre(Jogador jogador, Socket socket){
    char[50] pergunta;
    char[] respostaMestre;
    char[50] chute;
    while(true){
        writeln("Aguardando pergunta do jogador: ");
        auto received = socket.receive(pergunta);
        if(pergunta[0 .. received] == "acabou"){
            break;
        }
        writeln(pergunta[0 .. received]);
        writeln("Digite sua resposta: ");
        readln(respostaMestre);
        socket.send(respostaMestre);
        writeln("Aguardando chute do jogador: ");
        received = socket.receive(chute);
        writeln(chute[0 .. received]);
    }
    return;
}

void wait_mestre(Socket socket){
    char[50] dicadomestre;
    auto receive = socket.receive(dicadomestre);
    int i = retira(dicadomestre[0 .. receive]);
    write("Dica da partida: ");
    write(dicadomestre[0 .. i]);
}

int retira(char[] recebido){
   int i=0;
   char aux;
    while(aux != '\n'){

        aux = recebido[i];
        i += 1;
        
    }
return i;
}

void jogadores(){
    File file = File("nomes.txt", "r");
    writeln("Jogadores na partida: ");
    while(!file.eof()){
                  string line = chomp(file.readln());
                  if(line != ""){
                     writeln(line);
                  }
               }

return;
}
/*
void printGanhador(Socket socket){
    char[] ganhador;
    File file = File("ganhador.txt", "r");
    write("Ganhador salvo em arquivo");
return;
}*/