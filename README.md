# CRIAÇÃO DO BANCO DE DADOS DA ROLETA – P.I

# Contexto

• Para o nosso Projeto Integrador, cujo o tema trata-se de uma roleta  para ser usada em estabelecimentos, foi criado um banco de dados chamado (roletadb;).

• Logo em seguida, para a estrutura do banco de dados da roleta, foi pensado e definido algumas das identidades principais, sendo elas;
1.	Empresa
2.	Administrador
3.	Participante
4.	Sorteio
5.	Resultado
6.	QRCode
7.	Publicidade - Para anúncios que serão exibidos no site.
8.	Caso haja necessidade – Configurações do Sorteio (para futuras personalizações e novas animações) essa entidade ajuda.

# MODELAGEM BANCO DE DADOS

A modelação  do banco de dados foi feito à partir da definição das entidades, pensando nisso, foi realizado a normalização com todos os atributos necessários para esse banco de dados.

# Especificação dos elementos usados no banco de dados.

• Tabelas:

Empresa ▪ empresa_id (Chave Primária) ▪ Nome ▪ empreendimento ▪ data_sorteio ▪ periodo.
Administrador ▪ admin_id (Chave Primária) ▪ Nome ▪ Email ▪ Senha ▪ empresa_id (Chave Estrangeira) referenciando a tabela empresa. 
Sorteio ▪ Serviço_ID (Chave Estrangeira referenciando a tabela Serviços) ▪ Data ▪ Horário ▪ Cabeleireiro o Estoque ▪ Produto_ID (Chave Primária) ▪ Nome ▪ Quantidade ▪ Data_Entrada ▪ Data_Saída o Funcionários ▪ Funcionário_ID (Chave Primária) ▪ Nome ▪ Função ▪ Horário_Trabalho ▪ Salário

# MODELO FISICO - Banco de dados
### Código escrito em sql

```sql create database roletadb; use roletadb;

-- Criação do banco de dados - Roleta para sorteios.
create database roletadb;

-- Criação das tabelas que serão inseridas no banco de dados da roleta da empresa.
create table empresa (
    id_empresa int auto_increment primary key,
    nome varchar(255) not null,
    empreendimento varchar(255) not null,
    data_sorteio date not null,
    periodo enum('Manhã', 'Tarde', 'Integral')  not null
);

create table administrador (
    id_admin int auto_increment primary key,
    nome varchar(255) not null,
	email varchar(255) unique not null,
    senha varchar(255) not null, -- seria importante armazenar senha criptografada para evitar possíveis invasões.
	id_empresa int not null,
    FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa) ON DELETE CASCADE  -- on delete cascade seria interessente adicionar
    -- para caso haja necessidade de apagar alguma tabela que tenha dados referenciados de otra tabela, apaga de ambos e o ponto
    -- positivo disto é que protege a integridadade dos dados e do próprio banco de dados.
);

create table sorteio (
	id_sorteio int auto_increment primary key,
    id_empresa int not null,
    id_admin int not null,
    data_criacao datetime default current_timestamp,
    status enum('Aberto', 'Finalizado') default 'Aberto',
    foreign key(id_empresa) references empresa(id_empresa)  on delete cascade,
	foreign key(id_admin) references administrador(id_admin)  on delete cascade
);

create table participante (
id_participante int auto_increment primary key,
nome varchar(255) not null,
equipe varchar(255) not null,
supervisao varchar(255),
id_sorteio int not null,
via_qr boolean default false, -- defaulf false, caso nenhum valor seja inserido, o próprio banco de dados
-- irá entender que nenhum participante foi informado via qrcode.
unique(id_sorteio, nome), -- unique para evitar nomes duplicados no mesmmo sorteio.
foreign key (id_sorteio) references sorteio(id_sorteio) on delete cascade
);


