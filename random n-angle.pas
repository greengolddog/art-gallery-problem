uses GraphABC;
type figure = array [1.. 10000, 1.. 2] of int64;
function get_line_intersection(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y: int64): boolean;//пересекаются ли два отрезка
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
function S_figure(room : figure; lines : int64) : int64;
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
procedure insert(num_insert, len_place : int64; var place_insert : figure);//вставляет последний элемент массива в позицию А
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
function points_dist(x1, y1, x2, y2 : int64) : int64;//расстояние между двумя точками
begin 
    result := Round(Sqrt(Sqr(Abs(x1 - x2)) + Sqr(Abs(y1 - y2))));
end;
{function S_triangle(a, b, c : int64) : real;//площадь треугольника с длинами строн А В и С
var p : int64;//полупериметр
begin 
    p := (a + b + c) div 2;
    result := Sqrt(p * (p - a) * (p - b) * (p - c));
end;}
function linepoint_dist(xp, yp, line_x1, line_y1, line_x2, line_y2 : int64) : int64;//расстояние от линии до точки
begin 
    //result := Round((S_triangle(points_dist(xp, yp, line_x1, line_y1), points_dist(xp, yp, line_x2, line_y2), points_dist(line_x1, line_y1, line_x2, line_y2)) * 2) / points_dist(line_x1, line_y1, line_x2, line_y2));
    //Print(Abs((line_y2 - line_y1) * xp - (line_x2 - line_x1) * yp + line_x2 * line_y1 - line_y2 * line_x1), points_dist(line_x1, line_y1, line_x2, line_y2));
    result := Round(Abs((line_y2 - line_y1) * xp - (line_x2 - line_x1) * yp + line_x2 * line_y1 - line_y2 * line_x1) / points_dist(line_x1, line_y1, line_x2, line_y2));
end;
{function anglemore5(Ax, Ay, Bx, By, Cx, Cy : int64) : boolean;//правда ли что угол АВС больше 5 гр.
begin
    if points_dist(Ax, Ay, Bx, By) > points_dist(Cx, Cy, Bx, By) then 
    begin
        result := (points_dist(Ax, Ay, Cx, Cy) / linepoint_dist(Cx, Cy, Ax, Ay, Bx, By) < 10.5);
    end
    else 
    begin
        result := (points_dist(Ax, Ay, Bx, By) / linepoint_dist(Bx, By, Ax, Ay, Cx, Cy) < 10.5);
    end;
end;}
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
end;
procedure put_figure(room : figure; elements, num_file : int64);//кладёт массив в файл под указанным номером
var figurefile : Text;
begin 
    Assign(figurefile, 'random' + IntToStr(elements) + '_' + IntToStr(num_file));
    Rewrite(figurefile);
    for var el := 1 to elements do
        Writeln(figurefile, room[el]);
    Close(figurefile);
end;
procedure draw_figure(room : figure; n : int64);//рисует фигуру по массиву, используя первые n элементов и нумерует вершины
begin 
    for var i := 1 to n - 1 do
    begin
        Line(room[i][1], room[i][2], room[i + 1][1], room[i + 1][2]);
        Textout(room[i][1], room[i][2], i);
    end;
    Line(room[n][1], room[n][2], room[1][1], room[1][2]);
    Textout(room[n][1], room[n][2], n);
end;
procedure correct_figure(var room : figure; n : int64);//изменяет вершины, в начале введите № вершины, затем её новые координаты, после каждого изменение отрисовка
var num : int64;
begin 
  num := 1;
  while true do
  begin
      SetBrushColor(ARGB(255, 255, 255, 255));
      Rectangle(0, 0, 1280, 640);
      SetBrushColor(ARGB(0, 0, 0, 0));
      draw_figure(room, n);
      Read(num);
      if num = 0 then 
          break
      else
      begin
          TextOut(0, 0, room[num][1]);
          TextOut(0, 30, room[num][2]);
          Read(room[num][1], room[num][2]);
      end;
  end;
end;
procedure n_angle(n, filenum : int64; var put : figure);//рисует рандомный n-угольник и сохраняет его координаты вершин в файл и массив
var stop, notfar : boolean;
var prom : figure;
begin 
    for var point := 1 to n do
    begin
        stop := false; 
        repeat
            notfar := false;
            put[point][1] := Random(1, 1280);
            put[point][2] := Random(1, 630);
            //проверяем, правда ли, что вершина отстоит от всех сторон хотя бы на 10 пикселей (10 можно менять)
            for var i := 1 to point - 2 do 
            begin
                if linepoint_dist(put[point][1], put[point][2], put[i][1], put[i][2], put[i + 1][1], put[i + 1][2]) < 10 then
                    notfar := true;
            end;
            if (point > 2) and (linepoint_dist(put[point][1], put[point][2], put[point - 1][1], put[point - 1][2], put[1][1], put[1][2]) < 10) then
                notfar := true;
        until not notfar;
        //put[point + 1][1] := put[1][1];
        //put[point + 1][2] := put[1][2];
        for var sideA := 1 to point - 1 do
        begin
            prom := put;
            insert(sideA + 1, point, prom);
            if not (get_n_angle_intersection(prom, point) or stop) then
            begin
                put := prom;
                stop := true;
            end;
        end;
    end;
    correct_figure(put, n);
    put_figure(put, n, filenum);
end;
var room : figure;
begin 
    //Print(linepoint_dist(51, 57, 100, 100, 0, 0));
    SetBrushColor(ARGB(0, 0, 0, 0));
    n_angle(100, 0, room);
    //Print(room);
end.