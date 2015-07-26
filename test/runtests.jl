using Base.Test
using RiemannComplexNumbers

a = 2+3im
b = 4-5im

@test a+b == 6-2im
@test a/0 == ComplexInf
@test isnan((a-a)/(b-b)) 
@test Inf + im == Inf + 2*im
@test ComplexInf * ComplexInf == ComplexInf
@test isnan(ComplexInf + ComplexInf)
@test isnan(0*ComplexInf)

