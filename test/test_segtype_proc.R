df$seg_asso_proc[1]
df$seg_sensory_proc[1]

sense_i <- which(label$Chan_system_type_label[i_349]==1)
asso_i <- which(label$Chan_system_type_label[i_349]==2)

p349 <- label$Power_label[i_349]

submat <- cube349[,,1]
submat_noneg <- submat
submat_noneg[submat < 0 ] <- 0

w.mat <- submat_noneg[sense_i, sense_i]
mean_sense <- mean(w.mat[upper.tri(submat_noneg[sense_i, sense_i],diag=FALSE)])


# manually calculate sensory-motor within, between-same, between-other
mean(c(submat_noneg[p349==4, p349==4][upper.tri(submat_noneg[p349==4, p349==4],diag=FALSE)],
        submat_noneg[p349==5, p349==5][upper.tri(submat_noneg[p349==5, p349==5],diag=FALSE)],
        submat_noneg[p349==16, p349==16][upper.tri(submat_noneg[p349==16, p349==16],diag=FALSE)],
        submat_noneg[p349==24, p349==24][upper.tri(submat_noneg[p349==24, p349==24],diag=FALSE)]))

mean(c(submat_noneg[p349==4, is.element(p349, c(5,16,24))],
       submat_noneg[p349==5, is.element(p349, c(4,16,24))],
       submat_noneg[p349==16,is.element(p349, c(5,4,24))],
       submat_noneg[p349==24,is.element(p349, c(5,16,4))]))

mean(c(submat_noneg[p349==4, is.element(p349, c(3,6,7,14,15,20))],
       submat_noneg[p349==5, is.element(p349, c(3,6,7,14,15,20))],
       submat_noneg[p349==16,is.element(p349, c(3,6,7,14,15,20))],
       submat_noneg[p349==24,is.element(p349, c(3,6,7,14,15,20))]))


w.mat <- submat_noneg[asso_i, asso_i]
mean_asso <- mean(w.mat[upper.tri(submat_noneg[asso_i, asso_i],diag=FALSE)])


segtype_proc <- segregation_by_type_pcontr(M = submat, Ci = label$Power_label[i_349], 
                                           C_Type = label$Chan_system_type_label[i_349], diagzero = T, negzero = T)


segtype_proc$W_same