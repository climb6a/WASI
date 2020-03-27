unit SCHOEN_;

{$MODE Delphi}

{27.8.2016}

interface

function schoen(x:double; SIG:byte):String;
function log10(x:double):integer;
function signif(x, dx : double; MIN, MAX: byte):byte;

implementation

function log10(x:double):integer;
{log10(x) = Zehnerpotenz von x}
begin
    x:=abs(x);
    if x=0 then x:=1;
    if (x>=1) then
        log10:= trunc( ln(x) / ln(10) )
    else
        log10:= trunc( ln(x) / ln(10) - 1 );
end;

function schoener_exponent(s:ShortString):string;
{Die Formatanweisung x:12 fuehrt fuer die Real- oder Doublezahl x im ($N+)-
 Modus auf einen Exponenten der Form 0002 und im ($N-)-Modus der Form -02.
 Diese Prozedur entfernt die ueberfluessigen Nullen. NEU: Bisher wurde auch
 die Null in E-10 entfernt; dieser Fehler ist hier behoben.}
var  a, z, nr_E, b : byte;
     s4            : string[4];
begin
    z:=0;
    while (s[z]<>'E') and (z<length(s)) do inc(z);
    nr_E:=z;
    b:=nr_E+2;
    while (s[b]='0') and (b<length(s)) do inc(b);
    s4:=copy(s, b, 1+length(s)-b);
    if s[1]=' ' then a:=1 else a:=0;            {fuehrenden Blank entfernen}
    schoener_exponent:=copy(s,1+a,nr_E+1-a)+s4;
    end;

function schoen(x:double; SIG:byte):String;
{Die Zahl x wird in in einen String verwandelt, wobei SIG signifikante
 Stellen angezeigt werden.}
var merk : integer;
    ss   : String;
    d    : integer;
begin
if x=0 then schoen:='0' else
if (x=1) and (SIG>2) then schoen:='1' else begin
    merk:=log10(x);
    if merk>=0 then begin
        if (merk<SIG) then begin
            str(x:merk:SIG-merk-1, ss);
            schoen:=ss;
            end
        else if (merk<SIG+3) then begin
            d:=abs(SIG-merk);
            str(x:merk+d:SIG-merk+d, ss);
            schoen:=ss;
            end
        else begin
            str(x:SIG+8, ss);                          { real:6, double:8 }
            if x>0 then ss:=copy(ss,2,length(ss)-1);
            schoen:=schoener_exponent(ss);
            end;
        end
    else begin  {merk<0}
        if merk{-2}+SIG>=0 then begin                           { real:-2 }
            str(x:-merk:SIG-merk-1, ss);
            schoen:=ss;
            end
        else if merk+3>=0 then begin
            if SIG>-merk then d:=SIG-merk+1 else d:=1;
            str(x:-merk+d+2:-merk+d,ss);
            schoen:=ss;
            end
        else begin
            str(x:SIG+8, ss);                          { real:6, double:8 }
            schoen:=schoener_exponent(ss);
            end;
        end;
    end;
    end;

function signif(x, dx : double; MIN, MAX: byte):byte;
{ Berechnet die Zahl der signifikanten Stellen, die notwendig sind, um
  die Zahlen x, x+dx zu unterscheiden. }
var  s : byte;
     error : integer;
     x1, x2 : double;
begin
    s:=MIN-1;
    repeat
        inc(s);
        val(schoen(x, s), x1, error);
        val(schoen(x+dx, s), x2, error);
    until (x1<>x2) or (s>=MAX);
    signif:=s;
    end;

begin end.
