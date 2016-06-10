typealias DefaultRefType UInt32

## Pools

abstract CategoricalPool{T, R <: Integer, V}

# V is always set to NominalValue{T} or OrdinalValue{T}
# This workaround is needed since this type not defined yet
# See JuliaLang/julia#269
for P in (:NominalPool, :OrdinalPool)
    @eval begin
        immutable $P{T, R <: Integer, V} <: CategoricalPool{T, R, V}
            index::Vector{T}
            invindex::Dict{T, R}
            order::Vector{R}
            ordered::Vector{T}
            valindex::Vector{V}

            function $P{T, R}(index::Vector{T},
                              invindex::Dict{T, R},
                              order::Vector{R})
                pool = new(index, invindex, order, index[order], V[])
                buildvalues!(pool)
                pool
            end
        end
    end
end


## Values

abstract CategoricalValue{T, R <: Integer}

immutable NominalValue{T, R <: Integer} <: CategoricalValue{T, R}
    level::R
    pool::NominalPool{T, R, NominalValue{T, R}}
end

immutable OrdinalValue{T, R <: Integer} <: CategoricalValue{T, R}
    level::R
    pool::OrdinalPool{T, R, OrdinalValue{T, R}}
end


## Arrays

type NominalArray{T, N, R <: Integer} <: AbstractArray{NominalValue{T, R}, N}
    pool::NominalPool{T, R, NominalValue{T, R}}
    values::Array{R, N}
end
typealias NominalVector{T, R} NominalArray{T, 1, R}
typealias NominalMatrix{T, R} NominalArray{T, 2, R}

abstract AbstractOrdinalArray{T, N, R <: Integer} <: AbstractArray{OrdinalValue{T, R}, N}
typealias AbstractOrdinalVector{T, R} AbstractOrdinalArray{T, 1, R}
typealias AbstractOrdinalMatrix{T, R} AbstractOrdinalArray{T, 2, R}

type OrdinalArray{T, N, R <: Integer} <: AbstractOrdinalArray{T, N}
    pool::OrdinalPool{T, R, OrdinalValue{T, R}}
    values::Array{R, N}
end
typealias OrdinalVector{T, R} OrdinalArray{T, 1, R}
typealias OrdinalMatrix{T, R} OrdinalArray{T, 2, R}


## Nullable Arrays

type NullableNominalArray{T, N, R <: Integer} <: AbstractArray{Nullable{NominalValue{T, R}}, N}
    pool::NominalPool{T, R, NominalValue{T, R}}
    values::Array{R, N}
end
typealias NullableNominalVector{T, R} NullableNominalArray{T, 1, R}
typealias NullableNominalMatrix{T, R} NullableNominalArray{T, 2, R}

type NullableOrdinalArray{T, N, R <: Integer} <: AbstractArray{Nullable{OrdinalValue{T, R}}, N}
    pool::OrdinalPool{T, R, OrdinalValue{T, R}}
    values::Array{R, N}
end
typealias NullableOrdinalVector{T, R} NullableOrdinalArray{T, 1, R}
typealias NullableOrdinalMatrix{T, R} NullableOrdinalArray{T, 2, R}