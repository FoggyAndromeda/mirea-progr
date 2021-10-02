#=
ДАНО: Робот - в юго-западном углу поля, на котором расставлено некоторое количество маркеров

РЕЗУЛЬТАТ: Функция вернула значение средней температуры всех замаркированных клеток

Обстановки:
mid_temp.sit
=#

using HorizonSideRobots

include("..\\movement_patterns_lib.jl")

"""
Функция, считающая количество маркеров в одной линии и суммарную температуру в клетках с маркерами
\n 
r - объект робота
"""
function count_temp_line(r::Robot)
    count_markers = 0
    sum_temp = 0
    while !isborder(r, Ost)
        if ismarker(r)
            count_markers += 1
            sum_temp += temperature(r)
        end
        move!(r, Ost)
    end
    if ismarker(r)
        count_markers += 1
        sum_temp += temperature(r)
    end
    move_until_border!(r, West)
    return count_markers, sum_temp
end

"""
Функция, считающая среднюю температуру в клетках с маркерами
///INPUT///
\n 
r - объект робота \n 
///OUTPUT/// \n 
среднее значение температуры (если маркеров не нашлось, вернется значение Nothing)
"""
function count_mid_temp(r::Robot)::Float16
    sum_temp = 0
    count_markers = 0
    while !isborder(r, Nord)
        mrk, sm = count_temp_line(r)
        sum_temp += sm
        count_markers += mrk
        move!(r, Nord)
    end
    mrk, sm = count_temp_line(r)
    sum_temp += sm
    count_markers += mrk
    return count_markers != 0 ? (sum_temp / count_markers) : Nothing
end
