# This package redefines Complex operations so that there is a single
# complex infinity and a single complex NaN.

# import Base./


module RiemannComplexNumbers

import Base.inv, Base.Complex, Base.complex_show, Base.show, Base.showcompact

export ComplexNaN, ComplexInf, inv

const ComplexNaN = Complex(NaN,NaN)
const ComplexInf = Complex(Inf,Inf)


function Complex(x::Real, y::Real)
    if isnan(x) || isnan(y)
        return ComplexNaN
    end

    if isinf(x) || isinf(y)
        return ComplexInf
    end
    return Complex(promote(x,y)...)
end


## show(io::IO, z::Complex) = complex_show(io, z, false)
## showcompact(io::IO, z::Complex) = complex_show(io, z, true)

function show(io::IO, z::Complex)
    if isnan(z)
        print(io, "ComplexNaN")
        return
    end

    if isinf(z)
        print(io, "ComplexInf")
        return
    end

    complex_show(io,z,false)
end

function showcompact(io::IO, z::Complex)
    if isnan(z)
        print(io, "C_NaN")
        return
    end

    if isinf(z)
        print(io, "C_Inf")
        return
    end

    complex_show(io,z,true)
end

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

#Division

function /(w::Complex, z::Complex)

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

/(w::Complex, x::Real) = w/Complex(x)
/(x::Real, z::Complex) = Complex(x)/z


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

    return conj(z)/abs2(z)
end

# These cover the cases in complex.jl (Julia 0.3.5)
inv(w::Complex{Float64}) = my_inv(w)
inv(w::Complex{Integer}) = my_inv(w)
inv(w::Complex) = my_inv(w)


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

end # end of module RiemannComplexNumbers
