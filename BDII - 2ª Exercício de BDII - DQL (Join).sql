-- Relatorio 1 - Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por data de admissão decrescente;
SELECT upper (e.nome) AS "Nome Empregado", e.cpf AS "CPF Empregado", date_format(e.dataAdm, '%d/%m/%Y')  AS "Data Admissão", 
concat('R$ ', format(e.salario, 2, 'de_DE'))AS "Salário", d.nome AS "Departamento", t.numero AS "Número de Telefone"
FROM empregado e JOIN departamento d ON e.departamento_idDepartamento = d.idDepartamento
LEFT JOIN telefone t ON e.cpf = t.empregado_cpf
WHERE e.dataAdm BETWEEN '2023-01-01' AND '2024-03-31'
ORDER BY e.dataAdm DESC;
-- Na tabela de empregados, só tem funcionario admitidos  de 2023 adiante, então eu mudei as datas e funcionou

-- Relatorio 2 - Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por nome do empregado;
SELECT e.nome AS "Nome Empregado", e.cpf AS "CPF Empregado", e.dataAdm AS "Data de Admissão", concat('R$ ', format(e.salario, 2, 'de_DE')) AS "Salário", 
d.nome AS "Departamento", t.numero AS "Número de Telefone"
FROM empregado e
JOIN departamento d ON e.departamento_idDepartamento = d.idDepartamento
LEFT JOIN telefone t ON e.cpf = t.empregado_cpf 
WHERE e.salario < (SELECT AVG(salario) FROM empregado)
ORDER BY e.nome;

-- Relatorio 3 - Lista dos departamentos com a quantidade de empregados total por cada departamento, trazendo também a média salarial dos funcionários do departamento e a média de comissão recebida pelos empregados do departamento, com as colunas (Departamento, Quantidade de Empregados, Média Salarial, Média da Comissão), ordenado por nome do departamento;

SELECT d.nome AS "Departamento", 
count(e.cpf) AS "Quantidade de Empregados", 
concat('R$ ', format(AVG(e.salario), 2, 'de_DE')) AS "Média Salarial",  
concat('R$ ', format(AVG(e.comissao), 2, 'de_DE')) AS "Média da Comissão"
FROM departamento d
JOIN empregado e ON e.departamento_idDepartamento = d.idDepartamento
GROUP BY d.nome
ORDER BY d.nome;

-- Relatorio 4 Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, além da soma do valor total das vendas do empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por quantidade total de vendas realizadas;
SELECT e.nome AS "Nome Empregado", e.cpf AS "CPF Empregado", e.sexo AS "Sexo", 
concat('R$ ', format(e.salario, 2, 'de_DE')) AS "Salário", 
count(v.idVenda) AS "Quantidade Vendas", 
concat('R$ ', format(sum(v.valor), 2, 'de_DE')) AS "Total Valor Vendido", 
concat('R$ ', format(sum(v.comissao), 2, 'de_DE')) AS "Total Comissão das Vendas"
FROM empregado e
LEFT JOIN venda v ON e.cpf = v.empregado_cpf 
GROUP BY e.nome, e.cpf, e.sexo, e.salario
ORDER BY COUNT(v.idVenda) DESC;

-- Relatorio 5 Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas com serviço por cada Empregado, além da soma do valor total apurado pelos serviços prestados nas vendas por empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço), ordenado por quantidade total de vendas realizadas;
SELECT UPPER(e.nome) AS "Nome Empregado", e.cpf AS "CPF Empregado", e.sexo AS "Sexo", 
concat('R$ ', format(e.salario, 2, 'de_DE')) AS "Salário",
count(v.idVenda) AS "Quantidade Vendas com Serviço", 
concat('R$ ', format(sum(v.valor), 2, 'de_DE')) AS "Total Valor Vendido com Serviço", 
concat('R$ ', format(sum(v.comissao), 2, 'de_DE')) AS "Total Comissão das Vendas com Serviço"
FROM empregado e 
LEFT JOIN venda v ON e.cpf = v.empregado_cpf
GROUP BY e.nome, e.cpf, e.sexo, e.salario
ORDER BY count(v.idVenda) DESC;

-- Relatorio 6  Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do Serviço, Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço), ordenado por data do serviço da mais recente a mais antiga;
SELECT p.nome AS 'Nome do Pet', 
s.nome AS 'Nome do Serviço', 
i.quantidade AS 'Quantidade', 
concat('R$ ', format(i.valor, 2, 'de_DE')) AS 'Valor', 
e.nome AS 'Empregado que realizou o Serviço', 
date_format(v.data, '%d/%m/%Y') AS 'Data do Serviço'
FROM PET p
JOIN itensServico i ON p.idPET = i.PET_idPET
JOIN Servico s ON i.Servico_idServico = s.idServico
JOIN Empregado e ON i.Empregado_cpf = e.cpf
JOIN Venda v ON i.Venda_idVenda = v.idVenda
ORDER BY v.data DESC; 


-- Relatorio 7 - Lista das vendas já realizados para um Cliente, trazendo as colunas (Data da Venda, Valor, Desconto, Valor Final, Empregado que realizou a venda), ordenado por data do serviço da mais recente a mais antiga;

SELECT date_format(v.data, '%d/%m/%Y') AS "Data da Venda", 
concat('R$ ', format(v.valor, 2, 'de_DE')) AS "Valor", 
concat('R$ ', format(v.desconto, 2, 'de_DE')) AS "Desconto", 
concat('R$ ', format(v.valor - v.desconto, 2, 'de_DE')) AS "Valor Final", 
e.nome AS "Empregado que realizou a venda"
FROM venda v
INNER JOIN empregado e ON v.empregado_cpf = e.cpf
ORDER BY v.data DESC;

-- Relatorio 8  Lista dos 10 serviços mais vendidos, trazendo a quantidade vendas cada serviço, o somatório total dos valores de serviço vendido, trazendo as colunas (Nome do Serviço, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;
SELECT serv.nome AS "Nome do Serviço", sum(itsv.quantidade) "Quantidade de Vendas",
SUM(itsv.valor) "Valor Total Vendido"
FROM servico serv
JOIN itensservico itsv ON serv.idServico = itsv.servico_idServico
GROUP BY serv.idServico, serv.nome
ORDER BY sum(itsv.quantidade) DESC
LIMIT 10;

-- Relatorio 9 Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento já foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;
SELECT fp.tipo AS "Tipo Forma Pagamento",
COUNT(v.idVenda) AS "Quantidade Vendas",
CONCAT('R$ ', FORMAT(SUM(fp.valorpago), 2, 'de_DE')) AS "Total Valor Vendido"
FROM formapagcompra fp
INNER JOIN venda v ON fp.compras_idCompra = v.idVenda
GROUP BY fp.tipo
ORDER BY 
COUNT(v.idVenda) DESC;

-- Relatorio 10 Balanço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda, Quantidade de Vendas, Valor Total Venda), ordenado por Data Venda da mais recente a mais antiga;
SELECT DATE(v.data) AS "Data Venda",COUNT(v.idVenda) AS "Quantidade de Vendas",
CONCAT('R$ ', FORMAT(SUM(fp.valorpago), 2, 'de_DE')) AS "Valor Total Venda"
FROM venda v
INNER JOIN formapagcompra fp ON v.idVenda = fp.compras_idCompra
GROUP BY 
DATE(v.data)
ORDER BY 
DATE(v.data) DESC;

-- Relatorio 11 Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas (Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), ordenado por Nome Produto;
SELECT p.nome AS 'Nome Produto', 
concat('R$ ', format(p.valorVenda, 2, 'de_DE')) AS 'Valor Produto', 
f.nome AS 'Nome Fornecedor', 
f.email AS 'Email Fornecedor', 
t.numero AS 'Telefone Fornecedor'
FROM Produtos p
JOIN ItensCompra ic ON p.idProduto = ic.Produtos_idProduto
JOIN Compras c ON ic.Compras_idCompra = c.idCompra
JOIN Fornecedor f ON c.Fornecedor_cpf_cnpj = f.cpf_cnpj
LEFT JOIN Telefone t ON f.cpf_cnpj = t.Fornecedor_cpf_cnpj
ORDER BY p.nome;
    
-- Relatorio 12 Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou em vendas e o total de valor apurado com a venda do produto, trazendo as colunas (Nome Produto, Quantidade (Total) Vendas, Valor Total Recebido pela Venda do Produto), ordenado por quantidade de vezes que o produto participou em vendas;
SELECT p.nome AS 'Nome_Produto',
COUNT(ivp.Produto_idProduto) AS 'Quantidade_Vendas',
concat('R$ ', format(SUM(ivp.valor * ivp.quantidade), 2, 'de_DE')) AS 'Valor_Total_Recebido'
FROM ItensVendaProd ivp
JOIN Produtos p ON ivp.Produto_idProduto = p.idProduto
GROUP BY p.nome
ORDER BY Quantidade_Vendas DESC;
