read.csv(car_data)
install.packages('glmnet')
install.packages('brms')
install.packages('rstanarm')
install.packages('quantreg')
library(mgcv)
library(MASS)
library(survival)

model <- lm(house_price ~ size + age + location, data)

model <- glm(disease ~ age + gender + lifestyle, data, family = 'binomial')

model <- lm(fuel_efficiency ~ poly(speed, degree = 2), data)

ridge_model <- glmnet(x, y, alpha = 0)

model <- multinom(brand_preference ~ age + income + lifestyle, data)

model <- polr(grades ~ family_background + study_habits, data)

model <- clogit(choice ~ cost + time + comfort, data = data, strata = individual)

model <- rq(y ~ x1 + x2, data, tau  = 0.5)

