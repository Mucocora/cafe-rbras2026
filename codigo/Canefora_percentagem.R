
#Regressão Robusta, canefora em percentagem
#==============================================================
#Pacotes

library(MASS)
library(ggplot2)
#===============================================================


# Dados de produção de café
dados <- data.frame(
  Ano = 2005:2025,
  Producao = c(38.6868686868687, 41.6161616161616,
               44.4949494949495 ,49.4949494949495,
               54.2424242424242,50.6565656565657,
               46.2121212121212,54.3939393939394,
               60.6565656565657 ,55.3030303030303,
               61.5151515151515 ,62.5252525252525,
               65.6565656565657,69.8989898989899,
               67.1212121212121,76.8686868686869,
               78.4343434343434,90.4040404040404,
               92.6262626262626,86.2626262626263,100)
  
)

print(dados)

#=======================================================
#ajuste de modelos 
modelo <- rlm(Producao ~ Ano, data = dados, psi = psi.bisquare)

mode_nulo <- update(modelo, . ~ 1) 

r <- residuals(modelo) 

s <- mad(r, center = 0) 

u <- r / s 


coef(modelo) # Mostra o intercepto e o coeficiente de Ano

# Calcula o p-valor aproximado de Ano pelo teste de Wald
t_ano <- coef(summary(modelo))["Ano", "t value"]
p_valor <- pchisq(t_ano^2, df = 1, lower.tail = FALSE)
p_valor

# Calcula a perda robusta usando a função bisquare do pacote MASS
perda <- function(z) sum(1 - psi.bisquare(z)^(3/2))

# Compara o modelo com Ano ao modelo só com intercepto
R2 <- 1 - perda(u) / perda(residuals(mode_nulo ) / s)
round(R2, 4)

# Mostra os anos com resíduo padronizado acima de 3 em valor absoluto
dados$Residuo_pad <- u
subset(dados, abs(Residuo_pad) > 3)



# Valores ajustados pela regressão robusta
dados$Ajustado <- fitted(modelo)

# Faixa de confiança aproximada de 95% para a tendência média
ano_centrado <- dados$Ano - mean(dados$Ano)
EP <- summary(modelo)$stddev *
  sqrt(1 / nrow(dados) + ano_centrado^2 / sum(ano_centrado^2))
margem <- qnorm(0.975) * EP

ggplot(dados, aes(x = Ano)) +
  geom_ribbon(aes(ymin = Ajustado - margem, ymax = Ajustado + margem),
              fill = "steelblue", alpha = 0.2) +
  geom_line(aes(y = Ajustado), color = "steelblue", linewidth = 1) +
  geom_point(aes(y = Producao), size = 2) +
  #geom_point(data = subset(cafe, abs(Residuo_pad) > 3),
  #aes(y = Producao), color = "red3", size = 3)
  labs(
    title = "Produção de café canephora",
    subtitle = paste("Regressão robusta | R² =", round(R2, 4)),
    x = "Ano",
    y = "Produção Percentual"
  ) +
  theme_minimal()

