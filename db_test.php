<?php
// db_config.php

// --- Configurações do Banco de Dados ---
// Altere os valores abaixo com as suas credenciais do MySQL.
define('DB_SERVER', 'localhost'); // Geralmente 'localhost' ou '127.0.0.1'
define('DB_USERNAME', 'root');    // Seu nome de usuário do MySQL
define('DB_PASSWORD', '');      // Sua senha do MySQL
define('DB_NAME', 'bancoTest'); // O nome do banco de dados que você criou

// --- Cria a Conexão ---
$conexao = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// --- Verifica a Conexão ---
if ($conexao->connect_error) {
    // Em um ambiente de produção, seria melhor logar o erro em vez de exibi-lo.
    die("Falha na conexão com o banco de dados: " . $conexao->connect_error);
}

// Define o charset para UTF-8 para evitar problemas com acentuação
$conexao->set_charset("utf8");

?>