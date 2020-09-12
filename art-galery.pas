uses graphABC;

type figure = array [1..2, 1..100000] of real;//фигура

type booleans = array [1.. 100000] of boolean;

var a: array[1..67]of Color;//цвета для охранников

var
        y_n, f, l, kol, s: int64;

var
        Gallery, Guards: array [1..2, 0..1000] of int64;

{ ************************  заносим в x y пересечение двух прямых, на которых лежат отрезки. Если пересечения нет - NAN   *******************************************}

function points_dist(x1, y1, x2, y2 : int64) : real;//расстояние между двумя точками
begin 
    result := Sqrt(Sqr(Abs(x1 - x2)) + Sqr(Abs(y1 - y2)));
end;

procedure intersection(x1, y1, x2, y2, x3, y3, x4, y4: real; var x, y: real);
begin
        var u1: real;
        u1 := ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
        //u2 := ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
        x := x1 + u1 * (x2 - x1);
        y := y1 + u1 * (y2 - y1);
end;

{ ************************  проверяем, лежит ли точка на прямой   *******************************************}
function line_and_pixel(x, y, x1, x2, y1, y2: real): boolean;
begin
        if (round(((y1 - y2) * x + (x2 - x1) * y + (x1 * y2 - x2 * y1))) = 0) then 
                Result := true
        else 
                Result := false;
end;

{ ************************  проверяем, лежит ли точка на отрезке   *******************************************}
function segment_and_pixel(x, y, x1, x2, y1, y2: real): boolean;
begin
        if ((round(((y1 - y2) * x + (x2 - x1) * y + (x1 * y2 - x2 * y1))) = 0) and ((not (x < x1) and not (x2 < x)) or (not (x < x2) and not (x1 < x))) and ((not (y < y1) and not (y2 < y)) or (not (y < y2) and not (y1 < y)))) then 
                Result := true
        else 
                Result := false;
end;

{function have_in_Galery(x, y : int64) : boolean;
begin 
    
end;}

{ ************************  проверяем, пересекаются ли отрезки   *******************************************}
function get_line_intersection(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y: real): boolean;
begin
        var cat1_x, cat2_x, cat1_y, cat2_y, prod1, prod2: real;
        cat1_x := p1_x - p0_x;
        cat1_y := p1_y - p0_y;
        cat2_x := p3_x - p2_x;
        cat2_y := p3_y - p2_y;
        prod1 := (cat1_x * (p2_y - p0_y)) - ((p2_x - p0_x) * cat1_y);
        prod2 := (cat1_x * (p3_y - p0_y)) - ((p3_x - p0_x) * cat1_y);
        if(((prod1 < 0) and (prod2 < 0)) or ((prod1 > 0) and (prod2 > 0))) then
        begin
                Result := false;
                exit;
        end;
        prod1 := (cat2_x * (p0_y - p2_y)) - ((p0_x - p2_x) * cat2_y);
        prod2 := (cat2_x * (p1_y - p2_y)) - ((p1_x - p2_x) * cat2_y);
        if(((prod1 < 0) and (prod2 < 0)) or ((prod1 > 0) and (prod2 > 0))) then
        begin
                Result := false;
                exit;
        end;
        Result := true;
end;

//удаляет элемент del массива fig
procedure delete2(var fig : figure; el, del : int64);
begin 
    for var i := del to el - 1 do
    begin
        fig[1][i] := fig[1][i + 1];
        fig[2][i] := fig[2][i + 1];
    end;
    fig[1][el] := 0;
    fig[2][el] := 0;
end;

//удаляет все заднные элементы fig
function delete_bad(var fig : figure; el : int64) : int64;
begin 
    for var i := el downto 1 do
    begin
        if fig[1][i] = -1 then
        begin
            delete2(fig, el - result, i);
            result := result + 1;
        end;
    end;
end;

//удаляет все заданные элементы массива fig, а также элементы массива fig2, стоящие на тех же местах
function delete_bad2(var fig, fig2 : figure; el : int64) : int64;
begin 
    for var i := el downto 1 do
    begin
        if fig[1][i] = -1 then
        begin
            delete2(fig, el - result, i);
            delete2(fig2, el - result, i);
            result := result + 1;
        end;
    end;
end;

function index(fig : figure; x, y : real; el : int64) : int64;
begin
    for var i := 1 to el do
    begin
        if (Abs(fig[1][i] - x) < 2) and (Abs(fig[2][i] - y) < 2) then
        begin
            Result := i;
            exit;
        end;
    end;
end;

//удаляем дубликаты
function delete_doubles(var fig : figure; el : int64) : int64;
begin 
    for var i := 1 to el do///идём по добавляемым вершинам
    begin
        for var j := 1 to el do///снова идём по добавляемым вершинам
        begin
            if (Abs(fig[1][i] - fig[1][j]) < 1) and (Abs(fig[2][i] - fig[2][j]) < 1) and not (i = j) then
            begin 
                fig[1][Max(i, j)] := -1;
                fig[2][Max(i, j)] := -1;
            end;
        end;
    end;
    result := delete_bad(fig, el);//само удаление
end;

function points_dist(x1, y1, x2, y2 : real) : real;//расстояние между двумя точками
begin 
    result := Sqrt(Sqr(x1 - x2) + Sqr(y1 - y2));
end;

procedure insert(num_insert, len_place : int64; var place_insert : figure);//вставляет len_place-ный элемент массива place_insert в позицию num_insert
var prom : real;
begin 
    prom := place_insert[1][num_insert];
    place_insert[1][num_insert] := place_insert[1][len_place];
    for var pointup := num_insert + 1 to len_place - 1 do
    begin
        place_insert[1][num_insert + len_place - pointup + 1] := place_insert[1][num_insert + len_place - pointup];
    end;
    place_insert[1][num_insert + 1] := prom; 
    prom := place_insert[2][num_insert];
    place_insert[2][num_insert] := place_insert[2][len_place];
    for var pointup := num_insert + 1 to len_place - 1 do
    begin
        place_insert[2][num_insert + len_place - pointup + 1] := place_insert[2][num_insert + len_place - pointup];
    end;
    place_insert[2][num_insert + 1] := prom;
end;

function in_or_out(x_guard, y_guard, xxx, yyy : real; el : int64; fig : figure): boolean;
begin
        var counter: int64;
        counter := 0;
        //        Print(num_of_walls);
        //        Line(0,0,x_guard,y_guard,clRed);
        //        SetPenWidth(3);
        for var lines := 1 to el - 1 do
        begin
                if get_line_intersection(fig[1][lines], fig[2][lines], fig[1][lines + 1], fig[2][lines + 1], x_guard, y_guard, xxx, yyy) then
                begin
                        counter := counter + 1;
                end;
                //                Line(k[1][lines],k[2][lines],k[1][lines + 1], k[2][lines + 1],clRed);
                //                Print(counter,k[1][lines], k[2][lines], k[1][lines + 1], k[2][lines + 1]);
        end;
        if get_line_intersection(fig[1][el], fig[2][el], fig[1][1], fig[2][1], x_guard, y_guard, xxx, yyy) then
        begin
                counter := counter + 1;
        end;
        //        Print(counter);
        if counter mod 2 = 0 then
                result := false
        else
                result := true;
end;

function in_or_out2(x_guard, y_guard : real; el : int64; fig : figure): boolean;
begin
        //Println()
        if(in_or_out(x_guard, y_guard, 0, 0, el, fig) <> in_or_out(x_guard, y_guard , WindowWidth(), WindowHeight(), el, fig)) then
        begin
                //Print(1);
                if(in_or_out(x_guard, y_guard, 0, WindowHeight(), el, fig) <> in_or_out(x_guard, y_guard, WindowWidth(), 0, el, fig)) then
                begin
                        if(in_or_out(x_guard, y_guard, 0, WindowHeight() div 2, el, fig) <> in_or_out(x_guard, y_guard, WindowWidth(), WindowHeight()div 2, el, fig)) then
                        begin
                                if(in_or_out(x_guard, y_guard, WindowWidth() div 2, WindowHeight(), el, fig) <> in_or_out(x_guard, y_guard, WindowWidth()div 2, 0, el, fig)) then
                                begin
                                        Result:= True;
                                end
                                else
                                begin
                                        Result := in_or_out(x_guard, y_guard, WindowWidth()div 2, WindowHeight(), el, fig);
                                end;
                        end
                        else
                        begin
                                Result := in_or_out(x_guard, y_guard, 0, WindowHeight()div 2, el, fig);
                        end;
                end
                else
                begin
                        Result := in_or_out(x_guard, y_guard, 0, WindowHeight(), el, fig);
                end;
        end
        else
        begin
                Result := in_or_out(x_guard, y_guard, 0, 0, el, fig);
        end;
end;

procedure insert_boolean(num_insert, len_place : int64; var place_insert : booleans);//вставляет len_place-ный элемент массива place_insert в позицию num_insert
var prom : boolean;
begin 
    prom := place_insert[num_insert];
    place_insert[num_insert] := place_insert[len_place];
    for var pointup := num_insert + 1 to len_place - 1 do
    begin
        place_insert[num_insert + len_place - pointup + 1] := place_insert[num_insert + len_place - pointup];
    end;
    place_insert[num_insert + 1] := prom;
end;

procedure insert_intersections(var fig1, fig2 : figure; var num_vert1, num_vert2 : int64; var intersections1, intersections2 : booleans);
var add, place_add : figure;//fig1, fig2 : копии figure1, figure2, add : список вершин, которые нужно добавить как пересечения, place_add : места, куда мы вставляем вершины из add
//var : array [1.. 100000] of int64;
var num_add : int64;//num_points : длина массива intersections, num_add : длина массива add
begin 
    fig1[1][num_vert1 + 1] := fig1[1][1];//замыкаем фигуры
    fig2[1][num_vert2 + 1] := fig2[1][1];
    fig1[2][num_vert1 + 1] := fig1[2][1];
    fig2[2][num_vert2 + 1] := fig2[2][1];
    {points := fig1;
    for var i := 1 to num_vert2 do
    begin
        points[1][i + num_vert1] := fig2[1][i];
        points[2][i + num_vert1] := fig2[2][i];
    end;}
    //начинаем искать коорднаты пересечений
    for var i :=  1 to num_vert1 do
    begin
        intersections1[i] := false
    end;
    for var i :=  1 to num_vert2 do
    begin
        intersections2[i] := false
    end;
    for var i1 := 1 to num_vert1 do//идём по первой фигуре
    begin
        for var i2 := 1 to num_vert2 do//идём по второй фигуре
        begin
            var x, y : real;//пересечение линий (которые являются продолжениями сторон)
            intersection(fig1[1][i1], fig1[2][i1], fig1[1][i1 + 1], fig1[2][i1 + 1], fig2[1][i2], fig2[2][i2], fig2[1][i2 + 1], fig2[2][i2 + 1], x, y);
            //проверяем пересекаются ли отрезки
            if (get_line_intersection(fig1[1][i1], fig1[2][i1], fig1[1][i1 + 1], fig1[2][i1 + 1], fig2[1][i2], fig2[2][i2], fig2[1][i2 + 1], fig2[2][i2 + 1]) or (points_dist(x, y, fig2[1][i2 + 1], fig2[2][i2 + 1]) < 1) or (points_dist(x, y, fig2[1][i2], fig2[2][i2]) < 1) or (points_dist(x, y, fig1[1][i1 + 1], fig1[2][i1 + 1]) < 1) or (points_dist(x, y, fig1[1][i1], fig1[2][i1]) < 1)) and (x / x = 1) then
            begin
                add[1][num_add + 1] := x;//заносим пересечение в add
                add[2][num_add + 1] := y;
                place_add[1][num_add + 1] := i1;//заносим место куда вставить в place_add
                place_add[2][num_add + 1] := i2;
                num_add := num_add + 1;//увеличиваем кол-во пересечений на 1
                //Println(Round(x), Round(y), i1, i2);
            end;
        end;
    end;
    //удаляем дубликаты
    for var i := 1 to num_add do///идём по добавляемым вершинам
    begin
        for var j := 1 to num_add do///снова идём по добавляемым вершинам
        begin
            if (Abs(add[1][i] - add[1][j]) < 1) and (Abs(add[2][i] - add[2][j]) < 1) and not (i = j) then
            begin 
                add[1][Max(i, j)] := -1;
                add[2][Max(i, j)] := -1;
            end;
        end;
    end;
    num_add := num_add - delete_bad2(add, place_add, num_add);//само удаление
    //удаляем те точки, которые не лежат на сторонах фигуры 1
    for var vert := num_add downto 1 do
    begin
        var bad_vert : boolean;//плохая ли вершина
        bad_vert := true;//до проверки она плохая
        for var i := 1 to num_vert1 do//идём по вершинам фигуры
        begin
            //и если вершина лежит на какой-то стороне...
            if segment_and_pixel(add[1][vert], add[2][vert], fig1[1][i], fig1[1][i + 1], fig1[2][i], fig1[2][i + 1]) then
                bad_vert := false;//...она хорошая
        end;
        if bad_vert then//если она не хорошая...
        begin
            //SetBrushColor(RGB(150, 90, 0));
            //SetPenColor(RGB(150, 90, 0));
            //Circle(Round(add[1][vert]), Round(add[2][vert]), 5);
            delete2(add, num_add, vert);//...мы её удалим
            num_add := num_add - 1;
        end;
    end;
    //тоже для фигуры 2
    for var vert := num_add downto 1 do
    begin
        var bad_vert : boolean;
        bad_vert := true;
        for var i := 1 to num_vert2 do
        begin
            if segment_and_pixel(add[1][vert], add[2][vert], fig2[1][i], fig2[1][i + 1], fig2[2][i], fig2[2][i + 1]) then
                bad_vert := false;
        end;
        if bad_vert then 
        begin
            //SetBrushColor(RGB(150, 0, 0));
            //SetPenColor(RGB(150, 0, 0));
            //Circle(Round(add[1][vert]), Round(add[2][vert]), 5);
            delete2(add, num_add, vert);
            num_add := num_add - 1;
        end;
    end;
    //вставляем пересечения в фигуры
    for var i := 1 to num_add do
    begin
        fig1[1][num_vert1 + 1] := add[1][i];//вначале поставим его на последнее место
        fig2[1][num_vert2 + 1] := add[1][i];
        fig1[2][num_vert1 + 1] := add[2][i];
        fig2[2][num_vert2 + 1] := add[2][i];
        intersections1[num_vert1 + 1] := true;//и скажем, что это пересечение
        intersections2[num_vert2 + 1] := true;
        num_vert1 := num_vert1 + 1;//увеличим кол-во вершин на 1
        num_vert2 := num_vert2 + 1;
        insert(Round(place_add[1][i] + 1), num_vert1, fig1);//перенесём в нужное место координаты точки и соответствующий ей boolean
        insert(Round(place_add[2][i] + 1), num_vert2, fig2);
        insert_boolean(Round(place_add[1][i] + 1), num_vert1, intersections1);
        insert_boolean(Round(place_add[2][i] + 1), num_vert2, intersections2);
        //идём по добавлемым точкам, чтобы обратить последствия сдивга во время вставления
        for var j := 1 to num_add do
        begin
            if (place_add[1][j] > place_add[1][i]) and (j > i) then//если точку надо втавить позже, и мы её ещё не вставили...
                place_add[1][j] := place_add[1][j] + 1;
            if (place_add[2][j] > place_add[2][i]) and (j > i) then//если точку надо втавить позже, и мы её ещё не вставили...
                place_add[2][j] := place_add[2][j] + 1;
        end;
    end;
    fig1[1][num_vert1 + 1] := fig1[1][1];//снова замыкаем фигуры
    fig2[1][num_vert2 + 1] := fig2[1][1];
    fig1[2][num_vert1 + 1] := fig1[2][1];
    fig2[2][num_vert2 + 1] := fig2[2][1];
    //сортируем пересечения внутри сторон 1-ой фигуры
    for var i := 1 to num_vert1 do//идём по вершинам
    begin
        var num_between : int64;//кол-во пересечений между 2-мя вершинами
        if not intersections1[i] then//если эта точка
        begin 
            for var plus := 1 to 3 do//идём вперёд от этой точки
            begin
                num_between := plus - 1;
                if not intersections1[i + plus] then//если это пересечение...
                    break;//...мы выходим из цикла
            end;
            //если между ними 2 точки и они стоят не в том порядке...
            if (num_between = 2) and (points_dist(fig1[1][i + 1], fig1[2][i + 1], fig1[1][i], fig1[2][i]) > points_dist(fig1[1][i + 2], fig1[2][i + 2], fig1[1][i], fig1[2][i])) then
            begin
                Swap(fig1[1][i + 1], fig1[1][i + 2]);//...мы меняем их местами
                Swap(fig1[2][i + 1], fig1[2][i + 2]);
            end;
        end;
    end;
    //тоже для 2-ой фигуры
    for var i := 1 to num_vert2 do
    begin
        var num_between : int64;
        if not intersections2[i] then
        begin 
            for var plus := 1 to 3 do
            begin
                num_between := plus - 1;
                if not intersections2[i + plus] then
                begin
                    break;
                end;
            end;
            if (num_between = 2) and (points_dist(fig2[1][i + 1], fig2[2][i + 1], fig2[1][i], fig2[2][i]) > points_dist(fig2[1][i + 2], fig2[2][i + 2], fig2[1][i], fig2[2][i])) then
            begin
                Swap(fig2[1][i + 1], fig2[1][i + 2]);
                Swap(fig2[2][i + 1], fig2[2][i + 2]);
            end;
        end;
    end;
    for var i := 1 to num_add do
    begin
        SetBrushColor(clRed);
        SetPenColor(clRed);
        Circle(Round(add[1][i]), Round(add[2][i]), 3)
    end;
end;

function segment_in_figure(fig : figure; num_vert, point_index : int64; x, y : real) : boolean;
var was_intersection : boolean;
begin
    was_intersection := false;
    for var i := 1 to num_vert do
    begin
        if get_line_intersection(fig[1][i], fig[2][i], fig[1][i + 1], fig[2][i + 1], fig[1][point_index], fig[2][point_index], x, y) and (not (i = point_index)) and (not (i = point_index - 1)) and (not ((point_index = 1) and (i = num_vert))) then
            was_intersection := true
    end;
    Result := was_intersection or in_or_out2(x, y, num_vert, fig);
end;

function Union_figures(var figure1, figure2, union : figure; var num_vertex1, num_vertex2, num_points : int64) : boolean;//объединяет фигуры (figure1 и figure2) и кладёт объединение в union (если фигуры не пересекаются выдает false)
var counter, start, direction, num_vert1, num_vert2 : int64;
var intersections1, intersections2 : booleans;
var in_fig1 : boolean;
var fig1, fig2 : figure;
begin
    fig1 := figure1;
    fig2 := figure2;
    num_vert1 := num_vertex1;
    num_vert2 := num_vertex2;
    insert_intersections(fig1, fig2, num_vert1, num_vert2, intersections1, intersections2);
    //ОБЪЕДИНЕНИЕ
    direction := 1;//зададим направление вперёд, туда мы пойдём, если не окажемся в пересечении
    for var i := 1 to num_vert1 do
    begin
        if not in_or_out2(fig1[1][i], fig1[2][i], num_vert2, fig2) then
        begin
            counter := i;
            break;
        end;
    end;
    start := counter;
    for var i := 1 to num_vert1 + num_vert2 do//идём по пустому массиву объединения
    begin
        var index_in_fig1, index_in_fig2 : int64;//сопоставляем для одной и той же вершины её номер в одной фигуре и в другой фигуре, эти переменные для результата
        num_points := num_points + 1;
        //добавляем в объединение
        if in_fig1 then
        begin
            union[1][i] := fig1[1][counter];
            union[2][i] := fig1[2][counter];
        end
        else
        begin
            union[1][i] := fig2[1][counter];
            union[2][i] := fig2[2][counter];
        end;
        //если точка пересечение
        if (not ((not intersections1[i]) and in_fig1)) and (not ((not intersections2[i]) and (not in_fig1))) then
        begin
            //сопоставляем для одной и той же вершины её номер в одной фигуре и в другой фигуре
            index_in_fig1 := index(fig1, fig2[1][counter], fig2[2][counter], num_vert1);
            index_in_fig2 := index(fig2, fig1[1][counter], fig1[2][counter], num_vert2);
            //Println('    ', index_in_fig2);
            if in_fig1 then//если в 1-ой фигуре
            begin
                if index_in_fig2 <= 1 then//обходим эффект круга наоборот
                begin
                   //если есть путь по увеличению номера
                    if not segment_in_figure(fig1, num_vert1, counter, fig2[1][index_in_fig2 + 1], fig2[2][index_in_fig2 + 1]) then
                    begin
                        in_fig1 := false;//переходим в другую фигуру
                        counter := index_in_fig2;
                        direction := 1;
                    end
                    //если есть путь по уменьшению номера
                    else if not segment_in_figure(fig1, num_vert1, counter, fig2[1][num_vert2], fig2[2][num_vert2]) then
                    begin
                        in_fig1 := false;//переходим в другую фигуру
                        counter := index_in_fig2;
                        direction := -1;
                    end;
                end
                else
                begin
                    //если есть путь по увеличению номера
                    if not segment_in_figure(fig1, num_vert1, counter, fig2[1][index_in_fig2 + 1], fig2[2][index_in_fig2 + 1]) then
                    begin
                        in_fig1 := false;//переходим в другую фигуру
                        counter := index_in_fig2;
                        direction := 1;
                    end
                    //если есть путь по уменьшению номера
                    else if not segment_in_figure(fig1, num_vert1, counter, fig2[1][index_in_fig2 - 1], fig2[2][index_in_fig2 - 1]) then
                    begin
                        in_fig1 := false;//переходим в другую фигуру
                        counter := index_in_fig2;
                        direction := -1;
                    end;
                end;
            end
            else
            begin
                if index_in_fig1 <= 1 then
                begin
                    //если есть путь по увеличению номера
                    if not segment_in_figure(fig2, num_vert2, counter, fig1[1][index_in_fig1 + 1], fig1[2][index_in_fig1 + 1]) then
                    begin
                        in_fig1 := true;//переходим в другую фигуру
                        counter := index_in_fig1;
                        direction := 1;
                    end
                    //если есть путь по уменьшению номера
                    else if not segment_in_figure(fig1, num_vert1, counter, fig2[1][num_vert2], fig2[2][num_vert2]) then
                    begin
                        in_fig1 := true;//переходим в другую фигуру
                        counter := index_in_fig1;
                        direction := -1;
                    end;
                end
                else
                begin
                    //если есть путь по увеличению номера
                    if segment_in_figure(fig2, num_vert2, counter, fig1[1][index_in_fig1 + 1], fig1[2][index_in_fig1 + 1]) then
                    begin
                        in_fig1 := true;//переходим в другую фигуру
                        counter := index_in_fig1;
                        direction := 1;
                    end
                    //если есть путь по уменьшению номера
                    else if segment_in_figure(fig1, num_vert1, counter, fig2[1][index_in_fig1 - 1], fig2[2][index_in_fig1 - 1]) then
                    begin
                        in_fig1 := true;//переходим в другую фигуру
                        counter := index_in_fig1;
                        direction := -1;
                    end;
                end;
            end;
        end;
        Print(counter);
        counter := counter + direction;//двигаем счётчик
        if counter < 1 then//нейтрализуем эффект круга
        begin
            if in_fig1 then
                counter := num_vert1
            else
                counter := num_vert2;
        end;
        if ((counter > num_vert1) and in_fig1) or ((counter > num_vert2) and (not in_fig1)) then
            counter := 1;
        if (counter = start) and in_fig1 and (i <> 1) then//если мы пришли в начало, то завершаем обход
            break;
    end;
    num_points := num_points - delete_doubles(union, num_points);//удаляем повторы
    union[1][num_points + 1] := union[1][1];//замыкаем объединение
    union[2][num_points + 1] := union[2][1];
    for var i := 1 to num_points do//отрисовка
    begin
        SetBrushColor(clBlue);
        SetPenColor(clBlue);
        Line(Round(union[1][i]), Round(union[2][i]), Round(union[1][i + 1]), Round(union[2][i + 1]));
        //TextOut(Round(union[1][i]), Round(union[2][i]), i);
        //Println(union[1][i], union[2][i]);
        Circle(Round(union[1][i]), Round(union[2][i]), 5);
    end;
    //Print(num_points);
 end;

{ ************************  векторное пересечение   *******************************************} 
function vector_multiplicator(vek1_x, vek1_y, vek2_x, vek2_y: int64): int64;
begin
        Result := vek1_x * vek2_y - vek1_y * vek2_x;
end;

{ ************************  кликаем мышкой   *******************************************} 

procedure MouseDown(x, y, mb: integer);
begin
        var intln: boolean;
        TextOut(0, 0, s + 1);
        s += 1;
        {************************* рисуем охранников **********************************}
        if ((y_n >= 2) and (y_n <= 1 + kol)) then // y_n  - счетчик событий
        begin
                y_n += 1;
                circle(x, y, 3);
                floodfill(x, y, clred);
                Guards[1][l] := x;
                Guards[2][l] := y;
                //strp := IntToStr(x) + ',' + IntToStr(y);
                //                TextOut(x, y, strp);
                l += 1;
        end;
        {************************* рисуем галерею **********************************}
        if (y_n = 1) then
        begin
                if ((x - 10 <= Gallery[1][1]) and (x + 10 >= Gallery[1][1]) and (y - 10 <= Gallery[2][1]) and (y + 10 >= Gallery[2][1])) then
                begin
                        intln := false; 
                        for var i := 1 to f - 3 do
                        begin
                            if get_line_intersection(x, y, Gallery[1][f - 1], Gallery[2][f - 1], Gallery[1][i], Gallery[2][i], Gallery[1][i + 1], Gallery[2][i + 1]) then
                            begin
                                intln := true; 
                            end;
                        end;
                        if not intln then
                        begin
                            LineTo(Gallery[1][1], Gallery[2][1]);
                            Gallery[1][f] := Gallery[1][1];
                            Gallery[2][f] := Gallery[2][1];
                            Gallery[1][0] := Gallery[1][f - 1];
                            Gallery[2][0] := Gallery[2][f - 1];
                            y_n := 2;
                        end;
                end
                else 
                begin;
                        intln := false; 
                        for var i := 1 to f - 3 do
                        begin
                            if get_line_intersection(x, y, Gallery[1][f - 1], Gallery[2][f - 1], Gallery[1][i], Gallery[2][i], Gallery[1][i + 1], Gallery[2][i + 1]) then
                            begin
                                intln := true; 
                            end;
                        end;
                        if not intln then
                        begin;
                            LineTo(x, y);
                            Gallery[1][f] := x;
                            Gallery[2][f] := y; //strp := IntToStr(x) + ',' + IntToStr(y);
                        //                        TextOut(x, y+20, strp);
                            f += 1;
                       end
                end;
        end;
        {**************************** ставим первую точку галереи *****************************}
        if (y_n = 0) then
        begin
                MoveTo(x, y);
                y_n := 1;
                Gallery[1][1] := x;
                Gallery[2][1] := y;
                //strp := IntToStr(x) + ',' + IntToStr(y);
                //                TextOut(x, y+20, strp);
                f := 2;
                l := 1;
        end;
        
        {**************************** начинаем вычислять зону видимости охранников *****************************}
        if (y_n = 2 + kol) then
        begin
                var intersections_local{точки пересечения со стенками у одного луча}, intersections_zero: figure;
                var intersections_global{точки пересечения со стенками у всех лучей всех охранников}, sort_intersections_global: array[1..1000]of figure;
                var number_local: int64;
                var xp, yp: real;
                var number_global{ //массив длин элементов массива intersection global (для i-го охранника  - сколько раз все лучи, выходящие из него, пересекают любые стенки)}, sort_number_global: array[1..1000]of int64;
                //sum := 0;
                number_local := 1;
                s := 0;
                for var i := 1 to l - 1 do // идем по всем охранникам
                begin
                        number_global[i] := 1;  
                        sort_number_global[i] := 1;
                        for var k := 1 to f - 1 do   // идем по всем вершинам галереи
                        begin
                                for var j := 1 to f - 1 do // снова идем по всем вершинам галереи
                                begin
                                        // проверяем, пересекается ли луч,выпущенный из охранника в k вершину со стороной, соединяющей j-1 и j вершины галереи
                                        if (get_line_intersection(Gallery[1][j], Gallery[2][j], Gallery[1][j + 1], Gallery[2][j + 1], Guards[1][i], Guards[2][i], Guards[1][i] - ((Guards[1][i] - Gallery[1][k]) * 100000), Guards[2][i] - ((Guards[2][i] - Gallery[2][k]) * 100000)) = True) then
                                        begin
                                                var x_x, y_y: real;
                                                // находим точку пересечения этих отрезков
                                                intersection(Gallery[1][j], Gallery[2][j], Gallery[1][j + 1], Gallery[2][j + 1], Guards[1][i], Guards[2][i], Guards[1][i] - ((Guards[1][i] - Gallery[1][k]) * 100000), Guards[2][i] - ((Guards[2][i] - Gallery[2][k]) * 100000), x_x, y_y);
                                                //Print(x_x,y_y);
                                                // смотрим, не оказались ли эти отрезки параллельны
                                                if ((x_x / x_x) = 1) then
                                                begin
                                                        intersections_local[1][number_local] := x_x;
                                                        intersections_local[2][number_local] := y_y;
                                                        //                                                        Print(intersections_local[1][number_local],intersections_local[2][number_local]);
                                                        number_local += 1;
                                                        //                                                        SetBrushColor(clRandom);
                                                        //                                                        SetPenWidth(5);
                                                        //                                                        Line(Gallery[1][j], Gallery[2][j], Gallery[1][j + 1], Gallery[2][j + 1]);
                                                        //                                                        Line(Guards[1][i], Guards[2][i], Guards[1][i] - ((Guards[1][i] - Gallery[1][k]) * 10000), Guards[2][i] - ((Guards[2][i] - Gallery[2][k]) * 10000));
                                                        //                                                                                                                Println(get_line_intersection(Gallery[1][j], Gallery[2][j], Gallery[1][j + 1], Gallery[2][j + 1], Guards[1][i], Guards[2][i], Guards[1][i] - ((Guards[1][i] - Gallery[1][k]) * 10000), Guards[2][i] - ((Guards[2][i] - Gallery[2][k]) * 10000)), x_x, y_y, j, k);Print;[;lkpolklxolxd;leeeeeeeeeee
                                                end;
                                        end;
                                end;
                                
                                // после того как нашли все точки пересечения на луче к вершине f, сортируем их по дальности от нашего охранника
                                for var j := number_local - 2 downto 1 do
                                begin
                                        for var o := 1 to j do
                                        begin
                                                if (sqrt(((Guards[1][i] - intersections_local[1][o]) ** 2) + ((Guards[2][i] - intersections_local[2][o]) ** 2)) > sqrt(((Guards[1][i] - intersections_local[1][o + 1]) ** 2) + ((Guards[2][i] - intersections_local[2][o + 1]) ** 2))) then
                                                begin
                                                        xp := intersections_local[1][o];
                                                        yp := intersections_local[2][o];
                                                        intersections_local[1][o] := intersections_local[1][o + 1];
                                                        intersections_local[2][o] := intersections_local[2][o + 1];
                                                        intersections_local[1][o + 1] := xp;
                                                        intersections_local[2][o + 1] := yp;
                                                end;
                                        end;
                                end;
                                
                                // идем по массиву точек на луче к вершине f...
                                for var j := 1 to number_local - 1 do
                                begin
                                        s := 0;
                                        //... переписываем точку в массив intersections_global, отсеиваем точки после угла
                                        intersections_global[i][1][number_global[i]] := intersections_local[1][j];
                                        intersections_global[i][2][number_global[i]] := intersections_local[2][j];
                                        //                                        Print(intersections_global[i][1][number_global[i]],intersections_global[i][2][number_global[i]]);
                                        number_global[i] += 1;
                                        
                                        // проверяем, пересекается ли луч с какой-либо стеной или углом, после которого мы выходим на улицу.
                                        for var o := 1 to f - 1 do
                                        begin
                                                if ((intersections_local[1][j] = Gallery[1][o]) and (intersections_local[2][j] = Gallery[2][o])) then
                                                begin
                                                        s := 1;
                                                        if(get_line_intersection(Gallery[1][o - 1], Gallery[2][o - 1], Gallery[1][o + 1], Gallery[2][o + 1], Guards[1][i] + ((Guards[1][i] - Gallery[1][k]) * 10000), Guards[2][i] + ((Guards[2][i] - Gallery[2][k]) * 10000), Guards[1][i] - ((Guards[1][i] - Gallery[1][k]) * 10000), Guards[2][i] - ((Guards[2][i] - Gallery[2][k]) * 10000)) = True) then
                                                        begin
                                                                s := 0;
                                                        end;
                                                        break;
                                                end;
                                        end;
                                        if (s = 0) then
                                        begin
                                                break;
                                        end;
                                end;
                                number_local := 1;
                                intersections_local := intersections_zero;
                        end;
                end;
                
                {****************************************************************************************
                
                              сортируем получившийся массив точек пересечения со всеми стенками
                
                *****************************************************************************************}
                //print(gallery);
                for var i := 1 to l - 1 do // идем по всем охранникам
                begin
                        for var j := 1 to f - 1 do   // идем по всем вершинам
                        begin
                                for var k := 1 to number_global[i] - 1 do // идем по всем точкам пересечения луча со стенками и сортируем этот массив, т.е. на какой стороне галереи какая точка лежит
                                begin
                                        //                                      проверяем, лежит ли точка на стороне. Если попала на свою сторону, записываем ее в массив в другом порядке      
                                        if(line_and_pixel(intersections_global[i][1][k], intersections_global[i][2][k], Gallery[1][j], Gallery[1][j + 1], Gallery[2][j], Gallery[2][j + 1])) then
                                        begin
                                                intersections_local[1][number_local] := intersections_global[i][1][k];
                                                intersections_local[2][number_local] := intersections_global[i][2][k];
                                                number_local += 1;
                                                //                                                SetBrushColor(clBlue);
                                                //                                               // print('@');
                                                //                                                Circle(Round(intersections_global[i][1][k]), Round(intersections_global[i][2][k]), 5);
                                        end
                                end;
                                // сортируем  точки внутри стороны
                                SetPenWidth(3);
                                {var a: Color;
                                a := clRandom;
                                SetBrushColor(a);
                                SetPenColor(a);}
                                //Line(Gallery[1][j],Gallery[2][j],Gallery[1][j+1],Gallery[2][j+1]);
                                for var p := number_local - 2 downto 1 do
                                begin
                                        for var o := 1 to p do
                                        begin
                                                // смотрим расстояние от точки номер о до точки первой на этой стороне
                                                //http://www.mathnet.ru/links/72b3628394e9831482b986d65de2e283/rm5269.pdf
                                                if(((intersections_local[1][o] - Gallery[1][j]) ** 2 + (intersections_local[2][o] - Gallery[2][j]) ** 2) > ((intersections_local[1][o + 1] - Gallery[1][j]) ** 2 + (intersections_local[2][o + 1] - Gallery[2][j]) ** 2)) then
                                                begin
                                                        Swap(intersections_local[1][o], intersections_local[1][o + 1]);
                                                        Swap(intersections_local[2][o], intersections_local[2][o + 1]);
                                                end;
                                        end;
                                        //Circle(Round(intersections_local[1][p]),Round(intersections_local[2][p]),7);
                                        //TextOut(Round(intersections_local[1][p]),Round(intersections_local[2][p]),(intersections_local[1][p] - Gallery[1][j]) ** 2 + (intersections_local[2][p] - Gallery[2][j]) ** 2)
                                end;
                                        // переносим в трехмерный массив: охранник - xy - вершина в его поле зрения
                                for var p := 1 to number_local - 1 do
                                begin
                                        sort_intersections_global[i][1][sort_number_global[i]] := intersections_local[1][p];
                                        sort_intersections_global[i][2][sort_number_global[i]] := intersections_local[2][p];
                                        sort_number_global[i] += 1;
                                end;
                                sort_intersections_global[i][1][sort_number_global[i]] := sort_intersections_global[i][1][1];
                                sort_intersections_global[i][2][sort_number_global[i]] := sort_intersections_global[i][2][1];
                                //sort_number_global[i] += 1;
                                intersections_local := intersections_zero;
                                number_local := 1;
                        end;
                end;
                for var i := 1 to 67 do
                begin
                    a[i] := clRandom;
                end;
                //                for var i := 1 to l - 1 do // идем по охранникам
//                begin
//                        //                        SetBrushColor(a[i]);
//                        //                        SetPenColor(a[i]);
//                        //                        circle(Guards[1][i], Guards[2][i], 10);
//                        for var j := 1 to sort_number_global[i] - 1 do//идём по узлам охранников
//                        begin
//                                //Println(i, j, sort_intersections_global[i][1][j], sort_intersections_global[i][2][j]); // здесь лежат все точки,которые видят все охранники
//                                ///соединяем все узлы охранника
//                                if((Round(sort_intersections_global[i][1][j - zzzz]) = Round(sort_intersections_global[i][1][j + 1 - zzzz])) and (Round(sort_intersections_global[i][2][j - zzzz]) = Round(sort_intersections_global[i][2][j + 1 - zzzz])) and (Round(sort_intersections_global[i][2][j - zzzz])<>0)) then
//                                begin
//                                        println(i, j,sort_intersections_global[i][1][j],sort_intersections_global[i][2][j],zzzz);
//                                        zzzz += 1;
//                                        //удаляем совпадающие узлы
//                                       for var o := j to sort_number_global[i] - zzzz + 1 do
//                                        begin
//                                                //sort_intersections_global[i][1][o] := sort_intersections_global[i][1][o + 1];
//                                                //sort_intersections_global[i][2][o] := sort_intersections_global[i][2][o + 1];
//                                        end;
//                                end;
//                                //                                Line(Round(sort_intersections_global[i][1][j]), Round(sort_intersections_global[i][2][j]), Round(sort_intersections_global[i][1][j + 1]), Round(sort_intersections_global[i][2][j + 1]));
//                                //                                Circle(Round(sort_intersections_global[i][1][j]), Round(sort_intersections_global[i][2][j]), 5);
//                                //                                TextOut(Round(sort_intersections_global[i][1][j]), round(sort_intersections_global[i][2][j]), j);
//                        end;
//                        sort_number_global[i] -= zzzz;
//                        zzzz := 0;
//                        //Print(sort_intersections_global[1],sort_number_global);
//                end;
                for var g := 7 to 7 * l - 1 do//7 раз идём по охранникам
                begin
                     for var i := 1 to sort_number_global[g div 7] - 2 do//идём по вершинам заново
                     begin
                         //если 3 точки лежат на одной прямой, то отмечаем их для delete_bad
                         if segment_and_pixel(sort_intersections_global[g div 7][1][i + 1], sort_intersections_global[g div 7][2][i + 1], sort_intersections_global[g div 7][1][i], sort_intersections_global[g div 7][1][i + 2], sort_intersections_global[g div 7][2][i], sort_intersections_global[g div 7][2][i + 2]) then
                         begin
                             //SetBrushColor(clRed);
                             //Circle(Round(sort_intersections_global[g div 7][1][i + 1]), Round(sort_intersections_global[g div 7][2][i + 1]), 5);
                             sort_intersections_global[g div 7][1][i + 1] := -1;
                             sort_intersections_global[g div 7][2][i + 1] := -1;
                         end;    
                     end;
                     //обходим эффкт круга
                     if segment_and_pixel(sort_intersections_global[g div 7][1][sort_number_global[g div 7]], sort_intersections_global[g div 7][2][sort_number_global[g div 7]], sort_intersections_global[g div 7][1][sort_number_global[g div 7] - 1], sort_intersections_global[g div 7][1][1], sort_intersections_global[g div 7][2][sort_number_global[g div 7] - 1], sort_intersections_global[g div 7][2][1]) then
                     begin
                         //SetBrushColor(clRed);
                         //Circle(Round(sort_intersections_global[g div 7][1][sort_number_global[g div 7]]), Round(sort_intersections_global[g div 7][2][sort_number_global[g div 7]]), 5);
                         sort_intersections_global[g div 7][1][sort_number_global[g div 7]] := -1;
                         sort_intersections_global[g div 7][2][sort_number_global[g div 7]] := -1;
                     end;
                     //обходим эффкт круга
                     if segment_and_pixel(sort_intersections_global[g div 7][1][1], sort_intersections_global[g div 7][2][1], sort_intersections_global[g div 7][1][sort_number_global[g div 7]], sort_intersections_global[g div 7][1][2], sort_intersections_global[g div 7][2][sort_number_global[g div 7]], sort_intersections_global[g div 7][2][2]) then
                     begin
                         sort_intersections_global[g div 7][1][1] := -1;
                         sort_intersections_global[g div 7][2][1] := -1;
                     end;
                     sort_number_global[g div 7] := sort_number_global[g div 7] - delete_bad(sort_intersections_global[g div 7], sort_number_global[g div 7] + 1);//удаляем отмеченые нами ранее вершины
                end;
                for var g := 1 to l - 1 do
                    sort_number_global[g] := sort_number_global[g] - delete_doubles(sort_intersections_global[g], sort_number_global[g]);
                for var i := 1 to l - 1 do // идем по охранникам
                begin
                        SetBrushColor(ARGB(0,0,0,0));
                        TextOut(Guards[1][i]+3, Guards[2][i], i);
                        SetBrushColor(a[i]);
                        SetPenColor(a[i]);
                        circle(Guards[1][i], Guards[2][i], 10);
                        for var j := 1 to sort_number_global[i] - 1 do//идём по узлам охранников
                        begin
                                //Println(i, j, sort_intersections_global[i][1][j], sort_intersections_global[i][2][j]); // здесь лежат все точки,которые видят все охранники
                                //соединяем все узлы охранника
                                SetBrushColor(ARGB(0,0,0,0));
                                Line(Round(sort_intersections_global[i][1][j]), Round(sort_intersections_global[i][2][j]), Round(sort_intersections_global[i][1][j + 1]), Round(sort_intersections_global[i][2][j + 1]));
                                Circle(Round(sort_intersections_global[i][1][j]), Round(sort_intersections_global[i][2][j]), 5);
                                //TextOut(Round(sort_intersections_global[i][1][j])+3, round(sort_intersections_global[i][2][j]), j);
                                {Print(sort_intersections_global[i][1][j]);
                                Print(sort_intersections_global[i][2][j]);}
                        end;
                        Line(Round(sort_intersections_global[i][1][sort_number_global[i]]), Round(sort_intersections_global[i][2][sort_number_global[i]]), Round(sort_intersections_global[i][1][1]), Round(sort_intersections_global[i][2][1]));
                        Circle(Round(sort_intersections_global[i][1][sort_number_global[i]]), Round(sort_intersections_global[i][2][sort_number_global[i]]), 5);
                        //TextOut(Round(sort_intersections_global[i][1][sort_number_global[i]])+3, round(sort_intersections_global[i][2][sort_number_global[i]]), sort_number_global[i]);
                end;
                Union_figures(sort_intersections_global[1], sort_intersections_global[2], sort_intersections_global[1000], sort_number_global[1], sort_number_global[2], sort_number_global[1000])
                //Sleep(2500);
//                var xxx, yyy: real;
//                for var i := 1 to l - 1 do
//                begin
//                        for var j := i + 1 to l - 1 do
//                        begin
//                                for var k := 1 to sort_number_global[i] - 2 do
//                                begin
//                                        for var o := 1 to sort_number_global[j] - 2 do
//                                        begin
//                                                //Line(Round(sort_intersections_global[i][1][k]), Round(sort_intersections_global[i][2][k]), Round(sort_intersections_global[i][1][k + 1]), Round(sort_intersections_global[i][2][k + 1]));
//                                                //Print(j, i);
//                                                if((Round(sort_intersections_global[i][1][k]) <> Round(sort_intersections_global[i][1][k + 1])) and (Round(sort_intersections_global[i][2][k]) <> Round(sort_intersections_global[i][2][k + 1]))) then
//                                                begin
//                                                        if(get_line_intersection(Round(sort_intersections_global[i][1][k]), Round(sort_intersections_global[i][2][k]), Round(sort_intersections_global[i][1][k + 1]), Round(sort_intersections_global[i][2][k + 1]), Round(sort_intersections_global[j][1][o]), Round(sort_intersections_global[j][2][o]), Round(sort_intersections_global[j][1][o + 1]), Round(sort_intersections_global[j][2][o + 1]))) then
//                                                        begin
//                                                                intersection(Round(sort_intersections_global[i][1][k]), Round(sort_intersections_global[i][2][k]), Round(sort_intersections_global[i][1][k + 1]), Round(sort_intersections_global[i][2][k + 1]), Round(sort_intersections_global[j][1][o]), Round(sort_intersections_global[j][2][o]), Round(sort_intersections_global[j][1][o + 1]), Round(sort_intersections_global[j][2][o + 1]), xxx, yyy);
//                                                                SetBrushColor(clred);
//                                                                SetPenColor(clRed);
//                                                                if((xxx / xxx) = 1) then
//                                                                begin
//                                                                        //Print(xxx, yyy);
//                                                                        //Println(k, l, Round(sort_intersections_global[i][1][k]), Round(sort_intersections_global[i][2][k]), Round(sort_intersections_global[i][1][k + 1]), Round(sort_intersections_global[i][2][k + 1]), Round(sort_intersections_global[j][1][o]), Round(sort_intersections_global[j][2][o]), Round(sort_intersections_global[j][1][o + 1]), Round(sort_intersections_global[j][2][o + 1]))
//                                                                        //Line(Round(sort_intersections_global[i][1][k]), Round(sort_intersections_global[i][2][k]), Round(sort_intersections_global[i][1][k + 1]), Round(sort_intersections_global[i][2][k + 1]));
//                                                                        Circle(Round(xxx), Round(yyy), 5);
//                                                                end
//                                                                else
//                                                                begin
//                                                                        SetBrushColor(clGreen);
//                                                                        SetPenColor(clGreen);
//                                                                        if(((sort_intersections_global[i][1][k] - sort_intersections_global[j][1][o + 1]) ** 2 + (sort_intersections_global[i][2][k] - sort_intersections_global[j][2][o + 1]) ** 2) > ((sort_intersections_global[i][1][k + 1] - sort_intersections_global[j][1][o]) ** 2 + (sort_intersections_global[i][2][k + 1] - sort_intersections_global[j][2][o]) ** 2)) then
//                                                                        begin
//                                                                                Circle(Round(sort_intersections_global[i][1][k + 1]), Round(sort_intersections_global[i][2][k + 1]), 5);
//                                                                                Circle(Round(sort_intersections_global[i][1][o]), Round(sort_intersections_global[i][2][o]), 5);
//                                                                                Circle(Round(sort_intersections_global[i][1][k]), Round(sort_intersections_global[i][2][k]), 5);
//                                                                                Circle(Round(sort_intersections_global[i][1][o + 1]), Round(sort_intersections_global[i][2][o + 1]), 5);
//                                                                        end
//                                                                        else
//                                                                        begin
//                                                                                Circle(Round(sort_intersections_global[i][1][k]), Round(sort_intersections_global[i][2][k]), 5);
//                                                                                Circle(Round(sort_intersections_global[i][1][o + 1]), Round(sort_intersections_global[i][2][o + 1]), 5);
//                                                                                Circle(Round(sort_intersections_global[i][1][k + 1]), Round(sort_intersections_global[i][2][k + 1]), 5);
//                                                                                Circle(Round(sort_intersections_global[i][1][o]), Round(sort_intersections_global[i][2][o]), 5);
//                                                                        end;
//                                                                        //                                                                        SetBrushColor(a[i]);
//                                                                        //                                                                        SetPenColor(a[i]);
//                                                                        //                                                                        Print(k);
//                                                                        //                                                                        SetBrushColor(a[j]);
//                                                                        //                                                                        SetPenColor(a[j]);
//                                                                        //                                                                        Println(o);
//                                                                        //                                                                        a[3] := clRandom;
//                                                                        //                                                                        SetBrushColor(a[3]);
//                                                                        //                                                                        SetPenColor(a[3]);
//                                                                        //                                                                        Circle(Round(sort_intersections_global[i][1][k]), Round(sort_intersections_global[i][2][k]), 5);
//                                                                        //                                                                        Circle(Round(sort_intersections_global[i][1][o+1]), Round(sort_intersections_global[i][2][o+1]), 5);
//                                                                        //                                                                        Circle(Round(sort_intersections_global[i][1][k+1]), Round(sort_intersections_global[i][2][k+1]), 5);
//                                                                        //                                                                        Circle(Round(sort_intersections_global[i][1][o]), Round(sort_intersections_global[i][2][o]), 5);
//                                                                end;
//                                                        end;
//                                                end;
//                                        end;
//                                end;
//                        end;
//                end;
                //                SetBrushColor(clGreen);
                //                for var i := 1 to number_global - 2 do 
                //                begin
                //                        sum += vector_multiplicator(intersections_global[1][i], intersections_global[2][i], intersections_global[1][i + 1], intersections_global[2][i + 1]);
                //                        Circle(intersections_global[1][i], intersections_global[2][i], 5);
                //                        TextOut(intersections_global[1][i], intersections_global[2][i], i)
                //                end;
                //                sum += vector_multiplicator(intersections_global[1][number_global - 1], intersections_global[2][number_global - 1], intersections_global[1][1], intersections_global[2][1]);
                //                Circle(intersections_global[1][number_global - 1], intersections_global[2][number_global - 1], 5);
                //                sum := sum div 2;
                //                sum := Round(Sqrt(sum ** 2));
                //                Print(sum);
        {var Gallery2 : figure;
        for var i := 1 to f - 1 do
        begin
            Gallery2[1][i] := Gallery[1][i];
            Gallery2[2][i] := Gallery[2][i];
        end;
        Gallery2[1][f] := Gallery2[1][1];
        Gallery2[2][f] := Gallery2[2][1];
        SetPenColor(clBlue);
        SetPenWidth(5); 
        Line(x, y, Gallery[1][3], Gallery[2][3]);
        Print(segment_in_figure(Gallery2, f, 3, x, y));}
    end;
end;

begin
    
                {var a1, a2, a3, a4, a5, a6, a7, a8: int64;
                var x, y: real;
                        a1 := Random(1, 800);
                        a2 := Random(1, 800);
                        a3 := Random(1, 800);
                        a4 := Random(1, 800);
                        a5 := Random(1, 800);
                        a6 := Random(1, 800);
                        a7 := Random(1, 800);
                        a8 := Random(1, 800);
                        Line(5, 7 , 50, 300);
                        Line(1, 9, 100, 200);
                        intersection(0, 0, 1, 1, 1, 1, 2, 2, x, y);
                        Print(x,y);
                        Circle(Round(x),Round(y),5);
                        Print(x,y);
                        intersection(1, 1, 5, 5, 0, 0, 10, 10, x, y);
                        Print(x,y);
                        Circle(Round(x), Round(y), 10);
                                                Print(x,y,x/x);
                                                if ((x/x)<>1)then Print(1);
                        Circle(Round(x), Round(y),5);
                        Print(get_line_intersection(Round(x), Round(y), Round(x),Round(y), 1, 9, 100, 200));}
        Read(kol); // читаем количество охранников
        OnMouseDown := MouseDown; // запускаем основную процедуру
        MaximizeWindow();
        //  print(WindowHeight,WindowWidth);
end.