# Projeto de Censura de Imagens BMP

Este é um programa simples em C que permite censurar áreas específicas de imagens BMP. O programa recebe como entrada o nome de um arquivo de imagem BMP, coordenadas iniciais (x e y), largura e altura do retângulo de censura e um nome para o arquivo de saída.

## Requisitos

- MASM32 instalado
- Sistema operacional Windows

## Compilação

Aconselho utilizar a propria IDE do MASM32, na aba 'Project':

```bash
Console Build All
# Projeto de Censura de Imagens BMP

Este é um programa simples em C que permite censurar áreas específicas de imagens BMP. O programa recebe como entrada o nome de um arquivo de imagem BMP, coordenadas iniciais (x e y), largura e altura do retângulo de censura e um nome para o arquivo de saída.

## Requisitos

- MASM32 instalado
- Sistema operacional Windows

## Compilação

Aconselho utilizar a propria IDE do MASM32, na aba 'Project':

```bash
Console Build All
```
## Uso
- Para executar o programa, siga as etapas abaixo:

- Certifique-se de que o arquivo de imagem BMP que você deseja censurar está no mesmo diretório do arquivo executável.

- abra o terminal e digite o nome do executável

Execute o programa da seguinte forma:

```bash
C:\masm32\Nova pasta> nomeDoExecutavel
```
- Siga as instruções fornecidas pelo programa, que solicitarão o nome do arquivo de imagem, coordenadas iniciais (x e y), largura e altura do retângulo de censura e o nome do arquivo de saída.
- Lembre de passar a extensão do arquivo .bmp
- O programa criará uma cópia da imagem com o retângulo de censura preto na área especificada e salvará o resultado no arquivo de saída (censura.bmp).

## Exemplo
- Aqui está um exemplo de como o programa pode ser usado:

```bash
Digite o nome do arquivo de imagem BMP: fotoanonima.bmp
Digite a coordenada X inicial: 250
Digite a coordenada Y inicial: 310
Digite a largura do retângulo: 230
Digite a altura do retângulo: 30
```

## Notas
- O programa assume que todas as entradas estão corretas e dentro das faixas de valores esperadas. Não foram implementadas verificações de erro para simplificar o código.

- O programa utiliza chamadas de sistema para abrir, ler, escrever e fechar arquivos, garantindo compatibilidade com sistemas Windows.

## Autores
- Davison Tavares.
- Camilla

## Licença
- Este projeto é licenciado sob a Licença MIT. Consulte o arquivo LICENSE para obter mais detalhes.
