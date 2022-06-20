create database dbcomerce;
use dbcomerce;

create table produto (
	cod_produto int(5) not null,
    descricao varchar(80),
    constraint pk_produto primary key(cod_produto));

create table estoque (
	cod_produto int(5) not null,
    qtdeMin int(3),
    qtdeMax int(3),
	qtdeAtual int(3),
    constraint pk_estoque primary key(cod_produto),
    constraint foreign key(cod_produto) references produto(cod_produto));
    
create table cliente (
	id int not null auto_increment,
    nome varchar(40),
    celular varchar(11),
	constraint pk_cliente primary key(id));
    
create table nota (
	id int not null auto_increment,
    nro varchar(10),
    idCliente int not null,
    dtVenda date,
    constraint pk_nota primary key(id),
    constraint foreign key(idCliente) references cliente(id));
    
create table itensNota (
	id int not null auto_increment,
    id_nota int(10),
    cod_produto int(5),
    vlUnitario decimal(10.2),
    Qtde decimal(4.1),
    constraint pk_itensNota primary key(id),
    constraint foreign key(id_nota) references nota(id),
    constraint foreign key(cod_produto) references produto(cod_produto));
    
insert into produto values (10, "celular xiaomi redmi note 9");
insert into produto values (20, "Batedeira Planetária Mondial BP-03 com 12 Velocidades e 700W");
insert into produto values (30, "Geladeira/Refrigerador Frost Free cor Inox 310L Electrolux 127V");
insert into produto values (40, "Smart TV UHD 4K LED 50” LG");

insert into estoque values (10, 5, 15, 6);
insert into estoque values (20, 3, 8, 7);
insert into estoque values (30, 2, 5, 5);

insert into cliente values (null, "Maria da Silva", 51984730344);
insert into cliente values (null, "Carlos da Silva Feijó", 51984723379);
insert into cliente values (null, "Suani Mendez Gonzales", 51965824402);
    
insert into nota values (null, '000358785', 1, "2020-01-20");
insert into nota values (null, '000358343', 1, "2020-04-11");
insert into nota values (null, '000333343', 2, "2021-02-12");

insert into itensNota values (null, 1, 10, 1500.00, 1);
insert into itensNota values (null, 1, 20, 248.00, 1);
insert into itensNota values (null, 2, 30, 2112.00, 1);
insert into itensNota values (null, 3, 20, 220.00, 2);

delimiter //
create procedure sp_inserir_estoque (in cod_produto int, in qtdeMin int, in qtdeMax int, in qtdeAtual int)
begin
	if qtdeMin > 0 and qtdeMax > 0 and qtdeMax >= qtdeMin then 
		insert into estoque values (cod_produto, qtdeMin, qtdeMax, 0);
    else
		select "Não foi possivel gravar";
    end if;
end //
delimiter ;

call sp_inserir_estoque(40, 5, 17, 0);

delimiter //
create procedure sp_atualizar_preco (in cdProduto int, in numero_fiscal int, in valor decimal(10.2))
begin
	update itensNota it, nota n
    set vlUnitario = valor
    where n.id = it.id_nota and n.nro = numero_fiscal and it.cod_produto = cdProduto;
    
end //
delimiter ;

call sp_atualizar_preco(30, '000358343', 150.00);

delimiter //
create function fn_busca_total_por_cliente(v_idCliente bigint)
returns decimal(10,2) deterministic
begin
	declare resultado decimal(10,2);
	select sum(it.vlUnitario * Qtde) into resultado from nota n, itensNota it, cliente c where n.id = it.id_nota and c.id = n.idCliente and c.id = v_idCliente;
	return resultado ;
end //
delimiter ;

select fn_busca_total_por_cliente(1);
