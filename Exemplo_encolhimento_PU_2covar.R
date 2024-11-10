library(MASS)
library(ggplot2)
## var(x1) = 50^2
## var(x2) = 2.5^2
## var(x3) = 5^2
## var(y) = 7500^2
##
## rho(x1,x2) = ,35
## rho(x1,y)  = ,55
## rho(x2,y)  = ,45
## rho(x3,y)  = -,35
##
## cov(x1,x2) = ,35.sqrt(50^2.5^2)     =  ,35.125     = 43,75
## cov(x1,y) =  ,55.sqrt(50^2.7500^2)  =  ,55.375.000 = 318.750
## cov(x2,y) =  ,45.sqrt(2.5^2.7500^2) =  ,45.18.750  = 8.437,5
## cov(x3,y) = -,35.sqrt(5^2.7500^2)   = -,35.37.500  = -13.125


##                  Area, Frente, Incl. ,Valor (y)
sigma <- matrix(c(50^2  , 43.75 ,   0   , 206250,
                  43.75 , 2.5^2 ,   0   , 8437.5,
                       0,      0, 5^2   , -13125,
                  206250, 8437.5,-13125 , 7500^2),
                ncol = 4, byrow = T)
n = 500

set.seed(2)
m <- mvrnorm(n = n,
             mu = c(360, 12, 0, 100000),
             Sigma = sigma)
colnames(m) <- c("x1", "x2", "x3", "y")
dados <- as.data.frame(m)
colnames(dados) <- c("Area", "Frente", "Incl", "Preco")
cor(dados)
cov(dados)

set.seed(3)
dados$amostra <- 1:n %in% sample(1:nrow(dados), size = 25)

amostra <- dados[dados$amostra == TRUE, ]

fit <- lm(Preco ~ Area + Frente + Incl, data = amostra)
amostra$.Fitted <- fitted(fit)

summary(fit)

augDados <- aug(fit, newdata = dados)
augDados$amostra <- dados$amostra

ggplot(data = augDados, aes(x = .Fitted, y = Preco)) +
  geom_point(color="lightgrey") +
  geom_abline(intercept = 0, slope = 1, color = "red", lty = 2) +
  stat_smooth(method = "lm", se = FALSE) +
  geom_point(data = amostra, aes(x = .Fitted, y = Preco, color = "red")) +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::label_number_auto()) +
  scale_x_continuous(labels = scales::label_number_auto())

