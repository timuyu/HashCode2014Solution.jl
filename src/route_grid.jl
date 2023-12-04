"""
    RouteGridNode

Group a junction and a street that leads to it together.

# Fields
- 'street::Int': a street in the city
- 'junction::Int': a junction that can be reached from the street
"""
@kwdef struct RouteGridNode
    junction::Int
    street::Int
end

"""
    RouteGrid

Transform a city into a graph where each junction is a node, and the streets are edges.

# Fields
- 'neighbors::Vector{Vector{RouteGridNode}}': for each junction, the list of street-junctions that can be reached from it.
"""
@kwdef struct RouteGrid
    neighbors::Vector{Vector{RouteGridNode}}
end

function create_grid(city::City)
    rg = RouteGrid([])

    for i in 1:length(city.streets)
        street = city.streets[i]
        while length(rg.neighbors) < street.endpointA
            push!(rg.neighbors, [])
        end

        push!(rg.neighbors[street.endpointA], RouteGridNode(street.endpointB, i))

        if street.bidirectional
            while length(rg.neighbors) < street.endpointB
                push!(rg.neighbors, [])
            end
            push!(rg.neighbors[street.endpointB], RouteGridNode(street.endpointA, i))
        end
    end

    return rg
end

# function get_neighboring_junctions(rg::RouteGrid, city::City, junction::Int)
#     return rg.neighbors[junction].junction
# end