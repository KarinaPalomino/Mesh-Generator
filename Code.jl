## information on polygon and plotting
pv = [[0,0], [1,0], [0.5,.5], [1,1], [0,1], [0,0]]
plot(first.(pv), last.(pv))
axis("equal");

## is the point in the polygon?

function inpolygon(p,pv)
    x, y = p
    inside = false
    n = length(pv)
       for i in 1:n
            j = i % n + 1
            xi, yi = pv[i]
            xj, yj = pv[j]
            
        intersect = (yi > y) != (yj > y) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
            
        if intersect
            inside = !inside
        end
    end

    return inside
end

## Triangle properties
 tri_area(tri) = (0.5 * abs(tri[1][1] * (tri[2][2] - tri[3][2]) + tri[2][1] * (tri[3][2] - tri[1][2]) + tri[3][1] * (tri[1][2] - tri[2][2])))
 tri_centroid(tri) = ((1/3) * (tri[1][1] + tri[2][1] + tri[3][1]) , (1/3) * (tri[1][2] + tri[2][2] + tri[3][2]))
function tri_circumcenter(tri)
    x1, y1 = tri[1]
    x2, y2 = tri[2]
    x3, y3 = tri[3]

    D = 2 * (x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2))

    Ux = (1/D)*((x1^2 + y1^2) * (y2 - y3) + (x2^2 + y2^2) * (y3 - y1) + (x3^2 + y3^2) * (y1 - y2))
    Uy = (1/D)*((x1^2 + y1^2) * (x3 - x2) + (x2^2 + y2^2) * (x1 - x3) + (x3^2 + y3^2) * (x2 - x1))

    return (Ux, Uy)
end

## generate the mesh

function pmesh(pv, hmax)

    #b
    n = length(pv) - 1
    p = []
    for i in 1:n
        dist = norm(pv[i + 1] .- pv[i])
        num_points = ceil(dist/hmax)
        δ = (pv[i+1] - pv[i])/num_points
        for j in 0:num_points
            new_point = pv[i] + j * δ
            if !in(new_point, p)
                push!(p, new_point)
            end
        end
    end
    
    #c
    t = delaunay(p)

    function tri_points(pv, t, tri_indx)
        tri_points_indx = t[tri_indx]
        return [pv[j] for j in tri_points_indx]
    end


    while true
        inpoly = []
        #d
        for k in 1:length(t)
            vertices = tri_points(p, t, k)
            centroid = tri_centroid(vertices)
            if inpolygon(centroid, pv)
                push!(inpoly, t[k])
            end
        end
        t = inpoly

        #e
        areas = [tri_area(tri_points(p, t, idx)) for idx in 1:length(t)]
        largest_area = maximum(areas)
        large_area_indx = argmax(areas)
        if largest_area > ((hmax^2)/2)
            circumcenter = tri_circumcenter(tri_points(p, t, large_area_indx))
            push!(p, circumcenter)
            t = delaunay(p)
        else
            break
        end
    end
    return p, t
end
