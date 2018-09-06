using Test
using RiemannComplexNumbers

a = 2+3IM
b = 4-5IM

@test a+b == 6-2im
@test a/0 == ComplexInf
@test isnan((a-a)/(b-b))
@test Inf + IM == Inf + 2*im
@test ComplexInf * ComplexInf == ComplexInf
@test isnan(ComplexInf + ComplexInf)
@test isnan(0*ComplexInf)
