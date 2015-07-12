# This package redefines Complex operations so that there is a single
# complex infinity and a single complex NaN.

import Base.inv, Base.Complex, Base.show, Base.showcompact





function Complex(x::Real, y::Real)
    if isnan(x) || isnan(y)
        return ComplexNaN
    end

    if isinf(x) || isinf(y)
        return ComplexInf
    end

    if x==0
        x = zero(x)
    end
    if y==0
        y = zero(y)
    end

    return Complex(promote(x,y)...)
end


module RiemannComplexNumbers

const ComplexNaN = Complex(NaN,NaN)
const ComplexInf = Complex(Inf,Inf)

export ComplexNaN, ComplexInf

function my_inv(z::Complex)
    if isnan(z)
        return ComplexNaN
    end
    if isinf(z)
        return zero(z)
    end
    if z == 0
        return ComplexInf
    end
    d = abs2(z)
    return Complex(z.re/d, -z.im/d)
end


function my_div(w::Complex, z::Complex)
    w,z = promote(w,z)
    if isnan(w) || isnan(z)
        return ComplexNaN
    end
    if isinf(z)
        if isinf(w)
            return ComplexNaN
        end
        return zero(typeof(z))
    end
    if z==0
        if w==0
            return ComplexNaN
        end
        return ComplexInf
    end

    zx = z.re
    zy = z.im
    top = w*conj(z)
    d   = zx*zx + zy*zy
    return Complex(top.re/d, top.im/d)
end

end #end of module

show(io::IO, z::Complex)        = print(io, string(z,false))
showcompact(io::IO, z::Complex) = print(io,string(z,true))


#### BASIC FOUR OPERATIONS ####

# Addition

function +(w::Complex, z::Complex)
    w,z = promote(w,z)
    if isnan(w) || isnan(z)
        return ComplexNaN
    end
    if isinf(w)
        if isinf(z)
            return ComplexNaN
        end
        return ComplexInf
    end
    if isinf(z)
        return ComplexInf
    end
    return Complex(w.re+z.re, w.im+z.im)
end

+(w::Complex, x::Real) = w + Complex(x)
+(x::Real, w::Complex) = Complex(x) + w

# Binary minus

function -(w::Complex, z::Complex)
    w,z = promote(w,z)
    if isnan(w) || isnan(z)
        return ComplexNaN
    end
    if isinf(w)
        if isinf(z)
            return ComplexNaN
        end
        return ComplexInf
    end
    if isinf(z)
        return ComplexInf
    end
    return Complex(w.re-z.re, w.im-z.im)
end

-(w::Complex, x::Real) = w - Complex(x)
-(x::Real, w::Complex) = Complex(x) - w

# Unary minus

function -(w::Complex)
    if isnan(w)
        return ComplexNan
    end
    if isinf(w)
        return ComplexInf
    end
    return Complex(-w.re, -w.im)
end

# Multiplication

function *(w::Complex, z::Complex)
    w,z = promote(w,z)
    if isnan(w) || isnan(z)
        return ComplexNaN
    end
    if isinf(w)
        if z==0
            return ComplexNaN
        end
        return ComplexInf
    end
    if isinf(z)
        if w==0
            return ComplexNaN
        end
        return ComplexInf
    end
    return Complex(w.re*z.re - w.im*z.im , w.re*z.im + w.im*z.re)
end

*(w::Complex, x::Real) = w * Complex(x)
*(x::Real, w::Complex) = Complex(x) * w

# Division

/(w::Complex, x::Real) = w * RiemannComplexNumbers.my_inv(Complex(x))
/(x::Real, z::Complex) = Complex(x)*RiemannComplexNumbers.my_inv(z)

/(w::Complex, z::Complex) = RiemannComplexNumbers.my_div(w,z)
/(w::Complex128, z::Complex128) = RiemannComplexNumbers.my_div(w,z)


# These cover the cases in complex.jl (Julia 0.3.10)
inv(w::Complex{Float64}) = RiemannComplexNumbers.my_inv(w)
inv{T<:Integer}(w::Complex{T}) = RiemannComplexNumbers.my_inv(w)
inv{T<:Union(Float16,Float32)}(w::Complex{T}) = RiemannComplexNumbers.my_inv(w)
inv(w::Complex) = RiemannComplexNumbers.my_inv(w)

# Equality

function ==(w::Complex, z::Complex)
    if isnan(w) || isnan(z)
        return false
    end
    if isinf(w) && isinf(z)
        return true
    end
    return w.re == z.re && w.im == z.im
end

==(w::Complex, x::Real) = w == Complex(x)
==(x::Real, z::Complex) = Complex(x) == z


import Base.string

function string(z::Complex,compact::Bool=true)
    if isnan(z)
        if compact
            return "C_NaN"
        else
            return "ComplexNaN"
        end
    end

    if isinf(z)
        if compact
            return "C_Inf"
        else
            return "ComplexInf"
        end
    end

    a,b = reim(z)

    # This is to hide -0.0
    if a==0
        a = zero(a)
    end

    if b==0
        b = zero(b)
    end

    sp = " "
    if compact
        sp = ""
    end

    op = "+"
    if b<0
        op = "-"
    end

    return string(a) * sp * op * sp * string(abs(b)) * "im"
end
