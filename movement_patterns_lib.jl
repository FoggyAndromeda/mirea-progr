using HorizonSideRobots

# Получить направление, противоположное данному
opposite_direction(d::HorizonSide) = HorizonSide((Int(d) + 2) % 4)


function move_to_corner!(r::Robot, first_corner_side::HorizonSide, second_corner_side::HorizonSide)
    """
    Функция, перемещающая робота в угол со стенами в направлениях first_corner_side и second_corner_side
    Возвращает путь, по которому робот попал в угол в формате вектора кортежей вида (направление, количество пройденных шагов)
    """
    path = []
    while !isborder(r, first_corner_side) || !isborder(r, second_corner_side)
        push!(path, (first_corner_side, move_until_border!(r, first_corner_side)))
        push!(path, (second_corner_side, move_until_border!(r, second_corner_side)))
    end
    return path
end

function do_n_steps!(r::Robot, direction::HorizonSide, steps::Int, fill::Bool=false, first_fill::Bool=false)
    """
    Делает робота на steps шагов в направлении direction. Параметр fill указывает, закрашивать ли клетки, по которым идет робот.

    """
    if fill && !ismarker(r) && first_fill
        putmarker!(r)
    end
    for _ in 1:steps
        move!(r, direction)
        if fill && !ismarker(r)
            putmarker!(r)
        end
    end
end

function move_path!(r::Robot, path::Vector, back::Bool=false)
    """
    """
    if back
        reverse!(path)
    end
    for elem in path
        direction, steps = elem
        if back
            direction = opposite_direction(direction)
        end
        do_n_steps!(r, direction, steps)
    end
end

function move_until_border!(r::Robot, direction::HorizonSide, fill::Bool=false, first_fill::Bool=false)::Int
    """
    Двигает робота до стенки в заданном направлении. Параметр fill указывает, закрашивать ли клетки, по которым идет робот.
    Возвращает количество шагов до стены
    """
    steps = 0
    if fill && !ismarker(r) && first_fill
        putmarker!(r)
    end
    while !isborder(r, direction)
        move!(r, direction)
        if fill && !ismarker(r)
            putmarker!(r)
        end
        steps += 1
    end
    return steps
end