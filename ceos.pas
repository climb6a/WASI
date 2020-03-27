unit CEOS;
{ Parameters and procedures used for sensitivity studies in CEOS report and paper.
  - https://elib.dlr.de/119249/
  - Gege and Dekker (2020): Optimal spectral and radiometric sensitivity for global monitoring
    of inland and reef waters. Remote Sensing, in preparation.

  Running the simulations:
  - Set flag_CEOS = TRUE
  - Iterate the third parameter of the Selection panel for specifying the parameter iterations

  Version vom 13.3.2020 }

{$mode delphi}

interface

uses    defaults, gui, misc, fw_calc, privates, schoen_, Popup_2D_Format, Classes, Dialogs,
        graphics, SysUtils, DateUtils;

const   flag_CEOS     : boolean = TRUE;                 { Run simulations for CEOS study }
        CEOS_LUT_dL   = 'D:\WASI5.1\private\LUT\8_Color.lut';
        CEOS_LUT_1    = 'D:\WASI5.1\private\LUT\Blue_Green_Red.lut';
        CEOS_dp       : double = 0.1;                   { CEOS study: parameter difference }
        scenario      : string = '';                    { Scenario name, input via dialog }

var     CEOS_maxima   : text;                           { File with maxima of dRrs }
        CEOS_1st      : text;                           { File with 1st derivatives }
        CEOS_2nd      : text;                           { File with 2nd derivatives }
        CEOS_NEdR     : text;                           { File with NEdR }
        CEOS_par      : string;                         { Parameter description of CEOS output }
        CEOS_spc      : string;                         { Spectrum type of CEOS output }
        CEOS_ku       : integer;                        { First channel of CEOS calculations }
        CEOS_ko       : integer;                        { Last channel of CEOS calculations }
        chMax         : integer;                        { Channel with maximum value of spectrum }
        p3Max         : array[1..3] of double;          { Maxima of Rrs for different values of the
                                                          third parameter of the selection panel }
        his_1st       : ^Attr_spec;                     { Histogram of 1st derivatives }
        his_2nd       : ^Attr_spec;                     { Histogram of 2nd derivatives }
        NEdR          : double;                         { Noise-equivalent delta-reflectance }
        merkdRrs      : spektrum;                       { Copy of delta Rrs }
        merkS         : spektrum;                       { Copy of actual spectrum }
        merk1st       : spektrum;                       { Copy of first derivative }
        flag_iter_3p  : boolean;                        { Iterate 3 parameters simultaneously? }
        old_albedo    : array[0..5]of Attr_spec;        { Bottom albedo spectra }

procedure CEOS_Average_images(Sender: TObject);
procedure run_CEOS_simulation(Sender: TObject);
procedure set_CEOS_settings(setting: integer);
procedure CEOS_Median_max(Sender: TObject);
procedure derivate_lambda(p: double; flag_ytxt: boolean);
procedure calc_spectral_resolution(max_dL: double);
procedure calc_NEdR(S:Spektrum; Lmin, Lmax : double; flag_ytxt: boolean);
procedure Rrs_N(flag_ytxt:boolean);
procedure dRrs_par(N: integer; p, dp:double; flag_ytxt: boolean);

implementation


procedure CEOS_Average_images(Sender: TObject);
{ Average all hyperspectral images in the directory of HSI_img. }
var tmp_yscale     : double;
    FileAttrs      : Integer;
    sr             : TSearchRec;
    Pfad           : String;
    Name_LoadBatch : string;
    Extension      : string;
    x, f, c        : longInt;
    ABBRUCH        : boolean;
    N_Spectra      : integer;
    N_Files        : integer;
begin
   tmp_yscale:=y_scale;
   TimeStartCalc:=Now;
   y_scale:=1;
   N_spectra:=0;
   flag_HSI_wv:=FALSE; { bands of HSI cube are no wavelengths }
   Pfad:=ExtractFilePath(HSI_img^.FName);
   Extension:=ExtractFileExt(HSI_img^.FName);
   Name_LoadBatch:=Pfad + '*' + ExtractFileExt(HSI_img^.FName);
   FileAttrs := faAnyFile;
   N_Files:=CountFilesInFolder('*' + Extension, Pfad);

   if N_Files>1 then begin
       if FindFirst(Name_LoadBatch, FileAttrs, sr) = 0 then begin
           actualFile:=Pfad+sr.Name;
           if flag_ENVI then Format_2D.Read_Envi_Header(actualFile);
           Channels_out:=Channels_in;
           SetLength(cube_fitpar, Width_in, Height_in, Channels_out);
           Output_HSI:=Pfad + 'average' + ExtractFileExt(HSI_img^.FName);
           ABBRUCH:=FALSE;
           REPEAT
               inc(N_spectra);
               actualFile:=Pfad+sr.Name;
               HSI_img^.FName:=actualFile;
               Format_2D.import_HSI(Sender);

               { loop over frames = image lines }
               f:=0;                    // Set f to first processed image line
               repeat
                   x:=0;                // Set x to first processed image column

                   { loop over pixels = image columns }
                   if flag_CEOS and (not flag_public) then repeat
                       Format_2D.extract_spektrum_new(spec[1]^, x, f, Sender);  // Read spectrum
                       for c:=1 to 10 do   // 12 bands is CEOS specific
                           cube_fitpar[x,f,c-1]:=cube_fitpar[x,f,c-1]+spec[1]^.y[c];
                       if  abs(spec[1]^.y[band_thresh])>=thresh_dRrs then begin
                           cube_fitpar[x,f,10]:=cube_fitpar[x,f,10]+spec[1]^.y[11];
                           cube_fitpar[x,f,11]:=cube_fitpar[x,f,11]+1;    // N
                           end;
                       inc(x);
                   until (x>=Width_in) or ABBRUCH

                   else repeat
                       Format_2D.extract_spektrum_new(spec[1]^, x, f, Sender);  // Read spectrum
                       for c:=1 to Channels_out do
                           cube_fitpar[x,f,c-1]:=cube_fitpar[x,f,c-1]+spec[1]^.y[c];
                       inc(x);
                   until (x>=Width_in) or ABBRUCH;

                   inc(f);
               until (f>=Height_in) or ABBRUCH;
           UNTIL (FindNext(sr)<>0);
           FindClose(sr);

           if N_Spectra>1 then
               for f:=0 to Height_in-1 do
               for x:=0 to Width_in-1 do begin
                   for c:=1 to Channels_out-2 do
                       cube_fitpar[x,f,c-1]:=cube_fitpar[x,f,c-1]/N_Spectra;
                   if flag_CEOS and (not flag_public) then begin
                       if cube_fitpar[x,f,11]>1 then  // N > 1
                           cube_fitpar[x,f,10]:=cube_fitpar[x,f,10]/cube_fitpar[x,f,11];
                       end
                   else begin
                       cube_fitpar[x,f,Channels_out-2]:=cube_fitpar[x,f,Channels_out-2]/N_Spectra;
                       cube_fitpar[x,f,Channels_out-1]:=cube_fitpar[x,f,Channels_out-1]/N_Spectra;
                       end;
                    end;

           TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
           Format_2D.Write_Fitresult(Height_in-1);
           Format_2D.Write_Envi_Header_fit(Output_HSI);
           spec[1]^.FName:=Output_HSI;

           HSI_img^.FName:=Output_HSI;
           Format_2D.import_HSI(Sender);
           Average_image_lines(ChangeFileExt(Output_HSI, '.txt'));
           end;
        end
        else ShowMessage('ERROR: Less than 2 images in directory '+Pfad);
        y_scale:=tmp_yscale;
    end;


procedure open_file_dL;
begin
    CEOS_spc:='dL';
    FW_TABLE:=CEOS_par+ '_' + CEOS_spc;
    assignFile(CEOS_NEdR, DIR_saveFwd + '\' + CEOS_par + '.dR');
    rewrite(CEOS_NEdR);
    writeln(CEOS_NEdR, 'NEdR = 0.01 * |Rrs_max - Rrs_min|');
    writeln(CEOS_NEdR);
    writeln(CEOS_NEdR, 'This file was generated by the program WASI');
    writeln(CEOS_NEdR, vers);
    writeln(CEOS_NEdR);
    if (Par1_Type>0) and (Par2_Type>0) then
        writeln(CEOS_NEdR, 'NEdR', #9, par.name[Par1_Type], #9,
        par.name[Par2_Type], #9, par.name[Par3_Type])
    else writeln(CEOS_NEdR, 'NEdR', #9, par.name[Par3_Type]);
    end;

procedure calc_NEdR(S:Spektrum; Lmin, Lmax : double; flag_ytxt: boolean);
{ Calculate noise-equivalent delta-reflectance (NEdR) based on minimum
  and maximum value of S in spectral range Lmin to Lmax. }
var chMin     : integer;     // channel with minimum value of S
    chMax     : integer;     // channel with maximum value of S
    k, ku, ko : integer;     // channel index
begin
    ku:=Nachbar(Lmin);
    ko:=Nachbar(Lmax);
    chMin:=ku;
    chMax:=ku;
    for k:=ku+1 to ko do begin
        if abs(S[k])<abs(S[chMin]) then chMin:=k;
        if abs(S[k])>abs(S[chMax]) then chMax:=k;
        end;
    NEdR:=0.01*abs(S[chMax]-S[chMin]);

    if not flag_ytxt then begin
        if (Par1_Type>0) and (Par2_Type>0) then
            writeln(CEOS_NEdR, schoen(NEdR, 3), #9, schoen(c1, 3), #9,
            schoen(c2, 3), #9, schoen(c3, 3))
        else writeln(CEOS_NEdR, schoen(NEdR, 3), #9, schoen(c3, 3));
        end;
    end;

procedure prepare_for_BMP;
var   z, s    : integer;
begin
    SetLength(WaterMask, Width_in, Height_in);
    SetLength(cube_HSI4, Width_in, Height_in, 4);
    for z:=0 to Height_in-1 do for s:=0 to Width_in-1 do begin
        WaterMask[s,z]:=TRUE;
        cube_HSI4[s,z,3]:=0;
        end;
    end;

procedure Select_channels_BMP(R,G,B:integer);
{ Select channels R, G, B of cube_fitpar for bitmap image }
var   z, s    : integer;
begin
    for z:=0 to Height_in-1 do
        for s:=0 to Width_in-1 do begin
            cube_HSI4[s,z,0]:=cube_fitpar[s,z,R];
            cube_HSI4[s,z,1]:=cube_fitpar[s,z,G];
            cube_HSI4[s,z,2]:=cube_fitpar[s,z,B];
            end;
    end;


procedure fill_BMP(var BMP: TBitmap);
{ Fill BMP pixels with colors. }
var   z, s    : integer;
      color   : TColor;
      R, G, B : longword;
begin
    for z:=0 to Height_in-1 do
    for s:=0 to Width_in-1 do begin
        R:=Channel_R[s,z];
        G:=Channel_G[s,z] shl 8;
        B:=Channel_B[s,z] shl 16;
        color:=R+G+B;
        BMP.Canvas.Pixels[s,z] := color;
        end;
    end;

procedure set_band_white(b: integer);
var i, z : integer;
    l    :  integer;
    color : double;
begin
    for z:=0 to Height_in-1 do begin
        for i:=1 to Channel_number do begin
            l:=round(x^.y[i]);
            if (l<=400) or ((l>500) and (l<=600)) or ((l>700) and (l<=800)) or (l>900)
                then color:=0.85 else color:=1;
            cube_fitpar[i-1,z,b]:=color;
            end;
        end;
    end;

procedure set_band_black(b: integer);
var i, z  : integer;
begin
    for z:=0 to Height_in-1 do
        for i:=1 to Channel_number do
            cube_fitpar[i-1,z,b]:=0;
    end;

procedure create_x_ticks;
var i, z : integer;
begin
    for z:=0 to Height_in-1 do
        for i:=1 to Channel_number do begin
            if (round(x^.y[i]) mod 100=0) then cube_fitpar[i-1,z,11]:=0;
            end;
    end;

procedure create_dRrs_mask(thresh:double);
var z, s : integer;
begin
    for z:=0 to Height_in-1 do for s:=0 to Width_in-1 do
        if (cube_fitpar[s,z,2]<thresh) then WaterMask[s,z]:=FALSE;
    end;

procedure CEOS_save_BMP;
{ Extract true color image from cube_fitpar and save it to file.
  The bands of cube_fitpar contain the following information:
  cube_fitpar[0]  = Rrs
  cube_fitpar[1]  = Rrs normalized
  cube_fitpar[2]  = abs(delta_Rrs)
  cube_fitpar[3]  = abs(delta_Rrs) normalized
  cube_fitpar[4]  = abs(1st derivative of Rrs)
  cube_fitpar[5]  = abs(1st derivative of Rrs normalized)
  cube_fitpar[6]  = abs(2nd derivative of Rrs)
  cube_fitpar[7]  = abs(2nd derivative of Rrs normalized)
  cube_fitpar[8]  = zeros of 1st derivative of Rrs
  cube_fitpar[9]  = zeros of 2nd derivative of Rrs
  cube_fitpar[10] = NEdR / abs(1st derivative of Rrs) = delta-Lambda
  cube_fitpar[11] = zero
}
var   BMP       : TBitmap;       { 3 channel representation of data cube }
      f1, f5    : frame_single;  { temporary image frame }
      i, z : integer;
begin
    BMP:=TBitmap.Create;        { Create image bitmap }
    BMP.Width  := Width_in;
    BMP.Height := Height_in;
    BMP.Pixelformat := pf24bit;
    prepare_for_BMP;
    SetLength(f1, Width_in, Height_in);
    SetLength(f5, Width_in, Height_in);

    // Rrs
    Par0_Min:=0; Par0_Max:=0.01;
    flag_3bands:=FALSE;
    Select_channels_BMP(0, 0, 0);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch000.bmp');

    // Rrs normalized
    Par0_Min:=0; Par0_Max:=1;
    Select_channels_BMP(1, 1, 1);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch111.bmp');

    // abs(delta_Rrs)
    Par0_Min:=0; Par0_Max:=1E-5;
    Select_channels_BMP(2, 2, 2);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch222.bmp');

    // abs(delta_Rrs) normalized
    Par0_Min:=0; Par0_Max:=1;
    Select_channels_BMP(3, 3, 3);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch333.bmp');

    // abs(1st derivative of Rrs)
    Par0_Min:=0; Par0_Max:=1E-4;
    Select_channels_BMP(4, 4, 4);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch444.bmp');

    // abs(1st derivative of Rrs normalized)
    Par0_Min:=0; Par0_Max:=1;
    Select_channels_BMP(5, 5, 5);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch555.bmp');

    // abs(2nd derivative of Rrs)
    Par0_Min:=0; Par0_Max:=1E-4;
    Select_channels_BMP(6, 6, 6);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch666.bmp');

    // abs(2nd derivative of Rrs normalized)
    Par0_Min:=0; Par0_Max:=1;
    Select_channels_BMP(7, 7, 7);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch777.bmp');

    flag_3bands:=TRUE;

    Select_channels_BMP(8, 9, 11);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch89b.bmp');

    for z:=0 to Height_in-1 do  // notice bands 1 and 5 of cube_fitpar
        for i:=2 to Channel_number do begin
        f1[i-1, z]:=cube_fitpar[i-1,z,1];
        f5[i-1, z]:=cube_fitpar[i-1,z,5];
        end;

    for z:=0 to Height_in-1 do  // change bands 1 and 5 of cube_fitpar
        for i:=1 to Channel_number do if cube_fitpar[i-1,z,8]=1 then begin
            cube_fitpar[i-1,z,1]:=0;
            cube_fitpar[i-1,z,5]:=0;
            end;
    Select_channels_BMP(8, 1, 5);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch815.bmp');
    for z:=0 to Height_in-1 do  // reset bands 1 and 5 of cube_fitpar
        for i:=1 to Channel_number do begin
        cube_fitpar[i-1,z,1]:=f1[i-1, z];
        cube_fitpar[i-1,z,5]:=f5[i-1, z];
        end;

    for z:=0 to Height_in-1 do
        for i:=1 to Channel_number do if cube_fitpar[i-1,z,9]=1 then begin
            cube_fitpar[i-1,z,1]:=0;
            cube_fitpar[i-1,z,5]:=0;
            end;
    Select_channels_BMP(9, 1, 5);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch915.bmp');

    (*
    set_band_white(11);
    for z:=0 to Height_in-1 do
        for i:=1 to Channel_number do
        if (cube_fitpar[i-1,z,8]=0) and (cube_fitpar[i-1,z,9]=0) then begin
            cube_fitpar[i-1,z,8]:=cube_fitpar[i-1,z,11];
            cube_fitpar[i-1,z,9]:=cube_fitpar[i-1,z,11];
            end
        else cube_fitpar[i-1,z,11]:=0;
    Select_channels_BMP(8, 9, 11);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch89w.bmp');

    set_band_white(11);
    create_x_ticks;
    Select_channels_BMP(11, 11, 11);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_ch_x.bmp');
    *)

    flag_3bands:=FALSE;

    // NEdR / abs(1st derivative of Rrs) = delta-Lambda
    Par0_Min:=0; Par0_Max:=20;
    file_LUT[2]:=CEOS_LUT_dL;
    import_LUT(2);
    Select_channels_BMP(10, 10, 10);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_chAAA_mask_none.bmp');
    create_dRrs_mask(1E-6);
    Select_channels_BMP(10, 10, 10);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_chAAA_mask_dRrs_1E-6.bmp');
    create_dRrs_mask(1E-5);
    Select_channels_BMP(10, 10, 10);
    Format_2D.create_RGB(CEOS_ku, CEOS_ko);
    fill_BMP(BMP);
    BMP.SaveToFile(DIR_saveFwd+'\'+CEOS_par+'_chAAA_mask_dRrs_1E-5.bmp');

    FreeAndNil(BMP);
    end;


procedure run_CEOS_simulation(Sender: TObject);
{ Simulations for CEOS study in 2016. }
var setting, smin      : integer;
    merk_flag_sv_fwd   : boolean;     // save calculated spectra as ASCII files
    merk_flag_sv_table : boolean;     // save calculated spectra as table
    merk_LUT           : string;      // notice old LUT filename
begin
    flag_iter_3p:=(Par3_Type<>0) and ((Par1_Type<>0) or (Par2_Type<>0));
    merk_LUT:=file_LUT[1];
    file_LUT[1]:=CEOS_LUT_1;
    import_LUT(1);
    merk_flag_sv_fwd  :=flag_b_SaveFwd;
    merk_flag_sv_table:=flag_sv_table;
    flag_b_SaveFwd:=false;         // don't save calculated spectra as ASCII files
    flag_sv_table:=false;          // don't save calculated spectra as table
    smin:=2;     // 3
    if not flag_iter_3p then begin // permutation of 1 parameter
        Width_in :=Channel_Number;
        Height_in:=Par3_N;
        Channels_Out:=12;
        HSI_img^.Fname:='none';
        SetLength(cube_fitpar, Width_in, Height_in, Channels_out);
        flag_b_SaveFwd:=TRUE;         // save calculated spectra as ASCII files
        flag_sv_table:=TRUE;          // save calculated spectra as table
        smin:=1;
        end;

   // flag_b_SaveFwd:=TRUE;
    for setting:=smin to 7 do begin
            set_CEOS_settings(setting);
            Form1.Forward_Mode(Sender);
            Form1.SavePlotWindow(Sender, DIR_saveFwd+'\'+CEOS_par+'_'+CEOS_spc+'.png');
            if setting=5 then begin
                SCREENSHOT:=CEOS_par+'_'+CEOS_spc+'_his.png';
                spec[1]^:=his_1st^;
                saveSpecFw(DIR_saveFwd+'\'+CEOS_par+'.hi1');
                Form1.Plot_Spectrum(his_1st^, TRUE, Sender);
                end;
            if setting=6 then begin
                spec[S_actual]^.y:=merk1st;
                end;
            if setting=7 then begin
                SCREENSHOT:=CEOS_par+'_'+CEOS_spc+'_his.png';
                spec[1]^:=his_2nd^;
                saveSpecFw(DIR_saveFwd+'\'+CEOS_par+'.hi2');
                Form1.Plot_Spectrum(his_2nd^, TRUE, Sender);
                end;
            end;
    CloseFile(CEOS_maxima);
    CloseFile(CEOS_1st);
    CloseFile(CEOS_NEdR);
    CloseFile(CEOS_2nd);
    if not flag_iter_3p then begin
        Format_2D.Write_Fitresult(Height_in-1);
        Format_2D.Write_Envi_Header_fit(Output_HSI);
        CEOS_save_BMP;
        end;
    RenameFile(DIR_saveFwd + '\' + INI_public, DIR_saveFwd+'\'+CEOS_par+'_WASI.INI');
    flag_b_SaveFwd:=merk_flag_sv_fwd;
    flag_sv_table :=merk_flag_sv_table;
    file_LUT[1]:=merk_LUT;
    end;

procedure fill_histogram(var his:spektrum);
{ Create histogramm of zeros of spectrum spec[S_actual] }
var i : integer;
begin
    for i:=1 to Channel_number-1 do
        if sign(spec[S_actual]^.y[i+1])<>sign(spec[S_actual]^.y[i])
        then his[i]:=his[i]+1;
    end;

procedure normalize(var S:Spektrum; Lmin, Lmax : double);
{ Normalize spectrum S such that its maximum value is 1 in the wavelength range
  Lmin to Lmax. }
var k, ku, ko : integer;     // channel index
    max       : double;      // maximum value of S
begin
    ku:=Nachbar(Lmin);
    ko:=Nachbar(Lmax);
    max:=abs(S[ku]);
    chMax:=ku;
    for k:=ku+1 to ko do
        if abs(S[k])>abs(S[chMax]) then chMax:=k;
    max:=abs(S[chMax]);
    if chMax>ku then STest^.y[chMax]:=max;
    if abs(max)<nenner_min then max:=1;
    for k:=1 to Channel_number do
        S[k]:=S[k]/max;
    p3max[1]:=x^.y[chMax];
    p3max[2]:=max;
    end;

procedure calc_spectral_resolution(max_dL: double);
{ Calculate spectral resolution as ratio of reflectance difference (dR)
  and the 1st derivative of the reflectance spetrum (R1st).
  cube_fitpar[10] = dL = NEdR / abs(1st derivative of Rrs)}
var i : integer;
begin
    calc_NEdR(merkS, Norm_min, Norm_max, TRUE);
    for i:=1 to Channel_number do begin
        if abs(merk1st[i])>=thresh_dRrs then
            spec[S_actual]^.y[i]:=abs(NEdR/merk1st[i])
        else spec[S_actual]^.y[i]:=max_dL; // minimize artifacts from numerics or model noise
        if not flag_iter_3p then cube_fitpar[i-1,S_actual-1,10]:=spec[S_actual]^.y[i];
        end;
    end;

procedure derivate_lambda(p: double; flag_ytxt: boolean);
{ Calculate wavelength derivative of actual spectrum. }
var  i : integer;
     j : integer;
begin
    merkS:=spec[S_actual]^.y;  { notice spectrum spec[S_actual] }

    // Calculate first derivative
    if flag_1st_dl then begin
        j:=0;
        spec[S_actual]^.y[1]:=merkS[2]-merkS[1];
        for i:=2 to Channel_number do begin
            spec[S_actual]^.y[i]:=merkS[i]-merkS[i-1];  { 1st derivative }
            // cube_fitpar[4] = abs(1st derivative of Rrs)
            if (S_actual<=Par3_N) and not flag_iter_3p then
                cube_fitpar[i-1,S_actual-1,4]:=abs(spec[S_actual]^.y[i]);
            if sign(spec[S_actual]^.y[i])<>sign(spec[S_actual]^.y[i-1]) then begin
                // cube_fitpar[8] = zeros of 1st derivative of Rrs
                if (S_actual<=Par3_N) and not flag_iter_3p then
                    cube_fitpar[i-1,S_actual-1,8]:=1;
                write(CEOS_1st, schoen(x^.y[i],0), #9, schoen(merkS[i], 3), #9, schoen(p,3));
                if j>0 then writeln(CEOS_1st, #9, schoen(x^.y[i]-x^.y[j],0))
                       else writeln(CEOS_1st, #9, '-1');
                j:=i;
                end;
            merk1st:=spec[S_actual]^.y;  { notice first derivative spectrum }
            end;
        if (not flag_dL) and (not flag_2nd_dl) and(not flag_ytxt) then begin
            fill_histogram(his_1st^.y);  { calculate histogram of 1st derivative }
            his_1st^.sim:=TRUE;
            end;

        if flag_2nd_dl and (not flag_dL) then begin  { Calculate second derivative }
            j:=0;
            spec[S_actual].y[1]:=merk1st[3]+merk1st[2]-merk1st[2]-merk1st[1];
            spec[S_actual].y[2]:=spec[S_actual].y[1];
            for i:=3 to Channel_number-1 do begin
                spec[S_actual].y[i]:=merk1st[i]+merk1st[i+1]-merk1st[i-1]-merk1st[i-2];
                // cube_fitpar[6] = abs(2nd derivative of Rrs)
                if (S_actual<=Par3_N) and not flag_iter_3p then
                    cube_fitpar[i-1,S_actual-1,6]:=abs(spec[S_actual]^.y[i]);
                if (sign(spec[S_actual].y[i])<>sign(spec[S_actual].y[i-1])) then begin
                    write(CEOS_2nd, schoen(x^.y[i],0), #9, schoen(merkS[i], 3), #9, schoen(p,3));
                    if j>0 then writeln(CEOS_2nd, #9, schoen(x^.y[i]-x^.y[j],0))
                       else writeln(CEOS_2nd, #9, '-1');
                    // cube_fitpar[9] = zeros of 2nd derivative of Rrs
                    if (S_actual<=Par3_N) and not flag_iter_3p then
                        cube_fitpar[i,S_actual-1,9]:=1;
                    j:=i;
                    end;
                end;

            if (S_actual=1) and flag_ytxt then begin
                YText:=YText + ', 2nd derivative for lambda';
                if flag_dnorm then YText:=YText + ' normalized';
                end;
            end
            else if (S_actual=1) and flag_ytxt and (not flag_dL) then begin
                YText:=YText + ', 1st derivative for lambda';
                if flag_dnorm then YText:=YText + ' normalized';
                end
            else if (S_actual=1) and flag_ytxt and flag_dL then
                YText:=YText + ', spectral resolution [nm]';

            if not flag_dL then begin
                fill_histogram(his_2nd^.y);  { calculate histogram of 2nd derivative }
                his_2nd^.sim:=TRUE;
                end;
            end;

        if (S_actual<=Par3_N) and (not flag_dL) then begin
            merkS:=spec[S_actual]^.y;
            norm_mx(spec[S_actual]^.y,400,800);  // normalize derivative
            if not flag_iter_3p then begin
                if flag_2nd_dl then for i:=1 to Channel_Number do
                // cube_fitpar[7] = abs(2nd derivative of Rrs normalized)
                cube_fitpar[i-1,S_actual-1,7]:=abs(spec[S_actual]^.y[i])
            else for i:=1 to Channel_Number do
               // cube_fitpar[5] = abs(1st derivative of Rrs normalized)
                cube_fitpar[i-1,S_actual-1,5]:=abs(spec[S_actual]^.y[i]);
            end;
            spec[S_actual]^.y:=merkS;
            end;
    end;

procedure Rrs_N(flag_ytxt:boolean);
{ Normalize spectrum Rrs }
var  i  : integer;
begin
    if flag_drel and (S_actual<=Par3_N) then begin
        norm_mx(spec[S_actual]^.y,Norm_min,Norm_max);
        // cube_fitpar[1] = Rrs normalized
        if not flag_iter_3p then for i:=1 to Channel_Number do
            cube_fitpar[i-1,S_actual-1,1]:=spec[S_actual]^.y[i];
        if (S_actual=1) and flag_ytxt then YText:=YText + ', normalized';
        end;
    end;

procedure dRrs_par(N: integer; p, dp:double; flag_ytxt: boolean);
{ Calculate difference of actual r_rs spectrum when parameter 'p' is
  increased by dp.
  N = number of spectrum in a series; required for changing YText. }
var  i      : integer;
     nenner : double;
     SNR    : double;
     sp     : string;
begin
    if flag_1st_dp then begin      { first derivative }
        determine_concentration_fw((1+dp)*p); { increase p by dp }
        calc_r_rs;
        for i:=1 to Channel_Number do begin  // calculate dRrs for each wavelength
            dnew[i]:=r_rs^.y[i];
            dold[i]:=spec[S_actual]^.y[i];
            // cube_fitpar[0] = Rrs
            if not flag_iter_3p then cube_fitpar[i-1,S_actual-1,0]:=dold[i];
            if flag_drel then nenner:=spec[S_actual]^.y[i]
                         else nenner:=1;
            if abs(nenner)>nenner_min then
                spec[S_actual]^.y[i]:=(dnew[i]-dold[i])/nenner
                else spec[S_actual]^.y[i]:=0;
            merkdRrs:=spec[S_actual]^.y;  { notice spectrum spec[S_actual] }
            // cube_fitpar[2] = abs(delta_Rrs)
            if not flag_iter_3p then cube_fitpar[i-1,S_actual-1,2]:=abs(spec[S_actual]^.y[i]);
            end;
        if flag_dnorm then begin  // normalize dRrs and write wavelength of maximum to file
            normalize(spec[S_actual]^.y,Norm_min,Norm_max);
           // cube_fitpar[3] = abs(delta_Rrs) normalized
            if not flag_iter_3p then for i:=1 to Channel_Number do
                cube_fitpar[i-1,S_actual-1,3]:=abs(spec[S_actual]^.y[i]);
            p3max[3]:=p;
            if not flag_ytxt then begin
                for i:=1 to 3 do write(CEOS_maxima, schoen(p3max[i],3), #9);
                if flag_iter_3p then write(CEOS_maxima, schoen(c1,3), #9, schoen(c2,3), #9);
                if (abs(p3max[i])>thresh_dRrs) and (abs(p3max[i])>nenner_min)
                    then SNR:=abs(r_rs^.y[chMax]/p3max[2])
                    else SNR:=0;
                writeln(CEOS_maxima, schoen(SNR,3));
                end;
            end;
        if (abs(N)<nenner_min) and flag_ytxt then begin
            sp:=schoen(100*dp,0);
            if flag_drel then YText:=YText + ', relative difference for '+par.name[Par3_type]
                         else YText:=YText + ', difference for '+sp+'% increase of '+par.name[Par3_type];
            Stest^.ParText:=YText + ', maxima';
            Stest^.sim:=TRUE;
            if flag_dnorm then YText:=YText + ' normalized';
            end;
        end;
    end;

procedure set_CEOS_settings(setting: integer);
begin
    thresh_below:=0;
    set_zero(his_1st^);
    set_zero(his_2nd^);
    his_1st^.ParText:='Zeros of 1st derivatives of Rrs';
    his_2nd^.ParText:='Zeros of 2nd derivatives of Rrs';
    if Par3_Log then FW_TABLE:='log' else FW_TABLE:='lin';
    CEOS_par:=scenario+'_'+par.name[Par3_Type]+'_'+IntToStr(Par3_N)+FW_TABLE+'_'+
        schoen(Par3_Min,3)+'-'+schoen(Par3_Max,4);
    FW_TABLE:=CEOS_par;
    CHANGES:=CEOS_par+'.par';
    CEOS_ku:=Nachbar(Norm_min);
    CEOS_ko:=Nachbar(Norm_max);
    if not flag_iter_3p then begin
        set_band_black(8);
        set_band_black(9);
        set_band_black(11);
        end;
    case setting of
    1: begin { calculate normalized Rrs }
           flag_1st_dp :=FALSE;
           flag_drel   :=TRUE;
           flag_dnorm  :=TRUE;
           flag_1st_dl :=FALSE;
           flag_2nd_dl :=FALSE;
           flag_dL     :=FALSE;
           CEOS_spc:='Rrs_N';
           FW_TABLE:=CEOS_par+'_'+CEOS_spc;
           Output_HSI:=DIR_saveFwd + '\'+CEOS_par+'_'+CEOS_spc+'.fit';
           end;
    2: begin { calculate Rrs }
           flag_1st_dp :=FALSE;
           flag_drel   :=FALSE;
           flag_dnorm  :=FALSE;
           flag_1st_dl :=FALSE;
           flag_2nd_dl :=FALSE;
           flag_dL     :=FALSE;
           CEOS_spc:='Rrs';
           FW_TABLE:=CEOS_par+'_'+CEOS_spc;
           end;
    3: begin { calculate delta_Rrs }
           flag_1st_dp :=TRUE;
           flag_drel   :=FALSE;
           flag_dnorm  :=FALSE;
           flag_1st_dl :=FALSE;
           flag_2nd_dl :=FALSE;
           flag_dL     :=FALSE;
           CEOS_spc:='dRrs';
           FW_TABLE:=CEOS_par+'_'+CEOS_spc;
           assignFile(CEOS_maxima, DIR_saveFwd + '\' + FW_TABLE + '.max');
           rewrite(CEOS_maxima);
           writeln(CEOS_maxima, 'Maxima of spectra delta_Rrs');
           writeln(CEOS_maxima);
           writeln(CEOS_maxima, 'This file was generated by the program WASI');
           writeln(CEOS_maxima, vers);
           writeln(CEOS_maxima);
           write(CEOS_maxima, 'Lambda', #9, '|dRrs|', #9, par.name[Par3_Type]);
           if flag_iter_3p then
               write(CEOS_maxima, #9, par.name[Par1_Type], #9, par.name[Par2_Type])
               else write(CEOS_maxima);
           writeln(CEOS_maxima, #9, 'SNR');
           end;
    4: begin { calculate normalized delta_Rrs }
           flag_1st_dp :=TRUE;
           flag_drel   :=FALSE;
           flag_dnorm  :=TRUE;
           flag_1st_dl :=FALSE;
           flag_2nd_dl :=FALSE;
           flag_dL     :=FALSE;
           CEOS_spc:='dRrs_N';
           FW_TABLE:=CEOS_par+'_'+CEOS_spc;
           end;
    5: begin { calculate d(Rrs)/d(Lambda) }
           flag_1st_dp :=FALSE;
           flag_drel   :=FALSE;
           flag_dnorm  :=FALSE;
           flag_1st_dl :=TRUE;
           flag_2nd_dl :=FALSE;
           flag_dL     :=FALSE;
           CEOS_spc:='dRrs_dLambda';
           FW_TABLE:=CEOS_par+'_'+CEOS_spc;
           assignFile(CEOS_1st, DIR_saveFwd + '\' + FW_TABLE + '.1st');
           rewrite(CEOS_1st);
           writeln(CEOS_1st, 'Zeros of 1st derivatives of Rrs');
           writeln(CEOS_1st);
           writeln(CEOS_1st, 'This file was generated by the program WASI');
           writeln(CEOS_1st, vers);
           writeln(CEOS_1st);
           writeln(CEOS_1st, 'Lambda', #9, 'Rrs', #9, par.name[Par3_Type], #9,
               'dLambda');
           end;

    6: begin { calculate NEdL and dL }
           flag_1st_dp :=FALSE;
           flag_drel   :=FALSE;
           flag_dnorm  :=FALSE;
           flag_1st_dl :=TRUE;
           flag_2nd_dl :=FALSE;
           flag_dL     :=TRUE;
           open_file_dL;
           end;

    7: begin { calculate d^2(Rrs)/d(Lambda)^2 }
           flag_1st_dp :=FALSE;
           flag_drel   :=FALSE;
           flag_dnorm  :=FALSE;
           flag_1st_dl :=TRUE;
           flag_2nd_dl :=TRUE;
           flag_dL     :=FALSE;
           CEOS_spc:='d2Rrs_dLambda2';
           FW_TABLE:=CEOS_par+'_'+CEOS_spc;
           assignFile(CEOS_2nd, DIR_saveFwd + '\' + FW_TABLE + '.2nd');
           rewrite(CEOS_2nd);
           writeln(CEOS_2nd, 'Zeros of 2nd derivatives of Rrs');
           writeln(CEOS_2nd);
           writeln(CEOS_2nd, 'This file was generated by the program WASI');
           writeln(CEOS_2nd, vers);
           writeln(CEOS_2nd);
           writeln(CEOS_2nd, 'Lambda', #9, 'Rrs', #9, par.name[Par3_Type], #9,
               'dLambda');
           end;
        end;
    end;


procedure CEOS_Median_max(Sender: TObject);
{ Calculate median spectrum of files *.max.
  Before running this module, open an image in that directory in order to
  initialize some image parameters.
  Version from 7 December 2019 }
const Fmax_Header    = 6;           // Header lines of files *.max
      Fmax_lines     = 1000;        // Number of lines with data of files *.max
      Fmax_bands     = 401;         // Number of bands on x-axis of files *.max
      Fmax_Lmin      = 400;         // First wavelength of files *.max
var   FileAttrs      : Integer;
      sr             : TSearchRec;
      Pfad           : string;
      Name_LoadBatch : string;
      z              : integer;
      c              : integer;
      lambda         : integer;
      dRrs           : double;
      datei          : text;
      N_Files        : integer;
      dummy          : double;

begin
   TimeStartCalc:=Now;
   Pfad:=ExtractFilePath(HSI_img^.FName);
   Name_LoadBatch:=Pfad + '*.max';
   FileAttrs := faAnyFile;
   N_Files:=CountFilesInFolder('*.max', Pfad);
   if N_Files>1 then begin
        if FindFirst(Name_LoadBatch, FileAttrs, sr) = 0 then begin
            SetLength(cube_fitpar, Fmax_bands, Fmax_lines, 1);
            Channels_out:=1;
            Width_in:=Fmax_bands;
            Height_in:=Fmax_lines;
            Np_water:=Width_in*Height_in;
            Np_masked:=0;
            bandname[1]:='|dRrs|';
            REPEAT
                actualFile:=Pfad+sr.Name;
                Output_HSI:=ChangeFileExt(actualFile, '_max.fit');
                HSI_img^.FName:=Output_HSI;
                {$i-}
                AssignFile(datei, actualFile);
                reset(datei);
                {$i+}
                for z:=1 to Fmax_Header do readln(datei);
                for z:=1 to Fmax_lines do begin
                    for c:=1 to Fmax_bands do cube_fitpar[c-1,z-1,0]:=0;
                    readln(datei, Lambda, dummy, dummy, dummy, dummy, dRrs);
                    if (Lambda-Fmax_Lmin>0) and (Lambda-Fmax_Lmin+1<=Fmax_bands) then
                        cube_fitpar[Lambda-Fmax_Lmin,z-1,0]:=dRrs;
                    end;
                CloseFile(datei);
                TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
                Format_2D.Write_Fitresult(Fmax_lines-1);
                Format_2D.Write_Envi_Header_fit(Output_HSI);
            UNTIL (FindNext(sr)<>0);
            FindClose(sr);
            median_band:=1;
            band_thresh:=1;
            median_xmin:=Fmax_Lmin;
            median_dx:=1;
            Median_images(Sender);
            DeleteAll(Pfad, '*_max.fit');
            DeleteAll(Pfad, '*_max.hdr');
            end;
         end
         else ShowMessage('ERROR: Less than 2 images in directory '+Pfad);
    end;



end.

