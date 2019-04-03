module cliente;
import std.stdio;

void main()
{
    writeln("------------------------------------------");
    writeln("Bem vindo ao WhoAmI !");
    writeln("------------------------------------------");
}

class Partida{
	int id;
	Jogador mestre;
	string dica;
	string resposta;
	int tempo;
	int pontuacao_maxima;
}

class Jogador{
	int id;
	string nome;
	int pontuacao;
}