# GÁFICOS DE CONTROLE DE MUNICIPIOS 

#Pacotes
library(ggplot2)
#--------------------------------------------------------

dados <- read.table("T.txt", header = TRUE, sep = ";", dec = ",",fileEncoding = "UTF-8"
)

View(dados)
#----------------------------------------------------
# Estatistica descritiva   
# Geral
media_G <- mean(dados$Geral)

desvio_G <- sd(dados$Geral)

# Rend_Cap
media_R <- mean(dados$Rend_Cap)

desvio_R <- sd(dados$Rend_Cap)

#-------------------------------------------------
set.seed(2026)
#Grafico do indice geral 
#Geral 
LSC <- media_G + 2 * desvio_G # limite superior de controle LSC
LIC <- media_G - 2 * desvio_G # limite inferior  de controle LIC

linhas <- data.frame(
  Legenda = c("Média", "LSC", "LIC"),
  Valor = c(media_G, LSC, LIC)
)

ggplot(dados, aes(x = seq_along(Geral), y = Geral)) +
  geom_point(aes(color = "Geral"), shape = 15, size = 2) +
  geom_hline(data = linhas, aes(yintercept = Valor, color = Legenda),
             linewidth = 1) +
  scale_color_manual(
    breaks = c("Geral", "Média", "LSC", "LIC"),
    values = c("Geral" = "#2459B3", "Média" = "#2459B3",
               "LSC" = "#00A63E", "LIC" = "#E60000")
  ) +
  labs(title = "Gráfico de Controle - Índice Geral",
       x = "Município", y = "Índice Geral", color = NULL) +
  theme_minimal() +
  theme(legend.position = "bottom") +

  scale_x_continuous(breaks = seq(2, nrow(dados), by = 2))

# selecionar os municipios abaixo de LIC
subset(dados, Geral < LIC, select = c(Cidade,Geral))
# municipios com limites superior
dados$Cidade[c(16,3)] 

#-------------------------------------------------
#Grafico de Renda per Capita 

set.seed(2027)
LSC <- media_R+ 2 * desvio_R # limite superior de controle LSC
LIC <- media_R- 2 * desvio_R # limite inferior de controle LIC

linhas <- data.frame(
  Legenda = c("Média", "LSC", "LIC"),
  Valor = c(media_R, LSC, LIC)
)

ggplot(dados, aes(x = seq_along(Rend_Cap), y = Rend_Cap)) +
  geom_point(aes(color = "Renda per Capita"), shape = 15, size = 2) +
  geom_hline(data = linhas, aes(yintercept = Valor, color = Legenda),
             linewidth = 1) +
  scale_color_manual(
    breaks = c("Renda per Capita", "Média", "LSC", "LIC"),
    values = c("Renda per Capita" = "#2459B3", "Média" = "#2459B3",
               "LSC" = "#00A63E", "LIC" = "#E60000")
  ) +
  labs(title = "Gráfico de Controle - Rend per Capita",
       x = "Município", y = "Renda per Capita", color = NULL) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  
  scale_x_continuous(breaks = seq(2, nrow(dados), by = 2))

#---------------------------------------------------------------
#Identificar municipios com bases os limites 
# selecionar os municipios abaixo de LIC
subset(dados, Rend_Cap < LIC, select = c(Cidade, Rend_Cap))
#dados$Cidade[c(24, 26, 27)]

# selecionar os municipios acima de LSC
#subset(dados, Rend_Cap > LSC, select = c(Cidade, Rend_Cap))
#dados$Cidade[c(19, 21)]
