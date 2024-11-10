library(MASS)
# Exemplo
# Duas variáveis:
# + V1 = Area, com média = 360m2 e
# desvio-padrao = 50m2 (Var(x) = 2.500)
# + V2 = Valor, com média = R$ 5.000,00 /m2 e
# desvio-padrao = R$ 1.000,00 (Var(y) = 10.000.000)
# + Correlação entre as variáveis r = -0,75.

m <- c(5000, 360)
s <- c(1000, 50)

# S(x,y) = S(y,x) = -0,75.50.1000 = -37.500
# S(x,x) = 50^2
# S(x,y) = 1.000^2

m <- mvrnorm(n = 300,
             mu = c(5000, 360),
             Sigma = matrix(c(1000^2, -37500,
                              -37500, 50^2),
                            ncol = 2, byrow = TRUE),
             empirical = T)

dados <- as.data.frame(m)

colnames(dados) <- c("PU", "Area")

set.seed(1)
dados$amostra <- 1:300 %in% sample(1:nrow(dados), size = 75)

amostra <- dados[dados$amostra == TRUE, ]

fit <- lm(PU ~ Area, data = amostra)

summary(fit)

library(ggplot2)
ggplot(data = dados, aes(x = Area, y = PU)) +
  geom_point(aes(colour = amostra)) +
  stat_smooth(method = "lm", se = FALSE) +
  geom_abline(intercept = coef(fit)["(Intercept)"],
              slope = coef(fit)["Area"], size = 1, color = hue_pal()(2)[2])
