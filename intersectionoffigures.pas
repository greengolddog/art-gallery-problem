uses GraphABC;

type
        polygon77 = array [1..2] of real;
        polygon777 = array [0..1000] of polygon77;

var
        counter, num_of_walls, num_of_walls2, num_of_walls3: int64;
        i, i2: polygon777;

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
        Result := was_intersection1 and was_intersection2 and IsPointInPolygon(fig, (x1 + x2) / 2, (y1 + y2) / 2, num_vert);
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
        var j: int64;
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
                while(i < size_of_poly_not_normal) do
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
                        //                Line(Round(poly_not_normal[i * 2][1]), Round(poly_not_normal[i * 2][2]), Round(poly_not_normal[i * 2 + 1][1]), Round(poly_not_normal[i * 2 + 1][2]));
                end;
        end;
        for var i := 0 to size_of_poly_not_normal do
        begin
                if ((not segment_in_figure_2(poly1, size_of_poly1, poly_not_normal[i * 2][1], poly_not_normal[i * 2][2], poly_not_normal[i * 2 + 1][1], poly_not_normal[i * 2 + 1][2])) and (not segment_in_figure_2(poly2, size_of_poly2, poly_not_normal[i * 2][1], poly_not_normal[i * 2][2], poly_not_normal[i * 2 + 1][1], poly_not_normal[i * 2 + 1][2]))) then
                begin
                        poly_not_normal_2[size_of_poly_not_normal_2 * 2] := poly_not_normal[i * 2];
                        poly_not_normal_2[size_of_poly_not_normal_2 * 2 + 1] := poly_not_normal[i * 2 + 1];
                        size_of_poly_not_normal_2 += 1;
                end
        end;
        //        Print(poly_not_normal);
        sort_poly[size_of_sort_poly][1] := poly[0][1];
        sort_poly[size_of_sort_poly][2] := poly[0][2];
        size_of_sort_poly := 1;
        var c: int64;
        for var l := 0 to size_of_poly - 2 do
        begin
                poly[l] := poly[l + 1];
        end;
        size_of_poly -= 1;
        Print(1);
        while (size_of_poly > 0) do
        begin
//                Print(1);
                for var i := 0 to size_of_poly - 1 do
                begin
                        for var k := 0 to size_of_poly_not_normal_2 do
                        begin
                                if (((poly[i] = poly_not_normal_2[k * 2]) and (sort_poly[size_of_sort_poly - 1] = poly_not_normal_2[k * 2 + 1])) or ((poly[i] = poly_not_normal_2[k * 2 + 1]) and (sort_poly[size_of_sort_poly - 1] = poly_not_normal_2[k * 2]))) then
                                begin
                                        sort_poly[size_of_sort_poly] := poly[i];
                                        size_of_sort_poly += 1;
                                        for var l := i to size_of_poly - 2 do
                                        begin
                                                poly[l] := poly[l + 1];
                                        end;
                                        size_of_poly -= 1;
                                        
                                        Line(Round(poly_not_normal_2[k * 2 + 1][1]), Round(poly_not_normal_2[k * 2 + 1][2]), Round(poly_not_normal_2[k * 2][1]), Round(poly_not_normal_2[k * 2][2]));
                                        //                                        Print(i);
                                        c := 1;
                                        break;
                                end;
                        end;
                        if (c = 1) then
                        begin
                                c := 0;
                                break;
                        end;
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

procedure MouseDown(x, y, mb: integer);
begin
        if counter = 1 then
        begin
                if num_of_walls2 = 0 then
                        MoveTo(x, y);
                if ((x - 10 <= i2[0][1]) and (x + 10 >= i2[0][1]) and (y - 10 <= i2[0][2]) and (y + 10 >= i2[0][2])) then
                begin
                        LineTo(Round(i2[0][1]), Round(i2[0][2]));
                        counter += 1;
                end
                        else
                begin;
                        LineTo(x, y);
                        i2[num_of_walls2][1] := x;
                        i2[num_of_walls2][2] := y;
                        num_of_walls2 += 1;
                end;
        end;
        if counter = 0 then
        begin
                if num_of_walls = 0 then
                        MoveTo(x, y);
                if ((x - 10 <= i[0][1]) and (x + 10 >= i[0][1]) and (y - 10 <= i[0][2]) and (y + 10 >= i[0][2])) then
                begin
                        LineTo(Round(i[0][1]), round(i[0][2]));
                        counter += 1;
                end
                        else
                begin;
                        LineTo(x, y);
                        i[num_of_walls][1] := x;
                        i[num_of_walls][2] := y;
                        num_of_walls += 1;
                end;
        end;
        if counter = 2 then
        begin
                var i3: polygon777;
                //                Print(segment_in_figure_2(i,num_of_walls,i[0][1],i[0][2],i[2][1],i[2][2]),segment_and_pixel(1,1,10,1,10,1));
                Print(PolygonUnion(i, i2, i3, num_of_walls, num_of_walls2, num_of_walls3));
                var k: int64;
                                //                Print(num_of_walls3, i3);
                //                Print(i, i2);
                k := num_of_walls3 - 1;
                SetPenColor(clred);
                SetPenWidth(3);
                for var j := 0 to num_of_walls3 - 1 do
                begin
                        Line(Round(i3[k][1]), Round(i3[k][2]), Round(i3[j][1]), Round(i3[j][2]));
                        k := j;
                end;
        end;
end;

begin
        //        var x, y: real;
        //        var poly: polygon777;
        //        poly[0][1] := -2;
        //        poly[0][2] := -2;
        //        poly[1][1] := 1;
        //        poly[1][2] := 0;
        //        poly[2][1] := 3.5;
        //        poly[2][2] := 2;
        //        poly[3][1] := 4;
        //        poly[3][2] := 0.5;
        //        ClockwiseSortPoints(poly, 4);
        //        Print(poly);
        MaximizeWindow();
        OnMouseDown := MouseDown;
end.