using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

"""
Функция, создающая одно поле шахматной доски
\n 
r - объект робота\n
tile_size - размер поля
"""
function one_tile(r::Robot, tile_size::Int)
    done_y = 0
    for i in 1:tile_size
        putmarker!(r)
        done_x = 0
        for j in 1:tile_size
            if !isborder(r, Ost)
                putmarker!(r)
                move!(r, Ost)
                done_x += 1
            else
                putmarker!(r)
                break
            end
        end
        do_n_steps!(r, West, done_x)
        if !isborder(r, Nord)
            move!(r, Nord)
            done_y += 1
        else
            break
        end
    end
    do_n_steps!(r, Sud, done_y)
end

"""
Функция, расставляющая поля из маркеров в шахматном порядке, левый нижний угол закрашен и возвращающая робота в исходное положение
\n 
r - объект робота\n 
tile_size - размеры одной клетки поля
"""
function big_chess(r::Robot, tile_size::Int)
    path = move_to_corner!(r, Sud, West)
    height = move_until_border!(r, Nord)
    move_until_border!(r, Sud)
    width = move_until_border!(r, Ost)
    move_until_border!(r, West)
    for i in 0:div(width, tile_size)
        for j in 0:div(height, tile_size)
            if (i + j) % 2 == 0
                do_n_steps!(r, Nord, tile_size * j)
                do_n_steps!(r, Ost, tile_size * i)
                one_tile(r, tile_size)
                do_n_steps!(r, Sud, tile_size * j)
                do_n_steps!(r, West, tile_size * i)
            end
        end
    end
    move_path!(r, path, back=true)
end
