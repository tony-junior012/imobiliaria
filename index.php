<?php
// index.php

// 1. Inclui o arquivo de configuração do banco de dados para estabelecer a conexão.
require_once 'db_config.php';

// 2. Prepara e executa a consulta SQL para buscar todos os imóveis.
$sql = "SELECT * FROM imoveis ORDER BY data_cadastro DESC";
$resultado = $conexao->query($sql);
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Imobiliária Your Home</title>
    <!-- Link para o mesmo arquivo CSS de antes -->
    <link rel="stylesheet" href="style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body>
        <a href = "Teste.php"><button>Teste</button></a>
    <header>
        <nav class="container">
            <a href="#" class="logo">Imobiliária <strong>Seu Lar</strong></a>
            <ul class="nav-links">
                <li><a href="#">Comprar</a></li>
                <li><a href="#">Alugar</a></li>
                <li><a href="anunciar.php">Anunciar Imóvel</a></li>
                <li><a href="#" class="btn-contact">Contato</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <section class="hero">
            <div class="hero-content">
                <h1>Encontre o imóvel dos seus sonhos</h1>
                <p>O lugar perfeito para você e sua família está aqui.</p>
            </div>
        </section>

        <section class="properties-section container">
            <h2>Imóveis em Destaque</h2>
            <div class="property-grid">

                <?php
                // 3. Verifica se a consulta retornou resultados.
                if ($resultado && $resultado->num_rows > 0) {
                    // 4. Itera sobre cada linha (imóvel) retornada do banco de dados.
                    while ($imovel = $resultado->fetch_assoc()) {
                ?>
                        <!-- O HTML abaixo será repetido para cada imóvel encontrado -->
                        <div class="property-card">
                            <div class="card-image">
                                <img src="https://placehold.co/600x400/E8F5E9/333?text=<?php echo urlencode($imovel['tipo_imovel']); ?>" alt="Foto de <?php echo htmlspecialchars($imovel['titulo']); ?>">
                                
                                <?php
                                // Define a classe e o texto da tag de status dinamicamente
                                $status_class = '';
                                $status_text = '';
                                if ($imovel['status'] == 'Disponível') {
                                    $status_text = 'Venda / Aluguel';
                                } elseif ($imovel['status'] == 'Alugado') {
                                    $status_class = 'rented';
                                    $status_text = 'Alugado';
                                } elseif ($imovel['status'] == 'Vendido') {
                                    $status_class = 'rented'; // Pode criar uma classe 'sold' se quiser
                                    $status_text = 'Vendido';
                                }
                                ?>
                                <span class="status-tag <?php echo $status_class; ?>"><?php echo $status_text; ?></span>
                            </div>
                            <div class="card-content">
                                <h3><?php echo htmlspecialchars($imovel['titulo']); ?></h3>
                                <p class="location"><?php echo htmlspecialchars($imovel['endereco']) . ' - ' . htmlspecialchars($imovel['cidade']) . ', ' . htmlspecialchars($imovel['estado']); ?></p>
                                <div class="property-details">
                                    <span><img src="https://api.iconify.design/material-symbols/bed-outline.svg?color=%23555" alt="ícone quarto" class="icon"> <?php echo $imovel['quartos']; ?> Quartos</span>
                                    <span><img src="https://api.iconify.design/material-symbols/shower-outline.svg?color=%23555" alt="ícone banheiro" class="icon"> <?php echo $imovel['banheiros']; ?> Banheiros</span>
                                    <span><img src="https://api.iconify.design/material-symbols/garage-outline.svg?color=%23555" alt="ícone garagem" class="icon"> <?php echo $imovel['vagas_garagem']; ?> Vagas</span>
                                    <span><img src="https://api.iconify.design/material-symbols/straighten-outline.svg?color=%23555" alt="ícone área" class="icon"> <?php echo number_format($imovel['area_m2'], 1, ',', '.'); ?> m²</span>
                                </div>
                                <div class="price-container">
                                    <?php if (!empty($imovel['valor_aluguel'])): ?>
                                        <p class="price rent">R$ <?php echo number_format($imovel['valor_aluguel'], 2, ',', '.'); ?> <span class="period">/mês</span></p>
                                    <?php endif; ?>
                                    <?php if (!empty($imovel['valor_venda'])): ?>
                                        <p class="price sale">R$ <?php echo number_format($imovel['valor_venda'], 2, ',', '.'); ?></p>
                                    <?php endif; ?>
                                </div>
                                <a href="#" class="btn-details <?php echo ($imovel['status'] != 'Disponível') ? 'disabled' : ''; ?>">Ver Detalhes</a>
                            </div>
                        </div>
                <?php
                    } // Fim do loop while
                } else {
                    // Mensagem exibida se nenhum imóvel for encontrado no banco de dados.
                    echo "<p>Nenhum imóvel encontrado no momento.</p>";
                }
                // 5. Fecha a conexão com o banco de dados.
                $conexao->close();
                ?>

            </div>
        </section>
    </main>

    <footer>
        <div class="container">
            <p>&copy; <?php echo date('Y'); ?> Imobiliária Seu Lar. Todos os direitos reservados.</p>
        </div>
    </footer>

</body>
</html>
