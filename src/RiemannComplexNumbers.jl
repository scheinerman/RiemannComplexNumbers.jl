# This package redefines Complex operations so that there is a single
# complex infinity and a single complex NaN.

# import Base./


module RiemannComplexNumbers

export ComplexNan, ComplexInf

const ComplexNaN = Complex(NaN,NaN)
const ComplexInf = Complex(Inf,Inf)

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


end # end of module
