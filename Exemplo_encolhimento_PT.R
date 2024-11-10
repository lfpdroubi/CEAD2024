library(MASS)
library(ggplot2)
# Exemplo
# Duas variáveis:
# + V1 = Area, com média = 360m2 e
# desvio-padrao = 50m2 (Var(x) = 2.500)
# + V2 = Valor, com média = R$ 100.000,00 e
# desvio-padrao = R$ 5.000,00 (Var(y) = 25.000.000)
# + Correlação entre as variáveis r = 0,75.


m <- c(100000, 360)
s <- c(5000, 50)

# S(x,y) = S(y,x) = 0,75.50.5000 = 187.500
# S(x,x) = 50^2
# S(x,y) = 5.000^2
set.seed(2)
m <- mvrnorm(n = 300,
             mu = c(100000, 360),
             Sigma = matrix(c(5000^2, 187500,
                              187500, 50^2),
                            ncol = 2, byrow = TRUE),
             empirical = T)

dados <- as.data.frame(m)

colnames(dados) <- c("P", "Area")

set.seed(6)
dados$amostra <- 1:300 %in% sample(1:nrow(dados), size = 20)

amostra <- dados[dados$amostra == TRUE, ]

fit <- lm(P ~ Area, data = amostra)

summary(fit)

ggplot(data = dados, aes(x = Area, y = P)) +
  geom_point(aes(colour = amostra, pch = amostra)) +
  stat_smooth(method = "lm", se = FALSE) +
  geom_abline(intercept = coef(fit)["(Intercept)"],
              slope = coef(fit)["Area"], size = 1, color = hue_pal()(2)[2])

augDados <- aug(fit, newdata = dados)
augDados$amostra <- dados$amostra

ggplot(data = augDados, aes(x = .Fitted, y = P)) +
  geom_point(aes(pch = amostra, color =)) +
  geom_abline(intercept = 0, slope = 1, color = "red", lty = 2) +
  stat_smooth(se = FALSE)

