uses GraphABC;

type
        ar = array [1..1000] of int64;
        ara = array [1..6] of real;
        aray = array [1..1000] of array [1..2] of int64;
        animal_array = array [1..6] of aray;

var
        y_n, num_of_walls, areas,assssssss: int64;

var
        i: array[1..2]of array[1..10000]of int64;

function get_line_intersection(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y: int64): boolean;
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

function in_or_out(x_guard, y_guard: int64): boolean;
begin
        var counter: int64;
        counter := 0;
        //        Print(num_of_walls);
        //        Line(0,0,x_guard,y_guard,clRed);
        //        SetPenWidth(3);
        for var lines := 1 to num_of_walls - 2 do
        begin
                if get_line_intersection(i[1][lines], i[2][lines], i[1][lines + 1], i[2][lines + 1], x_guard, y_guard, 0, 0) then
                begin
                        counter := counter + 1;
                end;
                //                Line(k[1][lines],k[2][lines],k[1][lines + 1], k[2][lines + 1],clRed);
                //                Print(counter,k[1][lines], k[2][lines], k[1][lines + 1], k[2][lines + 1]);
        end;
        if get_line_intersection(i[1][num_of_walls - 1], i[2][num_of_walls - 1], i[1][1], i[2][1], x_guard, y_guard, 0, 0) then
        begin
                counter := counter + 1;
        end;
        //        Print(counter);
        if counter mod 2 = 0 then
                result := false
        else
                result := true;
end;

function area(): int64;
begin
        var counter: int64;
        for var y := 1 to WindowHeight - 1 do
        begin
                for var x := 1 to WindowWidth - 1 do
                begin
                        if in_or_out(x, y) then
                        begin
                                counter := counter + 1;
                        end;
                end;
        end;
        result := counter;
end;

procedure array2random(var to_random: animal_array; var d: ar);
begin
        var r: int64;
        for var x := 1 to 6 do
        begin
                r := Random(1, Ceil(num_of_walls / 3));
                for var y := 1 to r do
                begin
                        //                        Print(in_or_out());
                        to_random[x][y][1] := Random(1, WindowWidth - 1);
                        to_random[x][y][2] := Random(1, WindowHeight - 1);
                        //Print(to_random[x][y][1],to_random[x][y][2]);
                        //SetBrushColor(clWhite);
                        //Circle(to_random[x][y][1],to_random[x][y][2],3);
                        while(not in_or_out(to_random[x][y][1], to_random[x][y][2])) do
                        begin
                                to_random[x][y][1] := Random(1, WindowWidth - 1);
                                to_random[x][y][2] := Random(1, WindowHeight - 1);
                                //Print(to_random[x][y][1],to_random[x][y][2]);
                                //SetBrushColor(clWhite);
                                //Circle(to_random[x][y][1],to_random[x][y][2],3);
                        end;
                        d[x] := r;
                        //SetBrushColor(clRed);
                        //Circle(to_random[x][y][1],to_random[x][y][2],3);
                end;
        end;
end;

procedure mutation(var animal: aray; d: ar; n: int64);
begin
        if Random(1, 10) = 1 then
        begin
                //                Print(2);
                var a := Random(1, d[n]);
                animal[a][1] := random(1, WindowWidth - 1);
                animal[a][2] := random(1, WindowHeight - 1);
                while(not in_or_out(animal[a][1], animal[a][2])) do
                begin
                        animal[a][1] := random(1, WindowWidth - 1);
                        animal[a][2] := random(1, WindowHeight - 1);
                end;
        end;
end;

procedure mutation_plus(var animal: aray; var d: ar; n: int64);
begin
        if Random(1, 10) = 1 then
        begin
                //                Print(1);
                if (d[n] = Ceil(num_of_walls / 3)) then
                begin
                        var ad := Random(1, d[n]);
                        for var j := ad to d[n] do
                        begin
                                animal[j] := animal[j + 1];
                        end;
                        d[n] -= 1;
                end
                else if (d[n] > 1) then
                begin
                        var a := Random(0, 1);
                        if (a = 1) then
                        begin
                                animal[d[n] + 1][1] := random(1, WindowWidth - 1);
                                animal[d[n] + 1][2] := random(1, WindowHeight - 1);
                                while(not in_or_out(animal[d[n] + 1][1], animal[d[n] + 1][2])) do
                                begin
                                        animal[d[n] + 1][1] := random(1, WindowWidth - 1);
                                        animal[d[n] + 1][2] := random(1, WindowHeight - 1);
                                end;
                                d[n] += 1;
                        end
                        else
                        begin
                                var ad := Random(1, d[n]);
                                for var j := ad to d[n] do
                                begin
                                        animal[j] := animal[j + 1];
                                end;
                                d[n] -= 1;
                        end;
                end
                else
                begin
                        animal[d[n] + 1][1] := random(1, WindowWidth - 1);
                        animal[d[n] + 1][2] := random(1, WindowHeight - 1);
                        while(not in_or_out(animal[d[n] + 1][1], animal[d[n] + 1][2])) do
                        begin
                                animal[d[n] + 1][1] := random(1, WindowWidth - 1);
                                animal[d[n] + 1][2] := random(1, WindowHeight - 1);
                        end;
                        d[n] += 1;
                end;
        end;
end;

procedure sum_of_array(mom, dad: aray; var new_animals: animal_array; tozka, number_of_new, n_d, n_m: int64; var d, d_c: ar);
begin
        if (n_d >= tozka) then
        begin
                d_c[number_of_new] := d[n_d];
        end
        else
        begin
                d_c[number_of_new] := tozka;
        end;
        for var ii := 1 to tozka do
        begin
                new_animals[number_of_new][ii] := mom[ii];
        end;
        for var ii := tozka + 1 to d_c[number_of_new] do
        begin
                new_animals[number_of_new][ii] := dad[ii];
        end;
end;

procedure crossingover(mom, dad: aray; var new_animals: animal_array; number_of_new, n_m, n_d: int64; var d, d_c: ar);
begin
        sum_of_array(mom, dad, new_animals, Random(1, Min(d[n_d], d[n_m])), number_of_new, n_d, n_m, d, d_c);
        //        Print(new_animals[number_of_new],d_c[number_of_new]);
        mutation(new_animals[number_of_new], d_c, number_of_new);
        mutation_plus(new_animals[number_of_new], d_c, number_of_new);
        //        Print(new_animals[number_of_new],d_c[number_of_new]);
end;

function fitness(animal: aray; l, count: int64): real;
begin
        var sum, s, s2: int64;
        for var ii := 1 to WindowWidth - 1 do
        begin
                for var iii := 1 to WindowHeight - 1 do
                begin
                        for var iiii := 1 to l do
                        begin
                                for var iiiii := 1 to num_of_walls - 2 do
                                begin
                                        if (get_line_intersection(ii, iii, animal[iiii][1], animal[iiii][2], i[1][iiiii], i[2][iiiii], i[1][iiiii + 1], i[2][iiiii + 1])) then
                                        begin
                                                s := 1;
                                                break;
                                        end;
                                end;
                                if (get_line_intersection(ii, iii, animal[iiii][1], animal[iiii][2], i[1][num_of_walls - 1], i[2][num_of_walls - 1], i[1][1], i[2][1])) then
                                begin
                                        s := 1;
                                end;
                                if(s = 0) then
                                begin
                                        s2 := 1;
                                        s := 0;
                                        break;
                                end;
                                        //Print(3);
                                s := 0;
                        end;
                        if (s2 = 1) then
                        begin
                                sum += 1;
                                if (count = 1) then
                                begin
                                        var c: Color := GetPixel(ii, iii);
                                        if (c.R + c.G + c.B + c.A = 4 * 255) then
                                        begin
                                                SetPixel(ii, iii, clYellow);
                                        end;
                                end;
                        end;
                                //Print(2);
                        s2 := 0;
                end;
                //Print(1);
        end;
                        //        var c: Color := RGB(Random(0,255),Random(0,255),Random(0,255));
                        //        for var ii:=1 to l do
                //        begin
                //          SetBrushColor(c);
                //          Circle(animal[ii][1], animal[ii][2], 3);
                //        end;
        //        Print(sum / area() * 100, sum, area);
//        if((1000 / (l * (100 - (sum / areas * 100) + 1))) = (1000 / (l * (100 - (areas / areas * 100) + 1))))then
//        begin
//          SetFontSize(10);
//          TextOut(200,200,'WARRING!');
//          Sleep(100000);
//        end;
        //SetFontSize(10);
        //TextOut(200,200,'WARRING!');
        result := 1000 / (l * (100 - (sum / areas * 100) + 1));
end;

function choose_parent(animals_young: animal_array; no: int64; d: ar; summs: ara): int64;
begin
        var random_var, hole: int64;
        random_var := Random(0, 9999);
        hole := 1;
                //        Print(1);
        //        print(summs);
                //        print(random_var);
        while not (random_var / 10000 < summs[hole]) do
        begin
                hole := hole + 1;
        end;
        //        Print(1);
        while (hole = no) do
        begin
                //                print(hole,no);
                hole := 1;
                random_var := Random(0, 9999);
                hole := 1;
                //        print(summs);
                   //        print(random_var);
                while not (random_var / 10000 < summs[hole]) do
                begin
                        hole := hole + 1;
                end;
        end;
        //        Print(summs);
        //        Sleep(10000000);
        Result := hole;
        //        Print(hole, summs, random_var);
end;

procedure fitt(animals_young: animal_array; d: ar; var fit, summs: ara; count: int64);
begin
        var summ3, summ2, max: real;
        var maxi: int64;
        // рисуем все особи в поколении
        for var j := 1 to 6 do
        begin
                {if((j = 1) and (count mod 10 = 1)) then fit[j] := fitness(animals_young[j], d[j], 1)
                else{} fit[j] := fitness(animals_young[j], d[j], 0);
                summ3 := summ3 + fit[j];
                // печатаем площадь,видную смене,деленную на количество охранников в смене
                Print(fit[j]);
                //                Sleep(1000000);
        end;
        for var j := 1 to 6 do
        begin
                if fit[j] > max then
                begin
                        max := fit[j];
                        maxi := j;
                end;
        end;
        if (count mod 10 = 1) then 
        begin
                fitness(animals_young[maxi], d[maxi], 1);
        end;
        for var k := 1 to d[maxi] do
        begin;
                Circle(animals_young[maxi][k][1], animals_young[maxi][k][2], 3);
        end;
        Print(summ3 / 6);
        Sleep(5000);
        
        for var animal := 1 to 6 do
        begin
                summ2 += fit[animal] / summ3;
                summs[animal] := summ2;
        end;
end;

procedure MouseDown(x, y, mb: integer);
begin
        //рисуем стены комнаты
        assssssss+=1;
        TextOut(0,0,assssssss);
        var counter: int64;
        for var u := 1 to num_of_walls - 3 do
        begin
                if get_line_intersection(x, y, i[1][num_of_walls - 1], i[2][num_of_walls - 1], i[1][u], i[2][u], i[1][u + 1], i[2][u + 1]) then
                begin
                        counter += 1;
                end;
        end;
        if counter = 0 then
        begin
                if (y_n = 1) then
                begin
                        if ((x - 10 <= i[1][1]) and (x + 10 >= i[1][1]) and (y - 10 <= i[2][1]) and (y + 10 >= i[2][1])) then
                        begin
                                LineTo(i[1][1], i[2][1]);
                                y_n := 2;
                        end
                        else
                        begin;
                                LineTo(x, y);
                                i[1][num_of_walls] := x;
                                i[2][num_of_walls] := y;
                                num_of_walls += 1;
                        end;
                end;
        end;
        if (y_n = 0) then
        begin
                MoveTo(x, y);
                y_n := 1;
                i[1][1] := x;
                i[2][1] := y;
                num_of_walls := 2;
        end;
        
        // начинаем расставлять охранников
        if (y_n = 2) then
        begin
                //                Print(area());
                var animals_young, new_animals: animal_array;
                var mom, dad: int64;
                var d, d_c: ar; // массивы длин смен - старой и новой
                var summs, fit: ara;
                areas := area();
                y_n += 1;
                
                // формируем первую смену охранников случайно внутри комнаты
                array2random(animals_young, d);
                
                // для каждого поколения
                for var k := 1 to 1000000 do
                begin
                        ClearWindow();
                        // отрисовка стен
                        MoveTo(i[1][1], i[2][1]);
                        for var wall := 2 to num_of_walls - 1 do
                        begin
                                Lineto(i[1][wall], i[2][wall]);
                        end;
                        Lineto(i[1][1], i[2][1]);
                        Print('Generation number', k);
                        fitt(animals_young, d, fit, summs, k);
                        // для каждой смены в поколении
                        SetBrushColor(clWhite);
                        for var j := 1 to 6 do
                        begin
                                //                                Print(d[j]);
                                                                // находим маму и папу
                                mom := choose_parent(animals_young, 0, d, summs);
                                //                                Print(1);
                                dad := choose_parent(animals_young, mom, d, summs);
                                //                                Print(1);
                                crossingover(animals_young[mom], animals_young[dad], new_animals, j, mom, dad, d, d_c);
                                //                                Print(1);
                        end;
                        //                                                                                                                        SetBrushColor(clWhite);
                        Println({animals_young{});
                        //                        Sleep(100000);
                        // копируем детей в родителей
                        d := d_c;
                        animals_young := new_animals;
                end;
        end;
end;

begin
        MaximizeWindow();
        OnMouseDown := MouseDown;
        //        Print(WindowHeight, WindowWidth);
end.