# The `RiemannComplexNumbers` module

This is a Julia module that defines a `RiemannComplexNumber` type (with `CX` as an alias) that provides an alternative to Julia `Complex` number types. The main feature is that there is a single complex infinity value. 

### Motivation

The usual Julia `Complex` type allows an unlimited array of infinite values such as `Int  + 3.0im` or `Inf - Inf*im` or even `NaN + Inf*im`. Our goal is to provide complex arithmetic with a single complex infinity and a single complex `NaN`.


