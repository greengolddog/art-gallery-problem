uses graphABC;

var
        y_n, f, l, kol, s: int64;

var
        Gallery, Guards: array[1..2]of array[0..10000]of int64;

type
        polygon77 = array [1..2] of real;
        polygon777 = array [0..1000] of polygon77;

function segment_and_pixel(x, y, x1, x2, y1, y2: real): boolean;
begin
        if ((round(((y1 - y2) * x + (x2 - x1) * y + (x1 * y2 - x2 * y1))) = 0) and ((not (x < x1) and not (x2 < x)) or (not (x < x2) and not (x1 < x))) and ((not (y < y1) and not (y2 < y)) or (not (y < y2) and not (y1 < y)))) then
                Result := true
        else 
                Result := false;
end;

function segment_and_pixel_2(x, y, x1, y1, x2, y2: real): boolean;
begin
        if ((round(((y1 - y2) * x + (x2 - x1) * y + (x1 * y2 - x2 * y1))) = 0) and ((not (x <= x1) and not (x2 <= x)) or (not (x <= x2) and not (x1 <= x))) and ((not (y <= y1) and not (y2 <= y)) or (not (y <= y2) and not (y1 <= y)))) then
                Result := true
        else 
                Result := false;
end;

function IsRectCross(p11, p12, p21, p22, q11, q12, q21, q22: real): boolean;
begin
        var ret: boolean;
        ret := (min(p11, p21) <= max(q11, q21)) and (min(q11, q21) <= max(p11, p21)) and (min(p12, p22) <= max(q12, q22)) and (min(q12, q22) <= max(p12, p22));
        result := ret;
end;

function IsLineSegmentCross(p11, p12, p21, p22, q11, q12, q21, q22: real): boolean;
begin
        var line1, line2: real;
        line1 := p11 * (q12 - p22) + p21 * (p12 - q12) + q11 * (p22 - p12);
        line2 := p11 * (q22 - p22) + p21 * (p12 - q22) + q21 * (p22 - p12);
        if ((line1 = line2) and (line1 <> 0) or (line1 <> line2) and ((line1 <> 0) or (line2 <> 0)) and ((line1 * line2) >= 0)) then
        begin
                result := false;
                exit;
        end;
        line1 := q11 * (p12 - q22) + q21 * (q12 - p12) + p11 * (q22 - q12);
        line2 := q11 * (p22 - q22) + q21 * (q12 - p22) + p21 * (q22 - q12);
        if ((line1 = line2) and (line1 <> 0) or (line1 <> line2) and ((line1 <> 0) or (line2 <> 0)) and ((line1 * line2) >= 0)) then
        begin;
                result := false;
                exit;
        end;
        result := true;
end;

function GetCrossPoint(p11, p12, p21, p22, q11, q12, q21, q22: real; var x, y: real): boolean;
begin
        if ((p11 = q11) and (p12 = q12)) then
        begin
                x := p11;
                y := p12;
                result := true;
                exit;
        end;
        if ((p11 = q21) and (p12 = q22)) then
        begin
                x := p11;
                y := p12;
                result := true;
                exit;
        end;
        if ((p21 = q11) and (p22 = q12)) then
        begin
                x := p21;
                y := p22;
                result := true;
                exit;
        end;
        if ((p21 = q21) and (p22 = q22)) then
        begin
                x := p21;
                y := p22;
                result := true;
                exit;
        end;
        if (IsRectCross(p11, p12, p21, p22, q11, q12, q21, q22)) then
        begin
                if (IsLineSegmentCross(p11, p12, p21, p22, q11, q12, q21, q22)) then
                begin
                        //求交点
                        var tmpLeft, tmpRight: real;
                        tmpLeft := (q21 - q11) * (p12 - p22) - (p21 - p11) * (q12 - q22);
                        tmpRight := (p12 - q12) * (p21 - p11) * (q21 - q11) + q11 * (q22 - q12) * (p21 - p11) - p11 * (p22 - p12) * (q21 - q11);
                        if (tmpLeft = 0) then
                        begin
                                result := false;
                                exit;
                        end;
                        x := tmpRight / tmpLeft;
                        tmpLeft := (p11 - p21) * (q22 - q12) - (p22 - p12) * (q11 - q21);
                        tmpRight := p22 * (p11 - p21) * (q22 - q12) + (q21 - p21) * (q22 - q12) * (p12 - p22) - q22 * (q11 - q21) * (p22 - p12);
                        if (tmpLeft = 0) then
                        begin
                                result := false;
                                exit;
                        end;
                        y := tmpRight / tmpLeft;
                        result := true;
                        exit;
                end;
        end;
        result := false;
end;

function IsPointInPolygon(poly: polygon777; p1, p2: real; size_of_poly: int64): boolean;
begin
        var c: boolean;
        c := false;
        var j: int64;
        j := size_of_poly - 1;
        for var i := 0 to size_of_poly - 1 do
        begin
                if ((((poly[i][2] <= p2) and (p2 < poly[j][2])) or ((poly[j][2] <= p2) and (p2 < poly[i][2]))) and (p1 < (poly[j][1] - poly[i][1]) * (p2 - poly[i][2]) / (poly[j][2] - poly[i][2]) + poly[i][1])) then
                begin
                        c := not c;
                end;
                j := i;
        end;
        result := c;
end;

function IsPointInPolygon2(poly: polygon777; p1, p2: real; size_of_poly: int64): boolean;
begin
        var c: boolean;
        c := false;
        var j: int64;
        j := size_of_poly - 1;
        for var i := 0 to size_of_poly - 1 do
        begin
                if ((((poly[i][2] <= p2) and (p2 < poly[j][2])) or ((poly[j][2] <= p2) and (p2 < poly[i][2]))) and (p1 < (poly[j][1] - poly[i][1]) * (p2 - poly[i][2]) / (poly[j][2] - poly[i][2]) + poly[i][1])) then
                begin
                        c := not c;
                end;
                if (segment_and_pixel(p1, p2, poly[i][1], poly[i][2], poly[j][1], poly[j][2]))  then
                begin
                  Result := false;
                  exit;
                end;
                j := i;
        end;
        result := c;
end;

function segment_in_figure_2(var fig: polygon777; num_vert: int64; x1, y1, x2, y2: real): boolean;
begin
        var was_intersection1, was_intersection2: boolean;
        var j: int64;
        j := num_vert - 1;
        for var i := 0 to num_vert - 1 do
        begin
                if (segment_and_pixel(x1, y1, fig[i][1], fig[j][1], fig[i][2], fig[j][2])) then
                begin
                        was_intersection1 := true;
                        if (segment_and_pixel(x2, y2, fig[i][1], fig[j][1], fig[i][2], fig[j][2])) then
                        begin
                                was_intersection2 := true;
                                //                                Println(1);
                                                                //                                SetPenColor(clRed);
                                                                //                                Line(Round(x1),Round(y1),Round(x2),Round(y2));
                                                                //                                Sleep(1000);
                                Result := false;
                                //                                SetPenColor(clGreen);
                                exit;
                        end;
                end
                else
                begin
                        if (segment_and_pixel(x2, y2, fig[i][1], fig[j][1], fig[i][2], fig[j][2])) then
                        begin
                                was_intersection2 := true;
                        end;
                end;
                //                Println(i,was_intersection1,was_intersection2,x1,y1,x2,y2, fig[i][1],fig[i][2], i1, i2);
                j := i;
        end;
        //        Println(i1,2);
        //        Circle(Round((x1+x2)/2),Round((y1+y2)/2),5);
        Result := was_intersection1 and was_intersection2 and IsPointInPolygon2(fig, (x1 + x2) / 2, (y1 + y2) / 2, num_vert);
end;

function PointCmp(p11, p12, p21, p22, center1, center2: real): boolean;
begin
        var det: real;
        det := (p11 - center1) * (p22 - center2) - (p21 - center1) * (p12 - center2);
        if (det < 0) then
        begin
                Result := true;
                exit;
        end;
        if (det > 0) then
        begin
                result := false;
                exit;
        end;
        if ((p11 = center1) and (p12 = center2)) then
        begin
                result := false;
                exit;
        end;
        if ((p21 = center1) and (p22 = center2)) then
        begin
                result := true;
                exit;
        end;
        result := ((p11 > p21) or (p12 > p22));
end;

procedure ClockwiseSortPoints(var poly, poly1, poly2: polygon777; var size_of_poly, size_of_poly1, size_of_poly2: int64);
begin
        var j, stc: int64;
        var poly_not_normal_2, poly_not_normal, sort_poly: polygon777;
        var size_of_poly_not_normal_2, size_of_poly_not_normal, size_of_sort_poly: int64;
        j := size_of_poly1 - 1;
        //        SetPenWidth(3);
        //        SetPenColor(clGold);
        for var i := 0 to size_of_poly1 - 1 do
        begin
                //                Println(poly1[i],poly1[j]);
                                //                if (not segment_in_figure_2(poly2, size_of_poly2, poly1[i][1], poly1[i][2], poly1[j][1], poly1[j][2])) then
                                //                begin
                                                        //                        Println(1);
                poly_not_normal[size_of_poly_not_normal * 2] := poly1[i];
                poly_not_normal[size_of_poly_not_normal * 2 + 1] := poly1[j];
                size_of_poly_not_normal += 1; 
                //                end;
                j := i;
        end;
        j := size_of_poly2 - 1;
        for var i := 0 to size_of_poly2 - 1 do
        begin
                //                Println(poly2[i],poly2[j]);
                                //                if (not segment_in_figure_2(poly1, size_of_poly1, poly2[i][1], poly2[i][2], poly2[j][1], poly2[j][2])) then
                                //                begin
                poly_not_normal[size_of_poly_not_normal * 2] := poly2[i];
                poly_not_normal[size_of_poly_not_normal * 2 + 1] := poly2[j];
                size_of_poly_not_normal += 1;
                //                end;
                j := i;
        end;
                //        Print(poly_not_normal,poly1,poly2);
        //        SetPenColor(clGreen);
        if (1 = 1) then
        begin
                var i: int64;
                i := -1;
                while(i <= size_of_poly_not_normal) do
                begin
                        //          Line(Round(poly_not_normal[i*2][1]),Round(poly_not_normal[i*2][2]),Round(poly_not_normal[i*2+1][1]),Round(poly_not_normal[i*2+1][2]));
                        i += 1;
                        for var k := 0 to size_of_poly - 1 do
                        begin
                                if (segment_and_pixel_2(poly[k][1], poly[k][2], poly_not_normal[i * 2][1], poly_not_normal[i * 2][2], poly_not_normal[i * 2 + 1][1], poly_not_normal[i * 2 + 1][2])) then
                                begin
                                        //              Println(1);
                                        poly_not_normal[size_of_poly_not_normal * 2] := poly_not_normal[i * 2];
                                        poly_not_normal[size_of_poly_not_normal * 2 + 1] := poly[k];
                                        size_of_poly_not_normal += 1; 
                                        poly_not_normal[i * 2] := poly[k];
                                end
                        end;
//                        SetPenColor(clRed);
//                                        Line(Round(poly_not_normal[i * 2][1]), Round(poly_not_normal[i * 2][2]), Round(poly_not_normal[i * 2 + 1][1]), Round(poly_not_normal[i * 2 + 1][2]));
                end;
        end;
        for var i := 0 to size_of_poly_not_normal do
        begin
                if ((not segment_in_figure_2(poly1, size_of_poly1, poly_not_normal[i * 2][1], poly_not_normal[i * 2][2], poly_not_normal[i * 2 + 1][1], poly_not_normal[i * 2 + 1][2])) and (not segment_in_figure_2(poly2, size_of_poly2, poly_not_normal[i * 2][1], poly_not_normal[i * 2][2], poly_not_normal[i * 2 + 1][1], poly_not_normal[i * 2 + 1][2]))) then
                begin
                        poly_not_normal_2[size_of_poly_not_normal_2 * 2] := poly_not_normal[i * 2];
                        poly_not_normal_2[size_of_poly_not_normal_2 * 2 + 1] := poly_not_normal[i * 2 + 1];       
                        SetPenColor(clRed);
                        Line(Round(poly_not_normal_2[size_of_poly_not_normal_2 * 2][1]), Round(poly_not_normal_2[size_of_poly_not_normal_2 * 2][2]), Round(poly_not_normal_2[size_of_poly_not_normal_2 * 2 + 1][1]), Round(poly_not_normal_2[size_of_poly_not_normal_2 * 2 + 1][2]));
                        size_of_poly_not_normal_2 += 1;
                 end
        end;
//        Println(poly_not_normal);
        sort_poly[0][1] := poly[0][1];
        sort_poly[0][2] := poly[0][2];
        size_of_sort_poly := 1;
        Print(poly[0]);
        var c: int64;
        Print(1);
//        Sleep(1000);
        while (true) do // 
        begin
                for var i := 0 to size_of_poly - 1 do
                begin
                        for var k := 0 to size_of_poly_not_normal_2 do
                        begin
                                if (((poly[i] = poly_not_normal_2[k * 2]) and (sort_poly[size_of_sort_poly - 1] = poly_not_normal_2[k * 2 + 1])) or ((poly[i] = poly_not_normal_2[k * 2 + 1]) and (sort_poly[size_of_sort_poly - 1] = poly_not_normal_2[k * 2]))) then
                                begin
                                        if (size_of_sort_poly >= 2) then
                                        begin
                                                if ((poly[i] <> sort_poly[size_of_sort_poly - 2]) and  (poly[i] <> sort_poly[size_of_sort_poly - 1])) then
                                                begin
                                                        Print(poly[i]);
                                                        sort_poly[size_of_sort_poly] := poly[i];
                                                        size_of_sort_poly += 1;
                                                        if (Round(poly[i][1] - sort_poly[0][1]) = 0) and (Round(poly[i][2] - sort_poly[0][2]) = 0) then
                                                        begin
                                                                stc := 1;
                                                        end;
                                                        for var l := i to size_of_poly - 2 do
                                                        begin
                                                                poly[l] := poly[l + 1];
                                                        end;
                                                        size_of_poly -= 1;
                                                        SetPenWidth(size_of_sort_poly);
                                                        SetPenColor(clBlue);
                                                        Line(Round(poly_not_normal_2[k * 2 + 1][1]), Round(poly_not_normal_2[k * 2 + 1][2]), Round(poly_not_normal_2[k * 2][1]), Round(poly_not_normal_2[k * 2][2]));
                                                        Sleep(100);
                                                        Print(i);
                                                        c := 1;
                                                        break;
                                                end;
                                        end
                                        else
                                        begin
                                                sort_poly[size_of_sort_poly] := poly[i];
                                                size_of_sort_poly += 1;
                                                for var l := i to size_of_poly - 2 do
                                                begin
                                                        poly[l] := poly[l + 1];
                                                end;
                                                size_of_poly -= 1;
                                                SetPenWidth(size_of_sort_poly);
                                                SetPenColor(clBlue);
                                                Line(Round(poly_not_normal_2[k * 2 + 1][1]), Round(poly_not_normal_2[k * 2 + 1][2]), Round(poly_not_normal_2[k * 2][1]), Round(poly_not_normal_2[k * 2][2]));
                                                Sleep(100);
                                                Print(i);
                                                c := 1;
                                                break;
                                        end;
                                end;
                                if (c = 1) then
                                begin
                                        break;
                                end;
                        end;
                        if (c = 1) then
                        begin
                                c := 0;
                                break;
                        end;
                end;
                if (stc = 1) then
                begin
                        break;
                end;
        end;
        poly := sort_poly;
        size_of_poly := size_of_sort_poly;
end;

function PolygonUnion(var poly1, poly2, interpoly: polygon777; var size_of_poly1, size_of_poly2, size_of_interpoly: int64): boolean;
begin
        if ((size_of_poly1 < 3) or (size_of_poly2 < 3)) then
        begin
                result := false;
                exit;
        end;
        var x, y: real;
        for var i := 0 to size_of_poly1 - 1 do
        begin
                var poly1_next_idx: int64;
                poly1_next_idx := (i + 1) mod size_of_poly1;
                for var j := 0 to size_of_poly2 - 1 do
                begin
                        var poly2_next_idx: int64;
                        poly2_next_idx := (j + 1) mod size_of_poly2;
                        if (GetCrossPoint(poly1[i][1], poly1[i][2], poly1[poly1_next_idx][1], poly1[poly1_next_idx][2], poly2[j][1], poly2[j][2], poly2[poly2_next_idx][1], poly2[poly2_next_idx][2], x, y)) then
                        begin
                                interpoly[size_of_interpoly][1] := x;
                                interpoly[size_of_interpoly][2] := y;
                                size_of_interpoly += 1;
                                //                                Println(x, y);
                        end;
                end;
        end;
        Print(6);
        var hasNoCrossPoint: boolean;
        hasNoCrossPoint := (size_of_interpoly = 0);
        //        Print(size_of_interpoly);
        for var i := 0 to size_of_interpoly - 1 do
        begin
                for var j := 0 to size_of_interpoly - 2 - i do
                begin
                        if ((interpoly[j][1] > interpoly[j + 1][1]) or (interpoly[j][2] > interpoly[j + 1][2])) then
                        begin
                                Swap(interpoly[j][1], interpoly[j + 1][1]);
                                Swap(interpoly[j][2], interpoly[j + 1][2]);
                        end;
                end;
        end;
        //        Print(interpoly);
        //        for var j := 0 to size_of_interpoly - 1 do
        //        begin
        //                Circle(Round(interpoly[j][1]),Round(interpoly[j][2]),5);
        //                TextOut(Round(interpoly[j][1]),Round(interpoly[j][2]),j);
        //        end;
        for var i := 0 to size_of_interpoly - 1 do
        begin
                for var j := i + 1 to size_of_interpoly - 1 do
                begin
                        if ((interpoly[j][1] = interpoly[i][1]) and (interpoly[j][2] = interpoly[i][2])) then
                        begin
                                for var z := i to size_of_interpoly - 2 do
                                begin
                                        interpoly[z] := interpoly[z + 1];
                                end;
                                size_of_interpoly -= 1;
                                interpoly[size_of_interpoly][1] := 0;
                                interpoly[size_of_interpoly][2] := 0;
                        end;
                end;
        end;
        //        Println(size_of_interpoly,interpoly);
        SetBrushColor(clRed);
                //        for var j := 0 to size_of_interpoly - 1 do
                //        begin
                //                Circle(Round(interpoly[j][1]), Round(interpoly[j][2]), 5);
                //                TextOut(Round(interpoly[j][1]), Round(interpoly[j][2]), j);
                //        end;
        //        SetBrushColor(clBlue);
        for var i := 0 to size_of_poly1 - 1 do
        begin
                if (not IsPointInPolygon(poly2, poly1[i][1], poly1[i][2], size_of_poly2)) then
                begin
                        interpoly[size_of_interpoly] := poly1[i];
                        size_of_interpoly += 1;
                        //                        Circle(Round(interpoly[size_of_interpoly - 1][1]),Round(interpoly[size_of_interpoly - 1][2]),5);
                end;
        end;
        for var i := 0 to size_of_poly2 - 1 do
        begin
                if (not IsPointInPolygon(poly1, poly2[i][1], poly2[i][2], size_of_poly1)) then
                begin
                        interpoly[size_of_interpoly] := poly2[i];
                        size_of_interpoly += 1;
                        //                        Circle(Round(interpoly[size_of_interpoly - 1][1]),Round(interpoly[size_of_interpoly - 1][2]),5);
                end;
        end;
                //        SetBrushColor(clRed);
                ////        Println(size_of_interpoly,interpoly);
        //        for var j := 0 to size_of_interpoly - 1 do
        //        begin
        //                Circle(Round(interpoly[j][1]), Round(interpoly[j][2]), 5);
        //                TextOut(Round(interpoly[j][1]), Round(interpoly[j][2]), j);
        //        end;
        //        Print(1);
        Print(10);
        if (hasNoCrossPoint) then
        begin
                Result := false;
                exit;
        end;
        //        Print(1);
        ClockwiseSortPoints(interpoly, poly1, poly2, size_of_interpoly, size_of_poly1, size_of_poly2);
        for var i := 0 to size_of_interpoly - 1 do
        begin
                for var j := i + 1 to size_of_interpoly - 1 do
                begin
                        if ((interpoly[j][1] = interpoly[i][1]) and (interpoly[j][2] = interpoly[i][2])) then
                        begin
                                for var z := i to size_of_interpoly - 2 do
                                begin
                                        interpoly[z] := interpoly[z + 1];
                                end;
                                size_of_interpoly -= 1;
                        end;
                end;
        end;
        SetBrushColor(clGreen);
        for var j := 0 to size_of_interpoly - 1 do
        begin
                Circle(Round(interpoly[j][1]), Round(interpoly[j][2]), 5);
                TextOut(Round(interpoly[j][1]), Round(interpoly[j][2]), j);
        end;
        Result := true;        
end;

{ ************************  заносим в x y пересечение двух прямых, на которых лежат отрезки. Если пересечения нет - NAN   *******************************************}
procedure intersection(x1, y1, x2, y2, x3, y3, x4, y4: int64; var x, y: real);
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
        if(round(((y1 - y2) * x + (x2 - x1) * y + (x1 * y2 - x2 * y1))) = 0) then 
                Result := true
        else 
                Result := false;
end;

{ ************************  проверяем, пересекаются ли отрезки   *******************************************}
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

{ ************************  векторное пересечение   *******************************************} 
function vector_multiplicator(vek1_x, vek1_y, vek2_x, vek2_y: int64): int64;
begin
        Result := vek1_x * vek2_y - vek1_y * vek2_x;
end;

{ ************************  кликаем мышкой   *******************************************} 

procedure MouseDown(x, y, mb: integer);
begin
        //var strp: string;
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
                        LineTo(Gallery[1][1], Gallery[2][1]);
                        Gallery[1][f] := Gallery[1][1];
                        Gallery[2][f] := Gallery[2][1];
                        Gallery[1][0] := Gallery[1][f - 1];
                        Gallery[2][0] := Gallery[2][f - 1];
                        y_n := 2;
                end
                else
                begin;
                        LineTo(x, y);
                        Gallery[1][f] := x;
                        Gallery[2][f] := y; //strp := IntToStr(x) + ',' + IntToStr(y);
                        //                        TextOut(x, y+20, strp);
                        f += 1;
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
                var intersections_local{точки пересечения со стенками у одного луча}, intersections_zero: array[1..2]of array[1..1000]of real;
                var intersections_global{точки пересечения со стенками у всех лучей всех охранников}: array[1..1000]of array[1..2]of array[1..1000]of real;
                var sort_intersections_global: array[1..1000]of polygon777;
                var intersectionn: polygon777;
                var number_local: int64;
                var xp, yp: real;
                var number_global{ //массив длин элементов массива intersection global (для i-го охранника  - сколько раз все лучи, выходящие из него, пересекают любые стенки)}, sort_number_global: array[1..1000]of int64;
                //sum := 0;
                number_local := 1;
                s := 0;
                for var i := 1 to l - 1 do // идем по всем охранникам
                begin
                        number_global[i] := 1;  
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
                                //                                var a: Color;
                                //                                a := clRandom;
                                //                                SetBrushColor(a);
                                //                                SetPenWidth(3);
                                //                                SetPenColor(a);
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
                                        sort_intersections_global[i][sort_number_global[i]][1] := intersections_local[1][p];
                                        sort_intersections_global[i][sort_number_global[i]][2] := intersections_local[2][p];
                                        sort_number_global[i] += 1;
                                end;
                                sort_intersections_global[i][sort_number_global[i]][1] := sort_intersections_global[i][1][1];
                                sort_intersections_global[i][sort_number_global[i]][2] := sort_intersections_global[i][1][2];
                                //sort_number_global[i] += 1;
                                intersections_local := intersections_zero;
                                number_local := 1;
                        end;
                end;
                var tf: boolean;
                var size_of_sig, i, sss: int64;
                size_of_sig := l;
                i := 1;
                SetPenColor(clGreen);
                SetPenWidth(4);
                for var j := 1 to size_of_sig - 1 do
                begin
                        for var k := 0 to sort_number_global[j] - 2 do
                        begin
                                Line(Round(sort_intersections_global[j][k][1]), Round(sort_intersections_global[j][k][2]), Round(sort_intersections_global[j][k + 1][1]), Round(sort_intersections_global[j][k + 1][2]));
                        end;
                        Line(Round(sort_intersections_global[j][0][1]), Round(sort_intersections_global[j][0][2]), Round(sort_intersections_global[j][sort_number_global[j] - 1][1]), Round(sort_intersections_global[j][sort_number_global[j] - 1][2]));
                end;
                while (i < size_of_sig) do
                begin
                        Print(i);
                        for var j := 1 to size_of_sig - 1 do
                        begin
                                if (j <> i) then
                                begin
                                        Print(3);
                                        tf := PolygonUnion(sort_intersections_global[i], sort_intersections_global[j], intersectionn, sort_number_global[i], sort_number_global[j], sss);
                                        Print(4);
                                        if (tf) then
                                        begin
                                                if (j > i) then
                                                begin
                                                        sort_intersections_global[i] := intersectionn;
                                                        sort_number_global[i] := sss;
                                                        for var k := j to size_of_sig - 1 do
                                                        begin
                                                                sort_intersections_global[k] := sort_intersections_global[k + 1];
                                                                sort_number_global[k] := sort_number_global[k + 1];
                                                        end;
                                                        size_of_sig -= 1;
                                                end
                                                else
                                                begin
                                                        sort_intersections_global[i] := intersectionn;
                                                        sort_number_global[i] := sss;
                                                        for var k := j to size_of_sig - 1 do
                                                        begin
                                                                sort_intersections_global[k] := sort_intersections_global[k + 1];
                                                                sort_number_global[k] := sort_number_global[k + 1];
                                                        end;
                                                        size_of_sig -= 1;
                                                        i -= 1;
                                                end
                                        end;
                                end;
                        end;
                        Print(22);
                        i += 1;
                end;
                Print(111);
                SetPenColor(clRed);
                SetPenWidth(4);
                for var j := 1 to size_of_sig - 1 do
                begin
                        for var k := 0 to sort_number_global[j] - 2 do
                        begin
                                Line(Round(sort_intersections_global[j][k][1]), Round(sort_intersections_global[j][k][2]), Round(sort_intersections_global[j][k + 1][1]), Round(sort_intersections_global[j][k + 1][2]));
                        end;
                        Line(Round(sort_intersections_global[j][0][1]), Round(sort_intersections_global[j][0][2]), Round(sort_intersections_global[j][sort_number_global[j] - 1][1]), Round(sort_intersections_global[j][sort_number_global[j] - 1][2]));
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
                //                for var i := 1 to l - 1 do // идем по охранникам
                //                begin
                //                        //                        SetBrushColor(ARGB(0, 0, 0, 0));
                //                        //                        TextOut(Guards[1][i] + 3, Guards[2][i], i);
                //                        SetBrushColor(clRandom);
                //                        SetPenColor(clRandom);
                //                        circle(Guards[1][i], Guards[2][i], 10);
                //                        for var j := 1 to sort_number_global[i] - 1 do//идём по узлам охранников
                //                        begin
                //                                //Println(i, j, sort_intersections_global[i][1][j], sort_intersections_global[i][2][j]); // здесь лежат все точки,которые видят все охранники
                //                                //соединяем все узлы охранника
                //                                Line(Round(sort_intersections_global[i][1][j]), Round(sort_intersections_global[i][2][j]), Round(sort_intersections_global[i][1][j + 1]), Round(sort_intersections_global[i][2][j + 1]));
                //                                Circle(Round(sort_intersections_global[i][1][j]), Round(sort_intersections_global[i][2][j]), 5);
                //                                SetBrushColor(ARGB(0, 0, 0, 0));
                //                                TextOut(Round(sort_intersections_global[i][1][j]) + 3, round(sort_intersections_global[i][2][j]), j);
                //                        end;
                //                end;
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
        end;
end;

begin
//     var rrr:polygon777;
//     rrr[0][1] := 1;
//     rrr[0][2] := 1;
//     rrr[1][1] := 500;
//     rrr[1][2] := 1;
//     rrr[2][1] := 500;
//     rrr[2][2] := 500;
//     rrr[3][1] := 1;
//     rrr[3][2] :=500;
//      Print(IsPointInPolygon2(rrr, 0, 0, 4));
                //var a1, a2, a3, a4, a5, a6, a7, a8: int64;
        //        var x, y: real;
                        //a1 := Random(1, 800);
                        //a2 := Random(1, 800);
                        //a3 := Random(1, 800);
                        //a4 := Random(1, 800);
                        //a5 := Random(1, 800);
                        //a6 := Random(1, 800);
                        //a7 := Random(1, 800);
                        //a8 := Random(1, 800);
        //                Line(5, 7 , 50, 300);
        //                Line(1, 9, 100, 200);
        //                intersection(0, 0, 1, 1, 1, 1, 2, 2, x, y);
        //                Print(x,y);
        //                Circle(Round(x),Round(y),5);
                        //Print(x,y);
                        //intersection(1, 1, 5, 5, 0, 0, 10, 10, x, y);
                        //Print(x,y);
                        //Circle(Round(x), Round(y), 10);
                        //                        Print(x,y,x/x);
                        //                        if ((x/x)<>1)then Print(1);
        //                Circle(Round(x), Round(y),5);
        //                Print(get_line_intersection(Round(x), Round(y), Round(x),Round(y), 1, 9, 100, 200));
                                                //  print(WindowHeight,WindowWidth)
        Read(kol); // читаем количество охранников
        OnMouseDown := MouseDown; // запускаем основную процедуру
        MaximizeWindow();
        //  print(WindowHeight,WindowWidth);
end.