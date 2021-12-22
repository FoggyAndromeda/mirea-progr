include("..\\movement_patterns_lib.jl")


"""
Функция, находящая максимальную площаль прямоугольной перегородки.
\n\n
На поле могут находится прямоугольные перегородки, которые могут вырождаться в отрезки. 
Эти внутренние перегородки изолированы друг от друга и от внешней рамки
\n
r - объект робота
"""
function find_max_square!(r::Robot)
    data = create_map!(r)
    num_squares = maximum(map(max, data))
    count_squares = zeros(Int, num_squares)
    for x in 1:size(data, 1)
        for y in 1:size(data, 2)
            if data[x, y] != -1
                count_squares[data[x, y]] += 1
            end
        end
    end
    return maximum(count_squares)
end
