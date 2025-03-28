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

-- tabela de administrador 
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

-- tabela de sorteios
create table sorteio (
	id_sorteio int auto_increment primary key,
    id_empresa int not null,
    id_admin int not null,
    data_criacao datetime default current_timestamp,
    status enum('Aberto', 'Finalizado') default 'Aberto',
    foreign key(id_empresa) references empresa(id_empresa)  on delete cascade,
	foreign key(id_admin) references administrador(id_admin)  on delete cascade
);

-- tabela de participantes 
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

-- tabela de resultados do sorteio
create table resultado (
	id_resultado int auto_increment primary key,
	id_sorteio int not null,
	id_participante int not null,
	posicao int not null,
	foreign key (id_sorteio) references sorteio(id_sorteio) on delete cascade,
	foreign key (id_participante) references participante(id_participante) on delete cascade
);

--  tabela de QR codes para participação da roleta
create table qrcode (
	id_qr int auto_increment primary key,
	id_sorteio int not null, 
	codigo varchar(255) unique not null,
	data_geracao datetime default current_timestamp,
	foreign key (id_sorteio) references sorteio(id_sorteio) on delete cascade
);

create table publicidade (
	id_publicidade int auto_increment primary key,
	titulo varchar(255) not null,
	imagem_url varchar(255) not null, -- guarda o endereço da imagem ao clicar na imagem colocada 
	-- na publicidade/anuncio.
	link_destino varchar(255) not null, -- guarda o endereco para onde o usuario será redirecionado
	-- ao clicar na publicidade/anuncio.
    tipo enum ('Rodapé', 'QR_Intermediário', 'QR-Final') not null -- enum significa que pode ser armazenado
    -- um conjunto de valores fixos e limitados.
    -- QR intermediario ou final indica onde, como ele será posicionado no anuncio e exibido no sistema.
);

ALTER TABLE sorteio ADD COLUMN finalizado BOOLEAN DEFAULT FALSE; -- o dowload do pdf da roleta com todos
-- os nomes e posições dos participantes só serão disponibilizados após a finalização do sorteio.
-- sendo assim, antes do sorteio, finalizado = FALSE (ninguém pode baixar).
-- depois do sorteio, finalizado = TRUE (todos podem baixar).

-- dessa forma, será necessário a criação de uma tabela chamada arquivos para armazenar todos os arquivos de pdfs gerados a cada sorteio realizado.
-- assim, podemos manter um histórico dos sorteios.

create table arquivos (
	id_arquivos int auto_increment primary key,
	id_sorteio int not null,
	nome_arquivo varchar(255) not null,
	data_geracao timestamp default current_timestamp,
	foreign key (id_sorteio) references sorteio(id_sorteio) on delete cascade
    -- com essa tabela, será permitido que qualquer participante baixe o arquivo.
);













