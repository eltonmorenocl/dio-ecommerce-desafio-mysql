-- criação do banco de dados para cenário de E-commerce

create database ecommerceDio;

use ecommerceDio;

-- criar tabela cliente
create table clients(
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50),
    Lname VARCHAR(20),
    CPF CHAR(11) DEFAULT NULL,
    CNPJ CHAR(15) DEFAULT NULL,
    Address VARCHAR(30),
    CONSTRAINT unique_cpf_cnpj_cliente UNIQUE (CPF, CNPJ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- criar tabela produto
create table product(
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(10) NOT NULL,
    Descricao VARCHAR(20),
    Valor FLOAT,
    Categoria ENUM('Eletrônicos', 'Alimentos', 'Roupas', 'Móveis') NOT NULL
);

-- criar tabela pagamentos
create table payments(
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT ,
    typePayment ENUM('boleto', 'cartão', 'Dois Cartões', 'Pix'),
    CONSTRAINT fk_payments_client FOREIGN KEY (idClient) REFERENCES clients(idClient)
);


-- criar tabela pedido
create table orders(
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Aprovado', 'Cancelado', 'Em Processamento') DEFAULT 'Em Processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOL DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
);

-- criar tabela estoque
create table productStorage(
    idProductStorage INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT DEFAULT 0,
    storageLocation VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- criar tabela fornecedor
create table supplier(
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- criar tabela vendedor
create table seller(
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15),
    CPF CHAR(9),
    location VARCHAR(11),
    contact CHAR(11) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_cnpj_supplier UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_supplier UNIQUE (CPF)
);

-- criar tabela produto/vendedor
create table productSeller(
    idProductSeller INT,
    idPproduct INT,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (idProductSeller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idProductSeller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

-- criar tabela relação entre produto/pedido
create table productOrder(
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productOrder_seller FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productOrder_product FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

-- criar tabela relação entre estoque/local
create table storageLocation(
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProductStorage)
);

-- criar tabela relação entre produto/fornecedor
create table productSupplier(
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

-- criar tabela cliente PJ/PF
create table clientType(
    idClientType INT AUTO_INCREMENT PRIMARY KEY,
    typeName ENUM('PJ', 'PF') NOT NULL,
    CONSTRAINT unique_typeName UNIQUE (typeName)
);

-- criar tabela pagamentoCliente
create table paymentClient(
    idPaymentClient INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    idPayment INT,
    CONSTRAINT fk_paymentClient_client FOREIGN KEY (idClient) REFERENCES clients(idClient),
    CONSTRAINT fk_paymentClient_payment FOREIGN KEY (idPayment) REFERENCES payments(idPayment)
 );   

--

-- Popular a tabela clientType
INSERT INTO clientType (typeName) VALUES ('PJ');
INSERT INTO clientType (typeName) VALUES ('PF');

-- Popular a tabela clients
INSERT INTO clients (Fname, Lname, CPF, CNPJ, Address) VALUES
    ('Fulano', 'Silva', '12345678901', NULL, 'Rua A, 123'),
    ('Beltrano', 'Santos', '98765432101', NULL, 'Rua B, 456'),
    ('Empresa XYZ', '', NULL, '12345678901234', 'Av. C, 789');

-- Popular a tabela product
INSERT INTO product (Pname, Descricao, Valor, Categoria) VALUES
    ('Celular', 'Smartphone', 1500.00, 'Eletrônicos'),
    ('Arroz', 'Tipo 1kg', 5.50, 'Alimentos'),
    ('Camiseta', 'Tamanho M', 20.00, 'Roupas'),
    ('Sofá', '3 lugares', 800.00, 'Móveis');

-- Popular a tabela payments
INSERT INTO payments (idClient, idPayment, typePayment) VALUES
    (1, 1, 'boleto'),
    (1, 2, 'cartão'),
    (2, 3, 'Pix'),
    (3, 4, 'cartão');

-- Popular a tabela orders
INSERT INTO orders (idOrderClient, orderDescription, sendValue, paymentCash) VALUES
    (1, 'Pedido 1', 150.00, false),
    (2, 'Pedido 2', 30.00, true),
    (3, 'Pedido 3', 800.00, false);

-- Popular a tabela productStorage
INSERT INTO productStorage (quantity, storageLocation) VALUES
    (50, 'Estoque A'),
    (100, 'Estoque B'),
    (30, 'Estoque C'),
    (10, 'Estoque D');

-- Popular a tabela supplier
INSERT INTO supplier (socialName, CNPJ, contact) VALUES
    ('Fornecedor A', '12345678901234', '11111111111'),
    ('Fornecedor B', '98765432101234', '22222222222');

-- Popular a tabela seller
INSERT INTO seller (socialName, CNPJ, CPF, location, contact) VALUES
    ('Vendedor 1', NULL, '123456789', 'Loja 1', '33333333333'),
    ('Vendedor 2', NULL, '987654321', 'Loja 2', '44444444444');

-- Popular a tabela productSeller
INSERT INTO productSeller (idProductSeller, idPproduct, quantity) VALUES
    (1, 1, 5),
    (1, 2, 10),
    (2, 3, 20),
    (2, 4, 8);

-- Popular a tabela productOrder
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity) VALUES
    (1, 1, 3),
    (2, 1, 2),
    (3, 2, 1),
    (4, 3, 1);

-- Popular a tabela storageLocation
INSERT INTO storageLocation (idLproduct, idLstorage, location) VALUES
    (1, 1, 'Prateleira A'),
    (2, 2, 'Prateleira B'),
    (3, 3, 'Prateleira C'),
    (4, 4, 'Prateleira D');

-- Popular a tabela productSupplier
INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity) VALUES
    (1, 1, 100),
    (1, 2, 500),
    (2, 3, 200),
    (2, 4, 150);



-- Recuperar todos os produtos
SELECT * FROM product;

-- Recuperar os nomes e valores dos produtos
SELECT Pname, Valor FROM product;



-- Recuperar clientes com CPF específico
SELECT * FROM clients WHERE CPF = '12345678901';

-- Recuperar pedidos aprovados
SELECT * FROM orders WHERE orderStatus = 'Aprovado';


-- Recuperar nomes completos dos clientes
SELECT CONCAT(Fname, ' ', Lname) AS NomeCompleto FROM clients;

-- Recuperar produtos ordenados por nome
SELECT * FROM product ORDER BY Pname;

-- Recuperar clientes ordenados por sobrenome e depois nome
SELECT * FROM clients ORDER BY Lname, Fname;


-- Recuperar categorias de produtos com mais de 10 unidades em estoque
SELECT p.Categoria, SUM(ps.quantity) AS TotalEstoque
FROM productStorage ps
JOIN product p ON ps.idProductStorage = p.idProduct
GROUP BY p.Categoria
HAVING TotalEstoque > 10;







-- Quantos pedidos foram feitos por cada cliente?


SELECT c.Fname, c.Lname, COUNT(o.idOrder) AS TotalPedidos
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient, c.Fname, c.Lname;

   

-- Algum vendedor também é fornecedor?


SELECT s.socialName AS NomeVendedor, f.socialName AS NomeFornecedor
FROM seller s
JOIN productSeller ps ON s.idSeller = ps.idProductSeller
JOIN productSupplier psu ON s.idSeller = psu.idPsSupplier
JOIN supplier f ON psu.idPsSupplier = f.idSupplier;

   

-- Relação de produtos fornecedores e estoques:


SELECT p.Pname AS NomeProduto, f.socialName AS NomeFornecedor, ps.quantity AS QuantidadeEstoque
FROM product p
JOIN productSupplier psu ON p.idProduct = psu.idPsProduct
JOIN supplier f ON psu.idPsSupplier = f.idSupplier
JOIN productStorage ps ON p.idProduct = ps.idProductStorage;



-- Relação de nomes dos fornecedores e nomes dos produtos:


SELECT f.socialName AS NomeFornecedor, p.Pname AS NomeProduto
FROM supplier f
JOIN productSupplier psu ON f.idSupplier = psu.idPsSupplier
JOIN product p ON psu.idPsProduct = p.idProduct;