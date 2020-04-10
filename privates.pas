unit privates;

{$MODE Delphi}

{ Version vom 10.4.2020 }

interface
uses defaults, Classes, Graphics, ExtCtrls, Forms;

type  EEMatrix        = record                          { Fluorescence excitation-emission-matrix }
          ex          : spektrum;                       { Excitation: center wavelengths }
          ex_line     : integer;                        { Excitation: line of center wavelengths }
          ex_FWHM     : double;                         { Excitation: FWHM }
          em          : spektrum;                       { Emission:   center wavelengths }
          em_col      : integer;                        { Emission:   column of center wavelengths }
          em_FWHM     : double;                         { Emission:   FWHM }
          Fname       : string;                         { EEM: file name }
          N_ex        : integer;                        { EEM: number of excitation wavelengths }
          N_em        : integer;                        { EEM: number of emission wavelengths }
          header_l    : integer;                        { EEM: header lines }
          header_c    : integer;                        { EEM: header columns }
          EEM         : frame_single;                   { EEM: data }
          end;

{ **************************************************************************** }
{ ***********             Settings of PRIVATE.INI                  *********** }
{ **************************************************************************** }

var     { Spectra read from file }
        tA            : ^Attr_spec;                     { Transmission of atmosphere }
        tC            : ^Attr_spec;                     { Transmission of clouds }
        Lpath         :  Attr_spec;                     { Path radiance }
        resp          :  Attr_spec;                     { Radiometric response }
        u_c           : ^Attr_spec;                     { Uncertainty of radiometric calibration }
        u_t           : ^Attr_spec;                     { Uncertainty of atmosphere transmission }
        u_p           : ^Attr_spec;                     { Uncertainty of path radiance }
        u_n           : ^Attr_spec;                     { Uncertainty by statistical noise }
        aphA          : ^Attr_spec;                     { Coefficient A of a*_ph }
        aphB          : ^Attr_spec;                     { Coefficient B of a*_ph }
        CMF_r         : ^Attr_spec;                     { Color Matching Function for long-wavelength radiation }
        CMF_g         : ^Attr_spec;                     { Color Matching Function for mid-wavelength radiation }
        CMF_b         : ^Attr_spec;                     { Color Matching Function for short-wavelength radiation }
        s_locus       : ^Attr_spec;                     { Spectral locus of chromaticity diagram }
        EEM_ph        : EEMatrix;                       { EEM of phytoplankton }
        EEM_DOM       : EEMatrix;                       { EEM of dissolved organic matter }

const   Val_dotsize   : word = 3;                       { Validation: size of plotted dots }
        clMinidots    : TColor = $00000000;             { Validation: color of minidots }
        HM_dim        : word = 400;                     { Heatmap: array dimension }
        HM_min        : double = 0;                     { Heatmap: minimum value }
        HM_max        : double = 10;                    { Heatmap: maximum value }
        Norm_min      : single = 400.0;                 { Normalisation: lower boundary }
        Norm_max      : single = 800.0;                 { Normalisation: upper boundary }
        flag_Rbottom  : boolean = FALSE;                { Determine bottom reflectance? }
        flag_2D_ASCII : boolean = FALSE;                { Save 2D fitresults as ASCII file }
        flag_aph_C    : boolean = TRUE;                 { a*_ph depends on concentration C[0] }
        flag_1st_dl   : boolean = TRUE;                 { Calculate first derivative with respect to wavelength }
        flag_2nd_dl   : boolean = TRUE;                 { Calculate second derivative with respect to wavelength }
        flag_1st_dp   : boolean = TRUE;                 { Calculate first derivative with respect to parameter }
        flag_drel     : boolean = FALSE;                { Calculate derivative relative to mean }
        flag_dnorm    : boolean = TRUE;                 { Normalize derivative }
        flag_dL       : boolean = FALSE;                { Calculate spectral resolution }
        flag_minidot  : boolean = TRUE;                 { Validation: mark reference pixels }
        flag_cut_ROI  : boolean = TRUE;                 { Cut fit image to ROI coordinates }
        flag_Martina  : boolean = FALSE;                { Program settings specifically for Martina Wenzl }
        flag_sim_NEL  : boolean = FALSE;                { Simulate sensor noise }
        test_spec     : byte = 1;                       { Internal spectrum used as "test" in forward mode }
        dz_Ed         : double = 0;                     { Distance between z sensor and Ed sensor }
        dz_Eu         : double = 0;                     { Distance between z sensor and Eu sensor }
        dz_Lu         : double = 0.265;                 { Distance between z sensor and Lu sensor }
        error_x       : double = 0;                     { Wavelength error of measurement [nm]}
        error_dx      : double = 0;                     { Wavelength increment error of measurement [nm / channel]}
        thresh_dRrs   : double = 1E-6;                  { Threshold of band 'band_thresh' }
        median_band   : integer = 11;                   { Band for which median is calculated }
        band_thresh   : integer = 3;                    { Band with threshold for |dRrs| }
        median_xmin   : integer = 380;                  { x-values of the median images }
        median_dx     : integer = 1;                    { x-differences of the median images }
        band_N        : integer = 12;                   { Band with number of spectra }

var     { Fitparameters }
        alpha_r       : Fitparameters;                  { reflection factor  }
        beta_r        : Fitparameters;                  { reflection factor  }
        gamma_r       : Fitparameters;                  { reflection factor  }
        delta_r       : Fitparameters;                  { reflection factor Clouds }
        alpha_d       : Fitparameters;                  { weight factor Sun }
        beta_d        : Fitparameters;                  { weight factor Sky }
        gamma_d       : Fitparameters;                  { weight factor Dust }
        delta_d       : Fitparameters;                  { weight factor Clouds }
        test          : Fitparameters;                  { test parameter }


{ **************************************************************************** }
{ ***********             Program internal settings                *********** }
{ **************************************************************************** }

const   Dim_regr      : integer = 100;                  { Dimension of regression matrix }
        NVal          = 10000;                          { Max. validation data points }
        NIter_min     : integer = 6;                    { Min. number of iterations }
        ch_Int_min    : integer = 1;                    { Integration: lower boundary }
        ch_Int_max    : integer = MaxChannels;          { Integration: upper boundary }
        flag_progress : boolean = TRUE;                 { write processing progress to file }
        flag_Ed_Gege  : boolean = TRUE;                 { use Ed model of Gege? }
        flag_trenn_Ed : boolean = FALSE;                { separate Edd and Eds? funktioniert nicht gut }
        flag_Kd_PAR   : boolean = FALSE;                { Save Kd_PAR? }
        flag_Secchi   : boolean = FALSE;                { Save Secchi disk depth? }
        flag_fw_intern: boolean = FALSE;                { Save internal spectra? }
        flag_truecolor_2D   : boolean = false;          { Calculate truecolor for images }
        flag_CIE_label      : boolean = TRUE;           { Label CIE chromaticity diagram }
        flag_CIE_dots_black : boolean = TRUE;           { Use black dots for single colors in CIE diagram }
        flag_CIE_calc_locus : boolean = FALSE;          { Calculate spectral locus curve of CIE diagram }
        SDD           : double = -1;                    { Secchi disk depth }
        Int_min       : double = 400;                   { Integration of Ed model Gege: lower boundary }
        Int_max       : double = 800;                   { Integration of Ed model Gege: upper boundary }
        f_EO          : double = 1.30;                  { Conversion factor from Ed to E0d }
        E_min         : double = 11.32314;
        E_max         : double = 11.32648;
        N_min         : double = 47.82521;
        N_max         : double = 47.82665;
        r_theta_fw    : double = 1.0;                   { Ratio of cosines of sun zenith angles, forward mode }
        r_theta_inv   : double = 1.0;                   { Ratio of cosines of sun zenith angles, inverse mode }
        quantile      : double = 0.90;                  { Quantile for averaging images; 0.5 = median }
        flag_show_EEM : boolean = FALSE;                { Displayed image is EEM }
        refl_IR       : double = 0.0;                   { Reflectance in the infrared }
        Sensor_max    = 50;                             { Maximum number of sensors }
        Sensor_N      : integer = 5;                    { Number of sensors }
        Sensor_act    : integer = 0;                    { Actually selected sensor }
        Sensor_list   = 'sensors.txt';                  { File name of sensor list }

var     Sensor_name   : array[0..Sensor_max] of string; { Names of sensors }
        Sensor_file   : array[0..Sensor_max] of string; { Names of sensor files }
        Sensor_head   : array[0..Sensor_max] of word;   { Header lines of sensor file }
        Sensor_band   : array[0..Sensor_max] of word;   { Column of band names }
        Sensor_center : array[0..Sensor_max] of word;   { Column of center wavelengths }
        Sensor_fwhm   : array[0..Sensor_max] of word;   { Column of FWHM's }
        Sensor_NEL    : array[0..Sensor_max] of word;   { Column of NEL's }

type    CalVal_data   = record
            FName     : String;                         { File name }
            Header    : integer;                        { Header lines }
            XColumn   : byte;                           { Column with x-values }
            YColumn   : byte;                           { Column with y-values }
            N         : integer;                        { Number of data points }
            map_E     : array[1..NVal]of double;        { Geographical coordinate East }
            map_N     : array[1..NVal]of double;        { Geographical coordinate North }
            map_p     : array[1..NVal]of double;        { Parameter value }
            end;

var     { Parameters used during program operation }
        sum1          : double;                         { = alpha_d + beta_d + gamma_d + delta_d }
        ValSet        : CalVal_data;                    { Validation data set }
        HM            : CalVal_data;                    { Heatmap data set }
        Regr_Matrix   : array of frame_int16;           { Regression matrix of 3 preview channels }
        bg            : integer;                        { Difference between bands blue and green }
        br            : integer;                        { Difference between bands blue and red }
        peaks         : spektrum;                       { maximum / minimum of spectrum }

        { Spectra calculated during run-time }
        Mie           : ^Attr_spec;                     { Aerosol (Mie) scattering }
        Rayleigh      : ^Attr_spec;                     { Molecule (Rayleigh) scattering }
        tEd           : ^Attr_spec;                     { Transmission of Ed }
        dold, dnew    : spektrum;
        L_TOA         : Attr_spec;                      { Upwelling radiance top of atmosphere }
        signal        : Attr_spec;                      { Simulated sensor signal }
        SNR_TOA       : Attr_spec;                      { SNR at top of atmosphere }
        SNR_BOA       : Attr_spec;                      { SNR at bottom of atmosphere }
        NEL           : Attr_spec;                      { Noise-equivalent radiance }
        BOA_TOA       : Attr_spec;                      { Transmitted BOA radiance relative to TOA radiance }


{ **************************************************************************** }
{ ***********             Procedures and Functions                 *********** }
{ **************************************************************************** }

procedure calc_Ed_Gege;
procedure mittle_Fitparameter(pfad:String);
procedure calc_var_Ed;
procedure calc_Lsky_Ed;
function  kurve_var_Ed(k:integer):double;
procedure perform_fit_Ed_Gege(Sender:TObject);
function  kurve_Ed_above_Gege(k:integer):double;
function  kurve_Ed_below_Gege(k:integer):double;
function  kurve_Rrs_waterlayer(k:integer):double;
function  kurve_R_waterlayer(k:integer):double;
function  kurve_Lsky_Ed(k:integer):double;
procedure perform_fit_waterlayer(Sender:TObject);
procedure perform_fit_Lsky_Ed(Sender:TObject);
procedure calculate_Kd_rd;
procedure regression_3bands;
procedure calc_std_Rrs;
procedure simulate_weight(s1,s2:byte; P1,P2:double);
procedure read_CalVal(del_outliers: boolean);
procedure read_XYdata;
procedure create_heatmap;
procedure calculate_statistics(zmin, zmax, dz, outlier: double);
procedure estimate_bottom_reflectance(index:byte);
procedure Average_spectra(relative:boolean);
procedure Average_image_lines(name: string);
procedure Quantile_images(q: double; Sender: TObject);
function  import_ASCII_EEM(var E: EEMatrix):boolean;
procedure EEM_to_image(var E: EEMatrix);
procedure simulate_sensor_signal(t:double);
procedure calc_DESIS;
procedure Correct_HSI(Sender: TObject);
procedure read_sensor_names;
procedure set_sensor;


implementation

uses fw_calc, invers, misc, Popup_2D_Format,Popup_2D_Info, SCHOEN_, gui, CEOS,
     math, SysUtils, dialogs, DateUtils;


{ ************************************************************************** }
{ ********             Procedures for forward modeling              ******** }
{ ************************************************************************** }


{ Downwelling irradiance; model of Gege }

procedure calc_tEd_Gege;
{ Atmospheric transmission for Ed }
var k : integer;
begin
    for k:=1 to Channel_number do
        tEd^.y[k]:= alpha_d.fw * tA^.y[k]  + beta_d.fw * Rayleigh^.y[k] +
                  gamma_d.fw * Mie^.y[k] + delta_d.fw * tC^.y[k];
    end;

procedure calc_Ed_plus_Gege;
{ Downwelling irradiance Ed in air }
var k : integer;
begin
    if ((spec_type=S_Ed_Gege) and flag_above) or not flag_use_Ed then begin
        calc_tEd_Gege;
        for k:=1 to Channel_number do Ed^.y[k]:= tEd^.y[k]*E0^.y[k]*sun_earth;
        Ed^.sim:=TRUE;
        end;
    { otherwise measured Ed spectrum is taken }
    end;

procedure calc_Ed_minus_Gege;
{ Downwelling irradiance Ed in water }
var k        : integer;
    nenner   : double;
    exponent : double;
begin
    if not flag_use_Ed then calc_Ed_plus_Gege;
    if not flag_use_R  then calc_R;
    calc_Kd;
    for k:=1 to Channel_number do begin
        nenner:=1-rho_Eu*R^.y[k];
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        Ed^.y[k]:= (1-rho_Ed) * Ed^.y[k] / nenner ;
        exponent:=-Kd^.y[k]*(zB.fw-z.fw);
        if exponent<exp_min then exponent:=exp_min;
        Ed^.y[k]:= Ed^.y[k] * exp(exponent);
        end;
    end;

procedure calc_Ed_Gege;
{ Downwelling irradiance }
begin
    if flag_above then calc_Ed_plus_Gege else calc_Ed_minus_Gege;
    end;

procedure calc_Ls_Gege;
{ Sky radiance reflected at the surface; Model of Gege }
var k      : integer;
begin
    if not flag_use_Ls then for k:=1 to Channel_number do
        Ls^.y[k]:= E0^.y[k]*(alpha_r.fw * tA^.y[k]  + beta_r.fw * Rayleigh^.y[k] +
                             gamma_r.fw * Mie^.y[k] + delta_r.fw * tC^.y[k]);
    { otherwise measured spectrum Ls is taken }
    end;

procedure mittle_Fitparameter(pfad:String);
const Fmax     = 20;        { max. number of fitparameters }
      Mmax     = 60;        { max. number of spectra per measurement }
      zmax     = 10000;     { max. number of rows of input file }
      noblank_filex       = 'FITPARS_no_blanks.TXT';
      File_mean_fitpar    = 'FITPARS_avg.txt';       { file with averages }
      File_single_fitpar  = 'FITPARS_single.txt';    { file with single values }
      header_Fitp = 10;
      mean_min = 0.001;
type param     = array[1..Mmax]of double;
var datei_in   : text;
    datei_avg  : text;
    datei_single : text;
    i          : longInt;
    p, delta   : array[1..FMax]of param;
    mean       : param;
    sig        : param;
    var_r      : param;
    m          : array[1..MMax]of String[255];  { measurement file name }
    mm         : String[255];
    dum1, dum2 : longInt;
    z, zz, s   : longInt;
    ch         : char;
    columns    : integer;
    st         : string;
    nenner     : double;
begin
    blanks_to_tab(pfad+FITPARS, pfad+noblank_filex, header_Fitp);
    assign(datei_in, pfad+noblank_filex);
    {$i-} reset(datei_in);
    if ioresult=0 then begin
        { Ermittle Zahl der Spalten }
        for i:=1 to header_Fitp do readln(datei_in);
        readln(datei_in, st);
        columns:=0;
        for i:=1 to length(st) do if st[i]=#9 then inc(columns);
        columns:=columns-3;
        if columns>FMax then columns:=FMax;
        close(datei_in);

        assign(datei_avg, pfad+File_mean_fitpar);
        rewrite(datei_avg);
        writeln(datei_avg, 'This file was generated by the program WASI');
        writeln(datei_avg, vers);
        writeln(datei_avg, 'Parameter values in files: ', INI_public, ', ', CHANGES);
        writeln(datei_avg);
        write(datei_avg, 'File', #9, 'N', #9);
        for i:=1 to columns do write(datei_avg, 'mean[', i, ']', #9, 'SD[', i, ']', #9);
        writeln(datei_avg);

        assign(datei_single, pfad+File_single_fitpar);
        rewrite(datei_single);
        writeln(datei_single, 'This file was generated by the program WASI');
        writeln(datei_single, vers);
        writeln(datei_single, 'Parameter values in files: ', INI_public, ', ', CHANGES);
        writeln(datei_single);
        write(datei_single, 'File', #9, 'col', #9);
        for i:=1 to columns do write(datei_single, 'par[', i, ']', #9,
                               'mean[', i, ']', #9, 'delta[', i, ']', #9);
        writeln(datei_single);

        reset(datei_in);
        for i:=1 to header_Fitp do readln(datei_in);
        z:=1;
        zz:=1;

        repeat
            { Read file name m[zz] of measurement }
            m[zz]:='';
            s:=1;
            repeat
                read(datei_in, ch);
                if ch<>#9 then m[zz]:=m[zz]+ch;
                inc(s);
            until (ch=#9) or (s>255);
            if z=1 then mm:=m[zz]; { File name of first measurement }

            { Read fit parameter of measurement }
            read(datei_in, dum1, dum2);
            for s:=1 to columns do read(datei_in, p[s, zz]);
            readln(datei_in);
            if (m[zz]<>mm) or eof(datei_in) then begin
                for s:=1 to columns do begin
                    mean[s]:=0;
                    sig[s]:=0;
                    var_r[s]:=0;
                    delta[s, zz]:=0;
                    end;
                for s:=1 to columns do begin
                    if zz>1 then begin
                        for i:=1 to zz-1 do mean[s]:=mean[s]+p[s,i]/(zz-1);
                        if zz>2 then for i:=1 to zz-1 do begin
                            delta[s,i]:=p[s,i]-mean[s];
                            sig[s]:=sig[s]+sqr(p[s,i]-mean[s])/(zz-2);
                            nenner:=mean[s];
                            if abs(nenner)<mean_min then nenner:=mean_min;
                            var_r[s]:=var_r[s]+sqr(p[s,i]/nenner-1)/(zz-2);
                            { Note: variance was used for the paper Gege and Pinnel (2011).
                              It has been deleted as output parameter on 22.1.2014. }
                            end;
                        end;
                    end;
                for i:=1 to zz-1 do begin
                    write(datei_single, mm, #9, i, #9);
                    for s:=1 to columns do begin
                        write(datei_single, schoen(p[s,i],3), #9,
                            schoen(mean[s],3), #9, schoen(delta[s,i],3), #9);
                        p[s,1]:=p[s,zz];
                        end;
                    writeln(datei_single);
                    end;
                write(datei_avg, mm, #9, zz-1, #9);
                mm:=m[zz];
                m[1]:=m[zz];
                for s:=1 to columns do
                    write(datei_avg, schoen(mean[s],3), #9, schoen(sqrt(sig[s]),3), #9);
                writeln(datei_avg);
                zz:=1;
                end;

            inc(z);
            inc(zz);
        until eof(datei_in) or (z>zmax) or (zz>Mmax);
        close(datei_in);
        close(datei_avg);
        close(datei_single);
        end;
    end;

procedure calc_var_Ed_second_order;
{ Variance of relative Ed spectra. }
{ alpha_d = var[delta_fdd/fdd]
  beta_d  = var[delta_fds/fds]
  gamma_d = var[z]
  delta_d = var[theta_s] }
var k          : integer;
    qs, qv     : double;
    dEd_dz,
    dEd_dfdd,
    dEd_dfds,
    dEd_dthetaS : double;
    d2_dz_dfdd,
    d2_dz_dfds,
    d2_dz_dthetaS,
    d2_dz_dz,
    d2_dfdd_dthetaS,
    d2_dfdd_dz,
    d2_dfds_dz,
    d2_dthetaS_dfdd,
    d2_dthetaS_dthetaS,
    d2_dthetaS_dz    : double;
begin
    qs:=arcsin(sin(sun.fw*pi/180)/nW);  { sun zenith angle in water }
    qv:=view.fw*pi/180;                 { viewing angle }

    for k:=1 to Channel_number do begin
        { first derivates of Ed }
        dEd_dz:=-f_dd.fw*Kdd^.y[k]/cos(qs)*GC_Edd^.y[k]-f_ds.fw*Kds^.y[k]*GC_Eds^.y[k];
        dEd_dfdd:=GC_Edd^.y[k];
        dEd_dfds:=GC_Eds^.y[k];
        dEd_dthetaS:=-f_dd.fw*tan(qs+qv)*GC_Edd^.y[k];

        { combined uncertainty: eq. (10) of GUM }
        STest^.y[k]:=sqr(dEd_dz)*gamma_d.fw + sqr(dEd_dfdd)*alpha_d.fw +
                     sqr(dEd_dfds)*beta_d.fw + sqr(dEd_dthetaS)*delta_d.fw;

        { second derivatives of Ed }
        d2_dz_dfdd:=-Kdd^.y[k]/cos(qs)*GC_Edd^.y[k];
        d2_dz_dfds:=-Kds^.y[k]*GC_Eds^.y[k];
        d2_dz_dthetaS:=sqr(f_dd.fw)*Kdd^.y[k]*tan(qs+qv)/cos(qs)*GC_Edd^.y[k];
        d2_dz_dz:=f_dd.fw*sqr(Kdd^.y[k]/cos(qs))*GC_Edd^.y[k] +
                  f_ds.fw*sqr(Kdd^.y[k])*GC_Eds^.y[k];
        d2_dfdd_dthetaS:=-f_dd.fw*tan(qs+qv)*GC_Edd^.y[k];
        d2_dfdd_dz:=-Kdd^.y[k]/cos(qs)*GC_Edd^.y[k];
        d2_dfds_dz:=-Kds^.y[k]*GC_Eds^.y[k];
        d2_dthetaS_dfdd:=-tan(qs+qv)*GC_Edd^.y[k];
        d2_dthetaS_dthetaS:=-f_dd.fw/sqr(cos(qs+qv))*GC_Edd^.y[k];
        d2_dthetaS_dz:=f_dd.fw*tan(qs+qv)*Kdd^.y[k]/cos(qs)*GC_Edd^.y[k];

        { combined uncertainty: NOTE after eq. (10) of GUM }
        STest^.y[k]:=STest^.y[k] +
                     0.5*sqr(d2_dz_dfdd)*gamma_d.fw*alpha_d.fw +
                     0.5*sqr(d2_dz_dfds)*gamma_d.fw*beta_d.fw +
                     0.5*sqr(d2_dz_dthetaS)*gamma_d.fw*delta_d.fw +
                     sqr(d2_dz_dz)*gamma_d.fw*gamma_d.fw +
                     0.5*sqr(d2_dfdd_dthetaS)*alpha_d.fw*delta_d.fw +
                     0.5*sqr(d2_dfdd_dz)*alpha_d.fw*gamma_d.fw +
                     0.5*sqr(d2_dfds_dz)*beta_d.fw*gamma_d.fw +
                     0.5*sqr(d2_dthetaS_dfdd)*delta_d.fw*alpha_d.fw +
                     sqr(d2_dthetaS_dthetaS)*delta_d.fw*delta_d.fw +
                     0.5*sqr(d2_dthetaS_dz)*delta_d.fw*gamma_d.fw;

        STest^.y[k]:=STest^.y[k]/sqr(Ed^.y[k]);
        end;
    end;

procedure calc_var_Ed;
{ Variance of relative Ed spectra. See eq. (11) in Gege & Pinnel (2011) }
{ alpha_d = var[delta_fdd/fdd]
  beta_d  = var[delta_fds/fds]
  gamma_d = var[z]
  delta_d = var[theta_s] }
var k          : integer;
    nenner     : double;
    qs, qv     : double;
//    ldd, lds   : double;
begin
   qs:=arcsin(sin(sun.fw*pi/180)/nW);  { sun zenith angle in water }
   qv:=view.fw*pi/180;                 { viewing angle }
//   ldd:=1;
//   lds:=lds0+lds1*(1-cos(qs));
   STest^.ParText:='var[dEd/Ed]';
   YText:=STest^.ParText;
    for k:=1 to Channel_number do begin
        nenner:=sqr(r_d^.y[k]+1);
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        STest^.y[k]:= 1/nenner*
                      ((sqr(r_d^.y[k])*(alpha_d.fw+sqr(tan(qs+qv))*delta_d.fw))+
                      sqr(Kdd^.y[k]*r_d^.y[k]+Kds^.y[k])*gamma_d.fw+
                      beta_d.fw);
        end;
    end;


procedure calc_Lsky_Ed;
{ Ratio of sky radiance to downwelling irradiance
  Eq. (10) with rho_L = 1 of Gege and Groetsch (2016), Proc. Ocean Optics XXIII }
// const r_ar     = 0.693; for Ocean Optics XXIII paper
var k          : integer;
    nenner     : double;
    Tr, Tas    : double;
begin
   STest^.ParText:='L_sky/Ed [1/sr]';
   YText:=STest^.ParText;

   calc_omega_a;   // omega_a, Single scattering albedo
   calc_Fa;        // F_a,     Aerosol forward scattering probability
   calc_M;         // GC_M,    Air mass
   calc_Tr_GC;     // Rayleigh transmission
   calc_tau_a_GC;  // Aerosol optical thickness
   calc_T_as;      // Transmission after aerosol scattering

   for k:=1 to Channel_number do begin
        Tr :=GC_T_r^.y[k];
        Tas:=GC_T_as^.y[k];
        nenner:=Tr*Tas+0.5*(1-power(Tr, 0.95))+power(Tr, 1.5)*(1-Tas)*F_a;
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        STest^.y[k]:=
            (g_dd.fw*Tr*Tas+0.5*g_dsr.fw*(1-power(Tr, 0.95))+
            g_dsa.fw*power(Tr, 1.5)*(1-Tas)*F_a)/nenner;
//             r_ar*g_dsr.fw*power(Tr, 1.5)*(1-Tas)*F_a)/nenner;
        end;
    end;


{ ************************************************************************** }
{ ********             Procedures for inverse modeling              ******** }
{ ************************************************************************** }

function kurve_var_Ed(k:integer):double;
{ Variance of downwelling irradiance according to eq. (11) in Gege and Pinnel (2011). Parameters:
  c[27] = sun
  c[28] = view
  c[41] = alpha_d = var[d_fdd/fdd]
  c[42] = beta_d  = var[d_fds/fds]
  c[43] = gamma_d = var[z]
  c[44] = delta_d = var[theta_s]  }
var rd1    : extended;
    rd_rd1 : extended;
    qs, qv : extended;
begin
with par do begin
    rd1:=sqr(1+r_d^.y[k]); if abs(rd1)<nenner_min then rd1:=nenner_min;
    rd_rd1:=sqr(r_d^.y[k])/rd1;
    qs:=arcsin(sin(c[27]*pi/180)/nW);   { sun zenith angle in water }
    qv:=c[28]*pi/180;                   { viewing angle }

    kurve_var_Ed:= rd_rd1*(c[41]+sqr(tan(qs+qv))*c[44])+
        (sqr(Kdd^.y[k]*r_d^.y[k]+Kds^.y[k])*c[43]+ c[42])/rd1;
    end;
    end;


function kurve_tEd_Gege(k:integer):double;
{ Atmospheric transmission for Ed. Parameters:
 c[19] = alpha    = Angström exponent of aerosols
 c[41] = alpha_d  = weight factor Sun
 c[42] = beta_d   = weight factor Sky
 c[43] = gamma_d  = weight factor Dust
 c[44] = delta_d  = weight factor Clouds }
var fak : double;
begin
with par do begin
    if c[19]=0 then fak:=1.0 else
        fak:=exp(-c[19]*ln(x^.y[k]/Lambda_M));
    kurve_tEd_Gege:=c[41]*tA^.y[k] + c[42]*Rayleigh^.y[k] + c[43]*fak + c[44]*tC^.y[k];
    end;
    end;


function kurve_Ed_above_Gege(k:integer):double;
{ Downwelling irradiance Ed above surface, model of Gege }
begin
    if ((spec_type=S_Ed_Gege) and flag_above) or not flag_use_Ed then
        kurve_Ed_above_Gege:=kurve_tEd_Gege(k)*E0^.y[k]*sun_earth
    else kurve_Ed_above_Gege:=Ed^.y[k]; { measurement }
    end;


function kurve_Ed_below_Gege(k:integer):double;
{ Downwelling downwelling irradiance Ed in water.
  par.c[25] = z }
var nenner   : double;
    exponent : double;
begin
    nenner:=1 - rho_Eu * kurve_R_deep(k);
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    { Added 29.6.2008: Depth dependency of Ed- }
{    if flag_public then kurve_Ed_below:=(1-sigma_Ed)*kurve_Ed_above_Gege(k)/nenner
         else begin    }
             exponent:=-kurve_Kd(k)*par.c[25];
             if exponent<exp_min then exponent:=exp_min;
             kurve_Ed_below_Gege:=(1-rho_Ed)*kurve_Ed_above_Gege(k)*exp(exponent)/nenner;
{            end;      }
    end;

procedure perform_fit_Ed_Gege;
var j, k : integer;
begin
    FIT:=1;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    set_parameters_inverse;
    for j:=1 to M1 do par.map[j]:=0;
    if flag_above then begin
        if par.fit[19]=1 then par.map[19]:=19;
        for j:=41 to 44 do if par.fit[j]=1 then par.map[j]:=j;
        end;
    if not flag_above then begin { below surface: R parameters }
        if not flag_use_Ed then begin
            if par.fit[19]=1 then par.map[19]:=19;
            for j:=41 to 44 do if par.fit[j]=1 then par.map[j]:=j;
            end;
        for j:=1 to 13 do if par.fit[j]=1 then par.map[j]:=j;
        if par.fit[24]=1 then par.map[24]:=24;
        if par.fit[25]=1 then par.map[25]:=25;
        if par.fit[36]=1 then par.map[36]:=36;
        end;
    for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
    setsteps;
    GetData;
    Simpl;
    set_actual_parameters;
    alpha_d.actual:=par.c[41];
    beta_d.actual:=par.c[42];
    gamma_d.actual:=par.c[43];
    delta_d.actual:=par.c[44];
    z.actual:=par.c[25];
    alpha.actual:=par.c[19];
    sum1:=alpha_d.actual+beta_d.actual+gamma_d.actual+delta_d.actual;
    end;

procedure calc_R_Gege;
{ Calculate subsurface irradiance reflectance from r_rs using Ed model of Gege. }
var fak, Ed, Ls   : double;
    Ray, xi       : double;
    surf          : double;
    k             : integer;
begin
    xi:=(1-rho_Ed)*(1-rho_Lu)/sqr(nW);
    for k:=1 to Channel_number do begin
        if alpha.actual=0 then fak:=1.0 else
            fak:=exp(-alpha.actual*ln(x^.y[k]/Lambda_M));
        Ray:=Rayleigh^.y[k]/E0^.y[k]/sun_earth;
        Ed:=(alpha_d.actual*tA^.y[k] + beta_d.actual*Ray +
             gamma_d.actual*fak + delta_d.actual*tC^.y[k]);
        if flag_surf_inv then
            Ls:=(alpha_r.actual*tA^.y[k] + beta_r.actual*Ray +
                gamma_r.actual*fak + delta_r.actual*tC^.y[k])
        else Ls:=Ed;
        if abs(Ed)<nenner_min then Ed:=nenner_min;
        surf:=rho_L.actual * Ls / Ed;
        if flag_above then R^.y[k]:= (r_rs^.y[k] - surf ) * Q.actual / xi
                      else R^.y[k]:= r_rs^.y[k] * Q.actual;
        end;
    end;

procedure calculate_Kd_rd;
{ Used for inversion of var[dEd/Ed]. }
var k        : integer;
    sz_water : double;
begin
    sz_water :=arcsin(sin(par.c[27]*pi/180)/nW);
    for k:=1 to Channel_Number do begin
        Kd^.y[k] :=Kurve_Kd(k);                 { Belegung von Kd }
        Kdd^.y[k]:=Kurve_Kdd(k,sz_water);       { Belegung von Kdd }
        Kds^.y[k]:=Kurve_Kds(k,sz_water);       { Belegung von Kds }
        Ed^.y[k] :=kurve_Ed_GC(k);              { Belegung von r_d }
        end;
    Kd^.sim:=TRUE;
    Kdd^.sim:=TRUE;
    Kds^.sim:=TRUE;
    Ed^.sim:=TRUE;
    end;

procedure resample_inv(var spek: DataSet);
{ Resample spectrum by averaging each channel k from k-dsmpl to k+dsmp}
{ NOT IMPLEMENTED ! }
var k, l  : integer;
    count : integer;
    new   : Attr_spec;
    sum   : double;
begin
    k:=ch_fit_min[FIT];
    repeat
        sum:=0;
        count:=0;
        for l:=-dsmpl to dsmpl do
            if (k+l>=1) and (k+l<=Channel_number) then begin
                sum:=sum+spek[k+l, Theorie];
                inc(count);
                end;
        if count>0 then sum:=sum/count;
        new.y[k]:=sum;
        inc(k, fit_dk);
    until k>ch_fit_max[FIT];
    k:=ch_fit_min[FIT];
    repeat
        spek[k, Theorie]:=new.y[k];
        inc(k, fit_dk);
    until k>ch_fit_max[FIT];
    end;

procedure Write_regression(Filename: string);
{ Save result of 3-band regression in BSQ format. }
var  Stream   : TFileStream;
     x, y, c  : integer;
begin
    Stream := TFileStream.Create(Filename, fmCreate);
    try
        for c:=0 to 2 do
        for y:=0 to Dim_regr-1 do
        for x:=0 to Dim_regr-1 do
            Stream.Write(Regr_Matrix[x,y,c], 2);
    finally
        Stream.Free;
        end;
    end;

procedure Write_Regression_Envi_Header(FileName : string);
{ Write Envi Header }
var   datei      : textFile;
      Headerfile : string;
begin
    set_parameter_names;
    Headerfile:= ChangeFileExt(FileName, '.hdr');
    AssignFile(datei, Headerfile);
    {$i-} rewrite(datei);
    if ioresult=0 then begin  {$i+ }
        writeln(datei, 'ENVI');
        writeln(datei, 'description = {');
        writeln(datei, '  This file was generated by the program WASI-2D');
        writeln(datei, '  ', vers);
        writeln(datei, '  Input file: ', HSI_img^.FName, ' }');
        writeln(datei, ENVI_Keyword[1], ' = ', Dim_regr);     { samples }
        writeln(datei, ENVI_Keyword[2], ' = ', Dim_regr);     { lines }
        writeln(datei, ENVI_Keyword[3], ' = ', 3);            { bands }
        writeln(datei, ENVI_Keyword[4], ' = ', 0);            { header offset = 0 }
        writeln(datei, ENVI_Keyword[5], ' = ', 2);            { data type = 2}
        writeln(datei, ENVI_Keyword[6], ' = bsq');            { interleave = BSQ }
        writeln(datei, ENVI_Keyword[10], ' = ', 1);           { y scale = 1}
        writeln(datei, 'band names = {');
        write(datei, '  ');
        write(datei, 'band ', band_B, ' vs. ', band_G, ', ');
        write(datei, 'band ', band_B, ' vs. ', band_R, ', ');
        writeln(datei, 'band ', band_G, ' vs. ', band_R, ' }');
        CloseFile(datei);
        end;
    end;


procedure regression_3bands;
var   b1, b2     : integer;
      x, y, c    : integer;
      r, g, b    : double;
      dr, dg, db : double;
const B_min : single = 0;     { minimum of blue band }
      B_max : single = 2;     { maximum of blue band }
      G_min : single = 0.008; { minimum of green band }
      G_max : single = 0.025; { maximum of green band }
      R_min : single = 0;     { minimum of red band }
      R_max : single = 6;     { maximum of red band }

begin
    { Initialize regression matrix }
    SetLength(Regr_Matrix, Dim_regr, Dim_regr, 3);

    for c:=0  to 2 do
    for b1:=0 to Dim_regr-1 do
    for b2:=0 to Dim_regr-1 do Regr_Matrix[b1,b2,c]:=0;

    { Band 1: blue channel vs. green channel }
    b:=B_min;
    db:=(B_max-B_min)/Dim_regr;
    dg:=(G_max-G_min)/Dim_regr;
    for b1:=0 to Dim_regr-1 do begin
        g:=G_min;
        for b2:=0 to Dim_regr-1 do begin
            for y:=0 to Height_in-1 do
            for x:=0 to Width_in-1 do
                  if (cube_HSI4[x,y,2]>b) and (cube_HSI4[x,y,2]<=b+db) and
                     (cube_HSI4[x,y,1]>g) and (cube_HSI4[x,y,1]<=g+dg) then
                     Regr_Matrix[b1,b2,0]:=Regr_Matrix[b1,b2,0]+1;
            g:=g+dg;
            end;
        b:=b+db;
        end;

    { Band 2: blue channel vs. red channel }
    b:=B_min;
    db:=(B_max-B_min)/Dim_regr;
    dr:=(R_max-R_min)/Dim_regr;
    for b1:=0 to Dim_regr-1 do begin
        r:=R_min;
        for b2:=0 to Dim_regr-1 do begin
            for y:=0 to Height_in-1 do
            for x:=0 to Width_in-1 do
                  if (cube_HSI4[x,y,2]>b) and (cube_HSI4[x,y,2]<=b+db) and
                     (cube_HSI4[x,y,0]>r) and (cube_HSI4[x,y,0]<=r+dr) then
                     Regr_Matrix[b1,b2,1]:=Regr_Matrix[b1,b2,1]+1;
            r:=r+dr;
            end;
        b:=b+db;
        end;

    { Band 3: green channel vs. red channel }
    g:=G_min;
    dg:=(G_max-G_min)/Dim_regr;
    dr:=(R_max-R_min)/Dim_regr;
    for b1:=0 to Dim_regr-1 do begin
        r:=R_min;
        for b2:=0 to Dim_regr-1 do begin
            for y:=0 to Height_in-1 do
            for x:=0 to Width_in-1 do
                  if (cube_HSI4[x,y,1]>g) and (cube_HSI4[x,y,1]<=g+dg) and
                     (cube_HSI4[x,y,0]>r) and (cube_HSI4[x,y,0]<=r+dr) then
                     Regr_Matrix[b1,b2,2]:=Regr_Matrix[b1,b2,2]+1;
            r:=r+dr;
            end;
        g:=g+dg;
        end;

    { Save result }
    Write_regression('d:\correl_1.img');
    Write_Regression_Envi_Header('d:\correl_1.img');
    SetLength(Regr_Matrix, 0, 0, 0);
    end;


procedure calc_std_rrs;
{ Standard deviation of radiance reflectance in shallow waters. }
var k         : integer;
    sigma_zB  : double;
begin
    sigma_zB:=0.045;
    flag_L:=TRUE;
    calc_R_rs;
    calc_Kd;
    for k:=1 to Channel_number do begin
        Stest^.y[k]:=sigma_zB * sqrt(
                     sqr(A1rs*r_rs^.y[k]*(Kd^.y[k]+kL_uW^.y[k])*
                     exp(-(Kd^.y[k]+kL_uW^.y[k])*zB.fw)) +
                     sqr(A2rs*bottom^.y[k]*(Kd^.y[k]+kL_uB^.y[k])*
                     exp(-(Kd^.y[k]+kL_uB^.y[k])*zB.fw))
                     );
        end;
    Stest^.ParText:='Standard deviation of Rrs (sr^-1)';
    Stest^.sim:=TRUE;
    end;

procedure simulate_weight_old(s1,s2:byte; P1,P2:double);
{ Optimize weight function for parameter P for inverse modelling.
  s1: Index of spectrum with P = P1;
  s2: Index of spectrum with P = P2;
  P1, P2: two values of the parameter P. }
var k      : integer;
    nenner : double;
    mean   : double;
    arg    : double;
    P      : double; { Parameter for which weight is optimized }
    dP     : double; { Interval P2-P1 }
    D      : double; { Difference measurement - simulation }
    Ds     : double; { Derivative of D by P }
    T      : double; { 'True' value }
    T_t    : double; { Tangent of T }
    ms     : double; { Scaling error of measurement }
    mo     : double; { Offset error of measurement }
    ss     : double; { Scaling error of simulation }
    so     : double; { Offset error of simulation }
    ss_t   : double; { Tangent of ss }

begin
    P:=(P1+P2)/2;
    dP:=P2-P1;
    if (abs(dP)>nenner_min) and (s2>2) then begin
        mean:=0;
        for k:=1 to Channel_number do begin
            T    := (spec[s2]^.y[k]+spec[s1]^.y[k])/2;
            T_t  := (spec[s2]^.y[k]-spec[s1]^.y[k])/dP;
            ms   := sqrt(sqr(u_c^.y[k])+sqr(u_t^.y[k]));
            mo   := sqrt(sqr(u_p^.y[k])+sqr(u_n^.y[k]));
            so   :=0;  { --> ergänzen }
            if abs(T)>nenner_min then  { --> Schleife über alle Parameter }
                ss   := (spec[s2]^.y[k]- so)/T-1
                else ss:=0;
            ss_t :=0;  { --> ergänzen }
            D    := T*(ms-ss) + mo - so;
            Ds   := T_t*(ms-ss) - T*ss_t;
            nenner:=D;
            if abs(nenner)>nenner_min then begin
                arg:=-2*P*Ds/nenner;
                if arg<exp_min then arg:=exp_min;
                if arg>exp_max then arg:=exp_max;
                Stest^.y[k]:=exp(arg);
                end
            else Stest^.y[k]:=0;
            mean:=mean+Stest^.y[k];
            end;
        if mean>nenner_min then for k:=1 to Channel_number do   { normalize integral }
            Stest^.y[k]:=Stest^.y[k]*Channel_number/mean;
        end;
    Stest^.ParText:='Simulated weight';
    Stest^.sim:=TRUE;
    end;

procedure simulate_weight(s1,s2:byte; P1,P2:double);
{ Optimize weight function for parameter P for inverse modelling.
  s1: Index of spectrum with P = P1;
  s2: Index of spectrum with P = P2;
  P1, P2: two values of the parameter P. }
var k      : integer;
    nenner : double;
    mean   : double;
    arg    : double;
    P      : double; { Parameter for which weight is optimized }
    dP     : double; { Interval P2-P1 }
    D      : double; { Difference measurement - simulation }
    Ds     : double; { Derivative of D by P }
    T      : double; { 'True' value }
    T_t    : double; { Tangent of T }
    ms     : double; { Scaling error of measurement }
    mo     : double; { Offset error of measurement }
    ss     : double; { Scaling error of simulation }
    so     : double; { Offset error of simulation }
    ss_t   : double; { Tangent of ss }
const zero = 1e-6;

begin
    dP:=Par1_Max-Par1_Min;
    P:=(Par1_Max+Par1_Min)/2;
    if (abs(dP)>nenner_min) and (Par1_N=3) then begin
        mean:=0;
        set_parameters_inverse;
        calc_Rrs_surface;     { Rrs_surf^.y[k] }
        for k:=1 to Channel_number do begin
            T    := spec[2]^.y[k];
            T_t  := (spec[3]^.y[k]-spec[1]^.y[k])/dP;
            ms   := sqrt(sqr(u_c^.y[k])+sqr(u_t^.y[k]));
            mo   := sqrt(sqr(u_p^.y[k])+sqr(u_n^.y[k]));
            so   := Kurve_Rrs_surf(k) - Rrs_surf^.y[k];
            nenner:=T;
            if abs(nenner)>nenner_min then
                ss:=(kurve_Rrs_above(k)-so)/nenner-1
                else ss:=0;
            ss_t :=0;  { --> ergänzen }
            D    := T*(ms-ss) + mo - so;
            Ds   := T_t*(ms-ss) - T*ss_t;
            nenner:=D*D/T*T;
            if nenner>zero then begin
                arg:=-2*P*D*Ds/nenner;
                if arg<exp_min then arg:=exp_min;
                if arg>5 then arg:=5;
                Stest^.y[k]:=exp(arg);
                end
            else Stest^.y[k]:=0;
            mean:=mean+Stest^.y[k];
            end;
        (*
        if mean>nenner_min then for k:=1 to Channel_number do   { normalize integral }
            Stest^.y[k]:=Stest^.y[k]*Channel_number/mean;
        *)
        end;
    Stest^.ParText:='Simulated weight';
    Stest^.sim:=TRUE;
    end;

procedure read_CalVal(del_outliers: boolean);
{ Import list of in situ data 'map_p' which were measured at the geographical
  coordinates 'map_x', 'map_y'. }
var z         : integer;
    datei_in  : TextFile;
    datei_out : TextFile;
    dummy_s   : string;
begin
    with ValSet do begin
        if del_outliers then begin
            AssignFile(datei_out, ChangeFileExt(FName, 'x.txt'));
           {$i-} rewrite(datei_out); {$i+}
            end;
        AssignFile(datei_in, FName);
        {$i-} reset(datei_in); {$i+}
        if ioresult=0 then begin
            if Header>0 then for z:=1 to Header do begin
                readln(datei_in, dummy_s);
                if del_outliers then writeln(datei_out, dummy_s);
                end;
            z:=1;
            repeat
                readln(datei_in, map_E[z], map_N[z], map_p[z]);
                if del_outliers and not
                   ((ValSet.map_E[z]>E_min) and (ValSet.map_E[z]<E_max) and
                   (ValSet.map_N[z]>N_min) and (ValSet.map_N[z]<N_max)) then
                    writeln(datei_out, map_E[z], #9, map_N[z], #9, map_p[z]);
                inc(z);
            until eof(datei_in) or (z>=NVal);
            if del_outliers then close(datei_out);
            N:=z-1;  { N = Number of imported measurements }
            end;
        end;
    end;

procedure read_XYdata;
{ Import x, y data from table for producing a heat map. }
var z     : integer;
    datei : TextFile;
    ok    : boolean;
    flag_CRLF : boolean;
begin
    with HM do begin
        flag_CRLF:=ASCII_is_Windows(FName);
        AssignFile(datei, FName);
        {$i-} reset(datei); {$i+}
        if ioresult=0 then begin
            if Header>0 then for z:=1 to Header do readln(datei);
            z:=1;
            repeat
                ok:=lies(datei, flag_CRLF, XColumn, YColumn, map_E[z], map_N[z]);
                inc(z);
            until eof(datei) or (z>=NVal) or (not ok);
            N:=z-1;  { N = Number of imported measurements }
            end;
        end;
        CloseFile(datei);
    end;


procedure Write_Heatmap_Envi_Header(FileName: string; dim: integer);
{ Write Envi Header }
var   datei      : textFile;
      Headerfile : string;
begin
    set_parameter_names;
    Headerfile:= ChangeFileExt(FileName, '.hdr');
    AssignFile(datei, Headerfile);
    {$i-} rewrite(datei);
    if ioresult=0 then begin  {$i+ }
        writeln(datei, 'ENVI');
        writeln(datei, 'description = {');
        writeln(datei, '  This file was generated by the program WASI-2D');
        writeln(datei, '  ', vers);
        writeln(datei, '  Heatmap created from the following ASCII table:');
        writeln(datei, '  ', HM.FName, ' }');
        writeln(datei, ENVI_Keyword[1], ' = ', dim);          { samples }
        writeln(datei, ENVI_Keyword[2], ' = ', dim);          { lines }
        writeln(datei, ENVI_Keyword[3], ' = ', 1);            { bands }
        writeln(datei, ENVI_Keyword[4], ' = ', 0);            { header offset = 0 }
        writeln(datei, ENVI_Keyword[5], ' = ', 12);           { data type = 12}
        writeln(datei, ENVI_Keyword[6], ' = bil');            { interleave }
        writeln(datei, ENVI_Keyword[10], ' = ', 1);           { y scale = 1}
        CloseFile(datei);
        end;
    end;

procedure create_heatmap;
{ Create heatmap from array ValSet.map_E[z], ValSet.map_N[z].
  Heatmap has dimension dim x dim, the range is from min to max. }
var Stream  : TFileStream;
    z       : integer;
    h, v    : word;
    heatmap : frame_word;
    m       : double;
begin
    SetLength(heatmap, HM_dim, HM_dim);                  // set array dimensions
    m:=HM_dim/(HM_max-HM_min);                           // scaling factor
    if abs(m)>nenner_min then for z:=1 to HM.N do begin
        h:=abs(round(HM.map_E[z]*m));
        v:=abs(round(HM.map_N[z]*m));
        if (h<HM_dim) and (v<HM_dim) then inc(heatmap[h,v]);
        end;

    Write_Heatmap_Envi_Header(ChangeFileExt(HM.FName, '.hdr'), HM_dim);
    Stream := TFileStream.Create(ChangeFileExt(HM.FName, '.img'), fmCreate);
    try
        for v:=HM_dim-1 downto 0 do
        for h:=0 to HM_dim-1 do
            Stream.Write(heatmap[h,v], 2)
    finally
        Stream.Free;
        end;
    end;

procedure swap(var a,b:double);
{ Exchange a and b }
var temp : double;
begin
    temp:=a;
    a:=b;
    b:=temp;
    end;

procedure QuickSort(var XY : CalVal_data; first, last : integer);
var  x : double;
     i : integer ;
     j : Integer ;
begin
    if First>=Last then begin
             (* do nothing it is sorted *)
         end else begin
              i := First ;
              j := Succ(Last) ;
              x := XY.map_E[First] ;
              repeat
                  repeat
                    i := Succ(i);
                  until (XY.map_E[i] >= x) or (i>=last) ;
                  repeat
                    j := pred(j);
                  until XY.map_E[j] <=x ;
                  if i < j then begin
                     swap(XY.map_E[i], XY.map_E[j]);
                     swap(XY.map_N[i], XY.map_N[j]);
                  end ;
              until i>=j ;
              swap (XY.map_E[First],XY.map_E[j]);
              swap (XY.map_N[First],XY.map_N[j]);
              QuickSort(XY, First, j - 1);
              QuickSort(XY, j+1, Last) ;
         end;
    end;

procedure Betrag(var XY : CalVal_data);
var i : integer;
begin
    for i:=1 to XY.N do begin
        XY.map_E[i]:=abs(XY.map_E[i]);
        XY.map_N[i]:=abs(XY.map_N[i]);
        end;
    end;

procedure calculate_statistics(zmin, zmax, dz, outlier: double);
{ Calculate statistics from array ValSet.map_E[z], ValSet.map_N[z]. }
var i       : integer;
    N, No   : integer;
    mean    : double;
    sum2    : double;
    sigma   : double;
    rmse    : double;
    border  : double;
    diff    : double;
    datei   : text;
    s10     : array[1..6]of string;
begin
    s10[1]:='Range [m]'+#9;
    s10[2]:='N'+#9;
    s10[3]:='outliers'+#9;
    s10[4]:='bias [cm]'+#9;
    s10[5]:='stddev [cm]'+#9;
    s10[6]:='RMSE [cm]'+#9;

    Betrag(HM);
    QuickSort(HM, 1, HM.N);
    i:=1;
    while (HM.map_E[i]<zmin) and (i<HM.N) do inc(i);
    border:=dz;
    repeat
        mean:=0;
        sum2:=0;
        N:=0;
        No:=0;
        while (HM.map_E[i]<border) and (i<HM.N) do begin
            diff  :=HM.map_N[i]-HM.map_E[i];
            if abs(diff)<outlier then begin
                mean  :=mean+diff;
                sum2:=sum2+sqr(diff);
                inc(N);
                end
            else inc(No);
            inc(i);
            end;
        if N>1 then begin
            sigma:=sqrt(sum2/(N-1)-sqr(mean)/N/(N-1));
            mean:=mean/N;
            rmse:=sqrt(sqr(sigma)+sqr(mean));
            s10[1]:=s10[1]+schoen(border-dz,0)+'-'+schoen(border,0)+#9;
            s10[2]:=s10[2]+inttoStr(N)+#9;
            s10[3]:=s10[3]+inttoStr(No)+#9;
            s10[4]:=s10[4]+schoen(100*mean,2)+#9;
            s10[5]:=s10[5]+schoen(100*sigma,2)+#9;
            s10[6]:=s10[6]+schoen(100*rmse,2)+#9;
            end;
        border:=border+dz;
    until (HM.map_E[i]>zmax) or (border>zmax) or (i>=HM.N);

    { Save results to file }
    assign(datei, ChangeFileExt(HM.FName, '_sta.txt'));
    {$i-} rewrite(datei);
    writeln(datei, 'This file was generated by the program WASI');
    writeln(datei, vers);
    writeln(datei);
    for i:=1 to 6 do writeln(datei, s10[i]);
    close(datei);
    end;

procedure estimate_bottom_reflectance(index:byte);
{ Calculate bottom reflectance from above-water measurement.
  This procedure was used to calculate bottom reflectance from HySpex data
  in P. Gege (2014): A case study at Starnberger See for hyperspectral
  bathymetry mapping using inverse modeling. Proc. WHISPERS, June 25-27, 2014,
  Lausanne, Switzerland. }
const thresh = 1;
var k      : integer;
    f1, f2 : double;
    nenner : double;
    R      : double;
begin
    set_parameters_inverse;
    f1:=(1-rho_Ed)*(1-rho_Lu)/sqr(nW);
    f2:=rho_Eu*Q.actual;
    for k:=1 to Channels_in do begin
        R:=spec[1]^.y[k]-kurve_Rrs_surf(k);
        nenner:=f1+f2*R;
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        spec[index]^.y[k]:=
            R/nenner -
            kurve_Rrs_deep_below(k)*(1-A1rs*exp(-(kurve_Kd(k)+kurve_kL_uW(k))*zB.actual));
        nenner:=A2rs*exp(-(kurve_Kd(k)+kurve_kL_uB(k))*zB.actual);
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        spec[index]^.y[k]:=pi*spec[index]^.y[k]/nenner;
        if abs(spec[index]^.y[k])>thresh then spec[index]^.y[k]:=thresh;
        end;
    S_actual:=1;
    NSpectra:=index;
    farbS[index]:=clGreen;
    spec[index]^.ParText:='Bottom estimate';
    end;

function kurve_Rrs_waterlayer(k:integer):double;
{ Calculate bottom reflectance from below-water measurement.
  Depth differences between the z sensor and the Ed and Lu sensor are
  accounted for by the parameters dz_Ed and dz_Lu, respectively. }
var   nenner : double;
      dummy  : double;
begin
    nenner:=A2rs*
            exp(-kurve_Kd(k)*(zB.actual-z.actual-dz_Ed)
                -kurve_kL_uB(k)*(zB.actual-z.actual-dz_Lu));
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    dummy:=
        (spec[1]^.y[k] -
        kurve_Rrs_deep_below(k)*
        (1-A1rs*exp(-kurve_Kd(k)*(zB.actual-z.actual-dz_Ed)
                    -kurve_kL_uW(k)*(zB.actual-z.actual-dz_Lu))))
        /nenner;
    if dummy<0 then dummy:=0 else if dummy>1 then dummy:=1;
    kurve_Rrs_waterlayer:=dummy;
    end;

function kurve_R_waterlayer(k:integer):double;
{ Calculate bottom reflectance from below-water measurement.
  Depth differences between the z sensor and the Ed and Eu sensor are
  accounted for by the parameters dz_Ed and dz_Eu, respectively. }
var   nenner : double;
      dummy  : double;
begin
    nenner:=A2*
            exp(-kurve_Kd(k)*(zB.actual-z.actual-dz_Ed)
                -kurve_KE_uB(k)*(zB.actual-z.actual-dz_Eu));
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    dummy:=
        (spec[1]^.y[k] -
        kurve_R_deep(k)*
        (1-A1*exp(-kurve_Kd(k)*(zB.actual-z.actual-dz_Ed)
                  -kurve_kE_uW(k)*(zB.actual-z.actual-dz_Eu))))
        /nenner;
    if dummy<0 then dummy:=0 else if dummy>1 then dummy:=1;
    kurve_R_waterlayer:=dummy;
    end;

{ *********************************}

procedure calc_Lsky_Ed_loeschen;
{ Ratio of sky radiance to downwelling irradiance }
var k          : integer;
    nenner     : double;
    Tr, Ta     : double;
begin
   STest^.ParText:='L_sky/Ed [1/sr]';
   YText:=STest^.ParText;

   calc_Tr_GC;     // Rayleigh transmission
   calc_tau_a_GC;  // Aerosol optical thickness
   calc_T_as;      // Transmission after aerosol scattering
   for k:=1 to Channel_number do begin
        Tr:=GC_T_r^.y[k];
        Ta:=GC_T_as^.y[k];
        nenner:=Tr*Ta+0.5*(1-power(Tr, 0.95))+power(Tr, 1.5)*(1-Ta)*F_a;
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        STest^.y[k]:=
            (g_dd.fw*Tr*Ta+0.5*g_dsr.fw*(1-power(Tr, 0.95))+
             g_dsa.fw*power(Tr, 1.5)*(1-Ta)*F_a)/nenner;
        end;
    end;

function kurve_Lsky_Ed(k:integer):double;
{ Ratio of sky radiance to downwelling irradiance }
var   nenner : double;
      sz_air, Fa, t_M, Tr, tau_a, Tas : double;
begin
    sz_air   :=par.c[27]*pi/180;
    Fa      := Fa_inv(sz_air);
    t_M     := M(sz_air);
    Tr      := Tr_GC(t_M,GC_P,k);
    tau_a   := tau_a_GC(k);
    Tas     := T_as(tau_a,t_M);
    nenner:=Tr*Tas+0.5*(1-power(Tr, 0.95))+power(Tr, 1.5)*(1-Tas)*Fa;
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    kurve_Lsky_Ed:=
            (par.c[20]*par.c[37]*Tr*Tas+0.5*par.c[21]*par.c[38]*(1-power(Tr, 0.95))+
             par.c[21]*par.c[39]*power(Tr, 1.5)*(1-Tas)*Fa)/nenner;
    end;

procedure perform_fit_Lsky_Ed(Sender:TObject);
var j, k : integer;
begin
    FIT:=4;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    set_parameters_inverse;
    for j:=1 to M1 do par.map[j]:=0;
    for j:=18 to 21 do if par.fit[j]=1 then par.map[j]:=j;    // beta, alpha, f_dd, f_ds
    for j:=37 to 39 do if par.fit[j]=1 then par.map[j]:=j;    // g_dd, g_dsr, g_dsa
    for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
    setsteps;
    GetData;
    Simpl;
    set_actual_parameters;
    end;

procedure perform_fit_waterlayer(Sender:TObject);
var j, k : integer;
begin
    FIT:=1;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    set_parameters_inverse;
    for j:=1 to M1 do par.map[j]:=0;   // no fit parameters
    // no fit
    for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
    set_actual_parameters;
    end;


procedure saveSpecMean(name:ShortString; x, m, SD, v: spektrum; ch, N: integer);
{ Save averaged spectrum }
var datei : text;
    k     : integer;
begin
    assign(datei, name);
    {$i-} rewrite(datei);
    writeln(datei, 'This file was generated by the program WASI');
    writeln(datei, vers);
    writeln(datei);
    writeln(datei, N, #9, '= number of averaged spectra');
    writeln(datei, day, #9, '= day of year');
    writeln(datei, schoen(sun.actual,2), #9, '= sun zenith angle');
    writeln(datei);
    writeln(datei, 'x    ', #9, 'mean ', #9, 'sigma', #9, 'variance');
    for k:=1 to ch do begin
        writeln(datei, x[k]:5:1, #9, schoen(m[k],5), #9, schoen(SD[k],5), #9, schoen(v[k],5));
        end;
    CloseFile(datei);
    {$i+}
    end;


procedure Average_image_lines(name: string);
{ Average the lines of a hyperspectral image cube for each band
  and save the resulting table as file 'name'.
  Version from 26 Nov 2019. }
const tLambdaMin = 380;   { first x value }
      tdLambda   = 1;     { difference of x values }
var   k, nr, f : integer;
begin
    Channel_number:=Width_in;
    NSpectra:=Channels_out;
    for k:=0 to Channel_number-1 do x^.y[k+1]:=tLambdaMin + k*tdLambda;
    for nr:=1 to NSpectra do for k:=0 to Channel_number-1 do spec[nr]^.y[k+1]:=0;
    if flag_CEOS and not flag_public then begin
        for nr:=1 to NSpectra-1 do
            for k:=0 to Channel_number-1 do
                for f:=0 to Height_in-1 do
                    spec[nr]^.y[k+1]:=spec[nr]^.y[k+1]+cube_fitpar[k,f,nr-1]/Height_in;
        for k:=0 to Channel_number-1 do
            for f:=0 to Height_in-1 do
                spec[NSpectra]^.y[k+1]:=spec[NSpectra]^.y[k+1]+cube_fitpar[k,f,NSpectra-1];
        end
    else for nr:=1 to NSpectra do
        for k:=0 to Channel_number-1 do
            for f:=0 to Height_in-1 do
                spec[nr]^.y[k+1]:=spec[nr]^.y[k+1]+cube_fitpar[k,f,nr-1]/Height_in;
    saveSpecFw(name);
    end;


procedure sort(var data: cube_single; x, lo, hi: longInt);
{ In-place merge sorting of a table in ascending order.
  Reference: After a java algorithm By Jason Harrison, 1995 University of British Columbia.
  TPW version by J-P Moreau, Paris (www.jpmoreau.fr), modified by P. Gege.
  Link: http://jean-pierre.moreau.pagesperso-orange.fr/Pascal/msort_pas.txt
  ---------------------------------------------------------------------------
  Inputs:
      data :  3D-Array of real numbers
      x    :  x-column of array
      lo   :  Starting index (>=0)
      hi   :  Ending index (<=n-1), with lo<hi.
   Output:
      data :  y-column of table sorted in ascending order. }

var  end_lo,k,mid,start_hi : longInt;
     T                     : double;
begin

    if lo>=hi then exit;     { no action }
    mid := (lo + hi) div 2;

    { Partition the list into two lists and sort them recursively }
    sort(data, x, lo, mid);
    sort(data, x, mid + 1, hi);

    { Merge the two sorted lists }
    start_hi := mid + 1;
    end_lo := mid;
    while (lo <= end_lo) and (start_hi <= hi) do
    begin
      if data[x,lo,0] < data[x,start_hi,0] then
        Inc(lo)
      else
      begin
        T := data[x,start_hi,0];
        for k := start_hi - 1 Downto lo do data[x,k+1,0] := data[x,k,0];
        data[x,lo,0] := T;
        Inc(lo);
        Inc(end_lo);
        Inc(start_hi)
      end
    end;
    end;


procedure Quantile_images(q: double; Sender: TObject);
{ Calculate quantile q of channel 'median_band' for all hyperspectral images
  in the current directory if the value of channel 'band_thresh' is above
  'thresh_dRrs'. q = 0.5 corresponds to the median. The x-values of the image
  are specified by 'median_xmin', the differences of two x-values by 'median_dx'.
  Before running this module, open one of the images for which the median
  shall be calculated, in order to initialize some image parameters.
  Version from 7 December 2019 }
var tmp_yscale     : double;
    FileAttrs      : Integer;
    sr             : TSearchRec;
    Pfad           : String;
    Name_LoadBatch : string;
    Extension      : string;
    k, f, z        : longInt;
    N_Files        : integer;
    the_data       : cube_single;   { input data and calculated values }
begin
   tmp_yscale:=y_scale;
   TimeStartCalc:=Now;
   y_scale:=1;
   z:=0;
   flag_HSI_wv:=FALSE; { bands of HSI cube are no wavelengths }
   Pfad:=ExtractFilePath(HSI_img^.FName);
   Extension:=ExtractFileExt(HSI_img^.FName);
   Name_LoadBatch:=Pfad + '*' + Extension;
   FileAttrs := faAnyFile;
   N_Files:=CountFilesInFolder('*' + Extension, Pfad);
   if N_Files>1 then begin
       if FindFirst(Name_LoadBatch, FileAttrs, sr) = 0 then begin
           actualFile:=Pfad+sr.Name;
           if flag_ENVI then Format_2D.Read_Envi_Header(actualFile);
           SetLength(the_data, Width_in, Height_in*N_Files+1, 1);
           HSI_img^.FName:=actualFile;
           ABBRUCH:=FALSE;
           for k:=0 to Width_in-1 do begin
               x^.y[k+1]:=median_xmin + k*median_dx;
               spec[1]^.y[k+1]:=0;
               spec[3]^.y[k+1]:=0;
               end;
           REPEAT
               actualFile:=Pfad+sr.Name;
               HSI_img^.FName:=actualFile;
               Format_2D.import_HSI(Sender);

               { loop over frames = image lines }
               f:=0;                    // first  image line
               repeat
                   k:=0;                // Set k to first image column
                   { loop over pixels = image columns }
                   repeat
                       Format_2D.extract_spektrum_new(spec[4]^, k, f, Sender);  // Read spectrum
                       if abs(spec[4]^.y[band_thresh])>=thresh_dRrs then begin
                           the_data[k,z,0]:=the_data[k,z,0]+spec[4]^.y[median_band]; // median
                           spec[1]^.y[k+1]:=spec[1]^.y[k+1]+spec[4]^.y[median_band]; // mean
                           spec[3]^.y[k+1]:=spec[3]^.y[k+1]+1;  // number of spectra
                           end;
                       inc(k);
                   until (k>=Width_in) or ABBRUCH;
                   inc(f);
                   inc(z);
               until (f>=Height_in) or ABBRUCH;
           UNTIL (FindNext(sr)<>0);
           FindClose(sr);

           // calculate mean and quantile q
           for k:=0 to Width_in-1 do       // mean
               if spec[3]^.y[k+1]>1 then spec[1]^.y[k+1]:=spec[1]^.y[k+1]/spec[3]^.y[k+1];
           spec[1]^.FName:=HSI_img^.FName;
           Channel_number:=Width_in;

           for k:=0 to Width_in-1 do begin // quantile
               sort(the_data, k, 0, Height_in*N_Files);
               spec[2]^.y[k+1]:=the_data[k, round(Height_in*N_Files-q*spec[3]^.y[k+1]), 0];
               end;
           end;
       NSpectra:=3;
       bandname[1]:='Mean';
       bandname[2]:=schoen(q,2) + '_quantile';
       bandname[3]:='N';
       TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
       saveSpecFw(Pfad+bandname[1]+'_'+bandname[2]+'_band'+IntToStr(median_band)+'.txt');
        end
        else ShowMessage('ERROR: Less than 2 images in directory '+Pfad);
        y_scale:=tmp_yscale;
    end;


procedure Median_SNR(Sender: TObject);
{ Not useful because the relevant data are not available as images! }
{ Calculate median of channel 'median_band' for all hyperspectral images
  in the current directory if the value of channel 'band_thresh' is above
  'thresh_dRrs'. The x-values of the image are specified by 'median_xmin',
  the differences of two x-values by 'median_dx'.
  Before running this module, open one of the images for which the median
  shall be calculated, in order to initialize some image parameters.
  Version from 12 March 2020 }
var tmp_yscale     : double;
    FileAttrs      : Integer;
    sr             : TSearchRec;
    Pfad           : String;
    Name_LoadBatch : string;
    Extension      : string;
    k, f, z, i     : longInt;
    N_Files        : integer;
    the_data       : cube_single;   { input data and calculated values }
    S              : array[1..521] of double; // signal
    N              : array[1..521] of double; // noise / number
    SNR            : array[1..521] of double; // signal-to-noise ratio
    chMax          : integer;                 // channel with maximum signal
const band_S       = 1;                       // band with signal
      band_N       = 3;                       // band with noise
begin
   tmp_yscale:=y_scale;
   TimeStartCalc:=Now;
   y_scale:=1;
   z:=0;
   flag_HSI_wv:=FALSE; { bands of HSI cube are no wavelengths }
   Pfad:=ExtractFilePath(HSI_img^.FName);
   Extension:=ExtractFileExt(HSI_img^.FName);
   Name_LoadBatch:=Pfad + '*' + Extension;
   FileAttrs := faAnyFile;
   N_Files:=CountFilesInFolder('*' + Extension, Pfad);
   if N_Files>1 then begin
       if FindFirst(Name_LoadBatch, FileAttrs, sr) = 0 then begin
           actualFile:=Pfad+sr.Name;
           if flag_ENVI then Format_2D.Read_Envi_Header(actualFile);
           if z=0 then SetLength(the_data, Width_in, Height_in*N_Files+1, 1);
           HSI_img^.FName:=actualFile;
           ABBRUCH:=FALSE;
           for k:=0 to Width_in-1 do begin
               x^.y[k+1]:=median_xmin + k*median_dx;
               spec[1]^.y[k+1]:=0;
               spec[3]^.y[k+1]:=0;
               end;
           REPEAT
               actualFile:=Pfad+sr.Name;
               HSI_img^.FName:=actualFile;
               Format_2D.import_HSI(Sender);

               { loop over frames = image lines }
               f:=0;                    // first  image line
               repeat
                   // Read one line
                   k:=0;
                   repeat // loop over image columns
                       Format_2D.extract_spektrum_new(spec[4]^, k, f, Sender);
                       inc(k);
                       S[k]:=spec[4]^.y[band_S];
                       N[k]:=spec[4]^.y[band_N];
                       if abs(N[k])>thresh_dRrs then
                           SNR[k]:=abs(S[k]/N[k]) else
                           SNR[k]:=0;
                   until (k>=Width_in) or (k>=521) or ABBRUCH;

                   // Determine channel with maximum signal
                   chMax:=1;
                   for i:=2 to 521 do
                       if abs(S[i])>abs(S[chMax]) then chMax:=i;

                   // Write relevant SNR to array "the_data"
                   for i:=1 to 521 do
                       if (i=chMax) and (S[i]>=thresh_dRrs) then
                           the_data[i-1,z,0]:=SNR[i] else
                           the_data[i-1,z,0]:=0;

                   inc(f);
                   inc(z);
               until (f>=Height_in) or ABBRUCH;
           UNTIL (FindNext(sr)<>0);
           FindClose(sr);

           // calculate mean
           for k:=1 to 521 do begin
               SNR[k]:=0;           // SNR
               spec[3]^.y[k]:=0;    // Number of data points
               end;

           for k:=1 to 521 do begin
               for i:=0 to z-1 do
                   if the_data[k-1,i,0]>0 then begin
                       SNR[k]:=SNR[k]+the_data[k-1,i,0];
                       spec[3]^.y[k]:=spec[3]^.y[k]+1;
                       end;
                 end;
           for k:=1 to 521 do
               if spec[3]^.y[k]>=1 then spec[1]^.y[k]:=SNR[k]/spec[3]^.y[k]
                                   else spec[1]^.y[k]:=0;
           spec[1]^.FName:=HSI_img^.FName;
           Channel_number:=521;

           // calculate median
           for k:=1 to 521 do begin
               sort(the_data, k-1, 0, z-1);
               spec[2]^.y[k]:=the_data[k-1, round(z-1-0.5*spec[3]^.y[k]), 0];
               end;
           end;
       NSpectra:=3;
       bandname[1]:='Mean';
       bandname[2]:='Median';
       bandname[3]:='N';
       TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
       saveSpecFw(Pfad+'Mean_Median_SNR.txt');
        end
        else ShowMessage('ERROR: Less than 2 images in directory '+Pfad);
        y_scale:=tmp_yscale;
    end;





procedure Average_spectra(relative:boolean);
{ Calculate mean, standard deviation and variance of spectra within a table. }
{ --> definiere parameter oder flags, ob relativ oder absolut }
var FileAttrs : Integer;
    k, ch     : word;
    channels  : word;
    sp        : integer;
    sr        : TSearchRec;
    Pfad      : String;
    svFile    : String;
    x         : Attr_spec;
    spek      : Attr_spec;
    mean0     : Attr_spec;
    mean      : Attr_spec;
    mue       : Attr_spec;
    SD2       : Attr_spec;
    SD        : Attr_spec;
begin
   FileAttrs := faAnyFile;
   Pfad:=ExtractFilePath(Name_LdBatch);
   begin
       if FindFirst(Name_LdBatch, FileAttrs, sr) = 0 then begin
           REPEAT
               set_zero(spek);
               set_zero(mean0);
               set_zero(mean);
               set_zero(mue);
               set_zero(SD2);
               set_zero(SD);

               if relative then begin
               { First run: determine mean }
                   sp:=0;
                   Channels:=0;
                   actualFile:=Pfad+sr.Name;
                   while (lies_spektrum(spek, actualFile, meas^.XColumn,
                            meas^.YColumn+sp, meas^.Header, ch, flag_tab)=0) and (sp<ycol_max) do begin
                       if sp=0 then Channels:=ch;
                       for k:=1 to Channels do mean0.y[k]:=mean0.y[k] + spek.y[k];
                       inc(sp);
                       end;
                   if sp>0 then for k:=1 to Channels do begin
                       mean0.y[k]:=mean0.y[k]/sp;
                       if abs(mean0.y[k])<nenner_min then mean0.y[k]:=nenner_min;
                       end;
                   set_zero(spek);
                   end;

               { Second run: determine standard deviation and variance }
               sp:=0;
               Channels:=0;
               actualFile:=Pfad+sr.Name;
               if flag_read_day then lies_day(actualFile);
               if flag_read_sun then lies_sun(actualFile);
               if flag_read_view then lies_view(actualFile);
               if flag_read_dphi then lies_dphi(actualFile);
               while (lies_spektrum(spek, actualFile, meas^.XColumn,
                        meas^.YColumn+sp, meas^.Header, ch, flag_tab)=0) and (sp<ycol_max) do begin
                   if sp=0 then begin
                       x:=xx^;
                       Channels:=ch;
                       end;
                   if relative then for k:=1 to Channels do begin
                       mean.y[k]:=mean.y[k] + spek.y[k]/mean0.y[k]-1;
                       mue.y[k] :=mue.y[k]  + sqr(spek.y[k]/mean0.y[k]-1);
                       end
                   else for k:=1 to Channels do begin
                       mean.y[k]:=mean.y[k] + spek.y[k];
                       mue.y[k] :=mue.y[k]  + sqr(spek.y[k]-mean0.y[k]);
                       end;

                   inc(sp);
                   end;
               if sp>0 then for k:=1 to Channels do begin
                   mean.y[k]:=mean.y[k]/sp;                        // mean
                   mue.y[k] :=mue.y[k]/sp;
                   SD2.y[k] :=mue.y[k]-sqr(mean.y[k]);            // variance
                   SD.y[k]  :=sqrt(abs(SD2.y[k]));                // standard deviation
                   end;

               svFile:=Pfad+ChangeFileExt(sr.Name, '.avg');
               if relative then mean:=mean0;
               saveSpecMean(svFile, x.y, mean.y, SD.y, SD2.y, Channels, sp);
           UNTIL (FindNext(sr)<>0);
           FindClose(sr);
           end;
        end;
    end;


{ **************************************************************************** }
{ ***********           Excitation-emission matrices               *********** }
{ **************************************************************************** }

procedure import_EEM_header(var datei: textFile; out N: integer;
          out em: spektrum; h0: integer);
{ Read header lines of EEM. Parameters:
  datei : input file
  N     : number of imported data
  em    : imported emission wavelengths
  h0    : number of header columns }
var  c  : integer;
     ch : char;
begin
    // skip header columns
    c:=1;
    repeat
        repeat read(datei, ch); until (ch=#9) or (ch=#0);
        inc(c);
    until c>h0;

    // import data
    c:=1;
    repeat
        read(datei, em[c]);
        inc(c);
    until eoln(datei) or (c>MaxChannels);
    N:=c-1;
    end;

procedure import_ASCII_line(var datei: textFile; out lem: double; out N: integer;
          out ex: spektrum; hc, hem: integer);
{ Read a single line of an image file in ASCII format. Parameters:
  datei : input file
  lem   : emission wavelength
  N     : number of imported data
  ex    : imported excitation spectrum
  hc    : number of header columns
  hem   : header column of emission wavelength }
var  c : integer;
     x : double;
begin
    // handle header columns
    c:=1;
    repeat
        read(datei, x);
        if c=hem then lem:=x;
        inc(c);
    until c>hc;

    // import data
    c:=1;
    repeat
        read(datei, ex[c]);
        inc(c);
    until eoln(datei) or (c>MaxChannels);
    N:=c-1;
    end;

function import_wavelengths_EEM(var E: EEMatrix):byte;
{ Determine number of excitation and emission wavelengths of EEM-matrix E
  and import excitation wavelengths and emission wavelengths. }
var  datei : textFile;
     ok    : byte;
     z     : integer;
     n     : integer;
     dummy : spektrum;
begin
    {$i-}
    AssignFile(datei, E.FName);
    reset(datei);
    if ioresult<>0 then ok:=4   // file not found
    else with E do begin
        ok:=1;

        // Import excitation wavelengths
        z:=1;
        repeat
            if z=ex_line then import_EEM_header(datei, n, ex, em_col);
            readln(datei);
            inc(z);
        until eof(datei) or (z>header_l);
        N_ex:=n;   // set number of excitation wavelengths
        if N_ex<3 then begin
            ok:=2;
            error_msg:='ERROR: could not read excitation wavelengths from file '
                       + Fname ;
            end
        else begin
            // Import emission wavelengths
            z:=1;
            repeat
                import_ASCII_line(datei, em[z], n, dummy, header_c, em_col);
                inc(z);
            until eof(datei) or (z>MaxChannels);
            N_em:=z-2;
            if N_em<3 then begin
                ok:=3;
                error_msg:='ERROR: could not read emission wavelengths from file '
                       + Fname ;
                end;
            end;
        CloseFile(datei);
        end;
    import_wavelengths_EEM:=ok;
    {$i+}
    end;

procedure EEM_to_image(var E: EEMatrix);
{ Prepare visualisation of excitation-emission-matrix E. }
var x, z : integer;
begin
with E do begin
        // Adjust image settings for display
        Width_in :=E.N_ex;
        Height_in:=E.N_em;
        Channels_in:=1;
        Band_mask:=1;

        // Set parameters for RGB display
        SetLength(cube_HSI4, N_ex, N_em, 4);
        for z:=1 to N_em do
        for x:=1 to N_ex do begin
            cube_HSI4[x-1, N_em-z, 0]:=EEM[z,x];  // channel red
            cube_HSI4[x-1, N_em-z, 1]:=EEM[z,x];  // channel green
            cube_HSI4[x-1, N_em-z, 2]:=EEM[z,x];  // channel blue
            cube_HSI4[x-1, N_em-z, 3]:=EEM[z,x];  // channel mask
            end;
        Format_2D.create_mask;

        // Set cursor parameters for wavelength display
        flag_map:=TRUE;
        map_E0:=EEM[0,1];
        if N_ex>1 then map_dE:=(EEM[0,N_ex]-EEM[0,1])/N_ex
            else flag_map:=FALSE;
        if N_em>1 then begin
            map_N0:=EEM[N_em,0];
            map_dN:=(EEM[1,0]-EEM[N_em,0])/N_em;
            end
        else flag_map:=FALSE;
     end;
     end;

procedure resample_EEM(var E: EEMatrix);
{ Resample imported EEM to actual wavelength grid.
  Optional improvement: Replace resampling by 2D interpolation. }
var tE     : EEMatrix;  // temporary EEM
    ix, iz : integer;   // channel numbers of imported EEM }
    ix0    : integer;   // first relevant channel number of imported EEM }
    c, r   : integer;   // column and row numbers of resampled EEM }
begin
    tE:=E;
    SetLength(tE.EEM, Channel_number+1, Channel_number+1);
    tE.N_ex:=Channel_number;
    tE.N_em:=Channel_number;
    tE.ex_FWHM:=dxb;
    tE.em_FWHM:=dxb;
    for r:=1 to Channel_number do tE.EEM[r,0]:=x^.y[r];   // set em wavelengths
    for c:=1 to Channel_number do tE.EEM[0,c]:=x^.y[c];   // set ex wavelengths
    ix:=1; while (E.ex[ix]<x^.y[1]) and (ix<E.N_ex) do inc(ix);
    iz:=1; while (E.em[iz]<x^.y[1]) and (iz<E.N_em) do inc(iz);
    ix0:=ix;

    for r:=1 to Channel_number do begin      // iterate matrix rows
        ix:=ix0;
        while (E.em[iz]<x^.y[r]) and (iz<E.N_em) do inc(iz);
        for c:=1 to Channel_number do begin  // iterate matrix columns
            while (E.ex[ix]<x^.y[c]) and (ix<E.N_ex) do inc(ix);
            if (ix>1) and (ix<E.N_ex) and (iz>1) and (iz<E.N_em) then
                tE.EEM[r,c]:=E.EEM[iz,ix]
                else tE.EEM[r,c]:=0;
            end;
        end;
    SetLength(E.EEM, Channel_number+1, Channel_number+1);
    E:=tE;
    end;

function import_ASCII_EEM(var E: EEMatrix):boolean;
{ Import excitation-emission matrix (EEM) in ASCII format.
  The EEM matrix must contain wavelength information in line and column headers. }
var  datei : textFile;
     ok    : byte;
     x, z  : integer;
     n     : integer;
     s     : spektrum;
     d     : double;
begin
//    ok:=import_wavelengths_EEM(E);
//  Import funktioniert unter Lazarus nicht!!!
    ok:=5;    // temporary setting until EEM import error is fixed
    if ok=1 then with E do begin
    SetLength(EEM, 1+N_em, 1+N_ex);
    {$i-}
    AssignFile(datei, E.FName);
    reset(datei);
    if ioresult<>0 then ok:=4
    else with E do begin
        ok:=1;
        for z:=1 to header_l do readln(datei);  // skip header

        // Import EEM data
        for z:=1 to N_em do begin
            import_ASCII_line(datei, d, n, s, header_c, em_col);
            for x:=1 to N_ex do EEM[z,x]:=s[x];
            end;
        CloseFile(datei);

        // Copy excitation and emission wavelenghts to EEM
        for x:=1 to N_ex do EEM[0,x]:=ex[x];
        for z:=1 to N_em do EEM[z,0]:=em[z];

        // Resample EEM to actual wavelength grid
        resample_EEM(E);

        // Calculate average bandwidth of excitation and emission wavelengths
        if N_ex>1 then ex_FWHM:=abs(ex[N_ex]-ex[1])/N_ex;
        if N_em>1 then em_FWHM:=abs(em[N_em]-em[1])/N_em;
        end;
    {$i+}
    end;
    if ok=4 then error_msg:='ERROR: File ' + E.Fname + ' not found';
    import_ASCII_EEM:=ok<3;
    end;



{ **************************************************************************** }
{ *****************           Sensor simulation               **************** }
{ **************************************************************************** }

procedure simulate_TOA_radiance;
{ Simulate upwelling radiance at top of atmosphere.
  Transmission of the atmosphere, tA, and path radiance, Lpath, are imported
  from file. For the DESIS simulations from 2018, they have been created using
  Modtran-6. }
var k : integer;
begin
    for k:=1 to Channel_Number do begin
        L_TOA.y[k]:=tA^.y[k]*Lu^.y[k] + Lpath.y[k];
        if L_TOA.y[k]>nenner_min then
            BOA_TOA.y[k]:=tA^.y[k]*Lu^.y[k]/L_TOA.y[k]
            else BOA_TOA.y[k]:=0;
        end;
    L_TOA.ParText:='TOA radiance [mW m^-2 nm^-1 sr^-1]';
    BOA_TOA.ParText:='Transmitted BOA radiance relative to TOA radiance';
    end;

procedure simulate_sensor_signal(t:double);
{ Simulate sensor signal [DN] for integration time t }
var k        : integer;
    variance : double;
    a, b     : double;
    Name     : string;
    Ziffer   : string;
begin
    calc_Lu;
    simulate_TOA_radiance;

    // Select variance of the chosen operation mode,
    // which is defined by the response file.
    // Note: these settings are specific for DESIS.
    a:=0; b:=0;
    Name:=ExtractFileName(resp.FName);
    k:=1; repeat inc(k); until (Name[k] in ['0'..'9']) or (k>length(Name));
    Ziffer:=Name[k];
    if Name[k+1] in ['0'..'9'] then Ziffer:=Ziffer+Name[k+1];
    case StrToInt(Ziffer) of
        1:  begin a:=1; b:=0.0038; end;  // mode LG1
        2:  begin a:=0; b:=0.0083; end;  // mode LG2
        5:  begin a:=0; b:=0.0224; end;  // mode HG5;  offset -2 ignored
        10: begin a:=0; b:=0.0432; end;  // mode HG10; offset -5 ignored
        end;

    for k:=1 to Channel_Number do begin
        signal.y[k]:=t*resp.y[k]*L_TOA.y[k];   // calculate signal [DN]
        variance:=a + b*signal.y[k];           // calculate variance [DN^2]
        if variance<0 then variance:=0;
        NEL.y[k]:=sqrt(variance)/resp.y[k]/t;  // calculate NEL
        if variance>Nenner_min then begin      // calculate SNR
            SNR_TOA.y[k]:=signal.y[k]/sqrt(variance);   // ... at TOA
            SNR_BOA.y[k]:=Lu^.y[k]/NEL.y[k];            // ... at BOA
            end
        else begin
            SNR_TOA.y[k]:=0;
            SNR_BOA.y[k]:=0;
            end;
        if SNR_BOA.y[k]>Nenner_min then        // calculate noise equivalent Rrs
            noiseS^.y[k]:=r_rs^.y[k]/SNR_BOA.y[k]
        else noiseS^.y[k]:=0;
        end;
    signal.ParText  :='Signal [DN]';
    NEL.ParText     :='Noise equivalent radiance [mW m^-2 nm^-1 sr^-1]';
    noiseS^.ParText :='Noise equivalent radiane reflectance [sr^-1]';
    SNR_TOA.ParText :='SNR at top of atmosphere';
    SNR_BOA.ParText :='SNR at bottom of atmosphere';
    end;

procedure calc_DESIS;
{ In order to study the parameter dependency of DESIS related spectra,
  parameter iteration has been implemented for the relevant spectra.
  Analogously to the spectra that can be selected in the main window of WASI,
  the parameter dependency of these spectra can be simulated in the forward mode
  for very flexible settings of many model parameters. }
var k : integer;
begin
    simulate_sensor_signal(1);
    case test_spec of  // Parameter 'test_spec' is set in PRIVATE.INI
        1: begin   // Upwelling radiance top of atmosphere
               for k:=1 to Channel_number do STest^.y[k]:=L_TOA.y[k];
               STest^.ParText:=L_TOA.ParText;
               end;
        2: begin  // Transmitted BOA radiance relative to TOA radiance
               for k:=1 to Channel_number do STest^.y[k]:=BOA_TOA.y[k];
               STest^.ParText:=BOA_TOA.ParText;
               end;
        3: begin  // Simulated sensor signal
               for k:=1 to Channel_number do STest^.y[k]:=signal.y[k];
               STest^.ParText:=signal.ParText;
               end;
        4: begin  // Noise-equivalent radiance
               for k:=1 to Channel_number do STest^.y[k]:=NEL.y[k];
               STest^.ParText:=NEL.ParText;
               end;
        5: begin  // SNR at top of atmosphere
               for k:=1 to Channel_number do STest^.y[k]:=SNR_TOA.y[k];
               STest^.ParText:=SNR_TOA.ParText;
               end;
        6: begin  // SNR at bottom of atmosphere
               for k:=1 to Channel_number do STest^.y[k]:=SNR_BOA.y[k];
               STest^.ParText:=SNR_BOA.ParText;
               end;
        7: begin  // Noise equivalent radiance reflectance
               for k:=1 to Channel_number do STest^.y[k]:=noiseS^.y[k];
               STest^.ParText:=noiseS^.ParText;
               end;
        end;
    YText:=STest^.ParText;
    end;

{ *************************************************************************** }

procedure Select_imgFit(Sender: TObject);         // Select fit image
{ Load graphic file or hyperspectral image from file for preview. }
var   FileExt        : string[4];
      temp_Ascaled   : boolean;
begin
    if flag_preview then begin   // Only 1 preview permitted
        Format_2D.close;
        Form_2D_Info.close;
        end;
    Form1.OpenDialog_HSI.FileName:=HSI_img^.FName;
    Form1.OpenDialog_HSI.InitialDir:=ExtractFileDir(HSI_img^.FName);
    Form1.OpenDialog_HSI.Filter := 'Fit results (*.fit)|*.fit|';
    Form1.OpenDialog_HSI.FilterIndex := 1;
    Form1.OpenDialog_HSI.Title := 'Load fit image';
    if Form1.OpenDialog_HSI.Execute then begin
        YText:='';
        {
        x_flag    := flag_x_file;
        fwhm_flag := flag_fwhm;
        x_FName   := x^.FName;
        x_Header  := x^.Header;
        x_Xcol    := x^.XColumn;
        x_Ycol    := x^.YColumn;
        }
        HSI_img^.FName:=Form1.OpenDialog_HSI.Filename;
        FileExt:=AnsiUpperCase(ExtractFileExt(HSI_img^.FName));
        Format_2D:= TFormat_2D.Create(Application);   { Ausgabefenster erzeugen }
        Format_2D.Caption:=ExtractFilename(HSI_img^.FName);
        Form_2D_Info:=TForm_2D_Info.Create(Application);

      {  flag_map:=FALSE;   }
        if flag_ENVI then Format_2D.Read_Envi_Header(HSI_img^.FName);
        if (frame_max>=Height_in) or (pixel_max>=Width_in) then begin
            frame_min:=0; frame_max:=0;
            pixel_min:=0; pixel_max:=0;
            flag_use_ROI:=FALSE;
            end;
        Format_2D.FormCreate(Sender);
     {   Form_2D_Info.FormCreate(Sender);  }
        if (FileExt='.FIT') then y_scale:=1;
  //      Format_2D.import_RGB;
  //      Format_2D.load_RGB(Sender);
        Format_2D.create_RGB(0, Height_in-1);
        Format_2D.PreviewHSI(Width_in, Height_in);
    //    flag_panel_fw:=FALSE;                         { activate inverse mode }

        temp_Ascaled:=Application.Scaled;
        Application.Scaled:=FALSE;
        Format_2D.Show;            // ERROR: Lazarus changes here window size
        flag_preview:=TRUE;
        Application.Scaled:=temp_Ascaled;
        end;
    end;

procedure create_HSI_from_fit(fit_img: string);
var x, f, c       : longInt;
begin
    Output_HSI:=ChangeFileExt(fit_img, '.TMP');
    Channels_out:=Channels_in;
    SetLength(cube_fitpar, Width_in, Height_in, Channels_out);
(*
 { loop over frames = image lines }
 f:=1;                                      // Set f to first processed image line
 repeat
     x:=1;                                  // Set x to first processed image column
     { loop over pixels = image columns }
     repeat
         HSI_img^.FName:=First;
         Format_2D.extract_spektrum(spec[1]^, x, f, Sender);  // Read first spectrum
         HSI_img^.FName:=Second;
         Format_2D.extract_spektrum(spec[2]^, x, f, Sender);  // Read second spectrum
         for c:=1 to Channels_out do cube_fitpar[x,f,c-1]:=spec[2]^.y[c]-spec[1]^.y[c];
         inc(x);
     until (x>=Width_in) or ABBRUCH;
     inc(f);
 until (f>=Height_in) or ABBRUCH;

 Format_2D.Write_Fitresult(Height_in-1);
 Format_2D.Write_Envi_Header(Output_HSI);      *)
    end;

procedure Correct_HSI(Sender: TObject);
{ Correct hyperspectral image. }
var  img_fit : string;
begin
    Select_imgFit(Sender);         // Load image with fit parameters
    img_fit:=HSI_img^.FName;
    create_HSI_from_fit(img_fit);
    end;

{ ************************************************************************************************ }

procedure get_sensorfile_infos(b: integer; s: string);
var j : integer;
    p : string;
begin
if length(s)>1 then begin
    Sensor_name[b]:='';
    j:=1;
    repeat
        Sensor_name[b]:=Sensor_name[b] + s[j];
        inc(j);
    until (s[j]=#9) or (j>=length(s));
    Sensor_name[b]:=trim(Sensor_name[b]);     // delete white spaces in sensor name

    Sensor_file[b]:='';
    repeat
        Sensor_file[b]:=Sensor_file[b] + s[j];
        inc(j);
    until (s[j]=#9) or (j>=length(s));
    Sensor_file[b]:=trim(Sensor_file[b]);     // delete white spaces in sensor file name

    p:='';
    repeat
        p:=p + s[j];
        inc(j);
    until (s[j]=#9) or (j>=length(s));
    Sensor_head[b]:=StrToInt(p);

    p:='';
    repeat
        p:=p + s[j];
        inc(j);
    until (s[j]=#9) or (j>=length(s));
    Sensor_band[b]:=StrToInt(p);

    p:='';
    repeat
        p:=p + s[j];
        inc(j);
    until (s[j]=#9) or (j>=length(s));
    Sensor_center[b]:=StrToInt(p);

    p:='';
    repeat
        p:=p + s[j];
        inc(j);
    until (s[j]=#9) or (j>=length(s));
    Sensor_fwhm[b]:=StrToInt(p);

    p:='';
    repeat
        p:=p + s[j];
        inc(j);
    until (s[j]=#9) or (j>=length(s));
    if length(p)>1 then Sensor_NEL[b]:=StrToInt(p);

    end;
    end;

procedure read_sensor_names;
var f     : text;
    i     : integer;
    path  : string;
    line  : string;
begin
    {$i-}
    path:=path_exe + 'data\';
    AssignFile(f, path+Sensor_list);
    reset(f);
    for i:=1 to 4 do readln(f);   // skip header
    path:=path + 'sensors\';
    i:=0;
    repeat
        inc(i);
        readln(f, line);
        get_sensorfile_infos(i, line);
        Sensor_file[i]:=path + Sensor_file[i];
    until (i>=Sensor_max) or (length(Sensor_name[i])<2) or eof(f);
    Sensor_N:=i;    // number of sensors
    CloseFile(f);
    {$i+}
    end;


procedure set_sensor;
begin
    if Sensor_act>0 then begin
        flag_x_file:=TRUE;
        x^.FName:=Sensor_file[Sensor_act];
        x^.Header:=Sensor_head[Sensor_act];
        if Sensor_center[Sensor_act]>0 then x^.XColumn:=Sensor_center[Sensor_act];
        if Sensor_fwhm[Sensor_act]>0   then begin
            flag_FWHM:=TRUE;
            x^.YColumn:=Sensor_fwhm[Sensor_act];
            end;
        end
    else flag_x_file:=FALSE;
    read_spectra;
    resample;
    delete_calculated_spectra;
    end;


end.


