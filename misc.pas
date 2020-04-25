unit misc;

{$MODE Delphi}

{ Collection of general-purpose procedures and functions of program WASI. }
{ Version vom 14.4.2020 }

interface
uses { $IFDEF private_version} privates, { $ENDIF}
     LCLIntf, LCLType, StdCtrls, classes, defaults, Farbe, math, forms, fileutil;

procedure complete_vers;
procedure SaveINI(flag_public:boolean);    { Save INI file }
function  LoadINI_public(INI_datei: string):boolean; { Read public INI file }
function  LoadINI_private:boolean;         { Read private INI file }
procedure SavePAR_public(vorlage, ausgabe:String);
procedure SavePAR_private(vorlage, ausgabe:String);
procedure saveSpecFw(name:String);         { Save spectra of forward calculations  }
procedure saveSpecInv(name:String);        { Save spectra of invers calculation }
procedure openCHANGES(pfad:String);        { Open file with changed parameters }
procedure saveCHANGES(spektrum:String; c1, c2, c3: double);
procedure openFITPARS(pfad:String);        { Open file with fitted parameters }
procedure saveFITPARS(spektrum:String; y:integer; c1, c2, c3: double);
procedure closeFITPARS;
function  import_spectrum(var S: Attr_spec):boolean;
procedure merk_fw;
procedure merk_actual;
procedure merk_fit;
procedure restore_fw;
procedure restore_actual;
procedure restore_fit;
procedure actual_to_fw;
procedure exclude_fit;
procedure set_parameter_names;
procedure set_YFilename;
procedure ReserveMemory;     { Get memory for pointer variables }
procedure DisposeMemory;     { Dispose reserved memory }
procedure berechne_aY(SS: double);
procedure berechne_Mie;
procedure berechne_bX;
procedure berechne_bbMie;
procedure berechne_bMie;
procedure berechne_bbW;
procedure berechne_SDD(Y,S,C: double; var SD: double);
function  Fresnel(angle:double):double;
function  rho_diffuse(sun:double):double;
procedure normalize(var spec: Attr_spec; Lambda:double);
procedure read_spectra;
function  xkoo(x:double; dx:integer):word;
function  ykoo(y:double; dy:integer):word;
procedure Auto_Scale(XMIN,XMAX: real; out VA,DV: real; out NV: Integer);
procedure scale;
function  YFilename(Name:String):String;
procedure determine_concentration_fw(RangeValue:single);
procedure blanks_to_tab(datenfile, tabfile:string; header: integer);
function  ASCII_is_Windows(var fn:string):boolean;
function  lies(var datei_in : textFile; CRLF: boolean;
          PosX, PosY: integer; out x1,x2 : double):boolean;
function  lies_spektrum(var spek: Attr_spec; name:String; PosX, PosY: byte;
          Header:word; out anzahl:word; flag_tab:boolean):byte;
function  x_anpassen(var spek: spektrum; N:integer; dx:double):boolean;
function  Nachbar(Lambda:double):integer;
procedure set_YText;
procedure scale_plot_batch(var spek: spektrum);
procedure change(kastl:TEdit; var x:Fitparameters);
procedure updt(kastl:TEdit; x:double; SIG:byte);
procedure adjust_bottom_weight_fw;
(* procedure add_offset(var spek: spektrum); *)
procedure rescale_measurement(var spek: spektrum);
procedure add_noise(var spek: spektrum);
function  calc_f(x, eta, angle_sun :double):double;
function  calc_f_rs(x, eta, angle_sun, angle_view, Q:double):double;
function  calc_Q_f(f_rs, f:double):double;
procedure norm_mx(var S:Spektrum; Lmin, Lmax : double);
function  calc_gewicht(par_type:byte; P1, P2, LMin, LMax:double):spektrum;
procedure prepare_Ed_temp(out liste:textFile);
procedure save_Ed_temp(var liste:textFile; FName:string; col:integer; f_dd, f_ds:double);
procedure separate_Edd_Eds(var liste:textFile; FName:string);
procedure lies_day(FName:String);
procedure lies_sun(FName:String);
procedure lies_view(FName:String);
procedure lies_dphi(FName:String);
function  sign(x:real):integer;
function  Gauss(dx, sx, A: double):double;
function  Gauss_2D(dx, dy, sx, sy, A: double):single;
function  Integral(var spek: Attr_spec; min, max: double):double;
function  rel_max(a,b:double):double;
procedure resample_Rect(var spek: Attr_spec);
procedure average(var spek: Attr_spec);
procedure set_zero(var spek: Attr_spec);
procedure resample_Gauss(var spek_in: Attr_spec; DirOut: String);
procedure resample_database(DirOut : string);
procedure load_resampled_spectra(pfad: string; channels: integer);
procedure load_single_resampled_file(pfad: string; var spek_in: Attr_spec;
    header: integer; channels: integer);
procedure resample;
procedure Save_Fitresults_as_ASCII(Filename: string);
procedure delete_calculated_spectra;
procedure activate_calculated_spectra;
procedure readlnS(var datei:text; var S: string; CRLF: boolean);
procedure import_LUT(i:byte);
function  bunt(i, N, M:integer):integer;
function  CountFilesInFolder(pattern, path: string): integer;
procedure DeleteAll(Dir, Files: string);


implementation

uses SysUtils, Graphics, Dialogs, Controls, SCHOEN_, fw_calc, invers, CEOS, meltpond;

var  dL    : double;
type s7 = string[7];

procedure complete_vers;
{ Add software architecture info (32bit or 64bit) to version info. }
var sbit : string;
begin
    sbit:=' - ';
    {$IFDEF WIN32}  sbit:=' (32bit) - ' {$ENDIF}
    {$IFDEF WIN64}  sbit:=' (64bit) - ' {$ENDIF}  ;
    vers:=StringReplace(vers, ' - ', sbit, [rfReplaceAll]);
    end;

function ASCII_is_Windows(var fn:string):boolean;
{ Determine type of ASCII file 'fn' according to line break character(s):
  #10 = CR: OSX
  #13 = LF: Linux, Unix
  #10#13 = CRLF: Windows }
const cmax=10000;
var f     : text;
    c, cc : char;
    i     : integer;
begin
    {$i-}
    AssignFile(f, fn);
    FileMode := 0;  {Set file access to read-only. }
    reset(f);
    cc:=#0;
    i:=0;
    repeat
        read(f, c);
        inc(i);
    until (c=#10) or (c=#13) or (i>cmax);
    if (c=#13) then read(f,cc);
    ASCII_is_Windows:=cc=#10;
    CloseFile(f);
    {$i+}
    end;

procedure readlnS(var datei:text; var S: string; CRLF: boolean);
{ Complements 'readln' command to read string 'S' from file 'datei'.
  While 'readln' assumes CR + LF as line break (CRLF=TRUE),
  readlnS also accepts CR (#10) alone (OSX convention) and
  LF (#13) alone (Linux and Unix convention). }
const cmax    = 10000;   { max. number of characters per line }
var i : integer;
    c : char;
begin
    if CRLF then readln(datei, S)
    else begin
        i:=0;
        S:='';
        repeat
            read(datei, c);
            if ((c<>#13) and (c<>#10)) then S:=S+c;
            inc(i);
        until (c=#10) or (c=#13) or (i>cmax);
        end;
    end;

procedure readINIpar(var datei:text; var F:Fitparameters);
begin
    readln(datei, F.fw, F.default, F.actual, F.min, F.max, F.f_step, F.f_err, F.fit, F.sv);
    end;

function LoadINI_public(INI_datei: string):boolean;
{ Load program settings and default values from public INI-file. }
var datei     : text;
    i, j      : integer;
    s9        : string[9];
begin
    LoadINI_public :=FALSE;
    {$i-}
    assignFile(datei, INI_Datei);
    reset(datei);
    if ioresult<>0 then begin
        error_INI:=1;
	MessageBox(0, PChar(INI_Datei), 'ERROR: FILE NOT FOUND', MB_ICONSTOP+MB_OK);
        halt;
        end
    else begin
        error_INI:=0;
        for i:=1 to 6 do readln(datei);
        readln(datei, x^.FName);
        readln(datei, x^.Header);
        readln(datei, x^.XColumn);
        readln(datei, x^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, offsetS^.FName);
        readln(datei, offsetS^.Header);
        readln(datei, offsetS^.XColumn);
        readln(datei, offsetS^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, scaleS^.FName);
        readln(datei, scaleS^.Header);
        readln(datei, scaleS^.XColumn);
        readln(datei, scaleS^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, noiseS^.FName);
        readln(datei, noiseS^.Header);
        readln(datei, noiseS^.XColumn);
        readln(datei, noiseS^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, E0^.FName);
        readln(datei, E0^.Header);
        readln(datei, E0^.XColumn);
        readln(datei, E0^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, aO2^.FName);
        readln(datei, aO2^.Header);
        readln(datei, aO2^.XColumn);
        readln(datei, aO2^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, aO3^.FName);
        readln(datei, aO3^.Header);
        readln(datei, aO3^.XColumn);
        readln(datei, aO3^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, aWV^.FName);
        readln(datei, aWV^.Header);
        readln(datei, aWV^.XColumn);
        readln(datei, aWV^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, a_ice.FName);
        readln(datei, a_ice.Header);
        readln(datei, a_ice.XColumn);
        readln(datei, a_ice.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, aW^.FName);
        readln(datei, aW^.Header);
        readln(datei, aW^.XColumn);
        readln(datei, aW^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, dadT^.FName);
        readln(datei, dadT^.Header);
        readln(datei, dadT^.XColumn);
        readln(datei, dadT^.YColumn);

        for j:=0 to 5 do begin
            for i:=1 to 2 do readln(datei);
            readln(datei, aP[j]^.FName);
            readln(datei, aP[j]^.Header);
            readln(datei, aP[j]^.XColumn);
            readln(datei, aP[j]^.YColumn);
            end;

        for i:=1 to 2 do readln(datei);
        readln(datei, aNAP^.FName);
        readln(datei, aNAP^.Header);
        readln(datei, aNAP^.XColumn);
        readln(datei, aNAP^.YColumn);
        for i:=1 to 2 do readln(datei);
        readln(datei, aY^.FName);
        readln(datei, aY^.Header);
        readln(datei, aY^.XColumn);
        readln(datei, aY^.YColumn);
        for i:=1 to 2 do readln(datei);
        readln(datei, bPhyN^.FName);
        readln(datei, bPhyN^.Header);
        readln(datei, bPhyN^.XColumn);
        readln(datei, bPhyN^.YColumn);
        for i:=1 to 2 do readln(datei);
        readln(datei, bXN^.FName);
        readln(datei, bXN^.Header);
        readln(datei, bXN^.XColumn);
        readln(datei, bXN^.YColumn);
        for j:=0 to 5 do begin
            for i:=1 to 2 do readln(datei);
            readln(datei, albedo[j]^.FName);
            readln(datei, albedo[j]^.Header);
            readln(datei, albedo[j]^.XColumn);
            readln(datei, albedo[j]^.YColumn);
            end;
        for i:=1 to 2 do readln(datei);
        readln(datei, a_nw^.FName);
        readln(datei, a_nw^.Header);
        readln(datei, a_nw^.XColumn);
        readln(datei, a_nw^.YColumn);
        for i:=1 to 2 do readln(datei);
        readln(datei, meas^.FName);
        readln(datei, meas^.Header);
        readln(datei, meas^.XColumn);
        readln(datei, meas^.YColumn);
        readln(datei, line_sun);
        readln(datei, col_sun);
        readln(datei, line_day);
        readln(datei, col_day);
        readln(datei, line_view);
        readln(datei, col_view);
        readln(datei, line_dphi);
        readln(datei, col_dphi);
        for i:=1 to 2 do readln(datei);
        readln(datei, R^.FName);
        readln(datei, R^.Header);
        readln(datei, R^.XColumn);
        readln(datei, R^.YColumn);
        for i:=1 to 2 do readln(datei);
        readln(datei, Ed^.FName);
        readln(datei, Ed^.Header);
        readln(datei, Ed^.XColumn);
        readln(datei, Ed^.YColumn);
        for i:=1 to 2 do readln(datei);
        readln(datei, Ls^.FName);
        readln(datei, Ls^.Header);
        readln(datei, Ls^.XColumn);
        readln(datei, Ls^.YColumn);
        for i:=1 to 2 do readln(datei);
        readln(datei, Kd^.Fname);
        readln(datei, Kd^.Header);
        readln(datei, Kd^.XColumn);
        readln(datei, Kd^.YColumn);
        for i:=1 to 2 do readln(datei);
        readln(datei, Gew^.FName);
        readln(datei, Gew^.Header);
        readln(datei, Gew^.XColumn);
        readln(datei, Gew^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, HSI_img^.FName);

        for i:=1 to 2 do readln(datei);
        readln(datei, file_LUT[1]);

        for i:=1 to 2 do readln(datei);
        readln(datei, file_LUT[2]);

        for i:=1 to 2 do readln(datei);
        readln(datei, Name_LdBatch);
        if not DirectoryExists(ExtractFileDir(Name_LdBatch)) then
        if not CreateDir(ExtractFileDir(Name_LdBatch)) then begin
 //           MessageBox(0, pchar(Name_LdBatch), 'WARNING', MB_OK);
            MessageBox(0, PChar(Name_LdBatch), 'WARNING: Directory does not exist', MB_ICONSTOP+MB_OK);
 //           halt;
            end;

        { Directories }
        for i:=1 to 2 do readln(datei);
        readln(datei, DIR_saveFwd);
            if not DirectoryExists(DIR_saveFwd) then
            if not CreateDir(DIR_saveFwd) then begin
                MessageBox(0, PChar(DIR_saveFwd), 'Cannot create directory', MB_ICONSTOP+MB_OK);
                halt;
                end;
        readln(datei, DIR_saveInv);
            if not DirectoryExists(DIR_saveInv) then
            if not CreateDir(DIR_saveInv) then begin
                MessageBox(0, PChar(DIR_saveInv), 'Cannot create directory', MB_ICONSTOP+MB_OK);
                halt;
                end;
        readln(datei, DIR_saveFit);
            if not DirectoryExists(DIR_saveFit) then
            if not CreateDir(DIR_saveFit) then begin
                MessageBox(0, PChar(DIR_saveFit), 'Cannot create directory', MB_ICONSTOP+MB_OK);
                halt;
                end;

        { General settings and parameters }
        for i:=1 to 2 do readln(datei);
        readln(datei, MinX);
        readln(datei, MaxX);
        readln(datei, MinDX);
        readln(datei, MinY);
        readln(datei, MaxY);
        readln(datei, xu);
        readln(datei, xo);
        readln(datei, yu);
        readln(datei, yo);
        readln(datei, xub);
        readln(datei, xob);
        readln(datei, dxb);
        readln(datei, dsmpl);
        readln(datei, dxs);
        readln(datei, FWHM0);
        readln(datei, FWHM0_min);
        readln(datei, FWHM0_max);
        readln(datei, dotsize);
        readln(datei, dotMaxN);
        readln(datei, PopupDirW);
        readln(datei, Ed_factor);
        readln(datei, E0_factor);
        readln(datei, Rrs_factor);
        readln(datei, i);  spec_type:=spec_types(i);
        readln(datei, Model_Ed);
        readln(datei, Model_R);
        readln(datei, Model_R_rsA);
        readln(datei, Model_R_rsB);
        readln(datei, Model_f);
        readln(datei, Model_f_rs);
        readln(datei, Model_Kdd);
        readln(datei, bottom_fill);
        readln(datei, s9); if s9<>'' then clPlotBk:=StringToColor(trim(s9));
        readln(datei, s9); if s9<>'' then clMaskImg:=StringToColor(trim(s9));      { $002E5A5A }

        { Flags }
        for i:=1 to 2 do readln(datei);
        readln(datei, i); flag_SubGrid:=i=1;
        readln(datei, i); flag_Grid:=i=1;
        readln(datei, i); flag_Dots:=i=1;
        readln(datei, i); flag_Autoscale:=i=1;
        readln(datei, i); flag_ShowFile:=i=1;
        readln(datei, i); flag_ShowPath:=i=1;
        readln(datei, i); flag_leg_left:=i=1;
        readln(datei, i); flag_leg_top:=i=1;
        readln(datei, i); flag_INI:=i=1;
        readln(datei, i); flag_sv_table:=i=1;
        readln(datei, i); flag_save_t:=i=1;
        readln(datei, i); flag_mult_Ed:=i=1;
        readln(datei, i); flag_mult_E0:=i=1;
        readln(datei, i); flag_mult_Rrs:=i=1;
        readln(datei, i); flag_x_file:=i=1;
        readln(datei, i); flag_fwhm:=i=1;
        readln(datei, i); flag_read_day:=i=1;
        readln(datei, i); flag_read_sun:=i=1;
        readln(datei, i); flag_read_view:=i=1;
        readln(datei, i); flag_read_dphi:=i=1;
        readln(datei, i); flag_sun_unit:=i=1;
        readln(datei, i); Par1_log:=i=1;
        readln(datei, i); Par2_log:=i=1;
        readln(datei, i); Par3_log:=i=1;
        readln(datei, i); flag_batch:=i=1;
        readln(datei, i); flag_bunt:=i=1;
        readln(datei, i); flag_b_SaveFwd:=i=1;
        readln(datei, i); flag_b_SaveInv:=i=1;
        readln(datei, i); flag_b_LoadAll:=i=1;
        readln(datei, i); flag_b_Reset:=i=1;
        readln(datei, i); flag_b_Invert:=i=1;
        readln(datei, i); flag_avg_err:=i=1;
        readln(datei, i); flag_multi:=i=1;
        readln(datei, i); flag_Res_log:=i=1;
        readln(datei, i); flag_Y_exp:=i=1;
        readln(datei, i); flag_surf_inv:=i=1;
        readln(datei, i); flag_surf_fw:=i=1;
        readln(datei, i); flag_fluo:=i=1;
        readln(datei, i); flag_MP:=i=1;
        readln(datei, i); flag_use_Ed:=i=1;
        readln(datei, i); flag_use_Ls:=i=1;
        readln(datei, i); flag_use_R:=i=1;
        readln(datei, i); flag_radiom:=i=1;
        readln(datei, i); flag_offset:=i=1;
        readln(datei, i); flag_offset_c:=i=1;
        readln(datei, i); flag_scale:=i=1;
        readln(datei, i); flag_scale_c:=i=1;
        readln(datei, i); flag_noise:=i=1;
        readln(datei, i); flag_noise_c:=i=1;
        readln(datei, i); flag_Tab:=i=1;
        readln(datei, i); flag_aW:=i=1;
        readln(datei, i); flag_above:=i=1;
        readln(datei, i); flag_shallow:=i=1;
        readln(datei, i); flag_L:=i=1;
        readln(datei, i); flag_anX_R:=i=1;
        readln(datei, i); flag_anX_Rsh:=i=1;
        readln(datei, i); flag_anCY_R:=i=1;
        readln(datei, i); flag_anzB:=i=1;
        readln(datei, i); flag_Fresnel_view:=i=1;
        readln(datei, i); flag_bX_file:=i=1;
        readln(datei, i); flag_bX_linear:=i=1;
        readln(datei, i); flag_CXisC0:=i=1;
        readln(datei, i); flag_norm_NAP:=i=1;
        readln(datei, i); flag_norm_Y:=i=1;

        { Batch mode }
        for i:=1 to 2 do readln(datei);
        readln(datei, iter_type);
        readln(datei, rangeMin);
        readln(datei, rangeMax);
        readln(datei, rangeDelta);
        readln(datei, Par1_Type);
        readln(datei, Par2_Type);
        readln(datei, Par3_Type);
        readln(datei, Par1_Min);
        readln(datei, Par2_Min);
        readln(datei, Par3_Min);
        readln(datei, Par1_Max);
        readln(datei, Par2_Max);
        readln(datei, Par3_Max);
        readln(datei, Par1_N);
        readln(datei, Par2_N);
        readln(datei, Par3_N);
        readln(datei, ycol_max);

        { Inverse mode }
        for i:=1 to 3 do readln(datei);
        for i:=1 to FC do readln(datei, fit_min[i], fit_max[i], fit_dL[i], MaxIter[i]);
        for i:=1 to FC do readln(datei, fitsh_min[i], fitsh_max[i], fitsh_dL[i], MaxItersh[i]);
        for i:=1 to 2 do read(datei, LambdaLf[i]);  readln(datei);
        for i:=1 to 2 do read(datei, dLambdaLf[i]); readln(datei);
        readln(datei, LambdaLsh);
        readln(datei, dLambdaLsh);
        for i:=1 to 3 do read(datei, LambdaCY[i]);  readln(datei);
        for i:=1 to 3 do read(datei, dLambdaCY[i]); readln(datei);
        readln(datei, LambdazB);
        readln(datei, dLambdazB);
        readln(datei, zB_inimin);
        readln(datei, CL_inimin);
        readln(datei, C0_inimin);
        readln(datei, CY_inimin);
        readln(datei, a_ini);
        readln(datei, da_ini);
        readln(datei, delta_min);
        readln(datei, SfA_min);
        readln(datei, SfA_max);
        readln(datei, res_max);
        readln(datei, res_mode);

        { Model constants }
        for i:=1 to 2 do readln(datei);
        readln(datei, day); sun_earth:=sqr(1+0.0167*cos(2*pi*(day-3)/365));
        readln(datei, T_W0);
        readln(datei, nW);
        readln(datei, Lambda_a);
        readln(datei, Lambda_0);
        readln(datei, Lambda_L);
        readln(datei, Lambda_S);
        readln(datei, Lambda_f0);
        readln(datei, Sigma_f0);
        readln(datei, Q_a);
        readln(datei, PAR_min);
        readln(datei, PAR_max);
        readln(datei, Lmin);
        readln(datei, Lmax);
        readln(datei, aNAP440);
        readln(datei, bbW500);
        readln(datei, bbX_A);
        readln(datei, bbX_B);
        readln(datei, bb_ice);
        readln(datei, bb_X);
        readln(datei, bb_Mie);
        readln(datei, b_X);
        readln(datei, b_Mie);
        readln(datei, rho0);
        readln(datei, rho1);
        readln(datei, rho2);
        readln(datei, rho_Eu);
        readln(datei, rho_Ed);
        readln(datei, rho_Lu);
        readln(datei, dynamics);
        readln(datei, offset_c);
        readln(datei, scale_c);
        readln(datei, noise_std);
        readln(datei, ldd);
        readln(datei, ldda);
        readln(datei, lddb);
        readln(datei, lds0);
        readln(datei, lds1);
        readln(datei, ld);
        readln(datei, ldd_ice);
        readln(datei, Q_ice_p);
        readln(datei, Q_ice_m);
        for i:=0 to 5 do readln(datei, BRDF[i]);

        { Parameters of 2D module }
        for i:=1 to 2 do readln(datei);
        readln(datei, i); flag_bk_2D:=i=1;
        readln(datei, i); flag_JoinBands:=i=1;
        readln(datei, i); flag_3Bands:=i=1;
        readln(datei, i); flag_LUT:=i=1;
        readln(datei, i); flag_ENVI:=i=1;
        readln(datei, i); flag_use_ROI:=i=1;
        readln(datei, i); flag_scale_ROI:=i=1;
        readln(datei, Width_in);
        readln(datei, Height_in);
        readln(datei, Channels_in);
        readln(datei, Channels_out);
        readln(datei, HSI_header);
        readln(datei, frame_min);
        readln(datei, frame_max);
        readln(datei, pixel_min);
        readln(datei, pixel_max);
        readln(datei, band_R);
        readln(datei, band_G);
        readln(datei, band_B);
        readln(datei, interleave_in);
        readln(datei, interleave_out);
        readln(datei, Datentyp);
        readln(datei, x_scale);
        readln(datei, y_scale);
        readln(datei, band_mask);
        readln(datei, thresh_below);
        readln(datei, thresh_above);
        readln(datei, Plot2D_delta);
        readln(datei, contrast);
        readln(datei, Par0_Type);
        readln(datei, Par0_Min);
        readln(datei, Par0_Max);
        readln(datei, N_avg);

        { Model parameters }
        for i:=1 to 3 do readln(datei);
        for i:=0 to 5 do readINIpar(datei, C[i]);
        readINIpar(datei, C_X);
        readINIpar(datei, C_Mie);
        readINIpar(datei, bbs_phy);
        readINIpar(datei, C_Y);
        readINIpar(datei, S);
        readINIpar(datei, n);
        readINIpar(datei, T_W);
        readINIpar(datei, Q);
        readINIpar(datei, rho_dd);
        readINIpar(datei, rho_L);
        readINIpar(datei, rho_ds);
        readINIpar(datei, beta);
        readINIpar(datei, alpha);
        readINIpar(datei, f_dd);
        readINIpar(datei, f_ds);
        readINIpar(datei, H_oz);
        readINIpar(datei, WV);
        readINIpar(datei, f);
        readINIpar(datei, z);
        readINIpar(datei, zB);
        readINIpar(datei, sun);
        readINIpar(datei, view);
        readINIpar(datei, dphi);
        readINIpar(datei, f_nw);
        for i:=0 to 5 do readINIpar(datei, fA[i]);
        readINIpar(datei, fluo);
        readINIpar(datei, g_dd);
        readINIpar(datei, g_dsr);
        readINIpar(datei, g_dsa);
        readINIpar(datei, dummy);
        CloseFile(datei);
        if ioresult<>0 then begin
            error_ini:=2;
            end
        else LoadINI_public:=TRUE;
        end;
    {$i+}
    for i:=1 to MaxSpectra do farbS[i]:=clBlue;
    end;

function LoadINI_private:boolean;
{ Load program settings and default values from private INI-file. }
var datei     : text;
    i         : integer;
    INI_Datei : string;
    s9        : string[9];
begin
    LoadINI_private :=FALSE;
    INI_Datei:=path_exe + INI_private;
    {$i-}
    assignFile(datei, INI_Datei);
    reset(datei);
    if ioresult<>0 then begin
        error_INI:=1;
	MessageBox(0, PChar(INI_Datei), 'ERROR: FILE NOT FOUND', MB_ICONSTOP+MB_OK);
        halt;
        end
    else begin
        for i:=1 to 6 do readln(datei);
        readln(datei, tA^.FName);
        readln(datei, tA^.Header);
        readln(datei, tA^.XColumn);
        readln(datei, tA^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, tC^.FName);
        readln(datei, tC^.Header);
        readln(datei, tC^.XColumn);
        readln(datei, tC^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, Lpath.FName);
        readln(datei, Lpath.Header);
        readln(datei, Lpath.XColumn);
        readln(datei, Lpath.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, resp.FName);
        readln(datei, resp.Header);
        readln(datei, resp.XColumn);
        readln(datei, resp.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, u_c^.FName);
        readln(datei, u_c^.Header);
        readln(datei, u_c^.XColumn);
        readln(datei, u_c^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, u_t^.FName);
        readln(datei, u_t^.Header);
        readln(datei, u_t^.XColumn);
        readln(datei, u_t^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, u_p^.FName);
        readln(datei, u_p^.Header);
        readln(datei, u_p^.XColumn);
        readln(datei, u_p^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, u_n^.FName);
        readln(datei, u_n^.Header);
        readln(datei, u_n^.XColumn);
        readln(datei, u_n^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, aphA^.FName);
        readln(datei, aphA^.Header);
        readln(datei, aphA^.XColumn);
        readln(datei, aphA^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, aphB^.FName);
        readln(datei, aphB^.Header);
        readln(datei, aphB^.XColumn);
        readln(datei, aphB^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, CMF_r^.FName);
        readln(datei, CMF_r^.Header);
        readln(datei, CMF_r^.XColumn);
        readln(datei, CMF_r^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, CMF_g^.FName);
        readln(datei, CMF_g^.Header);
        readln(datei, CMF_g^.XColumn);
        readln(datei, CMF_g^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, CMF_b^.FName);
        readln(datei, CMF_b^.Header);
        readln(datei, CMF_b^.XColumn);
        readln(datei, CMF_b^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, s_locus^.FName);
        readln(datei, s_locus^.Header);
        readln(datei, s_locus^.XColumn);
        readln(datei, s_locus^.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, ValSet.FName);
        readln(datei, ValSet.Header);
        readln(datei, ValSet.XColumn);
        readln(datei, ValSet.YColumn);
        readln(datei, Val_dotsize);
        readln(datei, s9); if s9<>'' then clPlotBk:=StringToColor(trim(s9));

        for i:=1 to 2 do readln(datei);
        readln(datei, HM.FName);
        readln(datei, HM.Header);
        readln(datei, HM.XColumn);
        readln(datei, HM.YColumn);

        for i:=1 to 2 do readln(datei);
        readln(datei, EEM_ph.Fname);
        readln(datei, EEM_ph.ex_line);
        readln(datei, EEM_ph.em_col);
        readln(datei, EEM_ph.header_l);
        readln(datei, EEM_ph.header_c);

        for i:=1 to 2 do readln(datei);
        readln(datei, EEM_DOM.Fname);
        readln(datei, EEM_DOM.ex_line);
        readln(datei, EEM_DOM.em_col);
        readln(datei, EEM_DOM.header_l);
        readln(datei, EEM_DOM.header_c);

        { General settings and parameters }
        for i:=1 to 2 do readln(datei);
        readln(datei, HM_dim);
        readln(datei, HM_min);
        readln(datei, HM_max);
        readln(datei, Norm_min);
        readln(datei, Norm_max);
        readln(datei, i); flag_Rbottom:=i=1;
        readln(datei, i); flag_2D_ASCII:=i=1;
        readln(datei, i); flag_aph_C:=i=1;
        readln(datei, i); flag_1st_dl:=i=1;
        readln(datei, i); flag_2nd_dl:=i=1;
        readln(datei, i); flag_1st_dp:=i=1;
        readln(datei, i); flag_drel:=i=1;
        readln(datei, i); flag_dnorm:=i=1;
        readln(datei, i); flag_dL:=i=1;
        readln(datei, i); flag_minidot:=i=1;
        readln(datei, i); flag_cut_ROI:=i=1;
        readln(datei, i); flag_Martina:=i=1;
        readln(datei, i); flag_sim_NEL:=i=1;
        readln(datei, test_spec);
        readln(datei, dz_Ed);
        readln(datei, dz_Eu);
        readln(datei, dz_Lu);
        readln(datei, error_x);
        readln(datei, error_dx);
        readln(datei, median_band);

        { Model parameters }
        for i:=1 to 3 do readln(datei);
        readINIpar(datei, alpha_r);
        readINIpar(datei, beta_r);
        readINIpar(datei, gamma_r);
        readINIpar(datei, delta_r);
        readINIpar(datei, alpha_d);
        readINIpar(datei, beta_d);
        readINIpar(datei, gamma_d);
        readINIpar(datei, delta_d);
        readINIpar(datei, test);

        CloseFile(datei);
        end;
    read_sensor_names;
    {$i+}
    end;


procedure writeINI(var i,o: text; wert : s7; mindest:byte);
var n  : byte;
    s  : ShortString;
begin
    readln(i, s);
    for n:=1 to length(wert) do if wert[n]=',' then wert[n]:='.';
//    wert:=wert + ' ';
    if length(s)>=7 then for n:=1 to length(wert) do s[n]:=wert[n];
    for n:=length(wert)+1 to mindest do s[n]:=' ';
    writeln(o, s);
    end;

procedure writeINImult(var i,o: text; text : String);
var n  : byte;
    s  : String;
begin
    readln(i, s);
    for n:=1 to length(text) do s[n]:=' ';
    for n:=1 to length(text) do if text[n]=',' then text[n]:='.';
    for n:=1 to length(text) do s[n]:=text[n];
    writeln(o, s);
    end;

procedure writeINIfile(var i,o: text; text : String);
var n : byte;
begin
    readln(i);
    for n:=1 to length(text) do if text[n]=',' then text[n]:='.';
    writeln(o, text);
    end;

procedure writeINIpar(var i,o: text; F : Fitparameters; TextPos, SIG: byte);
var n     : byte;
    s, st : String;
begin
    readln(i, s);
    st:=' ';
    for n:=TextPos to length(s) do st:=st+s[n];
    writeln(o, schoen(F.fw,SIG):8, ' ',
               schoen(F.default,SIG):8, ' ',
               schoen(F.actual,SIG):8, ' ',
               schoen(F.min,SIG):8, ' ',
               schoen(F.max,SIG):8, ' ',
               schoen(F.f_step,SIG):8, ' ',
               schoen(F.f_err,SIG):8, ' ',
               F.fit:3,
               F.sv:3, '  ',
               st);
    end;


procedure SavePAR_public(vorlage, ausgabe:String);
{ Load parameter comments from file 'vorlage',
  save actual parameter values in file 'ausgabe'. }
var datei_in,
    datei_out : text;
    i, j      : integer;
    s1        : string[1];
    tx, tx1   : String;
begin
    {$i-}
    assignFile(datei_in,  vorlage);
    assignFile(datei_out, ausgabe);
    reset(datei_in);
    rewrite(datei_out);

    for i:=1 to 3 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, 'WASI5_2.EXE ', vers);
    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, x^.Fname);
    writeINI(datei_in, datei_out, IntToStr(x^.Header),  5);
    writeINI(datei_in, datei_out, IntToStr(x^.XColumn), 5);
    writeINI(datei_in, datei_out, IntToStr(x^.YColumn), 5);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, offsetS^.Fname);
    writeINI(datei_in, datei_out, IntToStr(offsetS^.Header),  5);
    writeINI(datei_in, datei_out, IntToStr(offsetS^.XColumn), 5);
    writeINI(datei_in, datei_out, IntToStr(offsetS^.YColumn), 5);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, scaleS^.Fname);
    writeINI(datei_in, datei_out, IntToStr(scaleS^.Header),  5);
    writeINI(datei_in, datei_out, IntToStr(scaleS^.XColumn), 5);
    writeINI(datei_in, datei_out, IntToStr(scaleS^.YColumn), 5);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, noiseS^.Fname);
    writeINI(datei_in, datei_out, IntToStr(noiseS^.Header),  5);
    writeINI(datei_in, datei_out, IntToStr(noiseS^.XColumn), 5);
    writeINI(datei_in, datei_out, IntToStr(noiseS^.YColumn), 5);

    for i:=1 to 102 do writeINI(datei_in, datei_out, '', 0);


    for j:=0 to 5 do begin
        for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
        writeINIfile(datei_in, datei_out, albedo[j]^.FName);
        writeINI(datei_in, datei_out, IntToStr(albedo[j]^.Header),  5);
        writeINI(datei_in, datei_out, IntToStr(albedo[j]^.XColumn), 5);
        writeINI(datei_in, datei_out, IntToStr(albedo[j]^.YColumn), 5);
        end;

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, a_nw^.FName);
    writeINI(datei_in, datei_out, IntToStr(a_nw^.Header),  5);
    writeINI(datei_in, datei_out, IntToStr(a_nw^.XColumn), 5);
    writeINI(datei_in, datei_out, IntToStr(a_nw^.YColumn), 5);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, meas^.FName);
    writeINI(datei_in, datei_out, schoen(meas^.Header,0),  8);
    writeINI(datei_in, datei_out, schoen(meas^.XColumn,0), 8);
    writeINI(datei_in, datei_out, schoen(meas^.YColumn,0), 8);
    writeINI(datei_in, datei_out, schoen(line_sun,0), 8);
    writeINI(datei_in, datei_out, schoen(col_sun,0), 8);
    writeINI(datei_in, datei_out, schoen(line_day,0), 8);
    writeINI(datei_in, datei_out, schoen(col_day,0), 8);
    writeINI(datei_in, datei_out, schoen(line_view, 0), 8);
    writeINI(datei_in, datei_out, schoen(col_view, 0), 8);
    writeINI(datei_in, datei_out, schoen(line_dphi, 0), 8);
    writeINI(datei_in, datei_out, schoen(col_dphi, 0), 8);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, R^.FName);
    writeINI(datei_in, datei_out, schoen(R^.Header,0),  8);
    writeINI(datei_in, datei_out, schoen(R^.XColumn,0), 8);
    writeINI(datei_in, datei_out, schoen(R^.YColumn,0), 8);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, Ed^.FName);
    writeINI(datei_in, datei_out, schoen(Ed^.Header,0),  8);
    writeINI(datei_in, datei_out, schoen(Ed^.XColumn,0), 8);
    writeINI(datei_in, datei_out, schoen(Ed^.YColumn,0), 8);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, Ls^.FName);
    writeINI(datei_in, datei_out, schoen(Ls^.Header,0),  8);
    writeINI(datei_in, datei_out, schoen(Ls^.XColumn,0), 8);
    writeINI(datei_in, datei_out, schoen(Ls^.YColumn,0), 8);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, Kd^.Fname);
    writeINI(datei_in, datei_out, schoen(Kd^.Header,0),  8);
    writeINI(datei_in, datei_out, schoen(Kd^.XColumn,0), 8);
    writeINI(datei_in, datei_out, schoen(Kd^.YColumn,0), 8);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, Gew^.FName);
    writeINI(datei_in, datei_out, schoen(Gew^.Header,0),  8);
    writeINI(datei_in, datei_out, schoen(Gew^.XColumn,0), 8);
    writeINI(datei_in, datei_out, schoen(Gew^.YColumn,0), 8);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, HSI_img^.FName);
    
    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, file_LUT[1]);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINIfile(datei_in, datei_out, file_LUT[2]);

    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, Name_LdBatch);

    { Directories }
    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, DIR_saveFwd);
    readln(datei_in);  writeln(datei_out, DIR_saveInv);
    readln(datei_in);  writeln(datei_out, DIR_saveFit);

    { General settings and parameters }
    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINI(datei_in, datei_out, schoen(MinX,  3), 8);
    writeINI(datei_in, datei_out, schoen(MaxX,  3), 8);
    writeINI(datei_in, datei_out, schoen(MinDX,  2), 8);
    writeINI(datei_in, datei_out, schoen(MinY,  1), 8);
    writeINI(datei_in, datei_out, schoen(MaxY,  1), 8);
    writeINI(datei_in, datei_out, schoen(xu,  3), 8);
    writeINI(datei_in, datei_out, schoen(xo,  3), 8);
    writeINI(datei_in, datei_out, schoen(yu,  2), 8);
    writeINI(datei_in, datei_out, schoen(yo,  2), 8);
    writeINI(datei_in, datei_out, schoen(xub,  3), 8);
    writeINI(datei_in, datei_out, schoen(xob,  3), 8);
    writeINI(datei_in, datei_out, schoen(dxb,  3), 8);
    writeINI(datei_in, datei_out, schoen(dsmpl, 0), 8);
    writeINI(datei_in, datei_out, schoen(dxs,  0), 8);
    writeINI(datei_in, datei_out, schoen(FWHM0,  3), 8);
    writeINI(datei_in, datei_out, schoen(FWHM0_min, 3), 8);
    writeINI(datei_in, datei_out, schoen(FWHM0_max, 3), 8);
    writeINI(datei_in, datei_out, schoen(dotsize,  1), 8);
    writeINI(datei_in, datei_out, schoen(dotMaxN,  1), 8);
    writeINI(datei_in, datei_out, schoen(PopupDirW,  3), 8);
    writeINI(datei_in, datei_out, schoen(Ed_factor, 5), 8);
    writeINI(datei_in, datei_out, schoen(E0_factor, 5), 8);
    writeINI(datei_in, datei_out, schoen(Rrs_factor, 5), 8);
    i:=0; while (spec_type<>spec_types(i)) and (i<N_spectypes-1) do inc(i);
    writeINI(datei_in, datei_out, schoen(i, 0), 8);
    writeINI(datei_in, datei_out, schoen(Model_Ed, 0), 8);
    writeINI(datei_in, datei_out, schoen(Model_R, 0), 8);
    writeINI(datei_in, datei_out, schoen(Model_R_rsA, 0), 8);
    writeINI(datei_in, datei_out, schoen(Model_R_rsB, 0), 8);
    writeINI(datei_in, datei_out, schoen(Model_f, 0), 8);
    writeINI(datei_in, datei_out, schoen(Model_f_rs, 0), 8);
    writeINI(datei_in, datei_out, schoen(Model_Kdd, 0), 8);
    writeINI(datei_in, datei_out, schoen(bottom_fill, 0), 8);
    writeINImult(datei_in, datei_out, Format('%9s', [ColorToString(clPlotBk)]));
    writeINImult(datei_in, datei_out, Format('%9s', [ColorToString(clMaskImg)]));

    { Flags }
    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    if flag_SubGrid   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_Grid      then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_Dots      then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_Autoscale then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_ShowFile  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_ShowPath  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_leg_left  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_leg_top   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_INI       then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_sv_table  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_save_t    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_mult_Ed   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_mult_E0   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_mult_Rrs  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_x_file    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_fwhm      then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_read_day  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_read_sun  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_read_view then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_read_dphi then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_sun_unit  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if Par1_log       then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if Par2_log       then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if Par3_log       then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_batch     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_bunt      then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_b_SaveFwd then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_b_SaveInv then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_b_LoadAll then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_b_Reset   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_b_Invert  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_avg_err   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_multi     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_Res_log   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_Y_exp     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_surf_inv  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_surf_fw   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_fluo      then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_MP        then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_use_Ed    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_use_Ls    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_use_R     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_radiom    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_offset    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_offset_c  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_scale     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_scale_c   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_noise     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_noise_c   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_Tab       then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_aW        then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_above     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_shallow   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_L         then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_anX_R     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_anX_Rsh   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_anCY_R    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_anzB      then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_Fresnel_view then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_bX_file   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_bX_linear then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_CXisC0    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_norm_NAP  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_norm_Y    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);

    { Batch mode }
    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINI(datei_in, datei_out, IntToStr(iter_type), 8);
    writeINI(datei_in, datei_out, schoen(RangeMin,  2), 8);
    writeINI(datei_in, datei_out, schoen(RangeMax,  2), 8);
    writeINI(datei_in, datei_out, schoen(RangeDelta,  3), 8);
    writeINI(datei_in, datei_out, IntToStr(Par1_Type), 8);
    writeINI(datei_in, datei_out, IntToStr(Par2_Type), 8);
    writeINI(datei_in, datei_out, IntToStr(Par3_Type), 8);
    writeINI(datei_in, datei_out, schoen(Par1_Min, 3), 8);
    writeINI(datei_in, datei_out, schoen(Par2_Min, 3), 8);
    writeINI(datei_in, datei_out, schoen(Par3_Min, 3), 8);
    writeINI(datei_in, datei_out, schoen(Par1_Max, 3), 8);
    writeINI(datei_in, datei_out, schoen(Par2_Max, 3), 8);
    writeINI(datei_in, datei_out, schoen(Par3_Max, 3), 8);
    writeINI(datei_in, datei_out, IntToStr(Par1_N), 8);
    writeINI(datei_in, datei_out, IntToStr(Par2_N), 8);
    writeINI(datei_in, datei_out, IntToStr(Par3_N), 8);
    writeINI(datei_in, datei_out, IntToStr(ycol_max), 8);

    { Inverse mode }
    for i:=1 to 3 do writeINI(datei_in, datei_out, '', 0);
    for i:=1 to FC do begin
        str(round(fit_min[i]), tx);
        str(round(fit_max[i]):7, tx1); tx:=tx+tx1;
        str(fit_dL[i]:6, tx1);  tx:=tx+tx1;
        str(MaxIter[i]:6, tx1);  tx:=tx+tx1;
        writeINImult(datei_in, datei_out, tx);
        end;
    for i:=1 to FC do begin
        str(round(fitsh_min[i]), tx);
        str(round(fitsh_max[i]):7, tx1); tx:=tx+tx1;
        str(fitsh_dL[i]:6, tx1);  tx:=tx+tx1;
        str(MaxItersh[i]:6, tx1);  tx:=tx+tx1;
        writeINImult(datei_in, datei_out, tx);
        end;
    str(round(LambdaLf[1]), tx);
    str(round(LambdaLf[2]):7, tx1); tx:=tx+tx1;
    writeINImult(datei_in, datei_out, tx);
    str(round(dLambdaLf[1]), tx);
    str(round(dLambdaLf[2]):7, tx1); tx:=tx+tx1;
    writeINImult(datei_in, datei_out, tx);
    writeINI(datei_in, datei_out, FloatToStrF(LambdaLsh, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(dLambdaLsh, ffFixed, 3, 0), 8);

    str(round(LambdaCY[1]), tx);
    str(round(LambdaCY[2]):7, tx1); tx:=tx+tx1;
    str(round(LambdaCY[3]):7, tx1); tx:=tx+tx1;
    writeINImult(datei_in, datei_out, tx);
    str(round(dLambdaCY[1]), tx);
    str(round(dLambdaCY[2]):7, tx1); tx:=tx+tx1;
    str(round(dLambdaCY[3]):7, tx1); tx:=tx+tx1;
    writeINImult(datei_in, datei_out, tx);
    writeINI(datei_in, datei_out, FloatToStrF(LambdazB, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(dLambdazB, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, schoen(zB_inimin, 2), 8);
    writeINI(datei_in, datei_out, schoen(CL_inimin, 2), 8);
    writeINI(datei_in, datei_out, schoen(C0_inimin, 2), 8);
    writeINI(datei_in, datei_out, schoen(CY_inimin, 2), 8);
    writeINI(datei_in, datei_out, schoen(a_ini, 2), 8);
    writeINI(datei_in, datei_out, schoen(da_ini, 2), 8);
    writeINI(datei_in, datei_out, schoen(delta_min, 2), 8);
    writeINI(datei_in, datei_out, schoen(SfA_min, 2), 8);
    writeINI(datei_in, datei_out, schoen(SfA_max, 2), 8);
    writeINI(datei_in, datei_out, schoen(res_max, 2), 8);
    writeINI(datei_in, datei_out, schoen(res_mode, 0), 8);

    { Model constants }
    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    writeINI(datei_in, datei_out, IntToStr(day), 8);
    writeINI(datei_in, datei_out, FloatToStrF(T_W0, ffFixed, 4, 1), 8);
    writeINI(datei_in, datei_out, FloatToStrF(nW, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Lambda_a, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Lambda_0, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Lambda_L, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Lambda_S, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Lambda_f0, ffFixed, 5, 1), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Sigma_f0, ffFixed, 5, 2), 8);
    writeINI(datei_in, datei_out, schoen(Q_a, 3), 8);
    writeINI(datei_in, datei_out, FloatToStrF(PAR_min, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(PAR_max, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Lmin,   ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Lmax,   ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(aNAP440, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(bbW500, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(bbX_A, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(bbX_B, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(bb_ice, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(bb_X, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(bb_Mie, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(b_X, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(b_Mie, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(rho0, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(rho1, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(rho2, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(rho_Eu, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(rho_Ed, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(rho_Lu, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(dynamics, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(offset_c, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(scale_c, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(noise_std, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(ldd,   ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(ldda,  ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(lddb,  ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(lds0,  ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(lds1,  ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(ld,    ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(ldd_ice, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Q_ice_p, ffFixed, 7, 5), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Q_ice_m, ffFixed, 7, 5), 8);
    for i:=0 to 5 do writeINI(datei_in, datei_out, schoen(BRDF[i], 5), 8);

    { Parameters of 2D module }
    for i:=1 to 2 do writeINI(datei_in, datei_out, '', 0);
    if flag_bk_2D then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_JoinBands then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_3Bands then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_LUT then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_ENVI then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_use_ROI   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_scale_ROI then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    writeINI(datei_in, datei_out, IntToStr(Width_in), 8);
    writeINI(datei_in, datei_out, IntToStr(Height_in), 8);
    writeINI(datei_in, datei_out, IntToStr(Channels_in), 8);
    writeINI(datei_in, datei_out, IntToStr(Channels_out), 8);
    writeINI(datei_in, datei_out, IntToStr(HSI_Header), 8);
    writeINI(datei_in, datei_out, IntToStr(frame_min), 8);
    if frame_max=Height_in-1 then writeINI(datei_in, datei_out, '0', 8)
        else writeINI(datei_in, datei_out, IntToStr(frame_max), 8);
    writeINI(datei_in, datei_out, IntToStr(pixel_min), 8);
    if pixel_max=Width_in-1 then writeINI(datei_in, datei_out, '0', 8)
        else writeINI(datei_in, datei_out, IntToStr(pixel_max), 8);
    writeINI(datei_in, datei_out, IntToStr(band_R), 8);
    writeINI(datei_in, datei_out, IntToStr(band_G), 8);
    writeINI(datei_in, datei_out, IntToStr(band_B), 8);
    writeINI(datei_in, datei_out, FloatToStrF(interleave_in, ffFixed, 1, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(interleave_out, ffFixed, 1, 0), 8);
    writeINI(datei_in, datei_out, FloatToStrF(Datentyp, ffFixed, 1, 0), 8);
    writeINI(datei_in, datei_out, schoen(x_scale, 2), 8);;
    writeINI(datei_in, datei_out, schoen(y_scale, 4), 8);
    writeINI(datei_in, datei_out, FloatToStrF(band_mask, ffFixed, 3, 0), 8);
    writeINI(datei_in, datei_out, schoen(thresh_below, 0), 8);
    writeINI(datei_in, datei_out, schoen(thresh_above, 1), 8);
    writeINI(datei_in, datei_out, IntToStr(Plot2D_delta), 8);
    writeINI(datei_in, datei_out, FloatToStrF(contrast, ffFixed, 4, 2), 8);
    writeINI(datei_in, datei_out, IntToStr(Par0_Type), 8);
    writeINI(datei_in, datei_out, schoen(Par0_Min, 3), 8);
    writeINI(datei_in, datei_out, schoen(Par0_Max, 3), 8);
    writeINI(datei_in, datei_out, IntToStr(N_avg), 8);

    { Model parameters }
    for i:=1 to 3 do writeINI(datei_in, datei_out, '', 0);
    for i:=0 to 5 do writeINIpar(datei_in, datei_out, C[i],  73, 3);
    writeINIpar(datei_in, datei_out, C_X,  73, 3);
    writeINIpar(datei_in, datei_out, C_Mie, 73, 3);
    writeINIpar(datei_in, datei_out, bbs_phy, 73, 3);
    writeINIpar(datei_in, datei_out, C_Y,  73, 3);
    writeINIpar(datei_in, datei_out, S,    73, 3);
    writeINIpar(datei_in, datei_out, n,    73, 3);
    writeINIpar(datei_in, datei_out, T_W,  73, 3);
    writeINIpar(datei_in, datei_out, Q,    73, 3);
    writeINIpar(datei_in, datei_out, rho_dd, 73, 3);
    writeINIpar(datei_in, datei_out, rho_L, 73, 3);
    writeINIpar(datei_in, datei_out, rho_ds, 73, 3);
    writeINIpar(datei_in, datei_out, beta,  73, 4);
    writeINIpar(datei_in, datei_out, alpha, 73, 4);
    writeINIpar(datei_in, datei_out, f_dd,  73, 3);
    writeINIpar(datei_in, datei_out, f_ds,  73, 3);
    writeINIpar(datei_in, datei_out, H_oz,  73, 3);
    writeINIpar(datei_in, datei_out, WV,    73, 3);
    writeINIpar(datei_in, datei_out, f,     73, 3);
    writeINIpar(datei_in, datei_out, z,     73, 3);
    writeINIpar(datei_in, datei_out, zB,    73, 3);
    writeINIpar(datei_in, datei_out, sun,   73, 3);
    writeINIpar(datei_in, datei_out, view,  73, 3);
    writeINIpar(datei_in, datei_out, dphi,  73, 3);
    writeINIpar(datei_in, datei_out, f_nw,  73, 3);
    for i:=0 to 5 do
        writeINIpar(datei_in, datei_out, fA[i], 73, 3);
    writeINIpar(datei_in, datei_out, fluo,  73, 3);
    writeINIpar(datei_in, datei_out, g_dd,  73, 3);
    writeINIpar(datei_in, datei_out, g_dsr, 73, 3);
    writeINIpar(datei_in, datei_out, g_dsa, 73, 3);
    writeINIpar(datei_in, datei_out, dummy, 73, 3);
    CloseFile(datei_out);
    CloseFile(datei_in);
    {$i+}
    end;

procedure SavePAR_private(vorlage, ausgabe:String);
{ Load parameter comments from file 'vorlage',
  save actual parameter values in file 'ausgabe'. }
var datei_in,
    datei_out : text;
    i         : integer;
    s1        : string[1];
begin
    {$i-}
    assignFile(datei_in,  vorlage);
    assignFile(datei_out, ausgabe);
    reset(datei_in);
    rewrite(datei_out);

    for i:=1 to 3 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, 'WASI5_2.EXE ', vers);
    for i:=1 to 86 do writeINI(datei_in, datei_out, '', 0);

    readln(datei_in);  writeln(datei_out, ValSet.Fname);
    for i:=1 to 7 do writeINI(datei_in, datei_out, '', 0);
    readln(datei_in);  writeln(datei_out, HM.Fname);

    for i:=1 to 19 do writeINI(datei_in, datei_out, '', 0);

    { General settings and parameters }
    writeINI(datei_in, datei_out, schoen(HM_dim, 2), 8);
    writeINI(datei_in, datei_out, schoen(HM_min, 3), 8);
    writeINI(datei_in, datei_out, schoen(HM_max, 3), 8);
    writeINI(datei_in, datei_out, schoen(norm_min, 3), 8);
    writeINI(datei_in, datei_out, schoen(norm_max, 3), 8);
    if flag_Rbottom   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_2D_ASCII  then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_aph_C     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_1st_dl    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_2nd_dl    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_1st_dp    then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_drel      then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_dnorm     then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_dL        then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_minidot   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_cut_ROI   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_Martina   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    if flag_sim_NEL   then s1:='1' else s1:='0'; writeINI(datei_in, datei_out, s1, 8);
    writeINI(datei_in, datei_out, schoen(test_spec, 0), 8);
    writeINI(datei_in, datei_out, schoen(dz_Ed, 3), 8);
    writeINI(datei_in, datei_out, schoen(dz_Eu, 3), 8);
    writeINI(datei_in, datei_out, schoen(dz_Lu, 3), 8);
    writeINI(datei_in, datei_out, schoen(error_x, 3), 8);
    writeINI(datei_in, datei_out, schoen(error_dx, 3), 8);
    writeINI(datei_in, datei_out, schoen(median_band, 0), 8);

    { Model parameters }
    for i:=1 to 3 do writeINI(datei_in, datei_out, '', 0);
    writeINIpar(datei_in, datei_out, alpha_r, 73, 3);
    writeINIpar(datei_in, datei_out, beta_r, 73, 3);
    writeINIpar(datei_in, datei_out, gamma_r, 73, 3);
    writeINIpar(datei_in, datei_out, delta_r, 73, 3);
    writeINIpar(datei_in, datei_out, alpha_d, 73, 3);
    writeINIpar(datei_in, datei_out, beta_d,  73, 3);
    writeINIpar(datei_in, datei_out, gamma_d, 73, 3);
    writeINIpar(datei_in, datei_out, delta_d, 73, 3);
    writeINIpar(datei_in, datei_out, test,  73, 3);

    CloseFile(datei_out);
    CloseFile(datei_in);
    {$i+}
    end;

procedure SaveINI(flag_public:boolean);
{ Save INI file }
var new, old : string;
begin
    if flag_public then
        new:=path_exe + INI_public else
        new:=path_exe + INI_private;
    old:=new + '.bak';
    if FileExists(old) then DeleteFile(old);
    renameFile(new, old);
    if flag_public then
        SavePAR_public(old, new) else
        SavePAR_private(old, new);
    end;

procedure saveSpecFw(name:String);
{ Save spectra of forward calculation }
var datei : text;
    nr, k : integer;
    fitp  : boolean;
begin
    {$i-}
    assignFile(datei, name);
    rewrite(datei);
    fitp:=AnsiUpperCase(ExtractFileExt(HSI_img^.FName))='.FIT';

    if flag_extract then begin { spectrum 'spec' was extracted from image }
        writeln(datei, 'This file was generated by the program WASI');
        writeln(datei, vers);
        writeln(datei);
        if flag_avg then begin
            if fitp then
                 writeln(datei, 'Average fit parameters of selected image pixels')
            else writeln(datei, 'Average spectrum of selected image pixels');
            writeln(datei, 'Image: ', spec[1]^.FName);
            writeln(datei, 'Selected rectangle: (', pixel_min, ',', frame_min,
                '), (', pixel_max, ',', frame_max, ')');
            writeln(datei);
            if fitp then writeln(datei, 'Fit parameter', #9, 'mean', #9, 'sigma')
                    else writeln(datei, 'Lambda', #9, 'mean', #9, 'sigma')
            end
        else begin
            if fitp then
                 writeln(datei, 'Parameters extracted from image ', spec[1]^.FName)
            else writeln(datei, 'Spectrum extracted from image ', spec[1]^.FName);
            if flag_public then
                writeln(datei, 'Selected pixel: (', pixel_min, ',', frame_min, ')');
            writeln(datei);
            if flag_CEOS and not flag_public then begin
                write(datei, 'Lambda', #9);
                for nr:=1 to NSpectra do write(datei, bandname[nr], #9);
                writeln(datei);
                end
            end;
        end
    else begin
        writeln(datei, YText);
        writeln(datei);
        writeln(datei, 'This file was generated by the program WASI');
        writeln(datei, vers);
        writeln(datei, 'Documentation in directory:  ', DIR_saveFwd);
        writeln(datei, 'Parameter values in files:   ', INI_public, ', ', CHANGES);
        writeln(datei, 'Screenshot of plot in file:  ', SCREENSHOT);
        writeln(datei, 'Average from ', Lmin, ' to ', Lmax, ' nm');
        writeln(datei);

        if NSpectra>0 then begin
            write(datei, 'No.', #9);
            for nr:=1 to NSpectra do write(datei, nr, #9);
            writeln(datei);
            end;
        write(datei, 'Avg', #9);
        for nr:=1 to NSpectra do write(datei, schoen(spec[nr]^.avg,4), #9);
        writeln(datei);
        writeln(datei);
        end;

    k:=1;
    while k<=Channel_number do begin
        if flag_public then begin
            if fitp then write(datei, bandname[k], #9)
                else write(datei, x^.y[k]:5:2, #9);
            end
        else if {flag_CEOS and} not flag_public then write(datei, x^.y[k]:5:2, #9);

        for nr:=1 to NSpectra do
             write(datei, schoen(spec[nr]^.y[k],4), #9);
        writeln(datei);
        k:=k+dxs;
        end;
    CloseFile(datei);
    {$i+}
    end;


procedure saveSpecInv(name:String);
{ Save spectra of invers calculation }
var datei : text;
    nr, k : integer;
begin
    {$i-}
    assignFile(datei, name);
    rewrite(datei);
    writeln(datei, YText);
    writeln(datei);
    writeln(datei, 'This file was generated by the program WASI');
    writeln(datei, vers);
    writeln(datei, 'Parameter values in files: ', INI_public, ', ', FITPARS);
    writeln(datei);
    if flag_scale then writeln(datei, 'Measured spectrum was multiplied with ',
        ScaleS^. FName) else writeln(datei);
    writeln(datei);
    (*
    writeln(datei, 'Parameters determined during inverse modeling:');
    writeln(datei, 'p1 = ', a^.ParText);
    writeln(datei, 'p2 = ', a_calc^.ParText);
    writeln(datei, 'p3 = ', bb_calc^.ParText);
    writeln(datei, 'p4 = ', Kd^.ParText);
    writeln(datei);
    *)
    if flag_b_LoadAll then write(datei, 'Lambda', #9, 'Meas.', #9)
                      else write(datei, 'Lambda', #9, 'fwd', #9);
 (*   writeln(datei, 'Fit', #9, 'p1', #9, 'p2', #9, 'p3', #9, 'p4'); *)
    writeln(datei, 'Fit', #9, 'Rrs_surf', #9, 'R_rs');
 (*   write(datei, 'Mean', #9);
    for nr:=1 to 2 do write(datei, schoen(spec[nr]^.avg,4), #9);
    writeln(datei);        *)

    writeln(datei);
    for k:=1 to Channel_number do begin
        write(datei, x^.y[k]:5:2, #9);
        for nr:=1 to 2 do
             write(datei, schoen(spec[nr]^.y[k],4), #9);
        write(datei, schoen(Rrs_surf^.y[k],4), #9);
        write(datei, schoen(spec[1]^.y[k]-Rrs_surf^.y[k],4), #9);
        (*                      R_rs^.y[k]
        write(datei, schoen(a^.y[k],4), #9);
        write(datei, schoen(a_calc^.y[k],4), #9);
        write(datei, schoen(bb_calc^.y[k],4), #9);
        write(datei, schoen(Kd^.y[k],4), #9);
        *)
        writeln(datei);
        end;
    CloseFile(datei);
    {$i+}
    end;


procedure openCHANGES(pfad:String);
begin
    if not DirectoryExists(pfad) then
    if not CreateDir(pfad) then begin
        MessageBox(0, PChar(pfad), 'Cannot create directory', MB_ICONSTOP+MB_OK);
        halt;
        end;

    {$i-}
    assignFile(fileChanges, pfad+CHANGES);
    rewrite(fileChanges);
    writeln(fileChanges, 'This file was generated by the program WASI');
    writeln(fileChanges, vers);
    writeln(fileChanges);
    writeln(fileChanges, 'List of parameter values which differ',
                        ' from one spectrum to the next');
    writeln(fileChanges, 'Common parameter set of all spectra in file: ', INI_public);
    writeln(fileChanges, 'All spectra are the results of forward calculations');
    writeln(fileChanges, 'Spectra = ', YText);
    writeln(fileChanges);
    if NSpectra>0 then begin
        write(fileChanges, 'Spectrum':10);
        if Par1_Type<>0 then write(fileChanges, par.name[Par1_Type]:10);
        if Par2_Type<>0 then write(fileChanges, par.name[Par2_Type]:10);
        if Par3_Type<>0 then write(fileChanges, par.name[Par3_Type]:10);
        writeln(fileChanges);
        writeln(fileChanges);
        end;
    {$i+}
    end;

procedure saveCHANGES(spektrum:String; c1, c2, c3: double);
begin
    write(fileChanges, spektrum:10);
    if Par1_Type<>0 then write(fileChanges, schoen(c1,4):10);
    if Par2_Type<>0 then write(fileChanges, schoen(c2,4):10);
    if Par3_Type<>0 then write(fileChanges, schoen(c3,4):10);
    writeln(fileChanges);
    end;

procedure init_acc;
var i : integer;
begin
    acc_N      :=0;
    acc_iter   :=0;
    acc_iterM  :=0;
    acc_resid  :=0;
    acc_residM :=0;
    acc_fill   :=0;
    acc_fillM  :=0;
    acc_fills  :=0;
    acc_fillsM :=0;
    for i:=1 to 3 do begin
        acc_fsum[i]:=0;
        acc_fmax[i]:=0;
        end;
    for i:=1 to M1 do begin
        acc_isum[i]:=0;
        acc_imax[i]:=0;
        acc_esum[i]:=0;
        acc_emax[i]:=0;
        end;
    end;

procedure openFITPARS(pfad:String);
var   i  : integer;
      st : String;
begin
    if not DirectoryExists(pfad) then
    if not CreateDir(pfad) then begin
        MessageBox(0, PChar(pfad), 'Cannot create directory', MB_ICONSTOP+MB_OK);
        halt;
        end;

    {$i-}
    assignFile(fileFitpars, pfad+FITPARS);
    rewrite(fileFitpars);
    writeln(fileFitpars, 'This file was generated by the program WASI');
    writeln(fileFitpars, vers);
    writeln(fileFitpars);
    writeln(fileFitpars, 'List of fitted parameters which may differ',
                        ' from one spectrum to the next');
    writeln(fileFitpars, 'Common parameter set of all spectra in file: ', INI_public);
    if flag_b_loadAll=FALSE then  { reconstruction mode }
        writeln(fileFitpars, 'Errors are given in %: error = 100*(inv/fwd-1)');
    if Par1_Type=0 then writeln(fileFitpars, 'Input Files: ', Name_LdBatch);
    writeln(fileFitpars);

    write(fileFitpars, #9, #9);
    if Par1_Type<>0 then write(fileFitpars, 'fwd', #9);
    if Par2_Type<>0 then write(fileFitpars, 'fwd', #9);
    if Par3_Type<>0 then write(fileFitpars, 'fwd', #9);
    if flag_shallow and (bottom_fill>=0) then write(fileFitpars, 'fwd', #9);

    if flag_multi then write(fileFitpars, #9);
    write(fileFitpars, 'inv', #9);
    if flag_Kd_PAR then write(fileFitpars, #9);
    if flag_Secchi then write(fileFitpars, #9);
    for i:=0 to 5 do
        if C[i].fit=1  then write(fileFitpars, 'inv', #9);
    if C_X.fit=1       then write(fileFitpars, 'inv', #9);
    if C_Mie.fit=1     then write(fileFitpars, 'inv', #9);
    if C_Y.fit=1       then write(fileFitpars, 'inv', #9);
    if S.fit=1         then write(fileFitpars, 'inv', #9);
    if n.fit=1         then write(fileFitpars, 'inv', #9);
    if T_W.fit=1       then write(fileFitpars, 'inv', #9);
    if Q.fit=1         then write(fileFitpars, 'inv', #9);
    if fluo.fit=1      then write(fileFitpars, 'inv', #9);
    if rho_L.fit=1     then write(fileFitpars, 'inv', #9);
    if rho_dd.fit=1    then write(fileFitpars, 'inv', #9);
    if rho_ds.fit=1    then write(fileFitpars, 'inv', #9);
    if beta.fit=1      then write(fileFitpars, 'inv', #9);
    if alpha.fit=1     then write(fileFitpars, 'inv', #9);
    if f_dd.fit=1      then write(fileFitpars, 'inv', #9);
    if f_ds.fit=1      then write(fileFitpars, 'inv', #9);
    if H_oz.fit=1      then write(fileFitpars, 'inv', #9);
    if WV.fit=1        then write(fileFitpars, 'inv', #9);
    if f.fit=1         then write(fileFitpars, 'inv', #9);
    if z.fit=1         then write(fileFitpars, 'inv', #9);
    if zB.fit=1        then write(fileFitpars, 'inv', #9);
    if sun.fit=1       then write(fileFitpars, 'inv', #9);
    if view.fit=1      then write(fileFitpars, 'inv', #9);
    for i:=0 to 5 do  if fA[i].fit=1 then write(fileFitpars, 'inv', #9);
    if bbs_phy.fit=1   then write(fileFitpars, 'inv', #9);
    if g_dd.fit=1      then write(fileFitpars, 'inv', #9);
    if g_dsr.fit=1     then write(fileFitpars, 'inv', #9);
    if g_dsa.fit=1     then write(fileFitpars, 'inv', #9);
    if f_nw.fit=1      then write(fileFitpars, 'inv', #9);
    if not flag_public then begin
        if dphi.fit=1      then write(fileFitpars, 'inv', #9);
        if alpha_r.fit=1  then write(fileFitpars, 'inv', #9);
        if beta_r.fit=1   then write(fileFitpars, 'inv', #9);
        if gamma_r.fit=1  then write(fileFitpars, 'inv', #9);
        if delta_r.fit=1  then write(fileFitpars, 'inv', #9);
        if alpha_d.fit=1  then write(fileFitpars, 'inv', #9);
        if beta_d.fit=1   then write(fileFitpars, 'inv', #9);
        if gamma_d.fit=1  then write(fileFitpars, 'inv', #9);
        if delta_d.fit=1  then write(fileFitpars, 'inv', #9);
        if dummy.fit=1    then write(fileFitpars, 'inv', #9);
        if test.fit=1     then write(fileFitpars, 'inv', #9);
        end;

    if flag_shallow and (spec_type in [S_Lup, S_Rrs, S_R, S_Rbottom]) then
        write(fileFitpars, 'sum', #9);

    if flag_b_loadAll=FALSE then begin  { reconstruction mode }
        for i:=0 to 5 do
            if C[i].sv=1  then write(fileFitpars, 'error', #9);
        if C_X.sv=1       then write(fileFitpars, 'error', #9);
        if C_Mie.sv=1     then write(fileFitpars, 'error', #9);
        if C_Y.sv=1       then write(fileFitpars, 'error', #9);
        if S.sv=1         then write(fileFitpars, 'error', #9);
        if n.sv=1         then write(fileFitpars, 'error', #9);
        if T_W.sv=1       then write(fileFitpars, 'error', #9);
        if Q.sv=1         then write(fileFitpars, 'error', #9);
        if fluo.sv=1      then write(fileFitpars, 'error', #9);
        if rho_L.sv=1     then write(fileFitpars, 'error', #9);
        if rho_dd.sv=1    then write(fileFitpars, 'error', #9);
        if rho_ds.sv=1    then write(fileFitpars, 'error', #9);
        if beta.sv=1      then write(fileFitpars, 'error', #9);
        if alpha.sv=1     then write(fileFitpars, 'error', #9);
        if f_dd.sv=1      then write(fileFitpars, 'error', #9);
        if f_ds.sv=1      then write(fileFitpars, 'error', #9);
        if H_oz.sv=1      then write(fileFitpars, 'error', #9);
        if WV.sv=1        then write(fileFitpars, 'error', #9);
        if f.sv=1         then write(fileFitpars, 'error', #9);
        if z.sv=1         then write(fileFitpars, 'error', #9);
        if zB.sv=1        then write(fileFitpars, 'error', #9);
        if sun.sv=1       then write(fileFitpars, 'error', #9);
        if view.sv=1      then write(fileFitpars, 'error', #9);
        for i:=0 to 5 do
            if fA[i].sv=1 then write(fileFitpars, 'error', #9);
        if bbs_phy.sv=1   then write(fileFitpars, 'error', #9);
        if g_dd.sv=1     then write(fileFitpars, 'error', #9);
        if g_dsr.sv=1   then write(fileFitpars, 'error', #9);
        if g_dsa.sv=1  then write(fileFitpars, 'error', #9);
        if f_nw.sv=1      then write(fileFitpars, 'error', #9);
        if not flag_public then begin
            if dphi.sv=1      then write(fileFitpars, 'error', #9);
            if alpha_r.sv=1  then write(fileFitpars, 'error', #9);
            if beta_r.sv=1   then write(fileFitpars, 'error', #9);
            if gamma_r.sv=1  then write(fileFitpars, 'error', #9);
            if delta_r.sv=1  then write(fileFitpars, 'error', #9);
            if alpha_d.sv=1  then write(fileFitpars, 'error', #9);
            if beta_d.sv=1   then write(fileFitpars, 'error', #9);
            if gamma_d.sv=1  then write(fileFitpars, 'error', #9);
            if delta_d.sv=1  then write(fileFitpars, 'error', #9);
            if dummy.sv=1     then write(fileFitpars, 'error', #9);
            if test.sv=1     then write(fileFitpars, 'error', #9);
            end;
        end;
    writeln(fileFitpars);

    write(fileFitpars, 'File', #9);
    if flag_multi then write(fileFitpars, ' col', #9);
    if Par1_Type<>0 then write(fileFitpars, par.name[Par1_Type], #9);
    if Par2_Type<>0 then write(fileFitpars, par.name[Par2_Type], #9);
    if Par3_Type<>0 then write(fileFitpars, par.name[Par3_Type], #9);
    if flag_shallow and (bottom_fill>=0) then begin
        st:='fA''[' + IntToStr(bottom_fill) + ']';
        write(fileFitpars, st, #9);
        end;
    write(fileFitpars, 'Iter', #9);
    write(fileFitpars, 'Resid', #9);
    if flag_Secchi then write(fileFitpars, 'Secchi', #9);
    if flag_Kd_PAR then write(fileFitpars, 'Kd(PAR)', #9);
    for i:=0 to 5 do
        if C[i].fit=1  then write(fileFitpars, par.name[i+1], #9);
    if C_X.fit=1       then write(fileFitpars, par.name[7], #9);
    if C_Mie.fit=1     then write(fileFitpars, par.name[8], #9);
    if C_Y.fit=1       then write(fileFitpars, par.name[9], #9);
    if S.fit=1         then write(fileFitpars, par.name[10], #9);
    if n.fit=1         then write(fileFitpars, par.name[11], #9);
    if T_W.fit=1       then write(fileFitpars, par.name[12], #9);
    if Q.fit=1         then write(fileFitpars, par.name[13], #9);
    if fluo.fit=1      then write(fileFitpars, par.name[14], #9);
    if rho_L.fit=1     then write(fileFitpars, par.name[15], #9);
    if rho_dd.fit=1    then write(fileFitpars, par.name[16], #9);
    if rho_ds.fit=1    then write(fileFitpars, par.name[17], #9);
    if beta.fit=1      then write(fileFitpars, par.name[18], #9);
    if alpha.fit=1     then write(fileFitpars, par.name[19], #9);
    if f_dd.fit=1      then write(fileFitpars, par.name[20], #9);
    if f_ds.fit=1      then write(fileFitpars, par.name[21], #9);
    if H_oz.fit=1      then write(fileFitpars, par.name[22], #9);
    if WV.fit=1        then write(fileFitpars, par.name[23], #9);
    if f.fit=1         then write(fileFitpars, par.name[24], #9);
    if z.fit=1         then write(fileFitpars, par.name[25], #9);
    if zB.fit=1        then write(fileFitpars, par.name[26], #9);
    if sun.fit=1       then write(fileFitpars, par.name[27], #9);
    if view.fit=1      then write(fileFitpars, par.name[28], #9);
    for i:=0 to 5 do
        if fA[i].fit=1 then write(fileFitpars, par.name[30+i], #9);
    if bbs_phy.fit=1   then write(fileFitpars, par.name[36], #9);
    if g_dd.fit=1      then write(fileFitpars, par.name[37], #9);
    if g_dsr.fit=1     then write(fileFitpars, par.name[38], #9);
    if g_dsa.fit=1     then write(fileFitpars, par.name[39], #9);
    if f_nw.fit=1      then write(fileFitpars, par.name[50], #9);
    if not flag_public then begin
        if dphi.fit=1      then write(fileFitpars, par.name[29], #9);
        if alpha_r.fit=1  then write(fileFitpars, par.name[47], #9);
        if beta_r.fit=1   then write(fileFitpars, par.name[48], #9);
        if gamma_r.fit=1  then write(fileFitpars, par.name[49], #9);
        if delta_r.fit=1  then write(fileFitpars, par.name[40], #9);
        if alpha_d.fit=1  then write(fileFitpars, par.name[41], #9);
        if beta_d.fit=1   then write(fileFitpars, par.name[42], #9);
        if gamma_d.fit=1  then write(fileFitpars, par.name[43], #9);
        if delta_d.fit=1  then write(fileFitpars, par.name[44], #9);
        if dummy.fit=1    then write(fileFitpars, par.name[45], #9);
        if test.fit=1     then write(fileFitpars, par.name[46], #9);
        end;

    if flag_shallow and (spec_type in [S_Lup, S_Rrs, S_R, S_Rbottom])
        then write(fileFitpars, 'fA[i]', #9, '  ');

    init_acc;
    if flag_b_loadAll=FALSE then begin { reconstruction mode }
        for i:=0 to 5 do
            if C[i].sv=1  then write(fileFitpars, par.name[i+1], #9);
        if C_X.sv=1       then write(fileFitpars, par.name[7], #9);
        if C_Mie.sv=1     then write(fileFitpars, par.name[8], #9);
        if C_Y.sv=1       then write(fileFitpars, par.name[9], #9);
        if S.sv=1         then write(fileFitpars, par.name[10], #9);
        if n.sv=1         then write(fileFitpars, par.name[11], #9);
        if T_W.sv=1       then write(fileFitpars, par.name[12], #9);
        if Q.sv=1         then write(fileFitpars, par.name[13], #9);
        if fluo.sv=1      then write(fileFitpars, par.name[14], #9);
        if rho_L.sv=1     then write(fileFitpars, par.name[15], #9);
        if rho_dd.sv=1    then write(fileFitpars, par.name[16], #9);
        if rho_ds.sv=1    then write(fileFitpars, par.name[17], #9);
        if beta.sv=1      then write(fileFitpars, par.name[18], #9);
        if alpha.sv=1     then write(fileFitpars, par.name[19], #9);
        if f_dd.sv=1      then write(fileFitpars, par.name[20], #9);
        if f_ds.sv=1      then write(fileFitpars, par.name[21], #9);
        if H_oz.sv=1      then write(fileFitpars, par.name[22], #9);
        if WV.sv=1        then write(fileFitpars, par.name[23], #9);
        if f.sv=1         then write(fileFitpars, par.name[24], #9);
        if z.sv=1         then write(fileFitpars, par.name[25], #9);
        if zB.sv=1        then write(fileFitpars, par.name[26], #9);
        if sun.sv=1       then write(fileFitpars, par.name[27], #9);
        if view.sv=1      then write(fileFitpars, par.name[28], #9);
        if f_nw.sv=1      then write(fileFitpars, par.name[50], #9);
        for i:=0 to 5 do
            if fA[i].sv=1 then write(fileFitpars, par.name[30+i], #9);
        if bbs_phy.sv=1   then write(fileFitpars, par.name[36], #9);
        if g_dd.sv=1      then write(fileFitpars, par.name[37], #9);
        if g_dsr.sv=1     then write(fileFitpars, par.name[38], #9);
        if g_dsa.sv=1     then write(fileFitpars, par.name[39], #9);
        if f_nw.fit=1     then write(fileFitpars, par.name[50], #9);
        if not flag_public then begin
            if dphi.sv=1      then write(fileFitpars, par.name[29], #9);
            if alpha_r.sv=1  then write(fileFitpars, par.name[47], #9);
            if beta_r.sv=1   then write(fileFitpars, par.name[48], #9);
            if gamma_r.sv=1  then write(fileFitpars, par.name[49], #9);
            if delta_r.sv=1  then write(fileFitpars, par.name[40], #9);
            if alpha_d.sv=1  then write(fileFitpars, par.name[41], #9);
            if beta_d.sv=1   then write(fileFitpars, par.name[42], #9);
            if gamma_d.sv=1  then write(fileFitpars, par.name[43], #9);
            if delta_d.sv=1  then write(fileFitpars, par.name[44], #9);
            if dummy.sv=1     then write(fileFitpars, par.name[45], #9);
            if test.sv=1     then write(fileFitpars, par.name[46], #9);
            end;
        end;
    writeln(fileFitpars);
    writeln(fileFitpars);
    {$i+}
    end;

function rel_err(y:Fitparameters):double;
var n, e : double;
begin
    n:=y.fw;
    if abs(y.actual-n)<nenner_min then rel_err:=0 else begin
        if abs(n)<nenner_min then n:=nenner_min;
        e:=100*(y.actual/n-1);
        rel_err:=e;
        end;
    end;

function s_err(y:Fitparameters):String;
begin
    s_err:=schoen(rel_err(y), 3);
    end;

procedure accumulate_errors;
var i : integer;
begin
    for i:=0 to 5 do
        acc_esum[i+1] :=acc_esum[i+1]  + abs(rel_err(C[i]));
    acc_esum[7] :=acc_esum[7]  + abs(rel_err(C_X));
    acc_esum[8] :=acc_esum[8]  + abs(rel_err(C_Mie));
    acc_esum[9] :=acc_esum[9]  + abs(rel_err(C_Y));
    acc_esum[10]:=acc_esum[10] + abs(rel_err(S));
    acc_esum[11]:=acc_esum[11] + abs(rel_err(n));
    acc_esum[12]:=acc_esum[12] + abs(rel_err(T_W));
    acc_esum[13]:=acc_esum[13] + abs(rel_err(Q));
    acc_esum[14]:=acc_esum[14] + abs(rel_err(fluo));
    acc_esum[15]:=acc_esum[15] + abs(rel_err(rho_L));
    acc_esum[16]:=acc_esum[16] + abs(rel_err(rho_dd));
    acc_esum[17]:=acc_esum[17] + abs(rel_err(rho_ds));
    acc_esum[18]:=acc_esum[18] + abs(rel_err(beta));
    acc_esum[19]:=acc_esum[19] + abs(rel_err(alpha));
    acc_esum[20]:=acc_esum[20] + abs(rel_err(f_dd));
    acc_esum[21]:=acc_esum[21] + abs(rel_err(f_ds));
    acc_esum[22]:=acc_esum[22] + abs(rel_err(H_oz));
    acc_esum[23]:=acc_esum[23] + abs(rel_err(WV));
    acc_esum[24]:=acc_esum[24] + abs(rel_err(f));
    acc_esum[25]:=acc_esum[25] + abs(rel_err(z));
    acc_esum[26]:=acc_esum[26] + abs(rel_err(zB));
    acc_esum[27]:=acc_esum[27] + abs(rel_err(sun));
    acc_esum[28]:=acc_esum[28] + abs(rel_err(view));
    acc_esum[29]:=acc_esum[29] + abs(rel_err(dphi));
    acc_esum[50]:=acc_esum[50] + abs(rel_err(f_nw));
    for i:=0 to 5 do
        acc_esum[30+i]:=acc_esum[30+i] + abs(rel_err(fA[i]));
    acc_esum[36] :=acc_esum[36]  + abs(rel_err(bbs_phy));
    acc_esum[37]:=acc_esum[37] + abs(rel_err(g_dd));
    acc_esum[38]:=acc_esum[38] + abs(rel_err(g_dsr));
    acc_esum[39]:=acc_esum[39] + abs(rel_err(g_dsa));
    if not flag_public then begin
        acc_esum[47]:=acc_esum[47] + abs(rel_err(alpha_r));
        acc_esum[48]:=acc_esum[48] + abs(rel_err(beta_r));
        acc_esum[49]:=acc_esum[49] + abs(rel_err(gamma_r));
        acc_esum[40]:=acc_esum[40] + abs(rel_err(delta_r));
        acc_esum[41]:=acc_esum[41] + abs(rel_err(alpha_d));
        acc_esum[42]:=acc_esum[42] + abs(rel_err(beta_d));
        acc_esum[43]:=acc_esum[43] + abs(rel_err(gamma_d));
        acc_esum[44]:=acc_esum[44] + abs(rel_err(delta_d));
        acc_esum[45]:=acc_esum[45] + abs(rel_err(dummy));
        acc_esum[46]:=acc_esum[46] + abs(rel_err(test));
        end;
    for i:=0 to 5 do
        if abs(rel_err(C[i]))>abs(acc_emax[i+1]) then acc_emax[i+1]:=rel_err(C[i]);
    if abs(rel_err(C_X))>abs(acc_emax[7])       then acc_emax[7]:=rel_err(C_X);
    if abs(rel_err(C_Mie))>abs(acc_emax[8])     then acc_emax[8]:=rel_err(C_Mie);
    if abs(rel_err(C_Y))>abs(acc_emax[9])       then acc_emax[9]:=rel_err(C_Y);
    if abs(rel_err(S))>abs(acc_emax[10])        then acc_emax[10]:=rel_err(S);
    if abs(rel_err(n))>abs(acc_emax[11])        then acc_emax[11]:=rel_err(n);
    if abs(rel_err(T_W))>abs(acc_emax[12])      then acc_emax[12]:=rel_err(T_W);
    if abs(rel_err(Q))>abs(acc_emax[13])        then acc_emax[13]:=rel_err(Q);
    if abs(rel_err(fluo))>abs(acc_emax[14])     then acc_emax[14]:=rel_err(fluo);
    if abs(rel_err(rho_L))>abs(acc_emax[15])    then acc_emax[15]:=rel_err(rho_L);
    if abs(rel_err(rho_dd))>abs(acc_emax[16])   then acc_emax[16]:=rel_err(rho_dd);
    if abs(rel_err(rho_ds))>abs(acc_emax[17])   then acc_emax[17]:=rel_err(rho_ds);
    if abs(rel_err(beta))>abs(acc_emax[18])     then acc_emax[18]:=rel_err(beta);
    if abs(rel_err(alpha))>abs(acc_emax[19])    then acc_emax[19]:=rel_err(alpha);
    if abs(rel_err(f_dd))>abs(acc_emax[20])     then acc_emax[20]:=rel_err(f_dd);
    if abs(rel_err(f_ds))>abs(acc_emax[21])     then acc_emax[21]:=rel_err(f_ds);
    if abs(rel_err(H_oz))>abs(acc_emax[22])     then acc_emax[22]:=rel_err(H_oz);
    if abs(rel_err(WV))>abs(acc_emax[23])       then acc_emax[23]:=rel_err(WV);
    if abs(rel_err(f))>abs(acc_emax[24])        then acc_emax[24]:=rel_err(f);
    if abs(rel_err(z))>abs(acc_emax[25])        then acc_emax[25]:=rel_err(z);
    if abs(rel_err(zB))>abs(acc_emax[26])       then acc_emax[26]:=rel_err(zB);
    if abs(rel_err(sun))>abs(acc_emax[27])      then acc_emax[27]:=rel_err(sun);
    if abs(rel_err(view))>abs(acc_emax[28])     then acc_emax[28]:=rel_err(view);
    if abs(rel_err(dphi))>abs(acc_emax[29])     then acc_emax[29]:=rel_err(dphi);
    if abs(rel_err(f_nw))>abs(acc_emax[50])     then acc_emax[50]:=rel_err(f_nw);
    for i:=0 to 5 do
        if abs(rel_err(fA[i]))>abs(acc_emax[30+i]) then acc_emax[30+i]:=rel_err(fA[i]);
    if abs(rel_err(bbs_phy))>abs(acc_emax[36])  then acc_emax[36]:=rel_err(bbs_phy);
    if abs(rel_err(g_dd))>abs(acc_emax[37])     then acc_emax[37]:=rel_err(g_dd);
    if abs(rel_err(g_dsr))>abs(acc_emax[38])    then acc_emax[38]:=rel_err(g_dsr);
    if abs(rel_err(g_dsa))>abs(acc_emax[39])    then acc_emax[39]:=rel_err(g_dsa);
    if abs(rel_err(alpha_r))>abs(acc_emax[47])  then acc_emax[47]:=rel_err(alpha_r);
    if abs(rel_err(beta_r))>abs(acc_emax[48])   then acc_emax[48]:=rel_err(beta_r);
    if abs(rel_err(gamma_r))>abs(acc_emax[49])  then acc_emax[49]:=rel_err(gamma_r);
    if abs(rel_err(delta_r))>abs(acc_emax[40])  then acc_emax[40]:=rel_err(delta_r);
    if abs(rel_err(alpha_d))>abs(acc_emax[41])  then acc_emax[41]:=rel_err(alpha_d);
    if abs(rel_err(beta_d))>abs(acc_emax[42])   then acc_emax[42]:=rel_err(beta_d);
    if abs(rel_err(gamma_d))>abs(acc_emax[43])  then acc_emax[43]:=rel_err(gamma_d);
    if abs(rel_err(delta_d))>abs(acc_emax[44])  then acc_emax[44]:=rel_err(delta_d);
    if abs(rel_err(dummy))>abs(acc_emax[45])    then acc_emax[45]:=rel_err(dummy);
    if abs(rel_err(test))>abs(acc_emax[46])     then acc_emax[46]:=rel_err(test);
    end;

procedure accumulate(c1, c2, c3: double);
var i      : integer;
    sum_fA : double;
begin
    if Par1_Type<>0 then begin
        inc(acc_N);
        acc_fsum[1]:=acc_fsum[1]+c1;
        if abs(c1)>abs(acc_fmax[1]) then acc_fmax[1]:=c1;
        end;
    if Par2_Type<>0 then begin
        acc_fsum[2]:=acc_fsum[2]+c2;
        if abs(c2)>abs(acc_fmax[2]) then acc_fmax[2]:=c2;
        end;
    if Par3_Type<>0 then begin
        acc_fsum[3]:=acc_fsum[3]+c3;
        if abs(c3)>abs(acc_fmax[3]) then acc_fmax[3]:=c3;
        end;
    if flag_shallow and (bottom_fill>=0) then begin
        acc_fill:=acc_fill + fA[bottom_fill].fw;
        if fA[bottom_fill].fw>acc_fillM then acc_fillM:=fA[bottom_fill].fw;
        end;
    if NIter>acc_iterM then acc_iterM:=NIter;
    acc_iter:=acc_iter+NIter;
    acc_resid:=acc_resid+Resid;
    if Resid>acc_residM then acc_residM:=Resid;
    for i:=0 to 5 do
        acc_isum[i+1] :=acc_isum[i+1]  + C[i].actual;
    acc_isum[7] :=acc_isum[7]  + C_X.actual;
    acc_isum[8] :=acc_isum[8]  + C_Mie.actual;
    acc_isum[9] :=acc_isum[9]  + C_Y.actual;
    acc_isum[10]:=acc_isum[10] + S.actual;
    acc_isum[11]:=acc_isum[11] + n.actual;
    acc_isum[12]:=acc_isum[12] + T_W.actual;
    acc_isum[13]:=acc_isum[13] + Q.actual;
    acc_isum[14]:=acc_isum[14] + fluo.actual;
    acc_isum[15]:=acc_isum[15] + rho_L.actual;
    acc_isum[16]:=acc_isum[16] + rho_dd.actual;
    acc_isum[17]:=acc_isum[17] + rho_ds.actual;
    acc_isum[18]:=acc_isum[18] + beta.actual;
    acc_isum[19]:=acc_isum[19] + alpha.actual;
    acc_isum[20]:=acc_isum[20] + f_dd.actual;
    acc_isum[21]:=acc_isum[21] + f_ds.actual;
    acc_isum[22]:=acc_isum[22] + H_oz.actual;
    acc_isum[23]:=acc_isum[23] + WV.actual;
    acc_isum[24]:=acc_isum[24] + f.actual;
    acc_isum[25]:=acc_isum[25] + z.actual;
    acc_isum[26]:=acc_isum[26] + zB.actual;
    acc_isum[27]:=acc_isum[27] + sun.actual;
    acc_isum[28]:=acc_isum[28] + view.actual;
    acc_isum[29]:=acc_isum[29] + dphi.actual;
    acc_isum[50]:=acc_isum[50] + f_nw.actual;
    for i:=0 to 5 do
        acc_isum[30+i]:=acc_isum[30+i] + fA[i].actual;
    acc_isum[36] :=acc_isum[36]  + bbs_phy.actual;
    acc_isum[37]:=acc_isum[37] + g_dd.actual;
    acc_isum[38]:=acc_isum[38] + g_dsr.actual;
    acc_isum[39]:=acc_isum[39] + g_dsa.actual;
    if not flag_public then begin
        acc_isum[47]:=acc_isum[47] + alpha_r.actual;
        acc_isum[48]:=acc_isum[48] + beta_r.actual;
        acc_isum[49]:=acc_isum[49] + gamma_r.actual;
        acc_isum[40]:=acc_isum[40] + delta_r.actual;
        acc_isum[41]:=acc_isum[41] + alpha_d.actual;
        acc_isum[42]:=acc_isum[42] + beta_d.actual;
        acc_isum[43]:=acc_isum[43] + gamma_d.actual;
        acc_isum[44]:=acc_isum[44] + delta_d.actual;
        acc_isum[45]:=acc_isum[45] + dummy.actual;
        acc_isum[46]:=acc_isum[46] + test.actual;
        end;
    sum_fA:=0;
    for i:=0 to 5 do sum_fA:=sum_fA + fA[i].actual;
    acc_fills:=acc_fills + sum_fA;
    for i:=0 to 5 do
        if C[i].actual>acc_imax[i+1] then acc_imax[i+1]:=C[i].actual;
    if C_X.actual>acc_imax[7]        then acc_imax[7]:=C_X.actual;
    if C_Mie.actual>acc_imax[8]      then acc_imax[8]:=C_Mie.actual;
    if C_Y.actual>acc_imax[9]        then acc_imax[9]:=C_Y.actual;
    if S.actual>acc_imax[10]         then acc_imax[10]:=S.actual;
    if n.actual>acc_imax[11]         then acc_imax[11]:=n.actual;
    if T_W.actual>acc_imax[12]       then acc_imax[12]:=T_W.actual;
    if Q.actual>acc_imax[13]         then acc_imax[13]:=Q.actual;
    if fluo.actual>acc_imax[14]      then acc_imax[14]:=fluo.actual;
    if rho_L.actual>acc_imax[15]     then acc_imax[15]:=rho_L.actual;
    if rho_dd.actual>acc_imax[16]    then acc_imax[16]:=rho_dd.actual;
    if rho_ds.actual>acc_imax[17]    then acc_imax[17]:=rho_ds.actual;
    if beta.actual>acc_imax[18]      then acc_imax[18]:=beta.actual;
    if alpha.actual>acc_imax[19]     then acc_imax[19]:=alpha.actual;
    if f_dd.actual>acc_imax[20]      then acc_imax[20]:=f_dd.actual;
    if f_ds.actual>acc_imax[21]      then acc_imax[21]:=f_ds.actual;
    if H_oz.actual>acc_imax[22]      then acc_imax[22]:=H_oz.actual;
    if WV.actual>acc_imax[23]        then acc_imax[23]:=WV.actual;
    if f.actual>acc_imax[24]         then acc_imax[24]:=f.actual;
    if z.actual>acc_imax[25]         then acc_imax[25]:=z.actual;
    if zB.actual>acc_imax[26]        then acc_imax[26]:=zB.actual;
    if sun.actual>acc_imax[27]       then acc_imax[27]:=sun.actual;
    if view.actual>acc_imax[28]      then acc_imax[28]:=view.actual;
    if dphi.actual>acc_imax[29]      then acc_imax[29]:=dphi.actual;
    if f_nw.actual>acc_imax[50]      then acc_imax[50]:=f_nw.actual;
    for i:=0 to 5 do
        if fA[i].actual>acc_imax[30+i] then acc_imax[30+i]:=fA[i].actual;
    if bbs_phy.actual>acc_imax[36]   then acc_imax[36]:=bbs_phy.actual;
    if g_dd.actual>acc_imax[37]      then acc_imax[37]:=g_dd.actual;
    if g_dsr.actual>acc_imax[38]     then acc_imax[38]:=g_dsr.actual;
    if g_dsa.actual>acc_imax[39]     then acc_imax[39]:=g_dsa.actual;
    if not flag_public then begin
        if alpha_r.actual>acc_imax[47]  then acc_imax[47]:=alpha_r.actual;
        if beta_r.actual>acc_imax[48]   then acc_imax[48]:=beta_r.actual;
        if gamma_r.actual>acc_imax[49]  then acc_imax[49]:=gamma_r.actual;
        if delta_r.actual>acc_imax[40]  then acc_imax[40]:=delta_r.actual;
        if alpha_d.actual>acc_imax[41]  then acc_imax[41]:=alpha_d.actual;
        if beta_d.actual>acc_imax[42]   then acc_imax[42]:=beta_d.actual;
        if gamma_d.actual>acc_imax[43]  then acc_imax[43]:=gamma_d.actual;
        if delta_d.actual>acc_imax[44]  then acc_imax[44]:=delta_d.actual;
        if dummy.actual>acc_imax[45]    then acc_imax[45]:=dummy.actual;
        if test.actual>acc_imax[46]     then acc_imax[46]:=test.actual;
        end;
    if sum_fA>acc_fillsM then acc_fillsM:=sum_fA;

    if flag_b_loadAll=FALSE then accumulate_errors; { reconstruction mode }
    end;

procedure write_error(c1, c2, c3: double);
{ Write relative errors to file. }
var   i : integer;
begin
    { Set parameters of forward mode to actual values in loop }
    iter_type:=Par1_type;
    determine_concentration_fw(c1);
    iter_type:=Par2_type;
    determine_concentration_fw(c2);
    iter_type:=Par3_type;
    determine_concentration_fw(c3);

    for i:=0 to 5 do
        if C[i].sv=1  then write(fileFitpars, s_err(C[i]) ,#9);
    if fluo.sv=1      then write(fileFitpars, s_err(fluo) ,#9);
    if C_X.sv=1       then write(fileFitpars, s_err(C_X) ,#9);
    if C_Mie.sv=1     then write(fileFitpars, s_err(C_Mie) ,#9);
    if C_Y.sv=1       then write(fileFitpars, s_err(C_Y) ,#9);
    if S.sv=1         then write(fileFitpars, s_err(S) ,#9);
    if n.sv=1         then write(fileFitpars, s_err(n) ,#9);
    if T_W.sv=1       then write(fileFitpars, s_err(T_W) ,#9);
    if Q.sv=1         then write(fileFitpars, s_err(Q) ,#9);
    if rho_dd.sv=1    then write(fileFitpars, s_err(rho_dd) ,#9);
    if rho_L.sv=1     then write(fileFitpars, s_err(rho_L) ,#9);
    if rho_ds.sv=1    then write(fileFitpars, s_err(rho_ds) ,#9);
    if alpha.sv=1     then write(fileFitpars, s_err(alpha) ,#9);
    if beta.sv=1      then write(fileFitpars, s_err(beta) ,#9);
    if f_dd.sv=1      then write(fileFitpars, s_err(f_dd) ,#9);
    if f_ds.sv=1      then write(fileFitpars, s_err(f_ds) ,#9);
    if H_oz.sv=1      then write(fileFitpars, s_err(H_oz) ,#9);
    if WV.sv=1        then write(fileFitpars, s_err(WV) ,#9);
    if f.sv=1         then write(fileFitpars, s_err(f) ,#9);
    if z.sv=1         then write(fileFitpars, s_err(z) ,#9);
    if zB.sv=1        then write(fileFitpars, s_err(zB) ,#9);
    if sun.sv=1       then write(fileFitpars, s_err(sun) ,#9);
    if view.sv=1      then write(fileFitpars, s_err(view) ,#9);
    if dphi.sv=1      then write(fileFitpars, s_err(dphi) ,#9);
    if f_nw.sv=1      then write(fileFitpars, s_err(f_nw) ,#9);
    for i:=0 to 5 do
        if fA[i].sv=1 then write(fileFitpars, s_err(fA[i]) ,#9);
    if bbs_phy.sv=1   then write(fileFitpars, s_err(bbs_phy) ,#9);
    if g_dd.sv=1      then write(fileFitpars, s_err(g_dd) ,#9);
    if g_dsr.sv=1     then write(fileFitpars, s_err(g_dsr) ,#9);
    if g_dsa.sv=1     then write(fileFitpars, s_err(g_dsa) ,#9);
    if not flag_public then begin
        if alpha_r.sv=1 then write(fileFitpars, s_err(alpha_r) ,#9);
        if beta_r.sv=1  then write(fileFitpars, s_err(beta_r) ,#9);
        if gamma_r.sv=1 then write(fileFitpars, s_err(gamma_r) ,#9);
        if delta_r.sv=1 then write(fileFitpars, s_err(delta_r) ,#9);
        if alpha_d.sv=1 then write(fileFitpars, s_err(alpha_d) ,#9);
        if beta_d.sv=1  then write(fileFitpars, s_err(beta_d) ,#9);
        if gamma_d.sv=1 then write(fileFitpars, s_err(gamma_d) ,#9);
        if delta_d.sv=1 then write(fileFitpars, s_err(delta_d) ,#9);
        if dummy.sv=1   then write(fileFitpars, s_err(dummy) ,#9);
        if test.sv=1    then write(fileFitpars, s_err(test) ,#9);
        end;
    end;

procedure saveFITPARS(spektrum:String; y:integer; c1, c2, c3: double);
const SIG = 4;
var   i   : integer;
      sum : double;
      CHL : double;
begin
    write(fileFitpars, spektrum, #9);
    if flag_multi   then write(fileFitpars, y:3, #9);
    if Par1_Type<>0 then write(fileFitpars, schoen(c1,4), #9);
    if Par2_Type<>0 then write(fileFitpars, schoen(c2,4), #9);
    if Par3_Type<>0 then write(fileFitpars, schoen(c3,4), #9);
    if flag_shallow and (bottom_fill>=0) then
        write(fileFitpars, schoen(fA[bottom_fill].fw,4), #9);
    write(fileFitpars, NIter, #9);
    write(fileFitpars, schoen(Resid, SIG-1), #9);
    if flag_Secchi then begin
        CHL:=0;
        for i:=0 to 5 do CHL:=CHL + C[i].actual;
        berechne_SDD(C_Y.actual,S.actual,CHL,SDD);
        write(fileFitpars, SDD:4:2, #9);
        end;
    if flag_Kd_PAR then begin
        calculate_Kd_inv;
        write(fileFitpars, schoen(Kd^.avg, SIG), #9);
        end;
    for i:=0 to 5 do
        if C[i].fit=1 then write(fileFitpars, schoen(C[i].actual,SIG), #9);
    if C_X.fit=1  then write(fileFitpars, schoen(C_X.actual,SIG), #9);
    if C_Mie.fit=1 then write(fileFitpars, schoen(C_Mie.actual,SIG), #9);
    if C_Y.fit=1  then write(fileFitpars, schoen(C_Y.actual,SIG), #9);
    if S.fit=1    then write(fileFitpars, schoen(S.actual,SIG), #9);
    if n.fit=1    then write(fileFitpars, schoen(n.actual,SIG), #9);
    if T_W.fit=1  then write(fileFitpars, schoen(T_W.actual,SIG), #9);
    if Q.fit=1    then write(fileFitpars, schoen(Q.actual,SIG), #9);
    if fluo.fit=1 then write(fileFitpars, schoen(fluo.actual,SIG), #9);
    if rho_L.fit=1  then write(fileFitpars, schoen(rho_L.actual,SIG), #9);
    if rho_dd.fit=1 then write(fileFitpars, schoen(rho_dd.actual,SIG), #9);
    if rho_ds.fit=1 then write(fileFitpars, schoen(rho_ds.actual,SIG), #9);
    if beta.fit=1  then write(fileFitpars, schoen(beta.actual,SIG), #9);
    if alpha.fit=1 then write(fileFitpars, schoen(alpha.actual,SIG), #9);
    if f_dd.fit=1  then write(fileFitpars, schoen(f_dd.actual,SIG), #9);
    if f_ds.fit=1  then write(fileFitpars, schoen(f_ds.actual,SIG), #9);
    if H_oz.fit=1  then write(fileFitpars, schoen(H_oz.actual,SIG), #9);
    if WV.fit=1    then write(fileFitpars, schoen(WV.actual,SIG), #9);
    if f.fit=1     then write(fileFitpars, schoen(f.actual,SIG), #9);
    if z.fit=1     then write(fileFitpars, schoen(z.actual,SIG), #9);
    if zB.fit=1    then write(fileFitpars, schoen(zB.actual,SIG), #9);
    if sun.fit=1   then write(fileFitpars, schoen(sun.actual,SIG), #9);
    if view.fit=1  then write(fileFitpars, schoen(view.actual,SIG), #9);
    for i:=0 to 5 do
        if fA[i].fit=1 then write(fileFitpars, schoen(fA[i].actual,SIG), #9);
    if bbs_phy.fit=1 then write(fileFitpars, schoen(bbs_phy.actual,SIG), #9);
    if g_dd.fit=1   then write(fileFitpars, schoen(g_dd.actual,SIG), #9);
    if g_dsr.fit=1  then write(fileFitpars, schoen(g_dsr.actual,SIG), #9);
    if g_dsa.fit=1 then write(fileFitpars, schoen(g_dsa.actual,SIG), #9);
    if f_nw.fit=1  then write(fileFitpars, schoen(f_nw.actual,SIG), #9);
    if not flag_public then begin
        if dphi.fit=1  then write(fileFitpars, schoen(dphi.actual,SIG), #9);
        if alpha_r.fit=1 then write(fileFitpars, schoen(alpha_r.actual,SIG), #9);
        if beta_r.fit=1  then write(fileFitpars, schoen(beta_r.actual,SIG), #9);
        if gamma_r.fit=1 then write(fileFitpars, schoen(gamma_r.actual,SIG), #9);
        if delta_r.fit=1 then write(fileFitpars, schoen(delta_r.actual,SIG), #9);
        if alpha_d.fit=1 then write(fileFitpars, schoen(alpha_d.actual,SIG), #9);
        if beta_d.fit=1  then write(fileFitpars, schoen(beta_d.actual,SIG), #9);
        if gamma_d.fit=1 then write(fileFitpars, schoen(gamma_d.actual,SIG), #9);
        if delta_d.fit=1 then write(fileFitpars, schoen(delta_d.actual,SIG), #9);
        if dummy.fit=1   then write(fileFitpars, schoen(dummy.actual,SIG), #9);
        if test.fit=1    then write(fileFitpars, schoen(test.actual,5), #9);
        end;

    if flag_shallow and (spec_type in [S_Lup, S_Rrs, S_R, S_Rbottom]) then begin
        sum:=0;
        for i:=0 to 5 do sum:=sum+fA[i].actual;
        write(fileFitpars, schoen(sum,SIG), #9);
        end;

    if flag_b_loadAll=FALSE then write_error(c1,c2,c3); { reconstruction mode }
    accumulate(c1,c2,c3);
    writeln(fileFitpars);
    end;

procedure closeFITPARS;
const SPACE = 8;
      SIG   = 4;
      SIGe  = 3;
var   i     : integer;
begin
if acc_N>0 then begin
    writeln(fileFitpars);

    { write first line with means }
    if Par1_Type<>0 then
        write(fileFitpars, 'mean=', #9, schoen(acc_fsum[1]/acc_N,4), #9);
    if Par2_Type<>0 then
        write(fileFitpars, schoen(acc_fsum[2]/acc_N,4), #9);
    if Par3_Type<>0 then
        write(fileFitpars, schoen(acc_fsum[3]/acc_N,4), #9);
    if flag_shallow and (bottom_fill>=0) then
        write(fileFitpars, schoen(acc_fill/acc_N,4), #9);
    write(fileFitpars, (acc_iter div acc_N):10, ' ');
    write(fileFitpars, schoen(acc_resid/acc_N, 4):10, ' ');
    for i:=0 to 5 do
        if C[i].fit=1 then write(fileFitpars, schoen(acc_isum[i+1]/acc_N,SIG), #9);
    if C_X.fit=1  then write(fileFitpars, schoen(acc_isum[7]/acc_N,SIG), #9);
    if C_Mie.fit=1 then write(fileFitpars, schoen(acc_isum[8]/acc_N,SIG), #9);
    if C_Y.fit=1  then write(fileFitpars, schoen(acc_isum[9]/acc_N,SIG), #9);
    if S.fit=1    then write(fileFitpars, schoen(acc_isum[10]/acc_N,SIG), #9);
    if n.fit=1    then write(fileFitpars, schoen(acc_isum[11]/acc_N,SIG), #9);
    if T_W.fit=1  then write(fileFitpars, schoen(acc_isum[12]/acc_N,SIG), #9);
    if Q.fit=1    then write(fileFitpars, schoen(acc_isum[13]/acc_N,SIG), #9);
    if fluo.fit=1 then write(fileFitpars, schoen(acc_isum[14]/acc_N,SIG), #9);
    if rho_L.fit=1   then write(fileFitpars, schoen(acc_isum[15]/acc_N,SIG), #9);
    if rho_dd.fit=1 then write(fileFitpars, schoen(acc_isum[16]/acc_N,SIG), #9);
    if rho_ds.fit=1 then write(fileFitpars, schoen(acc_isum[17]/acc_N,SIG), #9);
    if alpha.fit=1 then write(fileFitpars, schoen(acc_isum[19]/acc_N,SIG), #9);
    if beta.fit=1  then write(fileFitpars, schoen(acc_isum[18]/acc_N,SIG), #9);
    if f_dd.fit=1  then write(fileFitpars, schoen(acc_isum[20]/acc_N,SIG), #9);
    if f_ds.fit=1  then write(fileFitpars, schoen(acc_isum[21]/acc_N,SIG), #9);
    if H_oz.fit=1  then write(fileFitpars, schoen(acc_isum[22]/acc_N,SIG), #9);
    if WV.fit=1    then write(fileFitpars, schoen(acc_isum[23]/acc_N,SIG), #9);
    if f.fit=1     then write(fileFitpars, schoen(acc_isum[24]/acc_N,SIG), #9);
    if z.fit=1     then write(fileFitpars, schoen(acc_isum[25]/acc_N,SIG), #9);
    if zB.fit=1    then write(fileFitpars, schoen(acc_isum[26]/acc_N,SIG), #9);
    if sun.fit=1   then write(fileFitpars, schoen(acc_isum[27]/acc_N,SIG), #9);
    if view.fit=1  then write(fileFitpars, schoen(acc_isum[28]/acc_N,SIG), #9);
    if dphi.fit=1  then write(fileFitpars, schoen(acc_isum[29]/acc_N,SIG), #9);
    if f_nw.fit=1  then write(fileFitpars, schoen(acc_isum[50]/acc_N,SIG), #9);
    for i:=0 to 5 do
        if fA[i].fit=1 then write(fileFitpars, schoen(acc_isum[30+i]/acc_N,SIG), #9);
    if bbs_phy.fit=1 then write(fileFitpars, schoen(acc_isum[36]/acc_N,SIG), #9);
    if g_dd.fit=1    then write(fileFitpars, schoen(acc_isum[37]/acc_N,SIG), #9);
    if g_dsr.fit=1   then write(fileFitpars, schoen(acc_isum[38]/acc_N,SIG), #9);
    if g_dsa.fit=1   then write(fileFitpars, schoen(acc_isum[39]/acc_N,SIG), #9);
    if not flag_public then begin
        if alpha_r.fit=1  then write(fileFitpars, schoen(acc_isum[47]/acc_N,SIG), #9);
        if beta_r.fit=1   then write(fileFitpars, schoen(acc_isum[48]/acc_N,SIG), #9);
        if gamma_r.fit=1  then write(fileFitpars, schoen(acc_isum[49]/acc_N,SIG), #9);
        if delta_r.fit=1  then write(fileFitpars, schoen(acc_isum[40]/acc_N,SIG), #9);
        if alpha_d.fit=1  then write(fileFitpars, schoen(acc_isum[41]/acc_N,SIG), #9);
        if beta_d.fit=1   then write(fileFitpars, schoen(acc_isum[42]/acc_N,SIG), #9);
        if gamma_d.fit=1  then write(fileFitpars, schoen(acc_isum[43]/acc_N,SIG), #9);
        if delta_d.fit=1  then write(fileFitpars, schoen(acc_isum[44]/acc_N,SIG), #9);
        if dummy.fit=1    then write(fileFitpars, schoen(acc_isum[45]/acc_N,SIG), #9);
        if test.fit=1     then write(fileFitpars, schoen(acc_isum[46]/acc_N,SIG), #9);
        end;

    if flag_shallow then write(fileFitpars, schoen(acc_fills/acc_N,SIGe):SPACE, '   ');

    { reconstruction mode }
    if flag_b_loadAll=FALSE then begin
        for i:=0 to 5 do
            if C[i].sv=1 then write(fileFitpars, schoen(acc_esum[i+1]/acc_N,SIGe), #9);
        if C_X.sv=1  then write(fileFitpars, schoen(acc_esum[7]/acc_N,SIGe), #9);
        if C_Mie.sv=1 then write(fileFitpars, schoen(acc_esum[8]/acc_N,SIGe), #9);
        if C_Y.sv=1  then write(fileFitpars, schoen(acc_esum[9]/acc_N,SIGe), #9);
        if S.sv=1    then write(fileFitpars, schoen(acc_esum[10]/acc_N,SIGe), #9);
        if n.sv=1    then write(fileFitpars, schoen(acc_esum[11]/acc_N,SIGe), #9);
        if T_W.sv=1  then write(fileFitpars, schoen(acc_esum[12]/acc_N,SIGe), #9);
        if Q.sv=1    then write(fileFitpars, schoen(acc_esum[13]/acc_N,SIGe), #9);
        if fluo.sv=1 then write(fileFitpars, schoen(acc_esum[14]/acc_N,SIGe), #9);
        if rho_L.sv=1   then write(fileFitpars, schoen(acc_esum[15]/acc_N,SIGe), #9);
        if rho_dd.sv=1 then write(fileFitpars, schoen(acc_esum[16]/acc_N,SIGe), #9);
        if rho_ds.sv=1 then write(fileFitpars, schoen(acc_esum[17]/acc_N,SIGe), #9);
        if alpha.sv=1 then write(fileFitpars, schoen(acc_esum[19]/acc_N,SIGe), #9);
        if beta.sv=1  then write(fileFitpars, schoen(acc_esum[18]/acc_N,SIGe), #9);
        if f_dd.sv=1  then write(fileFitpars, schoen(acc_esum[20]/acc_N,SIGe), #9);
        if f_ds.sv=1  then write(fileFitpars, schoen(acc_esum[21]/acc_N,SIGe), #9);
        if H_oz.sv=1  then write(fileFitpars, schoen(acc_esum[22]/acc_N,SIGe), #9);
        if WV.sv=1    then write(fileFitpars, schoen(acc_esum[23]/acc_N,SIGe), #9);
        if f.sv=1     then write(fileFitpars, schoen(acc_esum[24]/acc_N,SIGe), #9);
        if z.sv=1     then write(fileFitpars, schoen(acc_esum[25]/acc_N,SIGe), #9);
        if zB.sv=1    then write(fileFitpars, schoen(acc_esum[26]/acc_N,SIGe), #9);
        if sun.sv=1   then write(fileFitpars, schoen(acc_esum[27]/acc_N,SIGe), #9);
        if view.sv=1  then write(fileFitpars, schoen(acc_esum[28]/acc_N,SIGe), #9);
        if dphi.sv=1  then write(fileFitpars, schoen(acc_esum[29]/acc_N,SIGe), #9);
        if f_nw.sv=1  then write(fileFitpars, schoen(acc_esum[50]/acc_N,SIGe), #9);
        for i:=0 to 5 do
            if fA[i].sv=1 then write(fileFitpars, schoen(acc_esum[30+i]/acc_N,SIGe), #9);
        if bbs_phy.sv=1 then write(fileFitpars, schoen(acc_esum[36]/acc_N,SIGe), #9);
        if g_dd.sv=1   then write(fileFitpars, schoen(acc_esum[37]/acc_N,SIGe), #9);
        if g_dsr.sv=1  then write(fileFitpars, schoen(acc_esum[38]/acc_N,SIGe), #9);
        if g_dsa.sv=1  then write(fileFitpars, schoen(acc_esum[39]/acc_N,SIGe), #9);
        if not flag_public then begin
            if alpha_r.sv=1  then write(fileFitpars, schoen(acc_esum[47]/acc_N,SIGe), #9);
            if beta_r.sv=1   then write(fileFitpars, schoen(acc_esum[48]/acc_N,SIGe), #9);
            if gamma_r.sv=1  then write(fileFitpars, schoen(acc_esum[49]/acc_N,SIGe), #9);
            if delta_r.sv=1  then write(fileFitpars, schoen(acc_esum[40]/acc_N,SIGe), #9);
            if alpha_d.sv=1  then write(fileFitpars, schoen(acc_esum[41]/acc_N,SIGe), #9);
            if beta_d.sv=1   then write(fileFitpars, schoen(acc_esum[42]/acc_N,SIGe), #9);
            if gamma_d.sv=1  then write(fileFitpars, schoen(acc_esum[43]/acc_N,SIGe), #9);
            if delta_d.sv=1  then write(fileFitpars, schoen(acc_esum[44]/acc_N,SIGe), #9);
            if dummy.sv=1    then write(fileFitpars, schoen(acc_esum[45]/acc_N,SIGe), #9);
            if test.sv=1     then write(fileFitpars, schoen(acc_esum[46]/acc_N,SIGe), #9);
            end;
        end;
    writeln(fileFitpars);

    { write second line with max }
    if Par1_Type<>0 then
        write(fileFitpars, 'max=', #9, schoen(acc_fmax[1],4), #9);
    if Par2_Type<>0 then
        write(fileFitpars, schoen(acc_fmax[2],4), #9);
    if Par3_Type<>0 then
        write(fileFitpars, schoen(acc_fmax[3],4), #9);
    if flag_shallow and (bottom_fill>=0) then
        write(fileFitpars, schoen(acc_fillM,4), #9);
    write(fileFitpars, acc_iterM:10, ' ');
    write(fileFitpars, schoen(acc_residM, 4):10, ' ');
    for i:=0 to 5 do
        if C[i].fit=1 then write(fileFitpars, schoen(acc_imax[i+1],SIG), #9);
    if C_X.fit=1  then write(fileFitpars, schoen(acc_imax[7],SIG), #9);
    if C_Mie.fit=1 then write(fileFitpars, schoen(acc_imax[8],SIG), #9);
    if C_Y.fit=1  then write(fileFitpars, schoen(acc_imax[9],SIG), #9);
    if S.fit=1    then write(fileFitpars, schoen(acc_imax[10],SIG), #9);
    if n.fit=1    then write(fileFitpars, schoen(acc_imax[11],SIG), #9);
    if T_W.fit=1  then write(fileFitpars, schoen(acc_imax[12],SIG), #9);
    if Q.fit=1    then write(fileFitpars, schoen(acc_imax[13],SIG), #9);
    if fluo.fit=1 then write(fileFitpars, schoen(acc_imax[14],SIG), #9);
    if rho_L.fit=1   then write(fileFitpars, schoen(acc_imax[15],SIG), #9);
    if rho_dd.fit=1  then write(fileFitpars, schoen(acc_imax[16],SIG), #9);
    if rho_ds.fit=1  then write(fileFitpars, schoen(acc_imax[17],SIG), #9);
    if alpha.fit=1    then write(fileFitpars, schoen(acc_imax[19],SIG), #9);
    if beta.fit=1     then write(fileFitpars, schoen(acc_imax[18],SIG), #9);
    if f_dd.fit=1     then write(fileFitpars, schoen(acc_imax[20],SIG), #9);
    if f_ds.fit=1     then write(fileFitpars, schoen(acc_imax[21],SIG), #9);
    if H_oz.fit=1     then write(fileFitpars, schoen(acc_imax[22],SIG), #9);
    if WV.fit=1       then write(fileFitpars, schoen(acc_imax[23],SIG), #9);
    if f.fit=1        then write(fileFitpars, schoen(acc_imax[24],SIG), #9);
    if z.fit=1        then write(fileFitpars, schoen(acc_imax[25],SIG), #9);
    if zB.fit=1       then write(fileFitpars, schoen(acc_imax[26],SIG), #9);
    if sun.fit=1      then write(fileFitpars, schoen(acc_imax[27],SIG), #9);
    if view.fit=1     then write(fileFitpars, schoen(acc_imax[28],SIG), #9);
    if dphi.fit=1     then write(fileFitpars, schoen(acc_imax[29],SIG), #9);
    if f_nw.fit=1     then write(fileFitpars, schoen(acc_imax[50],SIG), #9);
    for i:=0 to 5 do
        if fA[i].fit=1 then write(fileFitpars, schoen(acc_imax[30+i],SIG), #9);
    if bbs_phy.fit=1 then write(fileFitpars, schoen(acc_imax[36],SIG), #9);
    if g_dd.fit=1    then write(fileFitpars, schoen(acc_imax[37],SIG), #9);
    if g_dsr.fit=1   then write(fileFitpars, schoen(acc_imax[38],SIG), #9);
    if g_dsa.fit=1   then write(fileFitpars, schoen(acc_imax[39],SIG), #9);
    if not flag_public then begin
        if alpha_r.fit=1  then write(fileFitpars, schoen(acc_imax[47],SIG), #9);
        if beta_r.fit=1   then write(fileFitpars, schoen(acc_imax[48],SIG), #9);
        if gamma_r.fit=1  then write(fileFitpars, schoen(acc_imax[49],SIG), #9);
        if delta_r.fit=1  then write(fileFitpars, schoen(acc_imax[40],SIG), #9);
        if alpha_d.fit=1  then write(fileFitpars, schoen(acc_imax[41],SIG), #9);
        if beta_d.fit=1   then write(fileFitpars, schoen(acc_imax[42],SIG), #9);
        if gamma_d.fit=1  then write(fileFitpars, schoen(acc_imax[43],SIG), #9);
        if delta_d.fit=1  then write(fileFitpars, schoen(acc_imax[44],SIG), #9);
        if dummy.fit=1    then write(fileFitpars, schoen(acc_imax[45],SIG), #9);
        if test.fit=1     then write(fileFitpars, schoen(acc_imax[46],SIG), #9);
        end;

    if flag_shallow then write(fileFitpars, schoen(acc_fillsM,SIGe):SPACE, '   ');

    { reconstruction mode }
    if flag_b_loadAll=FALSE then begin
        for i:=0 to 5 do
            if C[i].sv=1 then write(fileFitpars, schoen(acc_emax[i+1],SIGe), #9);
        if C_X.sv=1  then write(fileFitpars, schoen(acc_emax[7],SIGe), #9);
        if C_Mie.sv=1 then write(fileFitpars, schoen(acc_emax[8],SIGe), #9);
        if C_Y.sv=1  then write(fileFitpars, schoen(acc_emax[9],SIGe), #9);
        if S.sv=1    then write(fileFitpars, schoen(acc_emax[10],SIGe), #9);
        if n.sv=1    then write(fileFitpars, schoen(acc_emax[11],SIGe), #9);
        if T_W.sv=1  then write(fileFitpars, schoen(acc_emax[12],SIGe), #9);
        if Q.sv=1    then write(fileFitpars, schoen(acc_emax[13],SIGe), #9);
        if fluo.sv=1 then write(fileFitpars, schoen(acc_emax[14],SIGe), #9);
        if rho_L.sv=1   then write(fileFitpars, schoen(acc_emax[15],SIGe), #9);
        if rho_dd.sv=1 then write(fileFitpars, schoen(acc_emax[16],SIGe), #9);
        if rho_ds.sv=1  then write(fileFitpars, schoen(acc_emax[17],SIGe), #9);
        if alpha.sv=1    then write(fileFitpars, schoen(acc_emax[19],SIGe), #9);
        if beta.sv=1     then write(fileFitpars, schoen(acc_emax[18],SIGe), #9);
        if f_dd.sv=1     then write(fileFitpars, schoen(acc_emax[20],SIGe), #9);
        if f_ds.sv=1     then write(fileFitpars, schoen(acc_emax[21],SIGe), #9);
        if H_oz.sv=1     then write(fileFitpars, schoen(acc_emax[22],SIGe), #9);
        if WV.sv=1       then write(fileFitpars, schoen(acc_emax[23],SIGe), #9);
        if f.sv=1        then write(fileFitpars, schoen(acc_emax[24],SIGe), #9);
        if z.sv=1        then write(fileFitpars, schoen(acc_emax[25],SIGe), #9);
        if zB.sv=1       then write(fileFitpars, schoen(acc_emax[26],SIGe), #9);
        if sun.sv=1      then write(fileFitpars, schoen(acc_emax[27],SIGe), #9);
        if view.sv=1     then write(fileFitpars, schoen(acc_emax[28],SIGe), #9);
        if dphi.sv=1     then write(fileFitpars, schoen(acc_emax[29],SIGe), #9);
        if f_nw.sv=1     then write(fileFitpars, schoen(acc_emax[50],SIGe), #9);
        for i:=0 to 5 do
            if fA[i].sv=1 then write(fileFitpars, schoen(acc_emax[30+i],SIGe), #9);
        if bbs_phy.sv=1 then write(fileFitpars, schoen(acc_emax[36],SIGe), #9);
        if g_dd.sv=1  then write(fileFitpars, schoen(acc_emax[37],SIGe), #9);
        if g_dsr.sv=1   then write(fileFitpars, schoen(acc_emax[38],SIGe), #9);
        if g_dsa.sv=1  then write(fileFitpars, schoen(acc_emax[39],SIGe), #9);
        if not flag_public then begin
            if alpha_r.sv=1  then write(fileFitpars, schoen(acc_emax[47],SIGe), #9);
            if beta_r.sv=1   then write(fileFitpars, schoen(acc_emax[48],SIGe), #9);
            if gamma_r.sv=1  then write(fileFitpars, schoen(acc_emax[49],SIGe), #9);
            if delta_r.sv=1  then write(fileFitpars, schoen(acc_emax[40],SIGe), #9);
            if alpha_d.sv=1  then write(fileFitpars, schoen(acc_emax[41],SIGe), #9);
            if beta_d.sv=1   then write(fileFitpars, schoen(acc_emax[42],SIGe), #9);
            if gamma_d.sv=1  then write(fileFitpars, schoen(acc_emax[43],SIGe), #9);
            if delta_d.sv=1  then write(fileFitpars, schoen(acc_emax[44],SIGe), #9);
            if dummy.sv=1    then write(fileFitpars, schoen(acc_emax[45],SIGe), #9);
            if test.sv=1     then write(fileFitpars, schoen(acc_emax[46],SIGe), #9);
            end;
        end;
    end;
    closeFile(FileFitpars);
    end;

procedure merk_fw;
{ Copy the actual parameter values "fw" of forward mode to "merkFw"
  in order to use the "fw" parameters for other purposes. }
var i : integer;
begin
    for i:=0 to 5 do C[i].merkFw :=C[i].fw;
    C_X.merkFw     :=C_X.fw;
    C_Mie.merkFw   :=C_Mie.fw;
    C_Y.merkFw     :=C_Y.fw;
    S.merkFw       :=S.fw;
    n.merkFw       :=n.fw;
    T_W.merkFw     :=T_W.fw;
    Q.merkFw       :=Q.fw;
    fluo.merkFw    :=fluo.fw;
    rho_L.merkFw   :=rho_L.fw;
    rho_dd.merkFw  :=rho_dd.fw;
    rho_ds.merkFw  :=rho_ds.fw;
    alpha.merkFw   :=alpha.fw;
    beta.merkFw    :=beta.fw;
    f_dd.merkFw    :=f_dd.fw;
    f_ds.merkFw    :=f_ds.fw;
    H_oz.merkFw    :=H_oz.fw;
    WV.merkFw      :=WV.fw;
    f.merkFw       :=f.fw;
    z.merkFw       :=z.fw;
    zB.merkFw      :=zB.fw;
    sun.merkFw     :=sun.fw;
    view.merkFw    :=view.fw;
    dphi.merkFw    :=dphi.fw;
    f_nw.merkFw    :=f_nw.fw;
    for i:=0 to 5 do fA[i].merkFw:=fA[i].fw;
    bbs_phy.merkFw :=bbs_phy.fw;
    g_dd.merkFw    :=g_dd.fw;
    g_dsr.merkFw   :=g_dsr.fw;
    g_dsa.merkFw   :=g_dsa.fw;
    delta_r.merkFw :=delta_r.fw;
    alpha_d.merkFw :=alpha_d.fw;
    beta_d.merkFw  :=beta_d.fw;
    gamma_d.merkFw :=gamma_d.fw;
    delta_d.merkFw :=delta_d.fw;
    dummy.merkFw   :=dummy.fw;
    test.merkFw    :=test.fw;
    alpha_r.merkFw :=alpha_r.fw;
    beta_r.merkFw  :=beta_r.fw;
    gamma_r.merkFw :=gamma_r.fw;
    end;

procedure merk_actual;
{ Copy the actual parameter values "actual" of inverse mode to "merk"
  in order to use the "actual" parameters for other purposes. }
var i : integer;
begin
    for i:=0 to 5 do C[i].merk :=C[i].actual;
    C_X.merk     := C_X.actual;
    C_Mie.merk   := C_Mie.actual;
    C_Y.merk     := C_Y.actual;
    S.merk       := S.actual;
    n.merk       := n.actual;
    T_W.merk     := T_W.actual;
    Q.merk       := Q.actual;
    fluo.merk    := fluo.actual;
    rho_L  .merk := rho_L.actual;
    rho_dd.merk  := rho_dd.actual;
    rho_ds.merk  := rho_ds.actual;
    alpha.merk   := alpha.actual;
    beta.merk    := beta.actual;
    f_dd.merk    := f_dd.actual;
    f_ds.merk    := f_ds.actual;
    H_oz.merk    := H_oz.actual;
    WV.merk      := WV.actual;
    f.merk       := f.actual;
    z.merk       := z.actual;
    zB.merk      := zB.actual;
    sun.merk     := sun.actual;
    view.merk    := view.actual;
    dphi.merk    := dphi.actual;
    f_nw.merk    := f_nw.actual;
    for i:=0 to 5 do fA[i].merk:=fA[i].actual;
    bbs_phy.merk := bbs_phy.actual;
    g_dd.merk    := g_dd.actual;
    g_dsr.merk   := g_dsr.actual;
    g_dsa.merk   := g_dsa.actual;
    delta_r.merk := delta_r.actual;
    alpha_d.merk := alpha_d.actual;
    beta_d.merk  := beta_d.actual;
    gamma_d.merk := gamma_d.actual;
    delta_d.merk := delta_d.actual;
    dummy.merk   := dummy.actual;
    test.merk    := test.actual;
    alpha_r.merk := alpha_r.actual;
    beta_r.merk  := beta_r.actual;
    gamma_r.merk := gamma_r.actual;
    end;

procedure merk_fit;
{ Copy the actual parameters "fit" of inverse mode to "merkFit"
  in order to use the "fit" parameters for other purposes. }
var i : integer;
begin
    for i:=0 to 5 do C[i].merkFit  :=C[i].fit;
    C_X.merkFit   :=C_X.fit;
    C_Mie.merkFit :=C_Mie.fit;
    C_Y.merkFit   :=C_Y.fit;
    S.merkFit     :=S.fit;
    n.merkFit     :=n.fit;
    T_W.merkFit   :=T_W.fit;
    Q.merkFit     :=Q.fit;
    rho_dd.merkFit   :=rho_dd.fit;
    rho_L.merkFit    :=rho_L.fit;
    rho_ds.merkFit :=rho_ds.fit;
    alpha.merkFit :=alpha.fit;
    beta.merkFit  :=beta.fit;
    f_dd.merkFit  :=f_dd.fit;
    f_ds.merkFit  :=f_ds.fit;
    H_oz.merkFit  :=H_oz.fit;
    WV.merkFit    :=WV.fit;
    f.merkFit     :=f.fit;
    z.merkFit     :=z.fit;
    zB.merkFit    :=zB.fit;
    sun.merkFit   :=sun.fit;
    view.merkFit  :=view.fit;
    dphi.merkFit  :=dphi.fit;
    f_nw.merkFit  :=f_nw.fit;
    for i:=0 to 5 do fA[i].merkFit:=fA[i].fit;
    bbs_phy.merkFit :=bbs_phy.fit;
    g_dd.merkFit    :=g_dd.fit;
    g_dsr.merkFit   :=g_dsr.fit;
    g_dsa.merkFit   :=g_dsa.fit;
    alpha_r.merkFit :=alpha_r.fit;
    beta_r.merkFit  :=beta_r.fit;
    gamma_r.merkFit :=gamma_r.fit;
    delta_r.merkFit :=delta_r.fit;
    alpha_d.merkFit :=alpha_d.fit;
    beta_d.merkFit  :=beta_d.fit;
    gamma_d.merkFit :=gamma_d.fit;
    delta_d.merkFit :=delta_d.fit;
    fluo.merkFit    :=fluo.fit;
    test.merkFit    :=test.fit;
    dummy.merkFit   :=dummy.fit;
    end;

procedure restore_fw;
{ Copy the "merkFw" parameters back to "fw" after the
  "fw" parameters may have been used for other purposes. }
var i : integer;
begin
    for i:=0 to 5 do C[i].fw:=C[i].merkFw;
    C_X.fw     := C_X.merkFw;
    C_Mie.fw   := C_Mie.merkFw;
    C_Y.fw     := C_Y.merkFw;
    S.fw       := S.merkFw;
    n.fw       := n.merkFw;
    T_W.fw     := T_W.merkFw;
    Q.fw       := Q.merkFw;
    fluo.fw    := fluo.merkFw;
    rho_L.fw   := rho_L.merkFw;
    rho_dd.fw  := rho_dd.merkFw;
    rho_ds.fw  := rho_ds.merkFw;
    alpha.fw   := alpha.merkFw;
    beta.fw    := beta.merkFw;
    f_dd.fw    := f_dd.merkFw;
    f_ds.fw    := f_ds.merkFw;
    H_oz.fw    := H_oz.merkFw;
    WV.fw      := WV.merkFw;
    f.fw       := f.merkFw;
    z.fw       := z.merkFw;
    zB.fw      := zB.merkFw;
    sun.fw     := sun.merkFw;
    view.fw    := view.merkFw;
    dphi.fw    := dphi.merkFw;
    f_nw.fw    := f_nw.merkFw;
    for i:=0 to 5 do fA[i].fw:=fA[i].merkFw;
    bbs_phy.fw := bbs_phy.merkFw;
    g_dd.fw    := g_dd.merkFw;
    g_dsr.fw   := g_dsr.merkFw;
    g_dsa.fw   := g_dsa.merkFw;
    delta_r.fw := delta_r.merkFw;
    alpha_d.fw := alpha_d.merkFw;
    beta_d.fw  := beta_d.merkFw;
    gamma_d.fw := gamma_d.merkFw;
    delta_d.fw := delta_d.merkFw;
    dummy.fw   := dummy.merkFw;
    test.fw    := test.merkFw;
    alpha_r.fw := alpha_r.merkFw;
    beta_r.fw  := beta_r.merkFw;
    gamma_r.fw := gamma_r.merkFw;
    end;

procedure restore_actual;
{ Copy the "merk" parameter values back to "actual" after the
  "actual" parameters may have been used for other purposes. }
var i : integer;
begin
    for i:=0 to 5 do C[i].actual:=C[i].merk;
    C_X.actual     :=C_X.merk;
    C_Mie.actual   :=C_Mie.merk;
    C_Y.actual     :=C_Y.merk;
    S.actual       :=S.merk;
    n.actual       :=n.merk;
    T_W.actual     :=T_W.merk;
    Q.actual       :=Q.merk;
    fluo.actual    :=fluo.merk;
    rho_L.actual   :=rho_L.merk;
    rho_dd.actual  :=rho_dd.merk;
    rho_ds.actual  :=rho_ds.merk;
    alpha.actual   :=alpha.merk;
    beta.actual    :=beta.merk;
    f_dd.actual    :=f_dd.merk;
    f_ds.actual    :=f_ds.merk;
    H_oz.actual    :=H_oz.merk;
    WV.actual      :=WV.merk;
    f.actual       :=f.merk;
    z.actual       :=z.merk;
    zB.actual      :=zB.merk;
    sun.actual     :=sun.merk;
    view.actual    :=view.merk;
    dphi.actual    :=dphi.merk;
    f_nw.actual    :=f_nw.merk;
    for i:=0 to 5 do fA[i].actual:=fA[i].merk;
    bbs_phy.actual :=bbs_phy.merk;
    g_dd.actual    :=g_dd.merk;
    g_dsr.actual   :=g_dsr.merk;
    g_dsa.actual   :=g_dsa.merk;
    delta_r.actual :=delta_r.merk;
    alpha_d.actual :=alpha_d.merk;
    beta_d.actual  :=beta_d.merk;
    gamma_d.actual :=gamma_d.merk;
    delta_d.actual :=delta_d.merk;
    dummy.actual   :=dummy.merk;
    test.actual    :=test.merk;
    alpha_r.actual :=alpha_r.merk;
    beta_r.actual  :=beta_r.merk;
    gamma_r.actual :=gamma_r.merk;
    end;

procedure restore_fit;
{ Copy the "merkFit" parameter values back to "fit" after the
  "fit" parameters may have been used for other purposes. }
var i : integer;
begin
    for i:=0 to 5 do C[i].fit:=C[i].merkFit;
    C_X.fit  :=C_X.merkFit;
    C_Mie.fit :=C_Mie.merkFit;
    C_Y.fit  :=C_Y.merkFit;
    S.fit    :=S.merkFit;
    n.fit    :=n.merkFit;
    T_W.fit  :=T_W.merkFit;
    Q.fit    :=Q.merkFit;
    rho_dd.fit   :=rho_dd.merkFit;
    rho_L.fit    :=rho_L.merkFit;
    rho_ds.fit :=rho_ds.merkFit;
    alpha.fit :=alpha.merkFit;
    beta.fit  :=beta.merkFit;
    f_dd.fit  :=f_dd.merkFit;
    f_ds.fit  :=f_ds.merkFit;
    H_oz.fit  :=H_oz.merkFit;
    WV.fit    :=WV.merkFit;
    f.fit     :=f.merkFit;
    z.fit     :=z.merkFit;
    zB.fit    :=zB.merkFit;
    sun.fit   :=sun.merkFit;
    view.fit  :=view.merkFit;
    dphi.fit  :=dphi.merkFit;
    f_nw.fit  :=f_nw.merkFit;
    for i:=0 to 5 do fA[i].fit:=fA[i].merkFit;
    bbs_phy.fit :=bbs_phy.merkFit;
    g_dd.fit    :=g_dd.merkFit;
    g_dsr.fit   :=g_dsr.merkFit;
    g_dsa.fit   :=g_dsa.merkFit;
    alpha_r.fit :=alpha_r.merkFit;
    beta_r.fit  :=beta_r.merkFit;
    gamma_r.fit :=gamma_r.merkFit;
    delta_r.fit :=delta_r.merkFit;
    alpha_d.fit :=alpha_d.merkFit;
    beta_d.fit  :=beta_d.merkFit;
    gamma_d.fit :=gamma_d.merkFit;
    delta_d.fit :=delta_d.merkFit;
    fluo.fit    :=fluo.merkFit;
    test.fit    :=test.merkFit;
    dummy.fit   :=dummy.merkFit;
    end;

procedure actual_to_fw;
{ Copy the "actual" parameters to "fw" in order to calculate spectra
  using the parameter set of inverse modeling. }
var i : integer;
begin
    for i:=0 to 5 do C[i].fw:=C[i].actual;
    C_X.fw     := C_X.actual;
    C_Mie.fw   := C_Mie.actual;
    C_Y.fw     := C_Y.actual;
    S.fw       := S.actual;
    n.fw       := n.actual;
    T_W.fw     := T_W.actual;
    Q.fw       := Q.actual;
    fluo.fw    := fluo.actual;
    rho_L.fw   := rho_L.actual;
    rho_dd.fw  := rho_dd.actual;
    rho_ds.fw  := rho_ds.actual;
    alpha.fw   := alpha.actual;
    beta.fw    := beta.actual;
    f_dd.fw    := f_dd.actual;
    f_ds.fw    := f_ds.actual;
    H_oz.fw    := H_oz.actual;
    WV.fw      := WV.actual;
    f.fw       := f.actual;
    z.fw       := z.actual;
    zB.fw      := zB.actual;
    sun.fw     := sun.actual;
    view.fw    := view.actual;
    dphi.fw    := dphi.actual;
    f_nw.fw    := f_nw.actual;
    for i:=0 to 5 do fA[i].fw:=fA[i].actual;
    bbs_phy.fw := bbs_phy.actual;
    g_dd.fw    := g_dd.actual;
    g_dsr.fw   := g_dsr.actual;
    g_dsa.fw   := g_dsa.actual;
    delta_r.fw := delta_r.actual;
    alpha_d.fw := alpha_d.actual;
    beta_d.fw  := beta_d.actual;
    gamma_d.fw := gamma_d.actual;
    delta_d.fw := delta_d.actual;
    dummy.fw   := dummy.actual;
    test.fw    := test.actual;
    alpha_r.fw := alpha_r.actual;
    beta_r.fw  := beta_r.actual;
    gamma_r.fw := gamma_r.actual;
    end;

procedure exclude_fit;
{ Exclude certain parameters from fit. }
var i : integer;
begin
    case spec_type of
    S_Ed_GC: begin { E_down }
          if flag_above then begin
              for i:=0 to 5 do C[i].fit:=0;
              C_X.fit  :=0;
              C_Mie.fit:=0;
              bbs_phy.fit:=0;
              C_Y.fit  :=0;
              S.fit    :=0;
              n.fit    :=0;
              T_W.fit  :=0;
              f.fit    :=0;
              z.fit    :=0;
              end;
           Q.fit       :=0;
           if flag_calc_rho_ds then rho_ds.fit :=0;
           zB.fit      :=0;
           view.fit    :=0;
           dphi.fit    :=0;
           for i:=0 to 5 do fA[i].fit:=0;
           alpha_d.fit :=0;
           beta_d.fit  :=0;
           gamma_d.fit :=0;
           delta_d.fit :=0;
           g_dd.fit :=0;
           g_dsr.fit  :=0;
           g_dsa.fit  :=0;
           alpha_r.fit :=0;
           beta_r.fit  :=0;
           gamma_r.fit :=0;
           delta_r.fit :=0;
           fluo.fit    :=0;
           end;
    S_Lup: if not flag_surf_inv then begin { L_up }
           rho_L.fit   :=0;
           f_nw.fit    :=0;
           dummy.fit   :=0;
           {
           rho_dd.fit  :=0;
           rho_ds.fit  :=0;
           beta.fit    :=0;
           g_dd.fit :=0;
           g_dsr.fit  :=0;
           g_dsa.fit :=0;
           }
           alpha_r.fit :=0;
           beta_r.fit  :=0;
           gamma_r.fit :=0;
           delta_r.fit :=0;
           if not flag_shallow then begin
               z.fit       :=0;
               zB.fit      :=0;
               sun.fit     :=0;
               view.fit    :=0;
               dphi.fit    :=0;
               for i:=0 to 5 do fA[i].fit:=0;
               end;
           end;
    S_Rrs: if not flag_surf_inv then begin { R_rs }
           f_nw.fit    :=0;
           f_dd.fit    :=0;
           f_ds.fit    :=0;
           H_oz.fit    :=0;
           WV.fit      :=0;
           rho_L.fit   :=0;
           dummy.fit   :=0;
           rho_dd.fit  :=0;
           rho_ds.fit  :=0;
           beta.fit    :=0;
           g_dd.fit    :=0;
           g_dsr.fit   :=0;
           g_dsa.fit   :=0;
           alpha_r.fit :=0;
           beta_r.fit  :=0;
           gamma_r.fit :=0;
           delta_r.fit :=0;
           alpha_d.fit :=0;
           beta_d.fit  :=0;
           gamma_d.fit :=0;
           delta_d.fit :=0;
           alpha.fit:=0;
           if not flag_shallow then begin
               z.fit       :=0;
               zB.fit      :=0;
               sun.fit     :=0;
               view.fit    :=0;
               dphi.fit    :=0;
               for i:=0 to 5 do fA[i].fit:=0;
               end;
           end;
    S_R: begin { R }
           Q.fit         :=0;
           rho_L.fit     :=0;
           f_dd.fit      :=0;
           f_ds.fit      :=0;
           H_oz.fit      :=0;
           WV.fit        :=0;
           dummy.fit     :=0;
           rho_dd.fit    :=0;
           rho_ds.fit    :=0;
           beta.fit      :=0;
           g_dd.fit   :=0;
           g_dsr.fit    :=0;
           g_dsa.fit   :=0;
           alpha_r.fit :=0;
           beta_r.fit  :=0;
           gamma_r.fit :=0;
           delta_r.fit   :=0;
           alpha_d.fit   :=0;
           beta_d.fit    :=0;
           gamma_d.fit   :=0;
           delta_d.fit   :=0;
           alpha.fit       :=0;
           if not flag_shallow then begin
               z.fit       :=0;
               zB.fit      :=0;
               if model_f=0 then sun.fit:=0 else f.fit:=0;
               view.fit    :=0;
               dphi.fit    :=0;
               for i:=0 to 5 do fA[i].fit:=0;
               end;
           end;
    S_a: begin { a }
           Q.fit       :=0;
           n.fit       :=0;
           rho_dd.fit  :=0;
           rho_ds.fit  :=0;
           rho_L.fit   :=0;
           f_dd.fit    :=0;
           f_ds.fit    :=0;
           H_oz.fit    :=0;
           WV.fit      :=0;
           dummy.fit   :=0;
           beta.fit    :=0;
           alpha.fit   :=0;
           f.fit       :=0;
           z.fit       :=0;
           zB.fit      :=0;
           sun.fit     :=0;
           view.fit    :=0;
           dphi.fit    :=0;
           f_nw.fit    :=0;
           for i:=0 to 5 do fA[i].fit:=0;
           g_dd.fit    :=0;
           g_dsr.fit   :=0;
           g_dsa.fit   :=0;
           alpha_r.fit :=0;
           beta_r.fit  :=0;
           gamma_r.fit :=0;
           delta_r.fit :=0;
           alpha_d.fit :=0;
           beta_d.fit  :=0;
           gamma_d.fit :=0;
           delta_d.fit :=0;
           end;
    S_Kd: begin { Kd }
           Q.fit       :=0;
           rho_dd.fit  :=0;
           rho_ds.fit  :=0;
           rho_L.fit   :=0;
           f_dd.fit    :=0;
           f_ds.fit    :=0;
           H_oz.fit    :=0;
           WV.fit      :=0;
           dummy.fit   :=0;
           beta.fit    :=0;
           alpha.fit   :=0;
           z.fit       :=0;
           zB.fit      :=0;
           view.fit    :=0;
           dphi.fit    :=0;
           f_nw.fit    :=0;
           for i:=0 to 5 do fA[i].fit:=0;
           g_dd.fit :=0;
           g_dsr.fit  :=0;
           g_dsa.fit :=0;
           alpha_r.fit :=0;
           beta_r.fit  :=0;
           gamma_r.fit :=0;
           delta_r.fit :=0;
           alpha_d.fit :=0;
           beta_d.fit  :=0;
           gamma_d.fit :=0;
           delta_d.fit :=0;
           end;
    S_RBottom: begin { Bottom albedo }
           for i:=0 to 5 do C[i].fit:=0;
           C_X.fit  :=0;
           C_Mie.fit:=0;
           bbs_phy.fit:=0;
           C_Y.fit  :=0;
           S.fit    :=0;
           n.fit    :=0;
           T_W.fit  :=0;
           f.fit       :=0;
           Q.fit       :=0;
           rho_dd.fit  :=0;
           rho_ds.fit  :=0;
           f_dd.fit    :=0;
           f_ds.fit    :=0;
           H_oz.fit    :=0;
           WV.fit      :=0;
           rho_L.fit   :=0;
           dummy.fit   :=0;
           beta.fit    :=0;
           alpha.fit   :=0;
           g_dd.fit :=0;
           g_dsr.fit  :=0;
           g_dsa.fit :=0;
           alpha_r.fit :=0;
           beta_r.fit  :=0;
           gamma_r.fit :=0;
           delta_r.fit :=0;
           alpha_d.fit :=0;
           beta_d.fit  :=0;
           gamma_d.fit :=0;
           delta_d.fit :=0;
           z.fit       :=0;
           zB.fit      :=0;
           view.fit    :=0;
           dphi.fit    :=0;
           end;
    S_Ed_Gege: begin { E_down }
          if flag_above then begin
              for i:=0 to 5 do C[i].fit:=0;
              C_X.fit  :=0;
              C_Mie.fit:=0;
              bbs_phy.fit:=0;
              C_Y.fit  :=0;
              S.fit    :=0;
              n.fit    :=0;
              T_W.fit  :=0;
              f.fit    :=0;
              z.fit    :=0;
              end;
           Q.fit       :=0;
           rho_dd.fit  :=0;
           rho_ds.fit  :=0;
           rho_L.fit   :=0;
           dummy.fit   :=0;
           beta.fit    :=0;
           zB.fit      :=0;
           sun.fit     :=0;
           view.fit    :=0;
           dphi.fit    :=0;
           f_nw.fit    :=0;
           for i:=0 to 5 do fA[i].fit:=0;
           g_dd.fit   :=0;
           g_dsr.fit   :=0;
           g_dsa.fit   :=0;
           alpha_r.fit :=0;
           beta_r.fit  :=0;
           gamma_r.fit :=0;
           delta_r.fit :=0;
           fluo.fit    :=0;
           test.fit    :=0;
           end;

    S_Test: begin
            end;
    end;
    if not flag_Y_exp then S.fit:=0; { if aY from file, no fit of S }
    end;

procedure set_parameter_descriptions;
var i : integer;
begin
    for i:=0 to 5 do
        par.desc[1+i] := 'Concentration of ' + ExtractFileName(aP[i]^.FName) + ' [ug/l]';
    par.desc[7]  := 'Concentration of non-algal particles type I [mg/l]';
    par.desc[8]  := 'Concentration of non-algal particles type II [mg/l]';
    par.desc[9]  := 'Concentration of CDOM [1/m]';
    par.desc[10] := 'Exponent of CDOM absorption [1/nm]';
    par.desc[11] := 'Angström exponent of non-algal particles type II';
    par.desc[12] := 'Water temperature [°C]';
    par.desc[13] := 'Anisotropy factor of upwelling radiation [sr]';
    par.desc[14] := 'Quantum yield of chl-a fluorescence';
    par.desc[15] := 'Reflection factor of downwelling radiance';
    par.desc[16] := 'Reflection factor of direct downwelling irradiance';
    par.desc[17] := 'Reflection factor of diffuse downwelling irradiance';
    par.desc[18] := 'Aerosol optical thickness at 550 nm';
    par.desc[19] := 'Angström exponent of aerosol scattering';
    par.desc[20] := 'Fraction of direct downwelling irradiance';
    par.desc[21] := 'Fraction of diffuse downwelling irradiance';
    par.desc[22] := 'Scale height of ozone [cm]';
    par.desc[23] := 'Scale height of precipitable water in the atmosphere [cm]';
    par.desc[24] := 'Proportionality factor of irradiance reflectance';
    par.desc[25] := 'Sensor depth [m]';
    par.desc[26] := 'Bottom depth [m]';
    par.desc[27] := 'Sun zenith angle [deg]';
    par.desc[28] := 'Viewing angle [deg]';
    par.desc[29] := 'Azimuth difference between sun and viewing direction [deg]';
    for i:=0 to 5 do
        par.desc[30+i] := 'Areal fraction of ' + ExtractFileName(albedo[i]^.FName);
    par.desc[36] := 'Specific backscattering coefficient of phytoplankton [m^2/mg]';
    par.desc[37] := 'Fraction of sky radiance due to direct solar radiation [1/sr]';
    par.desc[38] := 'Fraction of sky radiance due to molecule scattering [1/sr]';
    par.desc[39] := 'Fraction of sky radiance due to aerosol scattering [1/sr]';
    par.desc[50] := 'Fraction of non-water area';
    {
    par.desc[40] := 'delta_r';
    par.desc[41] := 'alpha_d';
    par.desc[42] := 'beta_d';
    par.desc[43] := 'gamma_d';
    par.desc[44] := 'delta_d';
    par.desc[45] := 'dummy';
    par.desc[46] := 'test';
    par.desc[47] := 'alpha_r';
    par.desc[48] := 'beta_r';
    par.desc[49] := 'gamma_r';
    }
    end;

procedure set_parameter_names;
begin
    par.name[1]  := 'C[0]';
    par.name[2]  := 'C[1]';
    par.name[3]  := 'C[2]';
    par.name[4]  := 'C[3]';
    par.name[5]  := 'C[4]';
    par.name[6]  := 'C[5]';
    par.name[7]  := 'C_X';
    par.name[8]  := 'C_Mie';
    par.name[9]  := 'C_Y';
    par.name[10] := 'S';
    par.name[11] := 'n';
    par.name[12] := 'T_W';
    par.name[13] := 'Q';
    par.name[14] := 'fluo';
    par.name[15] := 'rho_L';
    par.name[16] := 'rho_dd';
    par.name[17] := 'rho_ds';
    par.name[18] := 'beta';
    par.name[19] := 'alpha';
    par.name[20] := 'f_dd';
    par.name[21] := 'f_ds';
    par.name[22] := 'H_oz';
    par.name[23] := 'WV';
    par.name[24] := 'f';
    par.name[25] := 'z';
    par.name[26] := 'zB';
    par.name[27] := 'sun';
    par.name[28] := 'view';
    par.name[29] := 'dphi';
    par.name[30] := 'fA[0]';
    par.name[31] := 'fA[1]';
    par.name[32] := 'fA[2]';
    par.name[33] := 'fA[3]';
    par.name[34] := 'fA[4]';
    par.name[35] := 'fA[5]';
    par.name[36] := 'bbs_phy';
    par.name[37] := 'g_dd';
    par.name[38] := 'g_dsr';
    par.name[39] := 'g_dsa';
    par.name[40] := 'delta_r';
    par.name[41] := 'alpha_d';
    par.name[42] := 'beta_d';
    par.name[43] := 'gamma_d';
    par.name[44] := 'delta_d';
    par.name[45] := 'dummy';
    par.name[46] := 'test';
    par.name[47] := 'alpha_r';
    par.name[48] := 'beta_r';
    par.name[49] := 'gamma_r';
    par.name[50] := 'f_nw';
    set_parameter_descriptions;
    end;

procedure set_YFilename;
begin
    if flag_2D_inv then ActualFile:=YFilename(HSI_img^.FName) else
    case spec_type of
        S_Ed_GC   : ActualFile:=YFilename(Ed^.FName);
        S_Lup     : ActualFile:=YFilename(Lu^.FName);
        S_rrs     : ActualFile:=YFilename(r_rs^.Fname);
        S_R       : ActualFile:=YFilename(R^.FName);
        S_Rsurf   : ActualFile:=YFilename(Rrs_surf^.FName);
        S_a       : ActualFile:=YFilename(a^.FName);
        S_Kd      : ActualFile:=YFilename(Kd^.FName);
        S_Rbottom : ActualFile:=YFilename(r_rs^.Fname);
        S_Ed_Gege : ActualFile:=YFilename(Ed^.FName);
        S_test    : ActualFile:=YFilename(Stest^.Fname);
        end;
    end;


procedure ReserveMemory;
var n : integer;
begin
   { Input spectra }
    new(x);
    new(FWHM);        FWHM^.ParText:='';
    new(offsetS);     offsetS^.ParText:='';
    new(scaleS);      scaleS^.ParText:='';
    new(noiseS);      noiseS^.ParText:='';
    new(E0);          E0^.ParText:='';
    new(aO2);         aO2^.ParText:='';
    new(aO3);         aO3^.ParText:='';
    new(aWV);         aWV^.ParText:='';
    a_ice.ParText:='';
    new(aW);          aW^.ParText:='';
    new(dadT);        dadT^.ParText:='';
    for n:=0 to 5 do begin
        new(aP[n]);   aP[n]^.ParText:='';
        new(albedo[n]); albedo[n]^.ParText:='';
        end;
    new(a_nw);        a_nw^.ParText:='';
    new(aNAP);        aNAP^.ParText:='';
    new(aY);          aY^.ParText:='';
    new(bXN);         bXN^.ParText:='';
    new(meas);        meas^.ParText:='';
    new(Ed);          Ed^.ParText:='';
    new(Ls);          Ls^.ParText:='';
    new(Kd);          Kd^.ParText:='';
    new(R);           R^.ParText:='';
    new(gew);         gew^.ParText:='';

    { Calculated spectra }
    new(bbW);         bbW^.ParText:='';
    new(bMie);        bMie^.ParText:='';
    new(bbMie);       bbMie^.ParText:='';
    new(GC_T_o2);     GC_T_o2^.ParText:='';
    new(GC_T_o3);     GC_T_o3^.ParText:='';
    new(GC_T_wv);     GC_T_wv^.ParText:='';
    new(GC_tau_a);    GC_tau_a^.ParText:='';
    new(GC_T_r);      GC_T_r^.ParText:='';
    new(GC_T_as);     GC_T_as^.ParText:='';
    new(GC_T_aa);     GC_T_aa^.ParText:='';
    new(Ed0);         Ed0^.ParText:='';
    new(GC_Edd);      GC_Edd^.ParText:='';
    new(GC_Eds);      GC_Eds^.ParText:='';
    new(GC_Edsr);     GC_Edsr^.ParText:='';
    new(GC_Edsa);     GC_Edsa^.ParText:='';
    new(r_d);         r_d^.ParText:='';
    new(Lu);          Lu^.ParText:='';
    new(Lr);          Lr^.ParText:='';
    new(Lf);          Lf^.ParText:='';
    new(Kdd);         Kdd^.ParText:='';
    new(Kds);         Kds^.ParText:='';
    new(KE_uW);       KE_uW^.ParText:='';
    new(KE_uB);       KE_uB^.ParText:='';
    new(kL_uW);       kL_uW^.ParText:='';
    new(kL_uB);       kL_uB^.ParText:='';
    new(z_Ed);        z_Ed^.ParText:='';
    new(r_rs);        r_rs^.ParText:='';
    new(Rrs);         Rrs^.ParText:='';
    new(Rrs_surf);    Rrs_surf^.ParText:='';
    new(Rrsf);        Rrsf^.ParText:='';
    new(f_R);         f_R^.ParText:='';
    new(f_rs);        f_rs^.ParText:='';
    new(Q_f);         Q_f^.ParText:='';
    new(bottom);      bottom^.ParText:='';
    new(a);           a^.ParText:='';
    new(b);           b^.ParText:='';
    new(bb);          bb^.ParText:='';
    new(a_calc);      a_calc^.ParText:='';
    new(aP_calc);     aP_calc^.ParText:='';
    new(aNAP_calc);   aNAP_calc^.ParText:='';
    new(aCDOM_calc);  aCDOM_calc^.ParText:='';
    new(b_calc);      b_calc^.ParText:='';
    new(bb_calc);     bb_calc^.ParText:='';
    new(bb_phy);      bb_phy^.ParText:='';
    new(bb_NAP);      bb_NAP^.ParText:='';
    new(omega_b);     omega_b^.ParText:='';

    { Private spectra }
    new(HSI_img);     HSI_img^.ParText:='';
    new(tA);          ta^.ParText:='';
    new(tC);          tC^.ParText:='';
    new(u_c);         u_c^.ParText:='';
    new(u_t);         u_t^.ParText:='';
    new(u_p);         u_p^.ParText:='';
    new(u_n);         u_n^.ParText:='';
    new(bPhyN);       bPhyN^.ParText:='';
    new(aphA);        aphA^.ParText:='';
    new(aphB);        aphB^.ParText:='';
    new(CMF_r);       CMF_r^.ParText:='';
    new(CMF_g);       CMF_g^.ParText:='';
    new(CMF_b);       CMF_b^.ParText:='';
    new(s_locus);     s_locus^.ParText:='';
    new(Stest);       Stest^.ParText:='';
    new(his_1st);     his_1st^.ParText:='';
    new(his_2nd);     his_2nd^.ParText:='';
    for n:=1 to MaxSpectra do new(spec[n]);
    new(xx);
    new(tEd);         tEd^.ParText:='';
    new(Mie);         Mie^.ParText:='';
    new(Rayleigh);    Rayleigh^.ParText:='';
    end;

procedure DisposeMemory;
var n : integer;
begin
    { Input spectra }
    dispose(x);
    dispose(FWHM);
    dispose(offsetS);
    dispose(scaleS);
    dispose(noiseS);
    dispose(E0);
    dispose(aO2);
    dispose(aO3);
    dispose(aWV);
    dispose(aW);
    dispose(dadT);
    for n:=0 to 5 do dispose(aP[n]);
    dispose(aNAP);
    dispose(aY);
    dispose(bXN);
    for n:=0 to 5 do dispose(albedo[n]);
    dispose(a_nw);
    dispose(meas);
    dispose(Ed);
    dispose(Ls);
    dispose(Kd);
    dispose(R);
    dispose(gew);

    { Calculated spectra }
    dispose(bbW);
    dispose(bMie);
    dispose(bbMie);
    dispose(GC_T_o2);
    dispose(GC_T_o3);
    dispose(GC_T_wv);
    dispose(GC_tau_a);
    dispose(GC_T_r);
    dispose(GC_T_as);
    dispose(GC_T_aa);
    dispose(Ed0);
    dispose(GC_Edd);
    dispose(GC_Eds);
    dispose(GC_Edsr);
    dispose(GC_Edsa);
    dispose(r_d);
    dispose(Lu);
    dispose(Lr);
    dispose(Lf);
    dispose(Kdd);
    dispose(Kds);
    dispose(KE_uW);
    dispose(KE_uB);
    dispose(kL_uW);
    dispose(kL_uB);
    dispose(z_Ed);
    dispose(r_rs);
    dispose(Rrs);
    dispose(Rrs_surf);
    dispose(Rrsf);
    dispose(f_R);
    dispose(f_rs);
    dispose(Q_f);
    dispose(bottom);
    dispose(a);
    dispose(b);
    dispose(bb);
    dispose(a_calc);
    dispose(aP_calc);
    dispose(aNAP_calc);
    dispose(aCDOM_calc);
    dispose(b_calc);
    dispose(bb_calc);
    dispose(bb_phy);
    dispose(bb_NAP);
    dispose(omega_b);

    { Private spectra }
    dispose(HSI_img);
    dispose(tA);
    dispose(tC);
    dispose(u_c);
    dispose(u_t);
    dispose(u_p);
    dispose(u_n);
    dispose(bPhyN);
    dispose(aphA);
    dispose(aphB);
    dispose(CMF_r);
    dispose(CMF_g);
    dispose(CMF_b);
    dispose(s_locus);
    dispose(Stest);
    dispose(his_1st);
    dispose(his_2nd);
    for n:=1 to MaxSpectra do dispose(spec[n]);
    dispose(xx);
    dispose(tEd);
    dispose(Mie);
    dispose(Rayleigh);
    end;

{ ************************************************************************* }

function DelDoubleSpaces(OldText:String):string;
{ Replace series of multiple blanks in a string by a single blank. }
var i : integer;
    s : string;
begin
    s:='';
    for i:=1 to length(OldText) do begin
        if (OldText[i]=' ') and (i>1) then begin
            if not (OldText[i-1]=' ') then s:=s+' ';
            end
        else s:=s+OldText[i];
        end;
    DelDoubleSpaces:=s;
    end;

procedure blanks_to_tab(datenfile, tabfile:string; header: integer);
{ Remove blanks from input file and replace them by tab spacing.
  Convert Unix (LF = #13) and Mac (CR = #10) line break to DOS line break (CR+LF) }
const zmax    = 10000;   { max. number of rows of input file }
var datei_out : text;
    datei_in  : text;
    before, after : string;
    z         : integer;
    flag_CRLF : boolean;
begin
    flag_CRLF:=ASCII_is_Windows(datenfile);
    {$i-}
    assignFile(datei_in, datenfile);
    reset(datei_in);
    if ioresult=0 then begin
        assignFile(datei_out, tabfile);
        rewrite(datei_out);
        // convert header
        if header>0 then for z:=1 to header do begin
            readlnS(datei_in, before, flag_CRLF);
            writeln(datei_out, before);
            end;
        z:=header;
        // convert data
        repeat
            readlnS(datei_in, before, flag_CRLF);
            if length(before)>0 then begin
                while before[1]=' ' do before:=copy(before, 2, length(before));
                after:=DelDoubleSpaces(before);
                after:=StringReplace(after, ' ', #9, [rfReplaceAll]);
                { handle files in which columns are separated by blank and TAB: }
                after:=StringReplace(after, #9#9, #9, [rfReplaceAll]);
                if length(after)>1 then writeln(datei_out, after);
                end;
            inc(z);
        until eof(datei_in) or (z>zmax);
        closeFile(datei_in);
        closeFile(datei_out);
        end;
    {$i+}
    end;


function lies(var datei_in : textFile; CRLF: boolean;
              PosX, PosY: integer; out x1,x2 : double):boolean;
{ Liest aus einer Datei zwei Werte x1, x2 ein, die an den Stellen PosX, PosY
  stehen. ACHTUNG: Trennzeichen nur #9.
  Unterschied zu function lies_alt: Zeilen können länger als 255 Zeichen sein. }
var j    : integer;
    c    : char;
    u, o : byte;
    x, y : double;
    ok   : boolean;
    dummyS : string;
begin
    ok:=TRUE; c:=' '; x:=0;
    if PosX<PosY then begin u:=PosX; o:=PosY end
                 else begin u:=PosY; o:=PosX end;
    for j:=1 to u-1 do repeat read(datei_in, c); until (c=#9) or (c=#13) or eof(datei_in);
    if (c=#13) or eof(datei_in) then ok:=FALSE;

    {$i-}  { Vermeide Programmabsturz, wenn x oder y keine Zahl ist }
    if ok then read(datei_in, x);
    if ioresult<>0 then ok:=FALSE;
    for j:=u+1 to o do repeat read(datei_in, c); until (c=#9) or (c=#13) or eof(datei_in);
    if (c=#13) or eof(datei_in) then ok:=FALSE;
    if o>u then read(datei_in, y) else y:=x;
    if ioresult<>0 then ok:=FALSE;
    {$i+}

    if PosX<PosY then begin x1:=x; x2:=y; end
                 else begin x1:=y; x2:=x; end;
    readlnS(datei_in, dummyS, CRLF);
    if eof(datei_in) then ok:=FALSE;
    lies:=ok;
    end;

(*
function lies_alt(var datei_in : textFile; PosX, PosY: byte; var x1,x2 : double):boolean;
{ Liest aus einer Datei zwei Werte x1, x2 ein, die an den Stellen PosX, PosY
  stehen. Sowohl Dezimalpunkt als auch Dezimalkomma sind gueltig. Trenn-
  zeichen: Blank oder #9. }
const maxSlength = 255;
var s127, sx1, sx2 : string[255];
    j, jj, b  : integer;
begin
    lies_alt:=TRUE;
    readln(datei_in, s127);
    if eof(datei_in) then lies_alt:=FALSE;

    { Entferne fuehrende Blanks, ersetze Kommas durch Punkte }
    j:=1;
    while s127[j]=' ' do inc(j);
    s127:=copy(s127, j, length(s127));
    for j:=1 to length(s127) do if s127[j]=',' then s127[j]:='.';
    for j:=1 to length(s127) do if s127[j]=#9  then s127[j]:=' ';
    s127:=s127+' ';

    { Lies x1 }
    sx2:=s127;
    b:=0;
    repeat
        j:=1;
        inc(b);
        while sx2[j]=' ' do inc(j);
        sx2:=copy(sx2, j, length(sx2));
        jj:=1;
        while (sx2[jj]<>' ') and (jj<length(sx2)) and (jj<maxSlength) do inc(jj);
        sx1:=copy(sx2, 1, jj-1);
        val(sx1, x1, j);
        sx2:=copy(sx2, jj, length(sx2));
    until b>=PosX;
    if j<>0 then begin x1:=0; end;

    { Lies x2 }
    b:=0;
    repeat
        j:=1;
        inc(b);
        while s127[j]=' ' do inc(j);
        s127:=copy(s127, j, length(s127));
        jj:=1;
        while (s127[jj]<>' ') and (jj<length(s127)) and (jj<maxSlength) do inc(jj);
        sx1:=copy(s127, 1, jj-1);
        val(sx1, x2, j);
        s127:=copy(s127, jj, length(s127));
    until b>=PosY;
    if j<>0 then x2:=0;
    end;
*)

function lies_spektrum(var spek: Attr_spec; name:String; PosX, PosY: byte; Header:word;
                      out anzahl:word; flag_tab:boolean):byte;
{ Liest ein Spektrum aus der Datei 'name' ein.
  X-Werte = xx^.y[k]  = Spalte 'PosX',
  Y-Werte = spek.y[k] = Spalte 'PosY'
  Rückgabewert: 0 = ok
                1 = constant y values
                2 = less than three y-values
                3 = error in file
                4 = file not found}
var k, l      : word;
    datei     : text;
    flag      : boolean;
    ok        : byte;
    tabfile   : string;  { data columns separated by tab (#9 }
    tempfile  : string;  { input file }
    dummyS    : string;
    flag_CRLF : boolean;
begin
    name:=trim(name);     // delete white spaces in filename
    tabfile:=DIR_saveFwd+'\loe.tmp';
    if flag_tab then tempfile:=name else begin
        tempfile:=tabfile;
        blanks_to_tab(name, tempfile, Header);
        end;
    flag_CRLF:=ASCII_is_Windows(tempfile);
    for k:=1 to MaxChannels do spek.y[k]:=0.0;
    {$i-}
    AssignFile(datei, tempfile);
    reset(datei);
    {$i+}
    if ioresult<>0 then ok:=4
    else begin
        readlnS(datei, spek.ParText, flag_CRLF);
        spek.sim:=FALSE;
        if Header>0 then for k:=1 to Header-1 do readlnS(datei, dummyS, flag_CRLF);
        flag:=TRUE;
        k:=1; l:=1;
        ok:=1;
        while flag and (k<MaxChannels) do begin
            flag:=lies(datei, flag_CRLF, PosX, PosY, xx^.y[k], spek.y[k]);
            if flag and (ok=1) then if abs(spek.y[1]-spek.y[k])>nenner_min then ok:=0;
            if flag then inc(k);
            inc(l);
            { weiterlesen, wenn Headerzeilen zu klein angegeben sind }
            if (k=1) and (l<1000) then flag:=TRUE;
            end;
        anzahl:=k;
        if anzahl<3 then ok:=3;
        CloseFile(datei);
        end;
    lies_spektrum:=ok;
    if not flag_tab then deletefile(tabfile);
    average(spek);
    end;


function Nachbar(Lambda:double):integer;
{ Calculates channel closest to wavelength Lambda }
var k, k1 : integer;
begin
    k1:=1;
    dL:=abs(x^.y[k1]-Lambda);
    for k:=2 to MaxChannels do
        if abs(x^.y[k]-Lambda)<dL then begin
           k1:=k;
           dL:=abs(x^.y[k]-Lambda);
           end;
    Nachbar:=k1;
    end;

function x_anpassen(var spek: spektrum; N:integer; dx:double):boolean;
{ Adapt wavelengths of input file to specified wavelength scale.
  N+1 = number of channels of input spektrum;
  Channel_number+1 = number of channels of output spektrum;
  dx = wavelenngth error [nm] }
var k, neu  : integer;
    neu_min : integer;
    neu_max : integer;
    ddx     : double;
    new_S   : spektrum;
    merk    : spektrum;
begin
    ddx:=0;
    if flag_public then dx:=0;   // wavelength errors only supported in private version
    if dx<>0 then ddx:=error_dx; // wavelength increment errors only supported in combination with wavelength errors
    if N>MaxChannels then N:=MaxChannels;
    for k:=1 to MaxChannels do begin
        new_S[k]:=-9999.0;
        merk[k]:=0;
        end;
    neu_min:=Nachbar(xx^.y[1]-dx);
    neu_max:=neu_min;
    for k:=1 to N do begin
        neu:=Nachbar(xx^.y[k]-dx+k*ddx);
        if neu<neu_min then neu_min:=neu;
        if neu>neu_max then neu_max:=neu;
        if (new_S[neu]=-9999.0) or (dL<merk[neu]) then begin
            new_S[neu]:=spek[k];
            merk[neu]:=dL;
            end;
        end;
    if new_S[1]=-9999.0 then new_S[1]:=spek[1];
    if new_S[Channel_number]=-9999.0 then new_S[Channel_number]:=spek[N];
    for k:=2 to Channel_Number div 2 do
        if new_S[k]=-9999.0 then new_S[k]:=new_S[k-1];
    for k:=Channel_number-1 downto (Channel_Number div 2) do
        if new_S[k]=-9999.0 then new_S[k]:=new_S[k+1];
    for k:=1 to Channel_Number do spek[k]:=new_S[k];
    x_anpassen:=neu_min<>neu_max;
    end;

procedure berechne_I0;
{ Calculate integral of solar constant }
var k : integer;
begin
    I0:=0.0;
    for k:=ch_Int_min to ch_Int_max-1 do
        I0:=I0 + E0^.y[k]*(x^.y[k+1]-x^.y[k]);
    I0:=I0 + E0^.y[ch_Int_max]*(x^.y[ch_Int_max]-x^.y[ch_Int_max-1]);
    end;

procedure berechne_Rayleigh;
var k : integer;
    f, sum : double;
begin
    for k:=1 to Channel_number do
        Rayleigh^.y[k]:=exp(-4.09*ln(x^.y[k]/Lambda_R));
    { Check if Rayleigh scaling factor is correct }

    sum:=0.0;  f:=0;
    for k:=ch_Int_min to ch_Int_max-1 do
        sum:=sum + E0^.y[k] * Rayleigh^.y[k]*(x^.y[k+1]-x^.y[k]);
    sum:=sum + E0^.y[ch_Int_max] * Rayleigh^.y[ch_Int_max]*(x^.y[ch_Int_max]-x^.y[ch_Int_max-1]);
    if sum<>0 then f:=I0/sum;
    { if Rayleigh scaling factor is wrong, calculate Rayleigh spectrum again }
    if f<>1 then begin
        Lambda_R:=exp(ln(f)/4.09)*Lambda_R;
        for k:=1 to Channel_number do
            Rayleigh^.y[k]:=exp(-4.09*ln(x^.y[k]/Lambda_R));
        end;
    for k:=Channel_number+1 to MaxChannels do Rayleigh^.y[k]:=0.0;

    end;

procedure berechne_Mie;
var k : integer;
    f, sum : double;
begin
    for k:=1 to Channel_number do
        Mie^.y[k]:=exp(-alpha.fw*ln(x^.y[k]/Lambda_M));
    { Check if Mie scaling factor is correct }
    sum:=0.0;  f:=0;
    for k:=ch_Int_min to ch_Int_max-1 do
        sum:=sum + E0^.y[k] * Mie^.y[k]*(x^.y[k+1]-x^.y[k]);
    sum:=sum + E0^.y[ch_Int_max] * Mie^.y[ch_Int_max]*(x^.y[ch_Int_max]-x^.y[ch_Int_max-1]);
    if sum<>0 then f:=I0/sum;
    { if Mie scaling factor is wrong, calculate Mie spectrum again }
    if f<>1 then begin
        if abs(alpha.fw)>nenner_min then Lambda_M:=exp(ln(f)/alpha.fw)*Lambda_M;
        for k:=1 to Channel_number do
            Mie^.y[k]:=exp(-alpha.fw*ln(x^.y[k]/Lambda_R));
        end;
    for k:=Channel_number+1 to MaxChannels do Mie^.y[k]:=0.0;
    end;

procedure berechne_bX;
{ Scattering of suspended particles Type I,
  may depend on particle concentration C }
var k, kL  : integer;
    nenner : double;
begin
    kL:=Nachbar(Lambda_L);
    if flag_bX_file then begin
        nenner:=bXN^.y[kL];
        if abs(nenner)<nenner_min then nenner:=1;
        for k:=1 to Channel_number do
            bXN^.y[k]:=bXN^.y[k]/nenner;
        end
    else begin
        for k:=1 to Channel_number do begin
            nenner:=aP[0]^.y[k];
            if (abs(nenner)>0.001) and (x^.y[k]<=700) then
                bXN^.y[k]:=aP[0]^.y[kL]/nenner
            else bXN^.y[k]:=0;
            end;
        end;
    end;

procedure berechne_bbMie;
{ Backscattering of suspended particles Type II }
var k  : integer;
    nn : double;
    xx : double;
begin
    if flag_panel_fw then nn:=n.fw else nn:=n.actual;
    for k:=1 to Channel_number do begin
        xx:=x^.y[k]/Lambda_S;
        if xx>nenner_min then bbMie^.y[k]:=bb_Mie*exp(nn*ln(xx))
                         else bbMie^.y[k]:=0;
        end;
    bbMie^.ParText:='Specific backscattering coeff. of suspended particles Type II (m^2/g)';
    bbMie^.sim:=TRUE;
    end;

procedure berechne_bMie;
{ Scattering of suspended particles type II ('Mie') }
var k  : integer;
    nn : double;
    xx : double;
begin
    if flag_panel_fw then nn:=n.fw else nn:=n.actual;
    for k:=1 to Channel_number do begin
        xx:=x^.y[k]/Lambda_S;
        if xx>nenner_min then bMie^.y[k]:=b_Mie*exp(nn*ln(xx))
                         else bMie^.y[k]:=0;
        end;
    bMie^.ParText:='Specific scattering coeff. of suspended particles Type II (m^2/g)';
    bMie^.sim:=TRUE;
    end;


procedure berechne_aY(SS: double);
var k : integer;
    e : double;
begin
{    if flag_panel_fw then SS:=S.fw else SS:=S.actual; -- old }
    for k:=1 to Channel_number do begin
        e:=-SS*(x^.y[k]-Lambda_0);
        if e<exp_min then aY^.y[k]:=exp(exp_min)
        else if e>exp_max then aY^.y[k]:=exp(exp_max)
        else aY^.y[k]:=exp(e);
        end;
    aY^.ParText:='Normalized CDOM absorption';
    aY^.sim:=TRUE;
    end;

procedure berechne_bbW;
var k  : integer;
    xx : double;
begin
    for k:=1 to Channel_number do begin
        xx:=x^.y[k]/500.0;
        if xx>nenner_min then bbW^.y[k]:=bbW500*exp(-4.32*ln(xx))
                         else bbW^.y[k]:=0;
        end;
    bbW^.ParText:='Backscattering coefficient of pure water (1/m)';
    bbW^.sim:=TRUE;
    end;

procedure berechne_SDD(Y,S,C: double; var SD: double);
{ Calculate Secchi disk depth using the Baltsem Secchi depth algorithm.
Bärbel Müller-Karulis, Bo G. Gustafsson, Vivi Fleming-Lehtinen and Stefan G. H. Simis:
Secchi depth calculations in BALTSEM. Baltic Nest Institute, Stockholm Resilience Centre,
Stockholm University, Technical Report No. 8, 2012. ISBN: 978-91-86655-07-5. }
var k1, k2 : integer;
    r : double;
begin
    if flag_Y_exp then r:=exp(S*(Lambda_0-375)) else begin
        k1:=Nachbar(375);
        k2:=Nachbar(Lambda_0);
        if aY^.y[k2]>nenner_min then r:=aY^.y[k1] / aY^.y[k2] else r:=3;
        end;
    SD:=54.2*power(0.155 + Y*r + 2.77*C, -0.544) + power(C, 0.414)
        - sqr(Y*r)*power(2.97 + 1.35*C, -1.33) - 7.58;
    if SD>5.13 then SD:=(ln(SD)-ln(1.2066))/0.2822;
    end;

function Fresnel(angle:double):double;
{ Fresnel reflection for unpolarized light for relative refractive index nW >= 1
  at reflection angle 'angle' in units of degrees. }
var i, j: double;
begin
    if abs(angle)<nenner_min then
        Fresnel:=sqr((sqr(nW)-1)/(sqr(nW+1)))
    else begin
        i:=angle*pi/180;
        j:=arcsin(sin(i)/nW);
        Fresnel:=0.5*abs(sqr(sin(i-j)/sin(i+j))+sqr(tan(i-j)/tan(i+j)));
        end;
    end;

function rho_diffuse(sun:double):double;
{ Reflection factor for diffuse irradiance as function of sun zenith angle
  'sun' in units of sr. }
var cos_sun : double;
begin
    cos_sun:=cos(sun);
    rho_diffuse:=rho0+rho1*(1-cos_sun)+rho2*sqr(1-cos_sun)
    end;

procedure normalize(var spec: Attr_spec; Lambda:double);
var k    : integer;
    merk : double;
begin
    k:=Nachbar(Lambda);
    merk:=spec.y[k];
    if abs(merk)>nenner_min then
    for k:=1 to Channel_number do
        spec.y[k]:=spec.y[k]/merk;
    end;

function import_spectrum(var S: Attr_spec):boolean;
{ Import spectrum from file. }
var ch : word;  { Number of channels of input spectrum }
begin
    error_file:=lies_spektrum(S, S.Fname, S.XColumn, S.YColumn, S.Header, ch, false);
    if error_file<3 then begin
        error_msg:='';
        if not x_anpassen(S.y, ch, 0) then error_file:=3;
        end;
    if error_file=3 then error_msg:='ERROR reading file ' + S.Fname
    else if error_file=4 then error_msg:='ERROR: File ' + S.Fname + ' not found';
    import_spectrum:=error_file<3;
    end;

procedure read_spectra;
var k, k1, k2 : word;
    ch, i     : word;
    SS        : double;
    warning   : string;
begin
    { Determine channel and wavelength parameters }
    error_msg:='';
    warning:='';
    k1:=MinX;
    error_file:=lies_spektrum(x^,  x^.Fname, x^.XColumn, x^.YColumn, x^.Header, ch, false);

    if error_file>0 then begin   // Wavelength file is erroneous
        flag_x_file:=FALSE;
        flag_fwhm  :=FALSE;
        warning:='Error reading file ' + x^.Fname;
        if error_file=4 then warning:='File ' + x^.Fname + ' not found';
        warning:=warning + '. Import and resampling of wavelengths were deactivated.';
        if (not flag_background) then
            MessageBox(0, pchar(warning), 'WARNING', MB_OK);
        error_file:=0;
        end
    else begin                   // Wavelength file is ok
        while (xx^.y[ch]<nenner_min) and (ch>2) do dec(ch);
        k1:=1; while (xx^.y[k1]<MinX) and (k1<MaxChannels) do inc(k1);
        end;
    if k1>=MaxChannels then begin
        error_file:=3;
        error_msg:='Error reading file ' + x^.FName;
        end;
    if error_file<3 then begin
        xfile_xu:=xx^.y[k1];
        k2:=ch; while (xx^.y[k2]>MaxX) and (k2>2) do dec(k2);
        xfile_xo:=xx^.y[k2];
        xfile_dx:=xx^.y[k1+1]-x^.y[k1];
        end
    else exit;
    if flag_x_file then begin
        Channel_number:=k2-k1+1; { number of channels }
        if flag_FWHM then for k:=1 to Channel_number do begin
            FWHM^.y[k]:=x^.y[k+k1-1];
            if FWHM^.y[k]<FWHM0_min then FWHM^.y[k]:=FWHM0_min
            else if FWHM^.y[k]>FWHM0_max then FWHM^.y[k]:=FWHM0_max;
            end;
        for k:=1 to Channel_number do x^.y[k]:=xx^.y[k+k1-1];
        end
    else begin
        Channel_number:=1+round((xob-xub)/dxb);
        if Channel_number>MaxChannels then Channel_number:=MaxChannels;
        for k:=1 to Channel_number do x^.y[k]:=xub + (k-1)*dxb;
        if FWHM0<FWHM0_min then FWHM0:=FWHM0_min
        else if FWHM0>FWHM0_max then FWHM0:=FWHM0_max;
        if flag_FWHM then for k:=1 to Channel_number do FWHM^.y[k]:=FWHM0;
        end;

    { Import input spectra of public version }
    if not import_spectrum(offsetS^) then exit;
    if not import_spectrum(scaleS^) then exit;
    if not import_spectrum(noiseS^) then exit;
    if not import_spectrum(E0^)  then exit;
    if not import_spectrum(aO2^) then exit;
    if not import_spectrum(aO3^) then exit;
    if not import_spectrum(aWV^) then exit;
    if not import_spectrum(a_ice) then exit;
    if not import_spectrum(aW^)  then exit;
    if not import_spectrum(dadT^) then exit;
    for i:=0 to 5 do if not import_spectrum(aP[i]^) then exit;
    if not import_spectrum(aNAP^) then exit;
    if not flag_Y_exp then begin
        if not import_spectrum(aY^) then exit;
        if flag_norm_Y then normalize(aY^, Lambda_0);
        end;
    if not import_spectrum(bPhyN^) then exit;
    if not import_spectrum(bXN^)  then exit;
    for i:=0 to 5 do if not import_spectrum(albedo[i]^) then exit;
    if not import_spectrum(a_nw^) then exit;
    if not import_spectrum(Ed^)  then exit;
    if not import_spectrum(Ls^)  then exit;
    if not import_spectrum(Kd^)  then exit;
    if not import_spectrum(R^)   then exit;
    if not import_spectrum(gew^) then exit;

    import_LUT(1);   if error_msg<>'' then exit;
    import_LUT(2);   if error_msg<>'' then exit;

    { Adapt spectra }
    if flag_mult_E0 then for k:=1 to Channel_number do E0^.y[k]:=E0_factor * E0^.y[k];
    if flag_mult_Ed then for k:=1 to Channel_number do Ed^.y[k]:=Ed_factor * Ed^.y[k];
    Ch_int_min:=Nachbar(Norm_min);
    Ch_int_max:=Nachbar(Norm_max);
    if flag_panel_fw then SS:=S.fw else SS:=S.actual;
    if flag_Y_exp then berechne_aY(SS);
    if flag_norm_NAP then normalize(aNAP^, Lambda_0);
    berechne_bX;
    berechne_bbW;
    berechne_bMie;
    berechne_bbMie;

    { Import input spectra of private version }
    if not flag_public then begin
        if not import_spectrum(tA^)   then exit;
        if not import_spectrum(tC^)   then exit;
        if not import_spectrum(Lpath) then exit;
        if not import_spectrum(resp)  then exit;
        if not import_spectrum(u_c^)  then exit;
        if not import_spectrum(u_t^)  then exit;
        if not import_spectrum(u_p^)  then exit;
        if not import_spectrum(u_n^)  then exit;
        if not import_spectrum(aphA^) then exit;
        if not import_spectrum(aphB^) then exit;
        if not import_spectrum(CMF_r^) then exit;
        if not import_spectrum(CMF_g^) then exit;
        if not import_spectrum(CMF_b^) then exit;
        Import_spectral_locus;
        Import_CIExyz;
        assign_CIE_wavelengths;
        if not import_ASCII_EEM(EEM_ph) then exit;
        if not import_ASCII_EEM(EEM_DOM) then exit;
        end;
    end;


function xkoo(x:double; dx:integer):word;
begin
    if (x<=xu) then x:=xu else if (x>=xo) then x:=xo;
    xkoo:=DX_par + DX_leg +
          round((x-xu)/(xo-xu) * (dx-DX_par-DX_leg-DX_right));
    end;

function ykoo(y:double; dy:integer):word;
begin
    if (y<=yu) then y:=yu else if (y>=yo) then y:=yo;
    ykoo:=DY_top +
          round((yo-y)/(yo-yu) * (dy-DY_top-DY_leg-DY_modes))
    end;

procedure Auto_Scale(XMIN,XMAX: real; out VA,DV: real; out NV: Integer);
{Sinnvolle Achsenbeschriftung erstellen.}
{   XMIN..XMAX : Wertebereich
    VA : 1. Wert, der an die Achse geschrieben wird
    DV : Differenz zum nächsten Wert
    NV : Zahl der Beschriftungen        }

Var   DX, DUM : real;
      IEXP    : integer;

Begin
    NV:=3;
    DX  := (XMAX-XMIN)/NV;
    IEXP := log10(DX);

    DX := DX/POWER(10.0,IEXP);

    DUM := 1.0;
    If DX >= 2.0 Then DUM := 2.0;
    If DX >= 5.0 Then DUM := 5.0;

    DV := DUM*POWER(10.0,IEXP);

    VA := INT(XMIN/DV)*DV;
    If VA < XMIN Then VA := VA+DV;

    DUM:=VA;
    NV:=0;
    repeat
       DUM:=DUM+DV;
       NV:=NV+1;
    until DUM > XMAX;
    End;

function sign(x:real):integer;
begin
    if x<0 then sign:=-1 else sign:=1;
    end;

procedure scale;
var k, nr : integer;
    u,o,d : double;
    first : boolean;
begin
    u:=yu; o:=yo;
    first:=FALSE;
    for nr:=1 to Nspectra do
    for k:=1 to Channel_number do
        if (x^.y[k]>=xu) and (x^.y[k]<=xo) then begin
            if first=FALSE then begin
                u:=spec[nr]^.y[k];
                o:=spec[nr]^.y[k];
                end;
            first:=TRUE;
            if spec[nr]^.y[k]<u then u:=spec[nr]^.y[k];
            if spec[nr]^.y[k]>o then o:=spec[nr]^.y[k];
        end;
    if abs(o)>abs(u) then d:=0.05*abs(o) else d:=0.05*abs(u);
    yu:=u-d;
    yo:=o+d;
    if (u=0) and (o=0) then begin
        yu:=-0.1;
        yo:=0.1;
        end;
    end;

function YFilename(Name:String):String;
begin
    if not flag_ShowFile then YFileName:='' else
        if flag_ShowPath then YFileName:=Name
        else YFileName:=ExtractFileName(Name);
    end;

procedure determine_concentration_fw(RangeValue:single);
var flag_merk : boolean;
begin
    flag_merk:=flag_panel_fw;
    flag_panel_fw:=TRUE;
    case iter_type of
        1:  C[0].fw :=RangeValue;
        2:  C[1].fw :=RangeValue;
        3:  C[2].fw :=RangeValue;
        4:  C[3].fw :=RangeValue;
        5:  C[4].fw :=RangeValue;
        6:  C[5].fw :=RangeValue;
        7:  C_X.fw  :=RangeValue;
        8:  begin
                C_Mie.fw :=RangeValue;
                berechne_Mie;
                end;
        9:  C_Y.fw  :=RangeValue;
        10: begin
                S.fw   :=RangeValue;
                if flag_Y_exp then berechne_aY(S.fw);
                end;
        11: begin
                n.fw :=RangeValue;
                berechne_bbMie;
                berechne_bMie;
                end;
        12: T_W.fw :=RangeValue;
        13: Q.fw :=RangeValue;
        14: fluo.fw    :=RangeValue;
        15: rho_L.fw   :=RangeValue;
        16: rho_dd.fw  :=RangeValue;
        17: rho_ds.fw  :=RangeValue;
        18: begin
                beta.fw  :=RangeValue;
                berechne_Mie;
                end;
        19: begin
                alpha.fw :=RangeValue;
                berechne_Mie;
                end;
        20: f_dd.fw    :=RangeValue;
        21: f_ds.fw    :=RangeValue;
        22: H_oz.fw    :=RangeValue;
        23: WV.fw      :=RangeValue;
        24: f.fw       :=RangeValue;
        25: z.fw       :=RangeValue;
        26: zB.fw      :=RangeValue;
        27: begin
                sun.fw     :=RangeValue;
                if flag_Fresnel_sun then rho_dd.fw:=Fresnel(sun.fw);
            end;
        28: begin
                view.fw :=RangeValue;
                if flag_Fresnel_view then rho_L.fw:=Fresnel(view.fw);
            end;
        29: dphi.fw    :=RangeValue;
        30..35: fA[iter_type-30].fw:=RangeValue;
        36: bbs_phy.fw :=RangeValue;
        37: g_dd.fw    :=RangeValue;
        38: g_dsr.fw   :=RangeValue;
        39: g_dsa.fw   :=RangeValue;
        40: delta_r.fw :=RangeValue;
        41: alpha_d.fw :=RangeValue;
        42: beta_d.fw  :=RangeValue;
        43: gamma_d.fw :=RangeValue;
        44: delta_d.fw :=RangeValue;
        45: dummy.fw   :=RangeValue;
        46: test.fw    :=RangeValue;
        47: alpha_r.fw :=RangeValue;
        48: beta_r.fw  :=RangeValue;
        49: gamma_r.fw :=RangeValue;
        50: f_nw.fw    :=RangeValue;
        end;
    flag_panel_fw:=flag_merk;
    if bottom_fill>=0 then adjust_bottom_weight_fw;
    end;

procedure set_concentration_actual(Par_type:integer; RangeValue:single);
begin
    case Par_type of
        1:  C[0].actual :=RangeValue;
        2:  C[1].actual :=RangeValue;
        3:  C[2].actual :=RangeValue;
        4:  C[3].actual :=RangeValue;
        5:  C[4].actual :=RangeValue;
        6:  C[5].actual :=RangeValue;
        7:  C_X.actual  :=RangeValue;
        8:  C_Mie.actual :=RangeValue;
        9:  C_Y.actual  :=RangeValue;
        10: begin
                S.actual   :=RangeValue;
                if flag_Y_exp then berechne_aY(S.actual);
                end;
        11: begin
                n.actual :=RangeValue;
                berechne_bbMie;
                berechne_bMie;
                end;
        12: T_W.actual :=RangeValue;
        13: Q.actual :=RangeValue;
        14: fluo.actual   :=RangeValue;
        15: rho_L.actual  :=RangeValue;
        16: rho_dd.actual :=RangeValue;
        17: rho_ds.actual :=RangeValue;
        18: begin
                beta.actual  :=RangeValue;
                berechne_Mie;
                end;
        19: begin
                alpha.actual :=RangeValue;
                berechne_Mie;
                end;
        20: f_dd.actual    :=RangeValue;
        21: f_ds.actual    :=RangeValue;
        22: H_oz.actual    :=RangeValue;
        23: WV.actual      :=RangeValue;
        24: f.actual       :=RangeValue;
        25: z.actual       :=RangeValue;
        26: zB.actual      :=RangeValue;
        27: begin
                sun.actual     :=RangeValue;
                if flag_Fresnel_sun then rho_dd.actual:=Fresnel(sun.actual);
                end;
        28: begin
                view.actual:=RangeValue;
                if flag_Fresnel_view then rho_L.actual:=Fresnel(view.actual);
                end;
        29: dphi.actual    :=RangeValue;
        30..35: fA[iter_type-30].actual:=RangeValue;
        36: bbs_phy.actual :=RangeValue;
        37: g_dd.actual    :=RangeValue;
        38: g_dsr.actual   :=RangeValue;
        39: g_dsa.actual   :=RangeValue;
        40: delta_r.actual :=RangeValue;
        41: alpha_d.actual :=RangeValue;
        42: beta_d.actual  :=RangeValue;
        43: gamma_d.actual :=RangeValue;
        44: delta_d.actual :=RangeValue;
        45: dummy.actual   :=RangeValue;
        46: test.actual    :=RangeValue;
        47: alpha_r.fw     :=RangeValue;
        48: beta_r.fw      :=RangeValue;
        49: gamma_r.fw     :=RangeValue;
        50: f_nw.fw        :=RangeValue;
        end;
    end;


{ Procedures for batch mode }


procedure set_YText;
begin     
    case spec_type of
        S_Ed_GC   : YText:='Downwelling irradiance (mW m^-2 nm^-1)';
        S_Lup     : YText:='Upwelling radiance (mW m^-2 nm^-1 sr^-1)';
        S_Rrs     : YText:='Radiance reflectance (sr^-1)';
        S_R       : YText:='Irradiance reflectance';
        S_Rsurf   : YText:='Surface reflectance (sr^-1)';
        S_a       : YText:='Absorption (m^-1)';
        S_Kd      : YText:='Attenuation of downwelling irradiance (m^-1)';
        S_Rbottom : if flag_L then YText:='Bottom reflectance (sr^-1)'
                              else YText:='Bottom reflectance';
        S_Ed_Gege : YText:='Downwelling irradiance (mW m^-2 nm^-1)';
        S_test    : YText:='Radiance reflectance (sr^-1)';
        end;
    end;


procedure scale_plot_batch(var spek: spektrum);
{ Determine y-range of calculated spectra in batch mode. }
var c1, c2, c3 : double;     // Concentrations
    d1, d2, d3 : double;     // Data intervals
    delta      : double;
    i, N       : integer;
begin
   { Determine plot scale based on min and max of each parameter }
   delta:=1;
   if not flag_public and flag_1st_dp then delta:=Par3_N-1;
   if Par1_N>1 then d1:=(Par1_Max-Par1_Min) else d1:=0;
   if Par2_N>1 then d2:=(Par2_Max-Par2_Min) else d2:=0;
   if Par3_N>1 then d3:=(Par3_Max-Par3_Min)/delta else d3:=0;
   if Par1_type=0 then d1:=0;
   if Par2_type=0 then d2:=0;
   if Par3_type=0 then d3:=0;
   if Par3_Log and (d3>0) then                     // Par3_Log is set in Frame_Batch
       d3:=abs(ln(max(Par3_Max,nenner_min))-ln(max(Par3_Min,nenner_min)))/(Par3_N-1);

   for i:=1 to Channel_number do begin dold[i]:=0; dnew[i]:=0; end;
   S_actual:=1;
   N:=0;
   c1:=Par1_Min;
   if flag_Y_exp then berechne_aY(S.fw);
   berechne_bbMie;
   repeat
       iter_type:=Par1_type;
       determine_concentration_fw(c1);
       c2:=Par2_Min;
       repeat
           iter_type:=Par2_type;
           determine_concentration_fw(c2);
           c3:=Par3_Min;
           for i:=1 to Channel_number do begin dold[i]:=0; dnew[i]:=0; end;
           repeat
               iter_type:=Par3_type;
               determine_concentration_fw(c3);
               case spec_type of
               S_Ed_GC: begin
                      calc_Ed_GreggCarder;
                      spec[S_actual]^:=Ed^;
                      end;
               S_Lup: begin
                      calc_Lu;
                      spec[S_actual]^:=Lu^;
                      end;
               S_rrs: begin
                      flag_L:=TRUE;
                      calc_R_rs;
                      spec[S_actual]^:=r_rs^;
                      end;
               S_R: begin
                      calc_R;
                      spec[S_actual]^:=R^;
                      end;
               S_Rsurf: begin
                      calc_Rrs_surface;
                      spec[S_actual]^:=Rrs_surf^;
                      end;
               S_a: begin
                      calc_a;
                      spec[S_actual]^:=a^;
                      end;
               S_Kd: begin
                      calc_Kd;
                      spec[S_actual]^:=Kd^;
                      end;
               S_Rbottom: begin
                      calc_R_bottom;
                      spec[S_actual]^:=bottom^;
                      end;
               S_Ed_Gege: begin
                      calc_Ed_Gege;
                      spec[S_actual]^:=Ed^;
                      end;
               S_test: begin
                       if flag_MP then calc_meltpond
                                  else calc_test;
                      spec[S_actual]^:=Stest^;
                      end;

               end;

               { Private WASI version: Calculate derivative of actual spectrum }
               if not flag_public and flag_CEOS then begin
                   if flag_drel then Rrs_N(TRUE);
                   if flag_1st_dp and (d3>0) then dRrs_par(N, c3, CEOS_dp, TRUE);
                   if flag_1st_dl and (d3>0) then derivate_lambda(c3, TRUE);
                   if flag_dL and (d3>0) then calc_spectral_resolution(20);
                   end;

               { Private mode of WASI: Scale for spectrum type 'spek' }
               if not flag_public then if flag_fw_intern then
                   spec[S_actual]^.y:=spek;
                average(spec[S_actual]^);                 // average the spectrum
                inc(N);

(*               rescale_measurement(spec[S_actual]^.y); *)
               if not flag_public and flag_1st_dp and Par3_Log and (Par3_N>1)
                   then c3:=c3*exp(d3) else c3:=c3 + d3;
               if S_actual<MaxSpectra then S_actual:=S_actual+1;

            until (c3<Par3_Min) or (c3>Par3_Max+d3/10) or (d3=0);
            c2:=c2 + d2;
       until (c2<Par2_Min) or (c2>Par2_Max+d2/10) or (d2=0);
       c1:=c1 + d1;
   until (c1<Par1_Min) or (c1>Par1_Max+d1/10) or(d1=0);
   Nspectra:=S_actual-1;
   S_actual:=1;
   ActualFile:='simulated spectra';
   if flag_autoscale then scale;
   Nspectra:=0;
   end;

procedure change(kastl:TEdit; var x:Fitparameters);
var wert : double;
    input : single;
    error : integer;
begin
    if flag_panel_fw then wert:=x.fw else wert:=x.actual;
    val(kastl.Text, input, error);
    if error=0 then wert:=input;
    if flag_panel_fw then x.fw:=wert else begin
        if wert<x.min then wert:=x.min else if wert>x.max then wert:=x.max;
        x.actual:=wert;
        end;
    kastl.refresh;
    end;

procedure updt(kastl:TEdit; x:double; SIG:byte);
{ Update edit box 'kastl' with parameter x.
  Note: without the 'OnChange' workaround, the assignment of new text would
  raise the event 'OnChange' which leads here to rounding of x to SIG digits. }
var   txt : String;
      merk_OnChange: TNotifyEvent;
begin
    txt:=schoen(x,SIG);
    if kastl.Text<>txt then begin
        merk_OnChange:=kastl.OnChange;   { store OnChange activity }
        kastl.OnChange:=nil;             { inactivate OnChange event }
        kastl.Text:=txt;                 { assign new text to edit box }
        kastl.refresh;                   { refresh edit box }
        kastl.OnChange:=merk_OnChange;   { re-activate OnChange event }
        end;
    end;

procedure adjust_bottom_weight_fw;
{ Adjust weight of a single spectrum such that the sum of all weights equals 1. }
var i   : integer;
    sum : double;
begin
    if bottom_fill>=0 then begin
        sum:=0;
        for i:=0 to 5 do sum:=sum + fA[i].fw;
        if abs(sum-1)>nenner_min then fA[bottom_fill].fw:=fA[bottom_fill].fw+1-sum;
        end;
    end;



procedure rescale_measurement(var spek: spektrum);
{ Adds to spectrum a constant or wavelength-dependent offset and
  multiplies spectrum with constant or wavelength-dependent scaling factor. }
var k   : integer;
begin
    if flag_offset then for k:=1 to MaxChannels do begin   // M' = a + M
        if flag_offset_c then spek[k]:=spek[k] + offset_c
                         else spek[k]:=spek[k] + offsetS^.y[k];
        end;
    if flag_scale then for k:=1 to MaxChannels do begin   // M" = b * M'
        if flag_scale_c  then spek[k]:=spek[k] * scale_c
                         else spek[k]:=spek[k] * scaleS^.y[k];
        end;
    end;

procedure add_noise(var spek: spektrum);
{ Adds to spectrum Gaussian-distributed noise and reduces radiometric accuracy. }
var k   : integer;
    std : double;
begin
    if flag_radiom and flag_noise then for k:=1 to MaxChannels do begin
        if flag_noise_c then std:=noise_std else std:=noiseS^.y[k];
        if dynamics>nenner_min then
             spek[k]:=dynamics*round(randG(spek[k],std)/dynamics)
        else spek[k]:=randG(spek[k],std);
        end else
    if flag_radiom and not flag_noise and (dynamics>nenner_min) then
         for k:=1 to MaxChannels do
         spek[k]:=dynamics*round(spek[k]/dynamics) else
    if not flag_radiom and flag_noise then for k:=1 to MaxChannels do begin
        if flag_noise_c then std:=noise_std else std:=noiseS^.y[k];
         spek[k]:=randG(spek[k],std);
         end;
    end;

function calc_f(x, eta, angle_sun :double):double;
{ f-factor of R as function of sun angle:
  x         = bb/(a+bb) or bb/a
  eta       = bbW / bb
  angle_sun = sun zenith angle ABOVE water }
var mue_w : double;
begin
    mue_w:=cos(arcsin(sin(angle_sun*pi/180)/nW));
    case Model_f of
    1: { Kirk (1984 }
       calc_f:=0.975 - 0.629 * mue_w;
    2: { Morel and Gentili 1991 }
       calc_f:=0.6279 - 0.2227 * eta - 0.0513 * sqr(eta) +
                (-0.3119 + 0.2465 * eta) * cos(angle_sun);
    3: { Sathyendranath and Platt (1997 }
        calc_f:=0.5 / (0.5 + mue_w);
    4: { Albert (2002), wind speed ignored }
       begin
        if abs(mue_w)<nenner_min then mue_w:=nenner_min;
        calc_f:=fp1*(1+fp2*x+fp3*sqr(x)+fp4*x*sqr(x))*(1+fp5/mue_w);
        end
    else calc_f:=f.fw;
    end;
    end;

function calc_f_rs(x, eta, angle_sun, angle_view, Q:double):double;
{ f-factor for Rrs. Parameters:
  x          = bb/(a+bb)
  eta        = bbW/bb
  angle_sun  = sun zenith angle ABOVE water
  angle_view = viewing angle ABOVE water
  Q          = Q-factor }
var mue_sun  : double;
    mue_view : double;
begin
    if Model_f_rs=0 then begin { Andreas Albert (2003), wind speed ignored }
        mue_sun :=cos(arcsin(sin(angle_sun*pi/180)/nW));
        mue_view:=cos(arcsin(sin(angle_view*pi/180)/nW));
        if abs(mue_sun) <nenner_min then mue_sun:=nenner_min;
        if abs(mue_view)<nenner_min then mue_view:=nenner_min;
        calc_f_rs:=frsp1*(1+frsp2*x+frsp3*sqr(x)+frsp4*x*sqr(x))
                   *(1+frsp5/mue_sun)*(1+frsp7/mue_view);
        end
    else calc_f_rs:=calc_f(x, eta, angle_sun)/Q;
    end;

function calc_Q_f(f_rs, f:double):double;
{ Q = f_rs / f }
begin
    if abs(f_rs)>nenner_min then calc_Q_f:=f/f_rs
    else calc_Q_f:=Q.fw;
    end;

procedure norm_mx(var S:Spektrum; Lmin, Lmax : double);
{ Normalize spectrum S such that its maximum value is 1 in the wavelength range
  Lmin to Lmax. }
var max       : double;
    k, ku, ko : integer;
begin
    ku:=Nachbar(Lmin);
    ko:=Nachbar(Lmax);
    max:=abs(S[ku]);
    for k:=ku+1 to ko do
        if abs(S[k])>max then max:=abs(S[k]);
    if abs(max)<nenner_min then max:=1;
    for k:=1 to Channel_number do
        S[k]:=S[k]/max;
    end;

function calc_gewicht(par_type:byte; P1, P2, LMin, LMax:double):spektrum;
{ Calculates weighting function for fit based on two values P1, P2
  for the parameter type par_type. }
var k         : integer;
    merk_S    : Attr_spec;
    S         : Attr_spec;
    g         : spektrum;
    merk_type : integer;
    nenner    : double;
begin
    merk_type:=iter_type;
    iter_type:=par_type;
    case spec_type of
        S_R: begin
                 merk_S:=R^;
                 determine_concentration_fw(P1);
                 calc_R;
                 S:=R^;
                 determine_concentration_fw(P2);
                 calc_R;
                 for k:=1 to Channel_number do begin
                     nenner:=S.y[k];
                     if abs(nenner)<nenner_min then nenner:=nenner_min;
                     if nenner<R^.y[k] then g[k]:=R^.y[k]/nenner-1
                                       else g[k]:=nenner/R^.y[k]-1;
                     end;
                 norm_mx(g, LMin, Lmax);
                 R^:=merk_S;
                 calc_gewicht:=g;
                 end;
        S_Rrs: begin
                 merk_S:=r_rs^;
                 determine_concentration_fw(P1);
                 calc_R_rs;
                 S:=r_rs^;
                 determine_concentration_fw(P2);
                 calc_R_rs;
                 for k:=1 to Channel_number do begin
                     nenner:=S.y[k];
                     if abs(nenner)<nenner_min then nenner:=nenner_min;
                     if nenner<r_rs^.y[k] then g[k]:=r_rs^.y[k]/nenner-1
                                       else g[k]:=nenner/r_rs^.y[k]-1;
                     end;
                 norm_mx(g, LMin, Lmax);
                 r_rs^:=merk_S;
                 calc_gewicht:=g;
                 end;

        end;
    iter_type:=merk_type;
    end;

procedure prepare_Ed_temp(out liste:textFile);
var temp_file : string;
begin
    temp_file:=DIR_saveInv+'\Ed.tmp';
    {$i-}
    assignFile(liste, temp_file);
    rewrite(liste);
    writeln(liste, 'This file was generated by the program WASI');
    writeln(liste, vers);
    writeln(liste);
    writeln(liste, 'Temporary file used to separate direct and diffuse component of Ed');
    writeln(liste);
    writeln(liste, 'f_dd', #9, 'f_ds', #9, 'col', #9, 'File');
    end;

procedure save_Ed_temp(var liste:textFile; FName:string; col:integer; f_dd, f_ds:double);
begin
    writeln(liste, schoen(f_dd,8), #9, schoen(f_ds,8), #9, col, #9, FName);
    end;

procedure separate_Edd_Eds(var liste:textFile; FName:string);
var i, j, z, d : integer;
    cols       : integer;
    fdd1, fds1 : double;
    fdd2, fds2 : double;
    col1, col2 : integer;
    Ed1,  Ed2  : Attr_spec;
    Edd,  Eds  : Attr_spec;
    Ausgabe    : textFile;
    AusName    : string;
    nenner     : double;
    s1         : String;
    s2         : String;
    SinglePair : textFile;
    ch         : word;
const fmin     = 0.1;
      rmin     = 0.1;
begin
    closeFile(liste);
    AusName:=DIR_saveInv+'\very.tmp';
    {$i-}
    assignFile(Ausgabe, AusName);
    rewrite(Ausgabe);
    writeln(Ausgabe, 'File', #9, 'col1', #9, 'col2', #9, 'fdd1', #9, 'fdd2', #9, 'nenner');
    i:=1;
    d:=0;
    cols:=0;
    REPEAT
        reset(liste);
        for z:=1 to 6+d do readln(liste);
        readln(liste, fdd1, fds1, col1);
        j:=1+d;
        REPEAT
            readln(liste, fdd2, fds2, col2);
            inc(j);
            if (fdd1>fmin) and (fdd2>fmin) then begin
                nenner:=fds2/fdd2 - fds1/fdd1;
                if abs(nenner)>rmin then begin
                    str(col1, s1); if length(s1)<2 then s1:='0'+s1;
                    str(col2, s2); if length(s2)<2 then s2:='0'+s2;
                    s1:=s1+s2+'.$';
                    assignFile(SinglePair, DIR_saveInv+'\'+s1);
                    rewrite(SinglePair);

                    writeln(SinglePair, 'This file was generated by the program WASI');
                    writeln(SinglePair, vers);
                    writeln(SinglePair);
                    write(SinglePair, 'Direct and diffuse component of ');
                    writeln(SinglePair, FName);
                    lies_spektrum(Ed1, FName, meas^.XColumn, col1, meas^.Header, ch, false);
                    lies_spektrum(Ed2, FName, meas^.XColumn, col2, meas^.Header, ch, false);

                    writeln(SinglePair);
                    writeln(SinglePair, 'sun = ', schoen(sun.actual,3));
                    writeln(SinglePair, 'fdd', #9, 'fds', #9, 'x-col', #9, 'y-col');
                    writeln(SinglePair, schoen(fdd1,5), #9, schoen(fds1,5), #9,
                        meas^.XColumn, #9, col1);
                    writeln(SinglePair, schoen(fdd2,5), #9, schoen(fds2,5), #9,
                        meas^.XColumn, #9, col2);
                    writeln(SinglePair);
                    writeln(SinglePair, 'Lamda', #9, 'Edd', #9, 'Eds', #9, 'Edd+Eds');

                    for z:=1 to ch do begin
                        Eds.y[z]:=(Ed2.y[z]/fdd2 - Ed1.y[z]/fdd1)/nenner;
                        Edd.y[z]:=(Ed1.y[z] - fds1*Eds.y[z])/fdd1;
                        writeln(SinglePair, xx^.y[z]:5:2, #9, schoen(Edd.y[z],5), #9, schoen(Eds.y[z],5),
                            #9, schoen(Edd.y[z]+Eds.y[z],5));
                        end;
                    writeln(Ausgabe, s1, #9, col1, #9, col2, #9, schoen(fdd1,5), #9,
                            schoen(fdd2,5), #9, schoen(nenner,3));
                    closeFile(SinglePair);
                    end;
                end;
        UNTIL eof(liste) or (abs(fdd2)<nenner_min) or (j>ycol_max);
        closeFile(liste);
        if i=1 then cols:=j-1;
        inc(i);
        inc(d);
    UNTIL (i>cols) or (i>ycol_max);
    closeFile(Ausgabe);
    {$i+}
    end;

procedure lies_day(FName:String);
{ Read day of year from file }
var i      : integer;
    input  : textFile;
    d1, d2 : double;
    dummyS : string;
    flag_CRLF : boolean;
begin
    flag_CRLF:=ASCII_is_Windows(FName);
    {$i-}
    assignFile(input, FName);
    reset(input);
    for i:=1 to line_day-1 do readlnS(input, dummyS, flag_CRLF);
    lies(input,flag_CRLF,col_day-1,col_day,d1,d2);
    if (d2>0) and (d2<=365) then day:=round(d2);
    sun_earth:=sqr(1+0.0167*cos(2*pi*(day-3)/365));
    closeFile(input);
    {$i+}
    end;

procedure lies_sun(FName:String);
{ Read sun zenith angle from file }
var i      : integer;
    input  : textFile;
    d1, d2 : double;
    dummyS : string;
    flag_CRLF : boolean;
begin
    flag_CRLF:=ASCII_is_Windows(FName);
    {$i-}
    assignFile(input, FName);
    reset(input);
    if ioresult=0 then begin
        for i:=1 to line_sun-1 do readlnS(input, dummyS, flag_CRLF);
        lies(input,flag_CRLF,col_sun,col_sun+1,d1,d2);
        if not flag_sun_unit then d1:=d1*180/pi;
        if d1>90 then d1:=round(d1) mod 90;
        sun.actual:=d1;
        sun.fw:=d1;
        sun.merk:=d1;
        closeFile(input);
        end;
    {$i+}
    end;

procedure lies_view(FName:String);
{ Read viewing angle from file }
var i      : integer;
    input  : textFile;
    d1, d2 : double;
    dummyS : string;
    flag_CRLF : boolean;
begin
    flag_CRLF:=ASCII_is_Windows(FName);
    {$i-}
    assignFile(input, FName);
    reset(input);
    if ioresult=0 then begin
        for i:=1 to line_view-1 do readlnS(input, dummyS, flag_CRLF);
        lies(input,flag_CRLF,col_view,col_view+1,d1,d2);
        if not flag_sun_unit then d1:=d1*180/pi;
        if d1>90 then d1:=round(d1) mod 90;
        view.actual:=d1;
        view.fw:=d1;
        view.merk:=d1;
        closeFile(input);
        end;
    {$i+}
    end;

procedure lies_dphi(FName:String);
{ Read azimuth difference between sun and viewing angle from file }
var i      : integer;
    input  : textFile;
    d1, d2 : double;
    dummyS : string;
    flag_CRLF : boolean;
begin
    flag_CRLF:=ASCII_is_Windows(FName);
    {$i-}
    assignFile(input, FName);
    reset(input);
    if ioresult=0 then begin
        for i:=1 to line_dphi-1 do readlnS(input, dummyS, flag_CRLF);
        lies(input,flag_CRLF,col_dphi,col_dphi+1,d1,d2);
        if not flag_sun_unit then d1:=d1*180/pi;
        if d1>90 then d1:=round(d1) mod 90;
        dphi.actual:=d1;
        dphi.fw:=d1;
        dphi.merk:=d1;
        closeFile(input);
        end;
    {$i+}
    end;

function Gauss(dx, sx, A: double):double;
{ Gaussian normal distribution.
  dx = distance of maximum,
  sx = standard deviation,
  A  = amplitude }
var exponent : extended;
begin
    if abs(sx)<nenner_min then sx:=nenner_min;
    exponent:=sqr(dx/sx)*0.5;
    if exponent<exp_max then Gauss:=A/sx/sqrt(2*pi)*exp(-exponent)
        else Gauss:=0;
    end;

function Gauss_2D(dx, dy, sx, sy, A: double):single;
{ 2-dimensional Gaussian normal distribution for uncorrelated x and y.
  dx, dy = distance of maximum in x- and y-direction,
  sx, sy = standard deviation in x- and y-direction,
  A      = amplitude
  Note: If x and y are correlated, the correlation coefficient must be
  added as an additional parameter.  }
var exponent : extended;
begin
    if abs(sx)<nenner_min then sx:=nenner_min;     // avoid division by zero
    if abs(sy)<nenner_min then sy:=nenner_min;     // avoid division by zero
    exponent:=0.5*(sqr(dx/sx)+sqr(dy/sy));
    Gauss_2D:=A/(2*pi*sx*sy)*exp(-exponent);
    end;

function  Integral(var spek: Attr_spec; min, max: double):double;
{ Calculate integral of spectrum 'spek' from wavelength 'min' to 'max'. }
var k, ku, ko : integer;
    sum       : double;
begin
    ku:=Nachbar(min);
    ko:=Nachbar(max);
    sum:=0;
    for k:=ku to ko do sum:=sum + spek.y[k];
    Integral:=sum*(x^.y[ku+1]-x^.y[ku]);
    end;

function rel_max(a,b:double):double;
begin
    if abs(a)>b then rel_max:=a else rel_max:=b;
    end;

procedure resample_Rect(var spek: Attr_spec);
{ Resample spectrum by averaging each channel k from k-dsmpl to k+dsmp}
var k, l  : integer;
    count : integer;
    new   : Attr_spec;
begin
    if Channel_number>2 then for k:=1 to Channel_number do begin
        sum:=0;
        count:=0;
        for l:=-dsmpl to dsmpl do
            if (k+l>=1) and (k+l<=Channel_number) then begin
                sum:=sum+spek.y[k+l];
                inc(count);
                end;
        if count>0 then sum:=sum/count;
        new.y[k]:=sum;
        end;
    if Channel_number>2 then for k:=1 to Channel_number do spek.y[k]:=new.y[k];
    end;


procedure average(var spek: Attr_spec);
{ Calculate average of spectrum 'spek' over specified wavelength range. }
var k, u, o : integer;
begin
    u:=Nachbar(Lmin);
    o:=Nachbar(Lmax);
    for k:=u to o do spek.avg:=spek.avg+spek.y[k];
    spek.avg:=spek.avg/(o-u+1);
    end;

procedure set_zero(var spek: Attr_spec);
var k : integer;
begin
    for k:=1 to Channel_number do spek.y[k]:=0;
    spek.ParText:='';
    end;

procedure resample_Gauss(var spek_in: Attr_spec; DirOut: String);
{ Resample the spectrum 'spek_in' and save result in the Directory 'DirOut'.
  Resampling uses a Gaussian-shaped spectral response function and
  weights the data in an interval of +-3 standard deviations around the
  band's center wavelength. }
var  datei_out  : textFile;
     ch, i      : word;
     channels   : word;
     yy, dy     : double;
     kmin       : word;
begin
    lies_spektrum(spek_in, spek_in.Fname, spek_in.XColumn, spek_in.YColumn,
        spek_in.Header, channels, false);
    {$i-}
    AssignFile(datei_out, DirOut+ExtractFileName(spek_in.Fname));
    rewrite(datei_out);
    if ioresult=0 then begin
        writeln(datei_out, 'This file was created by WASI.2D');
        writeln(datei_out, vers);
        writeln(datei_out, 'Input spectrum: ', spek_in.FName);
        for ch:=1 to Channel_number do begin
            yy:=0;
            for i:=1 to channels do
                if (abs(xx^.y[i]-x^.y[ch])<3/2.35*FWHM^.y[ch]) then begin
                    if (i>1) then dy:=abs(xx^.y[i]-xx^.y[i-1])
                             else dy:=abs(xx^.y[2]-xx^.y[1]);   {i=1}
                    yy:=yy + spek_in.y[i] *
                        Gauss(xx^.y[i]-x^.y[ch], FWHM^.y[ch]/2.35, 1.0025)*dy;
                    end;
            { if input data are too sparce, use value of closest channel }
            if yy=0 then begin
                kmin:=1;
                for i:=2 to channels do
                    if abs(xx^.y[i]-x^.y[ch])<abs(xx^.y[kmin]-x^.y[ch]) then kmin:=i;
                yy:=spek_in.y[kmin]
                end;
            writeln(datei_out, schoen(x^.y[ch],4), #9, schoen(yy,4));
            end;
        closeFile(datei_out);
        end;
    {$i+}
    end;

procedure resample_database(DirOut : string);
{ Resample all relevant input spectra using the sensor properties
  specified in 'Bands' and save result in the directory 'DirOut'. }
var  i  : integer;
begin
    resample_Gauss(E0^,  DirOut);
    if flag_mult_E0 then
        for i:=1 to Channel_number do E0^.y[i]:=E0_factor * E0^.y[i];
    resample_Gauss(aO2^, DirOut);
    resample_Gauss(aO3^, DirOut);
    resample_Gauss(aWV^, DirOut);
    resample_Gauss(a_ice, DirOut);
    resample_Gauss(aW^,  DirOut);
    resample_Gauss(dadT^, DirOut);
    for i:=0 to 5 do resample_Gauss(aP[i]^, DirOut);
    resample_Gauss(aNAP^,  DirOut);
    resample_Gauss(aY^,  DirOut);
    resample_Gauss(bPhyN^, DirOut);
    resample_Gauss(bXN^,  DirOut);
    for i:=0 to 5 do resample_Gauss(albedo[i]^, DirOut);
    resample_Gauss(a_nw^, DirOut);
    resample_Gauss(Ed^,   DirOut);
    resample_Gauss(Ls^,   DirOut);
    resample_Gauss(Kd^,   DirOut);
    resample_Gauss(R^,    DirOut);
    resample_Gauss(Gew^,  DirOut);
    if not flag_public then begin
        resample_Gauss(tA^,  DirOut);
        resample_Gauss(tC^,  DirOut);
        resample_Gauss(Lpath, DirOut);
        resample_Gauss(resp, DirOut);
        resample_Gauss(u_c^,  DirOut);
        resample_Gauss(u_t^,  DirOut);
        resample_Gauss(u_p^,  DirOut);
        resample_Gauss(u_n^,  DirOut);
        resample_Gauss(aphA^,  DirOut);
        resample_Gauss(aphB^,  DirOut);
        resample_Gauss(CMF_r^,  DirOut);
        resample_Gauss(CMF_g^,  DirOut);
        resample_Gauss(CMF_b^,  DirOut);
        end;
    end;

procedure load_single_resampled_file(pfad: string; var spek_in: Attr_spec;
    header: integer; channels: integer);
var datei_in : text;
    ch       : integer;
    dummy    : double;
begin
    {$i-}
    AssignFile(datei_in, pfad+ExtractFileName(spek_in.FName));
    reset(datei_in);
    if ioresult=0 then begin
        if header>0 then for ch:=1 to header do readln(datei_in);
        for ch:=1 to channels do
            readln(datei_in, dummy, spek_in.y[ch]);
        CloseFile(datei_in);
        end;
    {$i+}
    end;


procedure load_resampled_spectra(pfad: string; channels: integer);
var i : integer;
begin
    load_single_resampled_file(pfad, E0^, 3, channels);
    if flag_mult_E0 then for i:=1 to channels do E0^.y[i]:=E0_factor * E0^.y[i];
    load_single_resampled_file(pfad, aO2^, 3, channels);
    load_single_resampled_file(pfad, aO3^, 3, channels);
    load_single_resampled_file(pfad, aWV^, 3, channels);
    load_single_resampled_file(pfad, a_ice, 3, channels);
    load_single_resampled_file(pfad, aW^, 3, channels);
    load_single_resampled_file(pfad, dadT^, 3, channels);
    for i:=0 to 5 do load_single_resampled_file(pfad, aP[i]^, 3, channels);
    load_single_resampled_file(pfad, aNAP^, 3, channels);
    load_single_resampled_file(pfad, aY^, 3, channels);
    load_single_resampled_file(pfad, bPhyN^, 3, channels);
    load_single_resampled_file(pfad, bXN^, 3, channels);
    for i:=0 to 5 do load_single_resampled_file(pfad, albedo[i]^, 3, channels);
    load_single_resampled_file(pfad, a_nw^, 3, channels);
    load_single_resampled_file(pfad, Ed^,   3, channels);
    if flag_mult_Ed then for i:=1 to channels do Ed^.y[i]:=Ed_factor * Ed^.y[i];
    load_single_resampled_file(pfad, Ls^,   3, channels);
    load_single_resampled_file(pfad, Kd^,   3, channels);
    load_single_resampled_file(pfad, R^,    3, channels);
    load_single_resampled_file(pfad, Gew^,  3, channels);
    Ch_int_min:=Nachbar(Norm_min);
    Ch_int_max:=Nachbar(Norm_max);
    if flag_Y_exp then berechne_aY(S.actual);
    berechne_bbW;
    berechne_bMie;
    berechne_bbMie;
    if not flag_public then begin
        load_single_resampled_file(pfad, tA^, 3, channels);
        load_single_resampled_file(pfad, tC^, 3, channels);
        load_single_resampled_file(pfad, Lpath, 3, channels);
        load_single_resampled_file(pfad, resp, 3, channels);
        load_single_resampled_file(pfad, u_c^, 3, channels);
        load_single_resampled_file(pfad, u_t^, 3, channels);
        load_single_resampled_file(pfad, u_p^, 3, channels);
        load_single_resampled_file(pfad, u_n^, 3, channels);
        load_single_resampled_file(pfad, aphA^, 3, channels);
        load_single_resampled_file(pfad, aphB^, 3, channels);
        load_single_resampled_file(pfad, CMF_r^, 3, channels);
        load_single_resampled_file(pfad, CMF_g^, 3, channels);
        load_single_resampled_file(pfad, CMF_b^, 3, channels);
        end;
    end;

//function DeleteFiles(const AFile: string): boolean;
//{ Dateien und Verzeichnisse löschen. Beispiele:
//      if DeleteFiles('c:\test.txt') then   //um eine Datei zu löschen
//      if DeleteFiles('c:\test') then       //um ein Verzeichnis zu löschen
//      if DeleteFiles('c:\test\*.*') then // Um alle Dateien eines Verzeichnisses zu löschen
//}
//var sh: SHFileOpStruct;
//begin
//    ZeroMemory(@sh, SizeOf(sh));
//    with sh do
//    begin
//        Wnd := Application.Handle;
//        wFunc := FO_DELETE;
//        pFrom := PChar(AFile +#0);
//        fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
//        end;
//    result := SHFileOperation(sh) = 0;
//    end;

procedure resample;
{ Resample input spectra to sensor resolution. }
var path : string;
begin
    path:=path_exe + path_resampl;
    if not DirectoryExists(path) then if not ForceDirectories(path) then begin
        MessageBox(0, PChar(path), 'ERROR: Could not create directory ',
        MB_ICONSTOP+MB_OK);
        halt;
        end;

    resample_database(path);
    load_resampled_spectra(path, Channel_number);
    //if flag_del_rsmpl then DeleteFiles(copy(path,1,length(path)-1));
    end;


procedure Save_Fitresults_as_ASCII(Filename: string);
{ Save fit parameters as ASCII table }
var  datei_out : textFile;
     x, y, b   : integer;
begin
   { Save fit parameters as ASCII table }
    {$i-}
    AssignFile(datei_out, Filename);
    rewrite(datei_out);
    writeln(datei_out, 'This file was generated by the program WASI-2D');
    writeln(datei_out, vers);
    writeln(datei_out);
    write(datei_out, 'x', #9, 'y', #9);
    for b:=1 to M1 do if (par.fit[b]=1) then write(datei_out, par.name[b], #9);
    writeln(datei_out, 'Resid', #9, 'NIter');

    for x:=0 to Width_in-1 do
    for y:=0 to Height_in-1 do
    if WaterMask[x,y] and (cube_fitpar[x,y,Channels_out-1]>1) then begin
        write(datei_out, x, #9);
        write(datei_out, y, #9);
        for b:=0 to Channels_out-1 do
            write(datei_out, schoen(cube_fitpar[x,y,b], 3), #9);
        writeln(datei_out);
        end;
    closeFile(datei_out);
    {$i+}
    end;

procedure delete_calculated_spectra;
begin
    bXN^.ParText:='';
    bMie^.ParText:='';
    bbMie^.ParText:='';
    aY^.ParText:='';
    GC_T_o2^.ParText:='';
    GC_T_o3^.ParText:='';
    GC_T_WV^.ParText:='';
    GC_tau_a^.ParText:='';
    GC_T_r^.ParText:='';
    GC_T_as^.ParText:='';
    GC_T_aa^.ParText:='';
    Ed0^.ParText:='';
    Ed^.ParText:='';
    GC_Edd^.ParText:='';
    GC_Eds^.ParText :='';
    GC_Edsr^.ParText:='';
    GC_Edsa^.ParText:='';
    r_d^.ParText:='';
    Lu^.ParText:='';
    Lr^.ParText:='';
    Ls^.ParText:='';
    Lf^.ParText:='';
    if Kd^.sim then Kd^.ParText:='';
    Kdd^.ParText:='';
    Kds^.ParText:='';
    KE_uW^.ParText:='';
    KE_uB^.ParText:='';
    kL_uW^.ParText:='';
    kL_uB^.ParText:='';
    z_Ed^.ParText:='';
    R^.ParText:='';
    r_rs^.ParText:='';
    Rrs^.ParText:='';
    Rrs_surf^.ParText:='';
    RrsF^.ParText:='';
    f_R^.ParText:='';
    f_rs^.ParText:='';
    Q_f^.ParText:='';
    bottom^.ParText:='';
    a^.ParText:='';
    b^.ParText:='';
    bb^.ParText:='';
    a_calc^.ParText:='';
    aP_calc^.ParText:='';
    aNAP_calc^.ParText:='';
    aCDOM_calc^.ParText:='';
    b_calc^.ParText:='';
    bb_calc^.ParText:='';
    bb_phy^.ParText:='';
    bb_NAP^.ParText:='';
    omega_b^.ParText:='';

    bXN^.sim      :=FALSE;
    bMie^.sim     :=FALSE;
    bbMie^.sim    :=FALSE;
    aY^.sim       :=FALSE;
    GC_T_o2^.sim  :=FALSE;
    GC_T_o3^.sim  :=FALSE;
    GC_T_WV^.sim  :=FALSE;
    GC_tau_a^.sim :=FALSE;
    GC_T_r^.sim   :=FALSE;
    GC_T_as^.sim  :=FALSE;
    GC_T_aa^.sim  :=FALSE;
    Ed0^.sim      :=FALSE;
    Ed^.sim       :=FALSE;
    GC_Edd^.sim   :=FALSE;
    GC_Eds^.sim   :=FALSE;
    GC_Edsr^.sim  :=FALSE;
    GC_Edsa^.sim  :=FALSE;
    r_d^.sim      :=FALSE;
    Lu^.sim       :=FALSE;
    Lr^.sim       :=FALSE;
    Ls^.sim       :=FALSE;
    Lf^.Sim       :=FALSE;
    Kd^.sim       :=FALSE;
    Kdd^.sim      :=FALSE;
    Kds^.sim      :=FALSE;
    KE_uW^.sim    :=FALSE;
    KE_uB^.sim    :=FALSE;
    kL_uW^.sim    :=FALSE;
    kL_uB^.sim    :=FALSE;
    z_Ed^.sim     :=FALSE;
    R^.sim        :=FALSE;
    r_rs^.sim     :=FALSE;
    Rrs^.sim      :=FALSE;
    Rrs_surf^.sim :=FALSE;
    RrsF^.sim     :=FALSE;
    f_R^.sim      :=FALSE;
    f_rs^.sim     :=FALSE;
    Q_f^.sim      :=FALSE;
    bottom^.sim   :=FALSE;
    a^.sim        :=FALSE;
    b^.sim        :=FALSE;
    bb^.sim       :=FALSE;
    a_calc^.sim   :=FALSE;
    aP_calc^.sim  :=FALSE;
    aNAP_calc^.sim  :=FALSE;
    aCDOM_calc^.sim :=FALSE;
    b_calc^.sim   :=FALSE;
    bb_calc^.sim  :=FALSE;
    bb_phy^.sim   :=FALSE;
    bb_NAP^.sim   :=FALSE;
    omega_b^.sim  :=FALSE;
    end;

procedure activate_calculated_spectra;
begin
{    delete_calculated_spectra; }
    case spec_type of
        S_Ed_GC   : begin
                    a_calc^.sim  :=not flag_above and not flag_use_Ed;
                    bb_calc^.sim :=not flag_above and not flag_use_Ed;
                    bb_phy^.sim  :=bb_calc^.sim;
                    bb_NAP^.sim  :=bb_calc^.sim;
                    Kdd^.sim     :=not flag_above and not flag_use_Ed;
                    Kds^.sim     :=not flag_above and not flag_use_Ed;
                    r_d^.sim     :=not flag_use_Ed;
                    GC_Edd^.sim  :=not flag_use_Ed;
                    GC_Edsr^.sim :=not flag_use_Ed;
                    GC_Edsa^.sim :=not flag_use_Ed;
                    GC_Eds^.sim  :=not flag_use_Ed;
                    end;
        S_Lup     : begin
                    a_calc^.sim  :=not flag_above and not flag_use_Ed;
                    bb_calc^.sim :=TRUE;
                    bb_phy^.sim  :=bb_calc^.sim;
                    bb_NAP^.sim  :=bb_calc^.sim;
                    Kd^.sim      :=flag_fluo;
                    Kdd^.sim     :=flag_use_Ed;
                    Kds^.sim     :=flag_use_Ed;
                    r_d^.sim     :=flag_use_Ed;
                    GC_Edd^.sim  :=flag_use_Ed;
                    GC_Edsr^.sim :=flag_use_Ed;
                    GC_Edsa^.sim :=flag_use_Ed;
                    GC_Eds^.sim  :=flag_use_Ed;
                    kL_uW^.sim   :=flag_fluo;
                    Ed0^.sim     :=flag_fluo;
                    RrsF^.sim    :=flag_fluo;
                    Lf^.sim      :=flag_fluo;
                    Lr^.sim      :=flag_above;
                    omega_b.sim  :=TRUE;


                    end;
        S_Rrs     : begin
                    b^.sim       :=FALSE;
                    kL_uW^.sim   :=flag_fluo;
                    Ed0^.sim     :=flag_fluo;
                    RrsF^.sim    :=flag_fluo;
                    Lf^.sim      :=flag_fluo;
                    end;
        S_R       : begin
                    b^.sim  :=FALSE;
                    kL_uW^.sim   :=flag_fluo;
                    Ed0^.sim     :=flag_fluo;
                    RrsF^.sim    :=flag_fluo;
                    Lf^.sim :=flag_fluo;
                    end;
        S_Rsurf   : begin
                    b^.sim  :=FALSE;
                    end;
        S_a       : begin
                    b^.sim  :=FALSE;
                    end;
        S_Kd      : begin
                    b^.sim  :=FALSE;
                    end;
        S_Rbottom : begin
                    b^.sim  :=FALSE;
                    end;
        S_Ed_Gege : begin
                    b^.sim  :=FALSE;
                    end;
        S_Test    : begin
                    b^.sim  :=FALSE;
                    end;

        end;

    if GC_T_r^.sim then GC_T_r^.ParText:='Transmittance of the atmosphere after Rayleigh scattering';
    if GC_tau_a^.sim then GC_tau_a^.ParText:='Aerosol optical thickness';
    if GC_T_as^.sim then GC_T_as^.ParText:='Transmittance of the atmosphere after aerosol scattering';
    if GC_T_aa^.sim then GC_T_aa^.ParText:='Transmittance of the atmosphere after aerosol absorption';
    if GC_T_o2^.sim then GC_T_o2^.ParText:='Transmittance of the atmosphere after oxygen absorption';
    if GC_T_o3^.sim then GC_T_o3^.ParText:='Transmittance of the atmosphere after ozone absorption';
    if GC_T_WV^.sim then GC_T_WV^.ParText:='Transmittance of the atmosphere after water vapor absorption';
    if GC_Edd^.sim then GC_Edd^.ParText:='Downwelling direct irradiance (mW m^-2 nm^-1)';
    if GC_Edsr^.sim then GC_Edsr^.ParText:='Downwelling irradiance due to Rayleigh scattering (mW m^-2 nm^-1)';
    if GC_Edsa^.sim then GC_Edsa^.ParText:='Downwelling irradiance due to aerosol scattering (mW m^-2 nm^-1)';
    if GC_Eds^.sim then GC_Eds^.ParText :='Downwelling diffuse irradiance (mW m^-2 nm^-1)';
    if r_d^.sim then r_d^.ParText:='Ratio of direct to diffuse downwelling irradiance';
    if a_calc^.sim then a_calc^.ParText:='Absorption coefficient of water + constituents (1/m)';
    if bb_calc^.sim then bb_calc^.ParText:='Backscattering coefficient of water + constituents (1/m)';
    if bb_phy^.sim then bb_phy^.ParText:='Phytoplankton backscattering coefficient (1/m)';
    if bb_NAP^.sim then bb_NAP^.ParText:='Non-algal particle backscattering coefficient (1/m)';
    if a^.sim then begin
        if flag_aW or (spec_type<>S_a) then a^.ParText:='Absorption coefficient (m^-1)'
        else a^.ParText:='Absorption of water constituents (m^-1)';
        end;
    if bb^.sim then bb^.ParText:='Backscattering coefficient (m^-1)';
    if b^.sim then b^.ParText:='Scattering coefficient (m^-1)';
    if omega_b^.sim then omega_b^.ParText:='omega_b';
    if f_R^.sim then f_R^.ParText:='f factor';
    if Ed0^.sim then Ed0^.ParText:='Downwelling irradiance just beneath water surface (mW m^-2 nm^-1)';
    if Lf^.sim then Lf^.ParText:='Chl-a fluorescence component of upwelling radiance (mW m^-2 nm^-1 sr^-1)';
    if RrsF^.sim then RrsF^.ParText:='Chl-a fluorescence component of radiance reflectance (1/sr)';
    if R^.sim then R^.ParText:='Irradiance reflectance';
    if r_rs^.sim then r_rs^.ParText:='Radiance reflectance (sr^-1)';
    if Lu^.sim then Lu^.ParText:='Upwelling radiance (mW m^-2 nm^-1 sr^-1)';
    if Ls^.sim then Ls^.ParText:='Sky radiance (mW m^-2 nm^-1 sr^-1)';
    if Lr^.sim then Lr^.ParText:='Radiance reflected at the water surface (mW m^-2 nm^-1 sr^-1)';
    if Rrs^.sim then Rrs^.ParText:='Remote sensing reflectance (1/sr)';
    if Rrs_surf^.sim then Rrs_surf^.ParText:='Surface reflectance (1/sr)';
    if bottom^.sim then begin
        if flag_L then bottom^.ParText:='Bottom radiance reflectance (1/sr)'
        else bottom^.ParText:='Bottom albedo';
        end;
    if Kd^.sim then Kd^.ParText:='Diffuse attenuation coefficient (1/m)';
    if Kdd^.sim then Kdd^.ParText:='Attenuation coefficient of direct irradiance (1/m)';
    if Kds^.sim then Kds^.ParText:='Attenuation coefficient of diffuse irradiance (1/m)';
    if KE_uW^.sim then KE_uW^.ParText:='Diffuse attenuation of upwelling irradiance backscattered in water (1/m)';
    if KE_uB^.sim then KE_uB^.ParText:='Diffuse attenuation of upwelling irradiance reflected from the bottom (1/m)';
    if kL_uW^.sim then kL_uW^.ParText:='Attenuation of upwelling radiance backscattered in water (1/m)';
    if kL_uB^.sim then kL_uB^.ParText:='Attenuation of upwelling radiance reflected from the bottom (1/m)';
    if z_Ed^.sim then z_Ed^.ParText:='Penetration depth (m)';
    end;


procedure import_LUT(i:byte);
{ Import Lookup-Table from file.
  i=1: Lookup table for series of simulated spectra
  i=2: Lookup table for color-coding of channels in 2D mode }
var Stream : TFileStream;
begin
    if (i=1) or (i=2) then try
        Stream := TFileStream.Create(file_LUT[i], fmOpenRead);
        except
          on EFOpenError do begin
            error_msg:='ERROR: File ' + file_LUT[i] + ' not found';
            exit;
          end;
        end;
        Stream.Read(LUT_R[i], 256);
        Stream.Read(LUT_G[i], 256);
        Stream.Read(LUT_B[i], 256);
        Stream.Free;
    end;


function bunt(i, N, M:integer):integer;
{ Return LUT color of N for N in [0..M]. If M<4, return clBlue. }
var farbe : integer;
begin
    if i<>2 then i:=1; // LUT index must be 1 or 2
    if M>0 then farbe:=round(255*N/M) else farbe:=clBlue;
    if farbe>255 then farbe:=255 else if farbe<0 then farbe:=0;
    farbe:=LUT_R[i,farbe] + LUT_G[i,farbe] shl 8 + LUT_B[i,farbe] shl 16;
    if M>0 then bunt:=farbe else bunt:=clBlue;
    end;

function CountFilesInFolder(pattern, path: string): integer;
{ Count the number of files with search pattern "pattern" in the folder "path". }
{ 5 July 2019 }
var tsr: TSearchRec;
begin
    path := IncludeTrailingPathDelimiter(path);
    result := 0;
    if FindFirst(path + pattern, faAnyFile and not faDirectory, tsr)=0 then begin
        repeat
            inc (result);
        until FindNext(tsr) <> 0;
        FindClose(tsr);
        end;
    end;

procedure DeleteAll(Dir, Files: string);
{ Delete all files in directory 'Dir' following the 'Files' specifications
  including wildcards. Adapted from
  https://www.delphipraxis.net/3574-alle-dateien-eines-verzeichnisses-loeschen.html }
var SearchRec : TSearchRec;
begin
  if FindFirst(Dir+Files, faAnyFile, SearchRec) = 0 then begin
      DeleteFile(SearchRec.Name);
      while FindNext(SearchRec) = 0 do
          DeleteFile(Dir + SearchRec.Name);
      end;
  FindClose(SearchRec);
  end;


end.




