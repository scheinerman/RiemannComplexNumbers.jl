module RiemannComplexNumbers

import Base.inv, Base.Complex, Base.show, Base.showcompact
import Base.+, Base.-, Base.*, Base./, Base.==
import Base: isinf, isnan, iszero

export RC, ComplexInf, ComplexNaN

struct RC{T<:Complex} <: Number
    val::T
    nan_flag::Bool
    inf_flag::Bool
end


const ComplexNaN = RC((0+0im)/0,true,false)
const ComplexInf = RC(0+0im,false,true)

function RC(z::Complex)
    if isnan(z)
        return ComplexNaN
    end
    if isinf(z)
        return ComplexInf
    end
    return RC(z,false,false)
end

RC(z::Real) = RC(z+0im)

isinf(z::RC) = z.inf_flag
isnan(z::RC) = z.nan_flag

function iszero(z::RC)
    if isnan(z) || isinf(z)
        return false
    end
    return iszero(z.val)
end

function show(io::IO, z::RC)
    if isinf(z)
        print(io,"ComplexInf")
    elseif isnan(z)
        print(io,"ComplexNaN")
    else
        print(io,z.val)
    end
end

function (+)(a::RC, b::RC)
    if isnan(a) || isnan(b)
        return ComplexNaN
    end
    if isinf(a) || isinf(b)
        return ComplexInf
    end
    return RC(a.val + b.val)
end

function (-)(a::RC)
    return RC(-a.val, a.nan_flag, a.inf_flag)
end

function (-)(a::RC,b::RC)
    return a + (-b)
end

function (*)(a::RC, b::RC)
    if isnan(a) || isnan(b)
        return ComplexNaN
    end
    if (isinf(a)&&iszero(b))||(iszero(a)&&isinf(b))  # 0 x Inf
        return ComplexNaN
    end
    if isinf(a) || isinf(b)
        return ComplexInf
    end
    return RC(a.val * b.val)
end

function inv(z::RC{T}) where T
    if isnan(z)
        return ComplexNaN
    end
    if iszero(z)
        return ComplexInf
    end
    if isinf(z) return
        RC(zero(T))
    end
    return RC(1/z.val)
end

function (/)(a::RC{S}, b::RC{T}) where {S,T}
    if isnan(a) || isnan(b)
        return ComplexNaN
    end

    # zero denominator cases
    if iszero(b) && !iszero(a)
        return ComplexInf
    end
    if iszero(b) && iszero(a)
        return ComplexNaN
    end

    # infinite denominator cases
    if isinf(a) && isinf(b)
        return ComplexNaN
    end
    if isinf(b)
        return RC(zero{S})
    end

    # infinite numerator, nonzero/noninf denominator
    if isinf(a)
        return a
    end

    return RC(a.val / b.val)
end




end  # end of module
