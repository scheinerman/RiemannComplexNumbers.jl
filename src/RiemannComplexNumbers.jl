# THIS IS A PLACE HOLDER ... MUCH MORE TO COME!


import Base./

const ComplexNaN = Complex(NaN,NaN)
const ComplexInf = Complex(Inf,Inf)

function /(w::Complex, z::Complex)

    println("Dividing ", w, " by ", z)   # DEBUG #

    w,z = promote(w,z)

    if isnan(w) || isnan(z)
        return ComplexNaN
    end

    if isinf(z)
        if isinf(w)
            return ComplexNaN
        end
        return Complex(zero(z))
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

