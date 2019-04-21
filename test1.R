prova = c("fuoco", "acqua", "aria", "terra")

cc = create.palette(prova, aggregate = "mean")
dd = create.palette(prova,11, "median")
plot(1:4, rep(0,4), col = cc, pch = 20, cex = 4)
points(seq(1, 4, length.out = 11), rep(0.2,11), col = dd, pch = 20, cex = 4)



prova = c("forest", "water", "fire")

cc = create.palette(prova, aggregate = "mean")
dd = create.palette(prova,11, "median")
plot(1:4, rep(0,4), col = cc, pch = 20, cex = 4, axes = F, xlab = "", ylab = "")
points(seq(1, 4, length.out = 11), rep(0.2,11), col = dd, pch = 20, cex = 4)



col1 = get.colors("Alessandro")
plot(1:22, rep(0, 22), pch = 15, col = col1, cex = 4, axes = F, xlab = "", ylab = "")


col2 = get.colors("Tullia")
points(1:22, rep(-0.2, 22), pch = 15, col = col2, cex = 4)
