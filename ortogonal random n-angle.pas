uses GraphABC;
const max_bottom = 620;//правый край листа
const max_right = 1250;//нижний край листа
const min_wall = 7;//наименьшая длинна стен
type pnt = array [1.. 2] of int64;//точка
type rectype = array [1.. 4] of int64;//прямоугольник
type figure = array [1.. 10000] of pnt;//многоугольник (не более 10000 углов)
function S_figure(room : figure; lines : int64) : int64;//вычисляет площаль фигуры, ПРОВЕРЕНО, не используется
var counter1, counter2 : int64;
begin
    for var i := 1 to lines - 1 do
        counter1 := counter1 + room[i][1] * room[i + 1][2];
    counter1 := counter1 + room[lines][1] * room[1][2];
    for var i := 1 to lines - 1 do
        counter2 := counter2 + room[i][2] * room[i + 1][1];
    counter2 := counter2 + room[lines][2] * room[1][1];
    result := Abs(counter1 - counter2) div 2;
end;
procedure insert(num_insert, len_place : int64; var place_insert : figure);//вставляет последний элемент массива в позицию А, ПРОВЕРЕНО
var prom : int64;
begin 
    prom := place_insert[num_insert][1];
    place_insert[num_insert][1] := place_insert[len_place][1];
    for var pointup := num_insert + 1 to len_place - 1 do
    begin
        place_insert[num_insert + len_place - pointup + 1][1] := place_insert[num_insert + len_place - pointup][1];
    end;
    place_insert[num_insert + 1][1] := prom; 
    prom := place_insert[num_insert][2];
    place_insert[num_insert][2] := place_insert[len_place][2];
    for var pointup := num_insert + 1 to len_place - 1 do
    begin
        place_insert[num_insert + len_place - pointup + 1][2] := place_insert[num_insert + len_place - pointup][2];
    end;
    place_insert[num_insert + 1][2] := prom;
end;
//даётся массив и точка в нём, ответ : самая удалённая точка от стороны начинающейся в данной точке (по увеличению)
function most_closest_up(n, num : int64; room : figure) : int64;
var max_now : int64;//ближайшая точка сейчас
begin
    if num = n then//проверяем является ли элемент последним
    begin
        if room[n][1] = room[1][1] then//проверяем проходит ли строна по Х
        begin
            max_now := max_right;//задаём самое отдалённое значение из возможных
            for var i := 1 to n do//для каждой точки...
            begin
                if room[i][1] > room[n][1] then//...проверяем лежит ли она правее
                    max_now := Min(max_now, room[i][1]);//и если да, то назначаем ближайшее число минимуму между страым и новым
            end;
        end
        else
        begin
            max_now := max_bottom;//задаём самое отдалённое значение из возможных
            for var i := 1 to n do//для каждой точки...
            begin
                if room[i][2] > room[n][2] then//...проверяем лежит ли она ниже
                    max_now := Min(max_now, room[i][2]);//и если да, то назначаем ближайшее число минимуму между страым и новым
            end;
        end;
    end
    else
    begin
        if room[num][1] = room[num + 1][1] then//проверяем проходит ли строна по Х
        begin
            max_now := max_right;//задаём самое отдалённое значение из возможных
            for var i := 1 to n do//для каждой точки...
            begin
                if room[i][1] > room[num][1] then//...проверяем лежит ли она правее
                    max_now := Min(max_now, room[i][1]);//и если да, то назначаем ближайшее число минимуму между страым и новым
            end;
        end
        else
        begin
            max_now := max_bottom;//задаём самое отдалённое значение из возможных
            for var i := 1 to n do//для каждой точки...
            begin
                if room[i][2] > room[num][2] then//...проверяем лежит ли она ниже
                    max_now := Min(max_now, room[i][2]);//и если да, то назначаем ближайшее число минимуму между страым и новым
            end;
        end;
    end;
    result := max_now;
end;
//даётся массив и точка в нём, ответ : самая удалённая точка от стороны начинающейся в данной точке (по уменьшению) это тоже самое но вместо право -- лево, вместо низ -- верх, вместо минимума -- максмум
function most_closest_down(n, num : int64; room : figure) : int64;
var max_now : int64;
begin
    if num = n then
    begin
        if room[n][1] = room[1][1] then
        begin
            max_now := 1;
            for var i := 1 to n do
            begin
                if room[i][1] < room[n][1] then
                    max_now := Max(max_now, room[i][1]);
            end;
        end
        else
        begin
            max_now := 1;
            for var i := 1 to n do
            begin
                if room[i][2] < room[n][2] then
                    max_now := Max(max_now, room[i][2]);
            end;
        end;
    end
    else
    begin
        if room[num][1] = room[num + 1][1] then
        begin
            max_now := 1;
            for var i := 1 to n do
            begin
                if room[i][1] < room[num][1] then
                    max_now := Max(max_now, room[i][1]);
            end;
        end
        else
        begin
            max_now := 1;
            for var i := 1 to n do
            begin
                if room[i][2] < room[num][2] then
                    max_now := Max(max_now, room[i][2]);
            end;
        end;
    end;
    result := max_now;
end;
procedure random_point_in_rectangle(rectang : rectype; var point : pnt);//кладёт в point рандомную точку из заданого прямоугольника
begin
    if abs(rectang[1] - rectang[3]) > min_wall * 2 then//если сторона достаточно длинная, чтобы сближение ничего не испортило...
    begin
        if rectang[1] > rectang[3] then//смотрим в какую сторону надо сближать
            point[1] := Random(rectang[1] - min_wall, rectang[3] + min_wall)//мы сближаем
        else
            point[1] := Random(rectang[1] + min_wall, rectang[3] - min_wall);//мы сближаем
    end
    else//ну иначе делаем не сближая
        point[1] := Random(rectang[1], rectang[3]);
    //теперь тоже для У
    if abs(rectang[2] - rectang[4]) > min_wall * 2 then
    begin
        if rectang[2] > rectang[4] then
            point[2] := Random(rectang[2] - min_wall, rectang[4] + min_wall)
        else
            point[2] := Random(rectang[2] + min_wall, rectang[4] - min_wall);
    end
    else
        point[2] := Random(rectang[2], rectang[4]);
end;
function point_in_rectangle(point : pnt; rect : rectype) : boolean;//выдаёт true если точка внутри прямоугольника ПРОВЕРЕНО
begin
    Result := (((rect[1] > point[1]) and (point[1] > rect[3])) or ((rect[1] < point[1]) and (point[1] < rect[3]))) and (((rect[2] > point[2]) and (point[2] > rect[4])) or ((rect[2] < point[2]) and (point[2] < rect[4]))); 
end;
procedure put_figure(room : figure; elements, num_file : int64);//кладёт массив в файл под указанным номером ПРОВЕРЕНО
var figurefile : Text;
begin 
    Assign(figurefile, 'randomORT' + IntToStr(elements) + '_' + IntToStr(num_file));
    Rewrite(figurefile);
    for var el := 1 to elements do
        Writeln(figurefile, room[el]);
    Close(figurefile);
end;
procedure draw_figure(room : figure; n : int64);//рисует фигуру по массиву, используя первые n элементов ПРОВЕРЕНО
begin 
    SetPenColor(ARGB(0, 0, 0, 0));
    Rectangle(1, 1, max_right + 20, max_bottom + 30); 
    SetPenColor(ARGB(255, 0, 0, 0));
    for var i := 1 to n - 1 do
    begin
        Line(room[i][1], room[i][2], room[i + 1][1], room[i + 1][2]);
        //Textout(room[i][1], room[i][2], i);
    end;
    Line(room[n][1], room[n][2], room[1][1], room[1][2]);
    //Textout(room[n][1], room[n][2], n);
end;
{function get_line_intersection(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y: int64): boolean;//пересекаются ли два отрезка
begin
        var cat1_x, cat2_x, cat1_y, cat2_y, prod1, prod2: int64;
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
function get_n_angle_intersection(room : figure; n : int64) : boolean;//является ли n-угольник самопересекающимся
var intln : boolean;
begin
    intln := false; 
    for var side1 := 1 to n - 1 do
    begin
        for var side2 := 1 to n - 1 do
        begin
            if (abs(side1 - side2) > 1) and get_line_intersection(room[side1][1], room[side1][2], room[side1 + 1][1], room[side1 + 1][2], room[side2][1], room[side2][2], room[side2 + 1][1], room[side2 + 1][2]) then
                intln := true;
        end;
    end;
    for var side := 2 to n - 2 do
    begin
        if get_line_intersection(room[side][1], room[side][2], room[side + 1][1], room[side + 1][2], room[n][1], room[n][2], room[1][1], room[1][2]) then 
            intln := true;
    end;
    result := intln;
end;}
procedure move_segment(n, num : int64; var room : figure);//двигает отрезок, не нарушая уголов
var new_position : int64;
begin
    new_position := Random(most_closest_down(n, num, room) + min_wall, most_closest_up(n, num, room) - min_wall);//выбираем новые координаты для отрезка
    if num = n then
    begin
        if room[n][1] = room[1][1] then
        begin
            room[n][1] := new_position;
            room[1][1] := new_position;
        end
        else
        begin
            room[n][2] := new_position;
            room[1][2] := new_position;
        end;
    end
    else
    begin
        if room[num][1] = room[num + 1][1] then
        begin
            room[num][1] := new_position;
            room[num + 1][1] := new_position;
        end
        else
        begin
            room[num][2] := new_position;
            room[num + 1][2] := new_position;
        end;
    end;
end;
function points_dist(p1, p2 : pnt) : int64;//расстояние между двумя точками
begin 
    result := Round(Sqrt(Sqr(Abs(p1[1] - p2[1])) + Sqr(Abs(p1[2] - p2[2]))));
end;
procedure ortogonal_plus2(n : int64; var put : figure);//дoбавляет рандомно ортогональному (n - 2)-угольнику 2 вершины
var random_point, counter : int64;
var new_p : pnt;
var rectang1, rectang2 : rectype;
begin
    counter := 0;
    random_point := Random(1, n - 2);
    repeat
        if random_point = 1 then
        begin
            if not((points_dist(put[random_point], put[random_point + 1]) < min_wall* 2) or (points_dist(put[random_point], put[n - 2]) < min_wall * 2)) then
                break;
        end
        else if random_point = n - 2 then
        begin
            if not ((points_dist(put[random_point], put[1]) < min_wall * 2) or (points_dist(put[random_point], put[random_point - 1]) < min_wall * 2)) then
                break;
        end
        else
        begin
            if not ((points_dist(put[random_point], put[random_point + 1]) < min_wall * 2) or (points_dist(put[random_point], put[random_point - 1]) < min_wall * 2)) then
                break;
        end;
        if random_point < n - 2 then
            random_point := random_point + 1
        else 
            random_point := 1;
        counter := counter + 1;
        if counter > n - 3 then
             break;
    until false;
    //Print(random_point);
    if random_point = 1 then
    begin  
        rectang1[1] := put[n - 2][1];
        rectang1[2] := put[n - 2][2];
        rectang1[3] := put[2][1];
        rectang1[4] := put[2][2];
    end
    else if random_point = n - 2 then 
    begin 
        rectang1[1] := put[n - 3][1];
        rectang1[2] := put[n - 3][2];
        rectang1[3] := put[1][1];
        rectang1[4] := put[1][2];
    end
    else
    begin  
        rectang1[1] := put[random_point - 1][1];
        rectang1[2] := put[random_point - 1][2];  
        rectang1[3] := put[random_point + 1][1];
        rectang1[4] := put[random_point + 1][2];
    end;
    //repeat
    random_point_in_rectangle(rectang1, new_p);
    for var i := 1 to n - 2 do
    begin
        rectang2[1] := put[random_point][1];
        rectang2[2] := put[random_point][2];
        rectang2[3] := new_p[1];
        rectang2[4] := new_p[2];
        if point_in_rectangle(put[i], rectang2) then
        begin
            rectang2[3] := put[i][1];
            rectang2[4] := put[i][2];
            random_point_in_rectangle(rectang2, new_p);
        end;
    end;
    //until not not_int;
    if rectang1[1] = put[random_point][1] then
        put[random_point][2] := new_p[2]
    else
        put[random_point][1] := new_p[1];
    put[n - 1] := new_p;
    insert(random_point + 1, n - 1, put);
    if rectang1[1] = put[random_point][1] then
    begin
        put[n][1] := new_p[1];
        put[n][2] := rectang1[4];
    end
    else
    begin
        put[n][2] := new_p[2];
        put[n][1] := rectang1[3];
    end;
    insert(random_point + 2, n, put);
end;
procedure ortogonal_plus4(n : int64 ;var put : figure);//дбавляет рандомно ортогональному (n - 4)-угольнику 4 вершины
var random_side, new_p2, new_p1, counter : int64;
begin
    random_side := Random(1, n - 4);
    counter := 0;
    repeat
        if random_side = n - 4 then
        begin
            if put[random_side][1] = put[1][1] then
            begin 
                if (points_dist(put[random_side], put[1]) > min_wall * 3) and ((put[random_side][1] - most_closest_down(n - 4, random_side, put) > min_wall * 2) or (Abs(put[random_side][1] - most_closest_up(n - 4, random_side, put)) > min_wall * 2)) then
                    break;
            end
            else
            begin 
                if (points_dist(put[random_side], put[1]) > min_wall * 3) and ((put[random_side][2] - most_closest_down(n - 4, random_side, put) > min_wall * 2) or (Abs(put[random_side][2] - most_closest_up(n - 4, random_side, put)) > min_wall * 2)) then
                    break;
            end;
        end
        else
        begin
            if put[random_side][1] = put[1][1] then
            begin 
                if (points_dist(put[random_side], put[random_side + 1]) > min_wall * 3) and ((put[random_side][1] - most_closest_down(n - 4, random_side, put) > min_wall * 2) or (Abs(put[random_side][1] - most_closest_up(n - 4, random_side, put)) > min_wall * 2)) then
                    break;
            end
            else
            begin 
                if (points_dist(put[random_side], put[random_side + 1]) > min_wall * 3) and ((put[random_side][2] - most_closest_down(n - 4, random_side, put) > min_wall * 2) or (Abs(put[random_side][2] - most_closest_up(n - 4, random_side, put)) > min_wall * 2)) then
                    break;
            end;
        end;
        counter := counter + 1;
        if random_side < n - 4 then
            random_side := random_side + 1
        else 
            random_side := 1;
        if counter > n - 5 then
            break;
    until false;
    new_p1 := Random(1, 299);
    new_p2 := Random(1, 299);
    if random_side = n - 4 then
    begin
        if new_p1 > new_p2 then
        begin
            put[n - 3][1] := (put[n - 4][1] * new_p1 + put[1][1] * (300 - new_p1)) div 300;
            put[n - 3][2] := (put[n - 4][2] * new_p1 + put[1][2] * (300 - new_p1)) div 300;
            put[n - 1][1] := (put[n - 4][1] * new_p2 + put[1][1] * (300 - new_p2)) div 300;
            put[n - 1][2] := (put[n - 4][2] * new_p2 + put[1][2] * (300 - new_p2)) div 300;
        end
        else
        begin
            put[n - 1][1] := (put[n - 4][1] * new_p1 + put[1][1] * (300 - new_p1)) div 300;
            put[n - 1][2] := (put[n - 4][2] * new_p1 + put[1][2] * (300 - new_p1)) div 300;
            put[n - 3][1] := (put[n - 4][1] * new_p2 + put[1][1] * (300 - new_p2)) div 300;
            put[n - 3][2] := (put[n - 4][2] * new_p2 + put[1][2] * (300 - new_p2)) div 300;
        end;
    end
    else
    begin
        if new_p1 > new_p2 then
        begin
            put[n - 3][1] := (put[random_side][1] * new_p1 + put[random_side + 1][1] * (300 - new_p1)) div 300;
            put[n - 3][2] := (put[random_side][2] * new_p1 + put[random_side + 1][2] * (300 - new_p1)) div 300;
            put[n - 1][1] := (put[random_side][1] * new_p2 + put[random_side + 1][1] * (300 - new_p2)) div 300;
            put[n - 1][2] := (put[random_side][2] * new_p2 + put[random_side + 1][2] * (300 - new_p2)) div 300;
        end
        else
        begin
            put[n - 1][1] := (put[random_side][1] * new_p1 + put[random_side + 1][1] * (300 - new_p1)) div 300;
            put[n - 1][2] := (put[random_side][2] * new_p1 + put[random_side + 1][2] * (300 - new_p1)) div 300;
            put[n - 3][1] := (put[random_side][1] * new_p2 + put[random_side + 1][1] * (300 - new_p2)) div 300;
            put[n - 3][2] := (put[random_side][2] * new_p2 + put[random_side + 1][2] * (300 - new_p2)) div 300;
        end;
    end;
    put[n] := put[n - 1];
    put[n - 2] := put[n - 3];
    insert(random_side + 1, n - 3, put);
    insert(random_side + 2, n - 2, put);
    insert(random_side + 3, n - 1, put);
    insert(random_side + 4, n, put);
    move_segment(n, random_side + 2, put);
    move_segment(n, random_side, put);
end;
function ortogonal(n : int64; room : figure) : boolean;
begin 
    result := true;
    for var i := 1 to n - 1 do
    begin
        if (room[i][1] <> room[i + 1][1]) and (room[i][2] <> room[i + 1][2]) then
        begin
            result := false;
            break;
        end;
    end;
    if (room[n][1] <> room[1][1]) and (room[n][2] <> room[1][2]) then
    begin
        result := false;
    end;
end;
procedure ortogonal_n_angle(n, filenum : int64; var figures : int64; var put : figure);//рисует рандомный ортогональный n-угольник ! n чётное, иначе не будет работать
var sides : int64;
begin
    put[1][1] := 1;
    put[1][2] := 1;
    put[2][1] := 1;
    put[2][2] := max_bottom;
    put[3][1] := max_right;
    put[3][2] := max_bottom;
    put[4][1] := max_right;
    put[4][2] := 1;
    sides := 4;
    while true do
    begin
        if sides = n - 2 then 
        begin
            ortogonal_plus2(n, put);
            break;
        end;
        if sides = n then
            break;
        if Random(1, 4) < 2.5 then
        begin 
            ortogonal_plus2(sides + 2, put);
            sides := sides + 2;
        end
        else
        begin 
            ortogonal_plus4(sides + 4, put);
            sides := sides + 4;
        end;
    end;
    if ortogonal(n, put) then
    begin
        draw_figure(put, n);
        put_figure(put, n, filenum);
        figures := figures + 1;
    end;
end;
procedure generate_ortogonal(n, figures, sleeptime : int64; var put : figure);
var figures_now : int64;
begin 
    while true do
    begin
        ortogonal_n_angle(n, figures_now + 1, figures_now, put);
        Sleep(sleeptime);
        if figures_now = figures then
            break;
    end;
end;
var room : figure;
begin
    generate_ortogonal(200, 40, 3000, room);
end.