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
