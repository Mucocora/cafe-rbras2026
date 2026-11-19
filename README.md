# Produção de café no Brasil: perspectiva da inteligência artificial

Material suplementar do pôster apresentado na **70ª Reunião Anual da Região Brasileira da Sociedade Internacional de Biometria (70ª RBras)**.

**Autores:** Apolinário Valentim João Mucocora¹, Gabriel Adrian Sarries², Elisabete Aparecida de Nadai Fernandes³, Marcelo Ângelo Cirillo⁴

¹ PPGEEA/UFLA · ² ESALQ/USP · ³ CENA/USP · ⁴ DES/UFLA
Contato: apolinario.mucocora@estudante.ufla.br

---

## Resumo dos resultados

| Análise | Resultado |
|---|---|
| Regressão robusta da produção (2005–2025) | Coeficiente angular (β₁): canéfora 2,56 (R² robusto = 0,69); arábica 1,14 (R² robusto = 0,54). A canéfora cresce 2,25 vezes mais rápido. |
| Gráfico de controle: Índice Geral ISDEL (n = 38) | Média 0,50; LIC 0,32; LSC 0,68. Três municípios abaixo do LIC. |
| Gráfico de controle: renda per capita (n = 38) | Média 0,68; LIC 0,31; LSC 1,05. Três municípios abaixo do LIC e um acima do LSC. |

Os municípios abaixo do LIC nos dois indicadores são **Barra do Choça, Planalto e Nova Canaã**. O município acima do LSC de renda é **Espírito Santo do Pinhal**.

## Estrutura do repositório

```
codigo/
  arabica_percentagem.R      Regressão robusta da produção de arábica (% do ano de máximo)
  Canefora_percentagem.R     Regressão robusta da produção de canéfora (% do ano de máximo)
  Grafico_Controle.R         Gráficos de controle do Índice Geral e da renda per capita
relatorios/
  arabica_percentagem.html   Relatório do R com código e saídas (arábica)
  Canefora_percentagem.html  Relatório do R com código e saídas (canéfora)
figuras/
  regressao_arabica.pdf
  regressao_canefora.pdf
  controle_indice_geral.pdf
  controle_renda_per_capita.pdf
dados/
  T.txt                      Dados dos municípios cafeeiros (Cidade; Geral; Rend_Cap)
poster/
  Poster_70RBras_Mucocora.pdf
```

## Métodos

**Regressão robusta.** Modelo `Producao ~ Ano` ajustado com `MASS::rlm` e a função bisquare de Tukey (M-estimação). A produção anual foi expressa em porcentagem do ano de maior produção de cada espécie. O R² robusto compara a perda bisquare do modelo com a do modelo só com intercepto:

R² = 1 − Σ ρ(uᵢ) / Σ ρ(u₀ᵢ), com uᵢ = rᵢ / s e s = MAD dos resíduos.

O p-valor da inclinação vem do teste de Wald, e a faixa de 95% é a aproximação normal para a tendência média.

**Gráfico de controle de Shewhart.** Limites LSC = x̄ + 2s e LIC = x̄ − 2s, calculados sobre os 38 municípios cafeeiros. Municípios abaixo do LIC indicam potencial de melhoria. Municípios acima do LSC servem de referência (benchmarking interno).

## Como reproduzir

Requisitos: R 4.x com os pacotes `MASS` e `ggplot2`.

```r
install.packages("ggplot2")   # MASS já vem com o R

source("codigo/arabica_percentagem.R")
source("codigo/Canefora_percentagem.R")

setwd("dados")                # Grafico_Controle.R lê T.txt do diretório de trabalho
source("../codigo/Grafico_Controle.R")
```

Os dados de produção estão dentro dos próprios scripts de regressão.

## Fontes dos dados

- Produção de café arábica e canéfora, 2005–2025: IBGE.
- Índice Geral e renda per capita dos municípios (2019): Índice Sebrae de Desenvolvimento Econômico Local (ISDEL/Sebrae) e PNUD.

## Referências

- Huber, P. J. (1964). Robust estimation of a location parameter. *The Annals of Mathematical Statistics*, 35(1), 73–101.
- Venables, W. N.; Ripley, B. D. (2002). *Modern Applied Statistics with S*. 4. ed. Springer.
- Westgard, J. O.; Barry, P. L.; Hunt, M. R. (1981). A multi-rule Shewhart chart for quality control in clinical chemistry. *Clinical Chemistry*, 27(3), 493–501.

## Agradecimentos

À CAPES, pelo apoio financeiro; ao GCUB; à UFLA e à ESALQ/USP.
