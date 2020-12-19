begin
        var f: Text;
        var s: string;
        Assign(f, 'random30_1');
        Reset(f);
        while(not Eof(f)) do
        begin
                Readln(f, s);
                Print(s);
                Readln(f, s);
                Println(s);
        end;
end.