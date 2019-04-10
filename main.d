import std.stdio;

void main()
{
    writeln("------------------------------------------");
    writeln("Bem vindo ao WhoAmI !");
    writeln("------------------------------------------");
}

class Jogador{
    int id;
    enum tipo_jogador{
        mestre, player}
    string nome;
    int pontuacao;
}

class Partida{
    int id;
    Jogador[] jogadores;
    string resposta;
    string dica;
}

class Rodada{
	
}