#Regressão Robusta, arabica em percentagem
#==============================================================
rm(list = ls())
#Pacotes

library(MASS)
library(ggplot2)
#===============================================================


# Dados de produção de café
dados <- data.frame(
  Ano = 2005:2025,
  Producao = c( 69.8973641240961,
                73.839514812223,
                77.4900863074411,
                77.1168649405178,
                78.6680662467926,
                79.6011196641008,
                79.8460461861441,
                81.8054583624913,
                82.5752274317705,
                75.7872638208538,
                77.1285281082342,
                88.5584324702589,
                93.666899930021,
                99.3585257756006,
                99.3585257756006,
                100 ,
                93.3636575693958,
                81.5721950081642,
                89.7947282481922,
                93.9818054583625,
                92.4889199906694
  )
  
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
    title = "Produção de café Arabica",
    subtitle = paste("Regressão robusta | R² =", round(R2, 4)),
    x = "Ano",
    y = "Produção Percentual"
  ) +
  theme_minimal()

#Maior produção 
#periodo <- subset(dados, Ano >= 2020 & Ano <= 2025)

#periodo[which.min(periodo$Producao), c("Ano", "Producao")]

