unit defaults;

{$MODE Delphi}
{ $DEFINE private_version}                                { Activate for private version }

{ Settings, global constants and global parameters of program WASI. }

interface



uses LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

const ProgramInfo  = 'WASI - Water color simulator';
      vers: string = 'Version 5.2 - Latest update: 19 April 2020';
      flag_public  : boolean = TRUE;                     { public version of WASI? }
      INI_public   = 'WASI5_2.INI';                      { File with public default values }
      INI_private  = 'private\PRIVATE.INI';              { File with private default values }
      MaxChannels  = 1300;                               { Max. number of spectral channels }
      M1           = 50;                                 { Max. number of fit parameters }
      FC           = 4;                                  { Max. number of fit curves }

type  spektrum     = array[1..MaxChannels]of double;     { Spectral data }
      spec_types   = (S_Ed_GC, S_Lup, S_rrs, S_R,        { Types of spectra }
                       S_Rsurf, S_a, S_Kd, S_Rbottom,
                       S_test, S_Ed_Gege);

      param = record                                     { fit variables }
          c        : array[1..M1]of double;              { fit parameters }
          step_c   : array[1..M1]of double;              { initial steps }
          cmin     : array[1..M1]of double;              { minimum allowed }
          cmax     : array[1..M1]of double;              { maximum allowed }
          fit      : array[1..M1]of byte;                { fitted? 0=no, 1=yes }
          map      : array[1..M1]of byte;                { used for mapping  }
          name     : array[1..M1]of string;              { parameter name }
          desc     : array[1..M1]of string;              { parameter description }
          end;

      Attr_spec = record                                 { Spectral data files }
          ParText  : String;                             { Parameter name and units }
          FName    : String;                             { File name }
          Header   : integer;                            { Header lines }
          XColumn  : byte;                               { Column with x-values }
          YColumn  : byte;                               { Column with y-values }
          y        : spektrum;                           { Spectral data }
          sim      : boolean;                            { Simulated spectrum? }
          avg      : double;                             { Average from Lmin to Lmax }
          end;

     Fitparameters = record
           fw      : double;                             { value in forward model }
           default : double;                             { default value for invers model }
           actual  : double;                             { actual value in invers model }
           min     : double;                             { minimum value of fit }
           max     : double;                             { maximum value of fit }
           f_step  : double;                             { initial step of fit }
           f_err   : double;                             { allowed error of fit parameter }
           fit     : byte;                               { used as fit variable? (1=YES) }
           sv      : byte;                               { save in reconstruction mode? (1=YES) }
           merk    : double;                             { save fitparameters? }
           merkFw  : double;                             { save parameters of forward mode? }
           merkFit : byte;                               { save parameters of inverse mode? }
           active  : boolean;                            { active? }
           end;

{ **************************************************************************** }
{ ***********               Settings of WASI.INI                   *********** }
{ **************************************************************************** }

var   { Input spectra specified in WASI.INI }
      x            : ^Attr_spec;                         { x-values (wavelengths) }
      FWHM         : ^Attr_spec;                         { Spectral resolution }
      offsetS      : ^Attr_spec;                         { Measurement offset spectrum }
      scaleS       : ^Attr_spec;                         { Measurement scale spectrum }
      noiseS       : ^Attr_spec;                         { Measurement noise spectrum }
      E0           : ^Attr_spec;                         { Extraterrestrial solar irradiance }
      aO2          : ^Attr_spec;                         { Absorption coefficient of oxygen }
      aO3          : ^Attr_spec;                         { Absorption coefficient of ozone }
      aWV          : ^Attr_spec;                         { Absorption coefficient of water vapor }
      a_ice        : Attr_spec;                          { Absorption coefficient of pure ice }
      aW           : ^Attr_spec;                         { Absorption coefficient of pure water }
      dadT         : ^Attr_spec;                         { Temperature gradient of water absorption coefficient }
      aP           : array[0..5]of ^Attr_spec;           { Specific absorption coefficient of phytoplankton }
      aNAP         : ^Attr_spec;                         { Specific absorption coefficient of NAP non-algal particles) }
      aY           : ^Attr_spec;                         { Specific absorption coefficient of CDOM }
      bPhyN        : ^Attr_spec;                         { Normalized scattering coefficient of phytoplankton }
      bXN          : ^Attr_spec;                         { Normalized scattering coefficient of particles type I }
      albedo       : array[0..5]of ^Attr_spec;           { Bottom albedo spectra }
      a_nw         : ^Attr_spec;                         { Albedo of non-water area }
      meas         : ^Attr_spec;                         { Measured spectrum }
      R            : ^Attr_spec;                         { Irradiance reflectance }
      Ed           : ^Attr_spec;                         { Downwelling irradiance }
      Ls           : ^Attr_spec;                         { Sky radiance }
      Kd           : ^Attr_spec;                         { Diffuse attenuation for downwelling irradiance }
      gew          : ^Attr_spec;                         { Weight factors for inversion }
      HSI_img      : ^Attr_spec;                         { Hyperspectral image }
      file_LUT     : array[1..2]of string;               { Lookup tables }

const { Files and directories specified in WASI.INI}
      Name_LdBatch : String = 'd:\frei\*.fwd';           { Spectra inverted in batch mode }
      DIR_saveFwd  : String = 'd:\frei';                 { Directory for saving forward calculations }
      DIR_saveInv  : String = 'd:\frei';                 { Directory for saving invers calculations }
      DIR_saveFit  : String = 'd:\frei';                 { Directory for saving image fits }

      { General settings and parameters specified in WASI.INI }
      MinX         : integer = 100;                      { lowest  x-value allowed for data import and calculation }
      MaxX         : integer = 1000;                     { highest x-value allowed for data import and calculation }
      MinDX        : double = 0.1;                       { lowest dx-value allowed for calculation }
      MinY         : double = -100;                      { lowest  y-value allowed for display }
      MaxY         : double = 100000;                    { highest y-value allowed for display }

      xu           : double = 395.0;                     { lowest x-coordinate displayed }
      xo           : double = 905.0;                     { highest x-coordinate displayed }
      yu           : double = 0.0;                       { lowest y-coordinate displayed }
      yo           : double = 3.0;                       { highest y-coordinate displayed }
      xub          : double = 300.0;                     { lowest x-coordinate calculated }
      xob          : double = 950.0;                     { highest x-coordinate calculated }
      dxb          : double = 1.0;                       { wavelength interval for calculation }
      dsmpl        : integer = 1;                        { resampling distance (channels); 0 = no resampling }
      dxs          : integer = 2;                        { interval for saving data (channels) }
      FWHM0        : single = 3.0;                       { spectral resolution (nm) }
      FWHM0_min    : single = 1.0;                       { lowest allowed spectral resolution (nm) }
      FWHM0_max    : single = 50.0;                      { highest allowed spectral resolution (nm) }
      dotsize      : word = 3;                           { size of plotted dots }
      dotMaxN      : word = 100;                         { max. number of data points to plot dots }
      PopupDirW    : integer = 600;                      { width of popup window 'directories' }
      Ed_factor    : double = 3.1415926;                 { multiplicator of E_down spectrum }
      E0_factor    : double = 0.10;                      { multiplicator of E0 spectrum }
      Rrs_factor   : double = 0.319;                     { multiplicator of R_rs spectrum }
      spec_type    : spec_types = S_Rrs;                 { type of spectrum:
                                                           0 = E_d
                                                           1 = L_up
                                                           2 = R_rs
                                                           3 = R
                                                           4 = R_surf
                                                           5 = a
                                                           6 = K_d
                                                           7 = R_bottom
                                                           8 = Test
                                                           9 = Ed_Gege }
      Model_Ed     : byte = 1;                           { Ed model:
                                                           0 = without separation direct / diffuse
                                                           1 = with separation direct / diffuse }
      Model_R      : byte = 0;                           { R model: 0 = Gordon, 1 = Prieur }
      Model_R_rsA  : byte = 0;                           { R_rs model above water surface:
                                                           0 = function of R_rs(0-)
                                                           1 = function of R
                                                           2 = function of both }
      Model_R_rsB  : byte = 0;                           { R_rs model below water surface:
                                                           0 = f_rs * bb / (a+bb)
                                                           1 = f_rs * bb / a
                                                           2 = R / Q }
      Model_f      : byte = 4;                           { f model:
                                                           0 = const.
                                                           1 = Kirk (1984)
                                                           2 = Morel & Gentili (1991)
                                                           3 = Sathyendranath + Platt (1997)
                                                           4 = Albert & Mobley (2003) }
      Model_f_rs   : byte = 0;                           { f_rs model:
                                                           0 = Albert & Mobley (2003)
                                                           1 = f / Q }
      Model_Kdd    : byte = 0;                           { K_dd model:
                                                           0 = Gege (2012)
                                                           1 = Grötsch (Diploma thesis }
      bottom_fill  : ShortInt = -1;                      { bottom surface type adjusted to yield sum weights = 1}
      clPlotBk     : TColor = $00E1FFFF;                 { color of plot background }
      clMaskImg    : TColor = $00000000;                 { color of image mask }

      { Flags specified in WASI5.INI: 0 = FALSE, 1 = TRUE }
      flag_SubGrid   : boolean = FALSE;                  { draw subgrid? }
      flag_Grid      : boolean = TRUE;                   { draw grid? }
      flag_Dots      : boolean = TRUE;                   { draw dots? }
      flag_Autoscale : boolean = TRUE;                   { autoscale plot? }
      flag_showFile  : boolean = TRUE;                   { display filename? }
      flag_showPath  : boolean = FALSE;                  { display path? }
      flag_leg_left  : boolean = FALSE;                  { Adjust parameter legend left }
      flag_leg_top   : boolean = TRUE;                   { Adjust parameter legend top }
      flag_INI       : boolean = FALSE;                  { save INI file automatically? }
      flag_sv_table  : boolean = FALSE;                  { save forward-spectra as table? }
      flag_save_t    : boolean = TRUE;                   { save calculation time? }
      flag_mult_Ed   : boolean = TRUE;                   { multiply E_down with Ed_factor? }
      flag_mult_E0   : boolean = TRUE;                   { multiply E0 with E0_factor? }
      flag_mult_Rrs  : boolean = TRUE;                   { multiply R_rs with Rrs_factor? }
      flag_x_file    : boolean = FALSE;                  { read x-values from file? }
      flag_fwhm      : boolean = FALSE;                  { use sensor resolution? }
      flag_read_day  : boolean = FALSE;                  { Read day of year angle from file? }
      flag_read_sun  : boolean = FALSE;                  { Read sun zenith angle from file? }
      flag_read_view : boolean = FALSE;                  { Read viewing angle from file? }
      flag_read_dphi : boolean = FALSE;                  { Read azimuth difference between sun and viewing angle from file? }
      flag_sun_unit  : boolean = TRUE;                   { sun zenith angle in deg? }
      Par1_log       : boolean = FALSE;                  { Parameter 1 of batch mode: logarithmic? }
      Par2_log       : boolean = FALSE;                  { Parameter 2 of batch mode: logarithmic? }
      Par3_log       : boolean = FALSE;                  { Parameter 3 of batch mode: logarithmic? }
      flag_batch     : boolean = TRUE;                   { batch mode (including forward mode)? }
      flag_bunt      : boolean = TRUE;                   { change color when calculating a series of spectra }
      flag_b_SaveFwd : boolean = FALSE;                  { save all spectra of forward mode? }
      flag_b_SaveInv : boolean = FALSE;                  { save all spectra of invers mode? }
      flag_b_LoadAll : boolean = FALSE;                  { batch mode: load all spectra? }
      flag_b_Reset   : boolean = FALSE;                  { batch mode: reset start values? }
      flag_b_Invert  : boolean = FALSE;                  { batch mode: invert spectra? }
      flag_avg_err   : boolean = TRUE;                   { reconstruction mode: save average errors? }
      flag_multi     : boolean = FALSE;                  { multiple spectra in single file? }
      flag_Res_log   : boolean = FALSE;                  { weight residuals logarithmically? }
      flag_Y_exp     : boolean = TRUE;                   { exponential Gelbstoff absorption? }
      flag_surf_inv  : boolean = TRUE;                   { wavelength dependent surface reflections? }
      flag_surf_fw   : boolean = TRUE;                   { wavelength dependent surface reflections? }
      flag_fluo      : boolean = TRUE;                   { include fluorescence of chl-a }
      flag_MP        : boolean = FALSE;                  { apply melt pond models }
      flag_use_Ed    : boolean = TRUE;                   { make use of Ed measurement }
      flag_use_Ls    : boolean = FALSE;                  { make use of Ls measurement }
      flag_use_R     : boolean = TRUE;                   { make use of R measurement }
      flag_radiom    : boolean = FALSE;                  { reduce radiometric resolution }
      flag_offset    : boolean = FALSE;                  { add measurement offset }
      flag_offset_c  : boolean = FALSE;                  { offset is constant }
      flag_scale     : boolean = FALSE;                  { add measurement scale }
      flag_scale_c   : boolean = FALSE;                  { scale is constant }
      flag_noise     : boolean = FALSE;                  { add measurement noise }
      flag_noise_c   : boolean = TRUE;                   { noise is constant? }
      flag_Tab       : boolean = FALSE;                  { only TAB (#9) separates columns }
      flag_aW        : boolean = TRUE;                   { include pure water absorption in a-modeling }
      flag_above     : boolean = TRUE;                   { above water }
      flag_shallow   : boolean = FALSE;                  { shallow water }
      flag_L         : boolean = TRUE;                   { type of bottom reflectance (0: albedo, 1: radiance reflectance) }
      flag_autoiniR  : boolean = TRUE;                   { automatic determination of R start values }
      flag_anX_R     : boolean = TRUE;                   { analytic X start value for R spectra in deep waters }
      flag_anX_Rsh   : boolean = TRUE;                   { analytic X start value for R spectra in shallow waters }
      flag_anCY_R    : boolean = TRUE;                   { analytic C, Y start values for R spectra }
      flag_anzB      : boolean = TRUE;                   { analytic zB start value }
      flag_Fresnel_view : boolean = true;                { calculate Fresnel reflectance for viewing angle }
      flag_bX_file   : boolean = TRUE;                   { scattering coeff. of particles Type I from file }
      flag_bX_linear : boolean = TRUE;                   { scattering coeff. of particles Type I linear with C_L }
      flag_CXisC0    : boolean = FALSE;                  { set C_X = C[0] }
      flag_norm_NAP  : boolean = TRUE;                   { normalise NAP spectrum from file }
      flag_norm_Y    : boolean = TRUE;                   { normalise CDOM spectrum from file }

      { Settings for batch mode }
      iter_type      : integer = 2;                      { which parameter is iterated: see list of Par3_Type }
      rangeMin       : single = 0.0;                     { First value of successive calculation }
      rangeMax       : single = 10.0;                    { Last value of successive calculation }
      rangeDelta     : single = 1.0;                     { Interval of successive calculation }
      Par1_Type      : integer = 1;                      { Parameter 1 of batch mode: }
      Par2_Type      : integer = 7;                      { Parameter 2 of batch mode: }
      Par3_Type      : integer = 0;                      { Parameter 3 of batch mode:
                                                           0  = none
                                                           1  = C[0]
                                                           2  = C[1]
                                                           3  = C[2]
                                                           4  = C[3]
                                                           5  = C[4]
                                                           6  = C[5]
                                                           7  = C_X
                                                           8  = C_Mie
                                                           9  = C_Y
                                                           10 = S
                                                           11 = n
                                                           12 = T_W
                                                           13 = Q
                                                           14 = fluo
                                                           15 = rho_L
                                                           16 = rho_dd
                                                           17 = rho_ds
                                                           18 = beta
                                                           19 = alpha
                                                           20 = f_dd
                                                           21 = f_ds
                                                           22 = H_oz
                                                           23 = WV
                                                           24 = f
                                                           25 = z
                                                           26 = zB
                                                           27 = sun
                                                           28 = view
                                                           29 = dphi            - private
                                                           30 = fA[0]
                                                           31 = fA[1]
                                                           32 = fA[2]
                                                           33 = fA[3]
                                                           34 = fA[4]
                                                           35 = fA[5]
                                                           36 = bbs_phy
                                                           37 = g_dd
                                                           38 = g_dsr
                                                           39 = g_dsa
                                                           40 = delta_r         - private
                                                           41 = alpha_d         - private
                                                           42 = beta_d          - private
                                                           43 = gamma_d         - private
                                                           44 = delta_d         - private
                                                           45 = dummy           - private
                                                           46 = test            - private
                                                           47 = alpha_r -        - private
                                                           48 = beta_r  -        - private
                                                           49 = gamma_r -        - private
                                                           50 = f_nw }
      Par1_Min       : double = 0.0;                     { Parameter 1 of batch mode: Minimum }
      Par2_Min       : double = 0.0;                     { Parameter 2 of batch mode: Minimum }
      Par3_Min       : double = 0.0;                     { Parameter 3 of batch mode: Minimum }
      Par1_Max       : double = 10.0;                    { Parameter 1 of batch mode: Maximum }
      Par2_Max       : double = 10.0;                    { Parameter 2 of batch mode: Maximum }
      Par3_Max       : double = 10.0;                    { Parameter 3 of batch mode: Maximum }
      Par1_N         : integer = 11;                     { Parameter 1 of batch mode: Steps }
      Par2_N         : integer = 11;                     { Parameter 2 of batch mode: Steps }
      Par3_N         : integer = 11;                     { Parameter 3 of batch mode: Steps }
      ycol_max       : integer = 70;                     { Max. number of y columns }

      { Settings for inverse mode }
      fit_min      : array[1..FC]of double
                   = (400, 700, 400, 400);               { first wavelength that is fitted }
      fit_max      : array[1..FC]of double
                   = (800, 800, 800, 800);               { last wavelength that is fitted }
      fit_dL       : array[1..FC]of byte
                   = (1, 1, 1, 1);                       { wavelength interval of fit }
      MaxIter      : array[1..FC]of integer
                   = (100, 100, 100, 100);               { max. number of iterations }
      fitsh_min    : array[1..FC]of double
                   = (400, 700, 400, 400);               { Rsh: first wavelength that is fitted }
      fitsh_max    : array[1..FC]of double
                   = (800, 800, 500, 800);               { Rsh: last wavelength that is fitted }
      fitsh_dL     : array[1..FC]of byte
                   = (5, 5, 5, 1);                       { Rsh: wavelength interval of fit }
      MaxItersh    : array[1..FC]of integer
                   = (100, 100, 100, 100);               { Rsh: max. number of iterations }
      LambdaLf     : array[1..2]of double = (800, 900);  { wavelengths for C_L and f initialisation }
      dLambdaLf    : array[1..2]of double = (0, 0);      { wavelengths intervals for C_L and f initialisation }
      LambdaLsh    : double = 800;                       { wavelength for C_L initialisation in shallow water }
      dLambdaLsh   : double = 0;                         { wavelengths interval for C_L initialisation in shallow water}
      LambdaCY     : array[1..3]of double
                   = (412.5, 442.5, 430);                { wavelengths for C_P and Y initialisation }
      dLambdaCY    : array[1..3]of double = (0,0,0);     { wavelengths intervals for C_P and Y initialisation }
      LambdazB     : double = 650;                       { wavelength for zB initialisation }
      dLambdazB    : double = 50;                        { wavelength interval for zB initialisation }
      zB_inimin    : double = 0.1;                       { minimum during initial value determination of zB }
      CL_inimin    : double = 0.1;                       { minimum during initial value determination of C_L for shallow water }
      C0_inimin    : double = 0.1;                       { minimum during initial value determination of C[0] for shallow water }
      CY_inimin    : double = 0.01;                      { minimum during initial value determination of C_Y for shallow water }
      a_ini        : double = 5.0;                       { start value of absorption (C[0]+C_Y) for nested interval during initial determination }
      da_ini       : double = 1.0;                       { step of absorption (C[0]+C_Y) for nested interval during initial determination }
      delta_min    : double = 0.01;                      { threshold of spectrum change for nested intervals }
      SfA_min      : double = 0.5;                       { minimum sum of fA[i] }
      SfA_max      : double = 2;                         { maximum sum of fA[i] }
      res_max      : double = 9e-5;                      { maximum allowed residuum }
      res_mode     : byte = 0;                           { 0 = least squares,
                                                           1 = absolute differences,
                                                           2 = relative differences,
                                                           3 = spectral angle }

      { Model constants defined in WASI.INI }
      day          : integer = 100;                   { Day of year }
      T_W0         : double = 20.0;                   { Reference temperature of water in °C }
      nW           : double = 1.33;                   { Refractive index of water }
      Lambda_a     : double = 550;                    { Reference wavelength for aerosol optical thickness (nm) }
      Lambda_0     : single = 440.0;                  { Reference wavelength for Gelbstoff and detritus absorption }
      Lambda_L     : double = 550.0;                  { Reference wavelength for scattering of particles Type I }
      Lambda_S     : double = 500.0;                  { Reference wavelength for scattering of particles Type II }
      Lambda_f0    : double = 685.0;                  { Wavelength of chl-a fluorescence (nm) }
      Sigma_f0     : double = 10.6;                   { Stddev. of chl-a fluorescence (nm) }
      Q_a          : double = 0.5;                    { Portion of emitted fluorescence not reabsorbed within the cell }
      PAR_min      : integer = 400;                   { PAR range: lower boundary (nm) }
      PAR_max      : integer = 700;                   { PAR range: upper boundary (nm) }
      Lmin         : integer = 400;                   { Spectrum average: lower boundary (nm) }
      Lmax         : integer = 800;                   { Spectrum average: upper boundary (nm) }
      aNAP440      : double = 0.027;                  { Specific absorption coefficient of NAP (m^2/g) }

      bbW500       : double = 0.00111;                { Backscattering coefficient of pure water }
      bbX_A        : double = 0.0006;                 { Factor A in backscattering to concentration relationship }
      bbX_B        : double = -0.37;                  { Factor B in backscattering to concentration relationship }
      bb_ice       : double = 10;                     { Backscattering coefficient of ice (m^-1) }
      bb_X         : double = 0.0086;                 { spec. backsc. coeff. of particles Type I }
      bb_Mie       : double = 0.01;                   { spec. backsc. coeff. of particles Type II }
      b_X          : double = 0.45;                   { spec. scattering coeff. of particles Type I }
      b_Mie        : double = 0.3;                    { spec. scattering coeff. of particles Type II }
      rho0         : double = 0.05825;                { rho_ds polynomial: 0th order value }
      rho1         : double = 0.04405;                { rho_ds polynomial: 1st order value }
      rho2         : double = 0.1722;                 { rho_ds polynomial: 2nd order value }
      rho_Eu       : double = 0.54;                   { Reflection factor for upwelling irradiance }
      rho_Ed       : double = 0.03;                   { Reflection factor for downwelling irradiance }
      rho_Lu       : double = 0.02;                   { Reflection factor for upwelling radiance }
      dynamics     : double = 0.001;                  { radiometric resolution }
      offset_c     : double = 0.0001;                 { constant measurement offset }
      scale_c      : double = 1.0;                    { constant measurement scale factor }
      noise_std    : double = 0.0001;                 { noise level (standard deviation) }
      ldd          : double = 1.0;                    { path length factor of direct irradiance }
      ldda         : double = 0.0;                    { path length factor of direct irradiance }
      lddb         : double = 0.0;                    { path length factor of direct irradiance }
      lds0         : double = 1.139;                  { path length factor of diffuse irradiance }
      lds1         : double = 0.5715;                 { path length factor of diffuse irradiance }
      ld           : double = 1.0546;                 { path length factor for Ed }
      ldd_ice      : double = 1.0;                    { Relative path length of direct radiation in ice }
      Q_ice_p      : double = 6.3;                    { Anisotropy factor of downwelling radiation at top of ice layer }
      Q_ice_m      : double = 1.68;                   { Anisotropy factor of downwelling radiation at bottom of ice layer }
      BRDF         : array[0..5]of double             { BRDF of bottom surface #n }
                   = (0.31, 0.31, 0.31, 0.31, 0.31, 0.31);

      { Parameters of 2D module defined in WASI.INI }
      flag_bk_2D     : boolean = FALSE;               { Invert 2D data in background mode (1=TRUE) }
      flag_3bands    : boolean = TRUE;                { Preview 3 bands / 1 band }
      flag_LUT       : boolean = TRUE;                { Use lookup table }
      flag_JoinBands : boolean = FALSE;               { Identical scaling for 3 preview bands }
      flag_ENVI      : boolean = TRUE;                { Read ENVI header file }
      flag_use_ROI   : boolean = FALSE;               { Analyse image for region of interest }
      flag_scale_ROI : boolean = FALSE;               { Scale image for region of interest }
      Width_in       : word = 500;                    { Input image width }
      Height_in      : word = 400;                    { Input image height }
      Channels_in    : word = 87;                     { Input image channels }
      Channels_out   : word = 1;                      { Output image channels }
      HSI_header     : word = 0;                      { Input image header bytes }
      frame_min      : word = 0;                      { First line of processed image }
      frame_max      : word = 0;                      { Last line of processed image; 0: all lines }
      pixel_min      : word = 0;                      { First column of processed image }
      pixel_max      : word = 0;                      { Last column of processed image; 0: all columns }
      band_R         : word = 11;                     { Preview band red }
      band_G         : word = 7;                      { Preview band green }
      band_B         : word = 2;                      { Preview band blue }
      band_mask      : word = 15;                     { Preview band of mask }
      interleave_in  : byte = 0;                      { Input image interleave: 0 = BIL, 1 = BSQ }
      interleave_out : byte = 0;                      { Output image interleave: 0 = BIL, 1 = BSQ }
      Datentyp       : byte = 2;                      { Input image data type:
                                                        1  = 8-bit  byte
                                                        2  = 16-bit signed integer
                                                        3  = 32-bit signed long integer
                                                        4  = 32-bit floating point
                                                        7  = text
                                                        12 = 16-bit unsigned integer }
      x_scale      : single = 1;                      { Scale factor of x-axis }
      y_scale      : single = 1;                      { Scale factor of y-axis }
      thresh_below : single  = 0.0;                   { Mask threshold min }
      thresh_above : single  = 0.001;                 { Mask threshold max }
      Plot2D_delta : integer = 10;                    { interval to plot spectrum }
      contrast     : single = 1.0;                    { Preview image contrast }
      Par0_Type    : integer = 26;                    { Preview parameter during inversion }
      Par0_Min     : double = 0.0;                    { Preview parameter min }
      Par0_Max     : double = 6.0;                    { Preview parameter max }
      N_avg        : integer = 15;                    { Averaged pixels for parameter initialization }

      { Model parameters defined in WASI.INI }
var   C            : array[0..5]of Fitparameters;     { Concentration of phytoplankton }
      C_X          : Fitparameters;                   { Concentration of suspended particles Type I }
      C_Mie        : Fitparameters;                   { Concentration of suspended particles Type II }
      bbs_phy      : Fitparameters;                   { Specific backscattering coefficient of phytoplankton (m^2/mg)}
      C_Y          : Fitparameters;                   { Gelbstoff absorption }
      S            : Fitparameters;                   { Gelbstoff exponent }
      n            : Fitparameters;                   { Angström exponent of particle scattering }
      T_W          : Fitparameters;                   { Water temperature (°C) }
      Q            : Fitparameters;                   { Q-factor (1/sr) }
      rho_dd       : Fitparameters;                   { reflection factor of Edd }
      rho_L        : Fitparameters;                   { Fresnel reflection at the water surface }
      rho_ds       : Fitparameters;                   { Reflectance factor of Eds }
      beta         : Fitparameters;                   { Turbidity coefficient }
      alpha        : Fitparameters;                   { Angström exponent of aerosol scattering }
      f_nw         : Fitparameters;                   { Fraction of non-water area }
      f_dd         : Fitparameters;                   { Fraction of direct irradiance }
      f_ds         : Fitparameters;                   { Fraction of diffuse irradiance }
      H_oz         : Fitparameters;                   { Ozone scale height }
      WV           : Fitparameters;                   { Precipitable water }
      f            : Fitparameters;                   { f-factor of R }
      z            : Fitparameters;                   { depth }
      zB           : Fitparameters;                   { bottom depth }
      sun          : Fitparameters;                   { sun zenith angle }
      view         : Fitparameters;                   { view zenith angle }
      dphi         : Fitparameters;                   { azimuth difference sun - view }
      fA           : array[0..5]of Fitparameters;     { bottom albedo fractions }
      fluo         : Fitparameters;                   { chl-a fluorescence quantum yield }
      g_dd         : Fitparameters;                   { Reflected fraction of sky irradiance due to direct solar radiation}
      g_dsr        : Fitparameters;                   { Reflected fraction of sky irradiance due to Rayleigh scattering }
      g_dsa        : Fitparameters;                   { Reflected fraction of sky irradiance due to aerosol scattering }
      dummy        : Fitparameters;                   { NOT USED }

{ **************************************************************************** }
{ ***********             Program internal settings                *********** }
{ **************************************************************************** }

const { Model constants }
      Lambda_R     : double = 534.10;                 { Scaling factor for Rayleigh scattering }
      Lambda_M     : double = 549.66;                 { Scaling factor for Mie scattering }
      T0           : double = 20.0;                   { Temperature of water absorption spectrum }

      { Constants of the shallow water model of Albert (2004) }
      fp1          : double = 0.1034;                 { f-parameter p1 }
      fp2          : double = 3.3586;                 { f-parameter p2 }
      fp3          : double = -6.5358;                { f-parameter p3 }
      fp4          : double = 4.6638;                 { f-parameter p4 }
      fp5          : double = 2.4121;                 { f-parameter p5 }
      frsp1        : double = 0.0512;                 { frs-parameter p1 }
      frsp2        : double = 4.6659;                 { frs-parameter p2 }
      frsp3        : double = -7.8387;                { frs-parameter p3 }
      frsp4        : double = 5.4571;                 { frs-parameter p4 }
      frsp5        : double = 0.1098;                 { frs-parameter p5 }
      frsp7        : double = 0.4021;                 { frs-parameter p7 }
      K1W          : double = 1.9991;                 { shallow water coefficient of KuW for R }
      K2W          : double = 0.2995;                 { shallow water coefficient of KuW for R }
      K1B          : double = 1.2441;                 { shallow water coefficient of KuB for R }
      K2B          : double = 0.5182;                 { shallow water coefficient of KuB for R }
      K1Wrs        : double = 3.5421;                 { shallow water coefficient of KuW for Rrs }
      K2Wrs        : double = -0.2786;                { shallow water coefficient of KuW for Rrs }
      K1Brs        : double = 2.2658;                 { shallow water coefficient of KuB for Rrs }
      K2Brs        : double = 0.0577;                 { shallow water coefficient of KuB for Rrs }
      A1           : double = 1.0546;                 { shallow water coefficient of R }
      A2           : double = 0.9755;                 { shallow water coefficient of R }
      A1rs         : double = 1.1576;                 { shallow water coefficient of Rrs }
      A2rs         : double = 1.0389;                 { shallow water coefficient of Rrs }

     { Constants of the irradiance model of Gregg & Carder (1990) }
      GC_M         : double = 1.15;                   { air mass }
      GC_P         : double = 1013.25;                { air pressure (mbar) }
      omega_a      : double = 1.13;                   { single scattering albedo }
      F_a          : double = 0.9;                    { aerosol forward scattering probability }
      H_a          : double = 1.0;                    { aerosol scale height (km) }
      AM           : byte = 1;                        { air mass type }
      RH           : double = 60;                     { relative humidity (%) }
      M_oz         : double = 1;                      { ozone path length (cm) }

const { Files and directories }
      CHANGES      : string = 'CHANGES.TXT';          { File with changing parameters }
      FITPARS      = 'FITPARS.TXT';                   { File with fitted parameters }
      FW_TABLE     : string = 'SPEC';                 { Filename of table with spectra in forward mode }
      SCREENSHOT   : string = 'WASI_plot.png';        { Filename of plot screenshot }
      WASI_IMG     : string = 'WASI_img.png';         { Filename of image screenshot }
      path_resampl = 'data\resample\';                { Path with resampled spectra }
      path_exe     : string = 'd:\wasi5\';            { Path of WASI.EXE }
      EXT_FWD      : String = 'fwd';                  { Extension of spectra from forward calculation }
      EXT_INV      : String = 'inv';                  { Extension of spectra from invers calculation }
      EXT_PAR      : String = 'par';                  { Extension of parameter file }
      ActualFile   : String = '';                     { Name of actual file }

     { File header info and data format }
      XText        : String = 'Wavelength (nm)';      { Text of x-axis }
      YText        : String = '';                     { Text of y-axis }
      line_sun     : integer = 10;                    { Line with sun zenith angle }
      col_sun      : integer = 5;                     { Column with sun zenith angle }
      line_day     : integer = 7;                     { Line with day of year }
      col_day      : integer = 2;                     { Column with day of year }
      line_view    : integer = 10;                    { Line with viewing angle }
      col_view     : integer = 5;                     { Column with viewing angle }
      line_dphi    : integer = 10;                    { Line with azimuth difference angle }
      col_dphi     : integer = 5;                     { Column with azimuth difference angle }


      { Constants for screen layout }
      GUI_scale    : double = 1;                      { Scale factor of GUI size }
      GUI_Height   : integer = 704;                   { Height of WASI GUI (pixels) }
      GUI_Width    : integer = 992;                   { Width of WASI GUI (pixels) }
      DX_par       : integer = 315;                   { Width of parameter panel (pixels) }
      DX_leg       : integer = 70;                    { Width of legend (pixels) }
      DX_right     : integer = 16;                    { Distance of right border (pixels) }
      DY_par       : integer = 552;                   { Height of parameter panel (pixels) }
      DY_Gege      : integer = 114;                   { Extra height for parameters of Gege's Ed model }
      DY_leg       : integer = 64;                    { Height of legend (pixels); is calcuated }
      DY_top       : integer = 48;                    { Distance of top border (pixels) }
      DY_modes     : integer = 170;                   { Height of modi panel(pixels); is calculated }
      DY_batch     : integer = 130;                   { Distance of fw mode panel(pixels) }
      DY_bottom    : integer = 6;                     { Distance of bottom border (pixels) }
      tu_ofs       : integer = 20;                    { Offset fuer Achsenbeschriftung unten }
      to_ofs       : integer = 6;                     { Offset fuer Achsenbeschriftung unten }
      tl_ofs       : integer = 40;                    { Offset fuer Achsenbeschriftung links }
      roh          = 8;                               { Rahmenoffset horizontal }
      rov          = 8;                               { Rahmenoffset vertikal }
      ZwischenX    = 5;                               { Zwischenstriche x-Achse }
      SIG          = 3;                               { signifikante Stellen }
      label_X      = 8;                               { length of x-labels }
      label_Y      = 6;                               { length of y-labels }
      Text_X       = 12;                              { distance of x-axis text }
      Text_y       = 10;                              { distance of x-axis text }

      { Constants used for program operation }
      N_spectypes  = 10;                              { number of spectrum types }
      MaxSpectra   = 130;                             { max. number of output spectra }
      p_Ed         : integer = 1;                     { percentage of remaining irradiance }
      nenner_min   = 1.0e-12;                         { avoid division by zero }
      exp_min      = -100;                            { lowest exponent }
      exp_max      = 30;                              { highest exponent }
      FWHM_sigma   = 2.355;                           { conversion FWHM --> sigma for Gauss curve }

var   { Model parameters calculated during run-time }
      Chl_a        : double;                          { Chlorophyll-a concentration }
      sun_earth    : double;                          { correction factor of E0 for sun-earth distance }
      I0           : double = 100;                    { Integral of solar constant }
      sz_cos       : double;                          { Cosine of sun zenith angle }

      { Parameters used for program operation }
      Nspectra     : integer = 0;                     { Number of output spectra }
      S_actual     : integer = 1;                     { actual no. of output spectrum }
      TimeCalc     : double = 0;                      { Calculation time in seconds }
      TimeStartCalc : TDateTime;                      { Start time of calculation }
      farbS        : array[1..MaxSpectra]of TColor;   { colours of spectra }
      c1           : double;                          { iterated parameter #1 }
      c2           : double;                          { iterated parameter #2 }
      c3           : double;                          { iterated parameter #3 }
      ABBRUCH      : boolean;                         { stop processing after ^C }

      { Parameters used for inverse mode }
      flag_Simpl_ini : boolean = TRUE;                { initialize Simplex? }
      fit_dk       : integer = 1;                     { difference between fitted channels }
      N_fit_bot    : integer = 0;                     { Number of bottom types which are fitted }
      NIter        : Integer;                         { number of iterations needed }
      Resid        : double;                          { residuum }
      SAngle       : double;                          { spectral angle }
      fileChanges  : text;
      fileFitpars  : text;
      ch_fit_min   : array[1..4]of integer;           { first channel that is fitted }
      ch_fit_max   : array[1..4]of integer;           { last channel that is fitted }
      FIT          : byte;                            { 1 = Ed (deep), a (shallow)
                                                        2 = r1_IR, Lup_IR
                                                        3 = r1_UV, Lup_UV
                                                        4 = r1, Lup, a }

      { Parameters used for analytic calculation of sensor depth for irradiance measurement}
      LambdaRN     : double = 680;                    { wavelength for ratio calculation; Nenner }
      LambdaRZ     : double = 800;                    { wavelength for ratio calculation; Zaehler }
      dLambdaRN    : double = 5;                      { wavelengths interval for ratio calculation: Nenner }
      dLambdaRZ    : double = 5;                      { wavelengths interval for ratio calculation: Nenner }

var   { Spectra calculated during run-time }
      xx           : ^Attr_spec;                      { temporary x-values }
      bbW          : ^Attr_spec;                      { Backscattering coefficient of pure water }
      bMie         : ^Attr_spec;                      { Scattering coeff. of particles type II }
      bbMie        : ^Attr_spec;                      { Backscattering coeff. of particles type II }
      GC_T_o2      : ^Attr_spec;                      { Transmittance of the atmosphere after oxygene absorption }
      GC_T_o3      : ^Attr_spec;                      { Transmittance of the atmosphere after ozone absorption }
      GC_T_wv      : ^Attr_spec;                      { Transmittance of the atmosphere after water vapor absorption }
      GC_tau_a     : ^Attr_spec;                      { Aerosol optical thickness }
      GC_T_r       : ^Attr_spec;                      { Transmittance of the atmosphere after Rayleigh scattering }
      GC_T_as      : ^Attr_spec;                      { Transmittance of the atmosphere after aerosol scattering }
      GC_T_aa      : ^Attr_spec;                      { Transmittance of the atmosphere after aerosol absorption }
      Ed0          : ^Attr_spec;                      { Downwelling irradiance just beneath water surface }
      GC_Edd       : ^Attr_spec;                      { Direct component of downwelling irradiance }
      GC_Eds       : ^Attr_spec;                      { Diffuse component of downwelling irradiance }
      GC_Edsr      : ^Attr_spec;                      { Diffuse component of Ed caused by Rayleigh scattering }
      GC_Edsa      : ^Attr_spec;                      { Diffuse component of Ed caused by aerosol scattering }
      r_d          : ^Attr_spec;                      { Ratio of direct to diffuse Ed component }
      Lu           : ^Attr_spec;                      { Upwelling radiance }
      Lr           : ^Attr_spec;                      { Radiance reflected from the surface }
      Lf           : ^Attr_spec;                      { Fluorescence radiance }
      Kdd          : ^Attr_spec;                      { Attenuation for direct downwelling irradiance }
      Kds          : ^Attr_spec;                      { Attenuation for diffuse downwelling irradiance }
      KE_uW        : ^Attr_spec;                      { attenuation of E reflected in water }
      KE_uB        : ^Attr_spec;                      { attenuation of E reflected at bottom }
      kL_uW        : ^Attr_spec;                      { attenuation of L reflected in water }
      kL_uB        : ^Attr_spec;                      { attenuation of L reflected at bottom }
      z_Ed         : ^Attr_spec;                      { depth at which p_Ed % of surface irradiance remains }
      r_rs         : ^Attr_spec;                      { Radiance reflectance }
      Rrs          : ^Attr_spec;                      { Remote sensing reflectance }
      Rrs_surf     : ^Attr_spec;                      { Surface reflectance }
      Rrsf         : ^Attr_spec;                      { Fluorescence radiance reflectance }
      f_R          : ^Attr_spec;                      { Scaling factor of irradiance reflectance  }
      f_rs         : ^Attr_spec;                      { Scaling factor of radiance reflectance  }
      Q_f          : ^Attr_spec;                      { Q derived from f_R and f_rs }
      bottom       : ^Attr_spec;                      { bottom albedo }
      a            : ^Attr_spec;                      { Absorption coefficient of water layer }
      b            : ^Attr_spec;                      { Scattering coefficient of water layer }
      bb           : ^Attr_spec;                      { Backscattering coefficient of water layer }
      a_calc       : ^Attr_spec;                      { calculated absorption spectrum }
      aP_calc      : ^Attr_spec;                      { calculated phytoplankton absorption }
      aNAP_calc    : ^Attr_spec;                      { calculated NAP absorption }
      aCDOM_calc   : ^Attr_spec;                      { calculated CDOM absorption }
      b_calc       : ^Attr_spec;                      { calculated scattering spectrum }
      bb_calc      : ^Attr_spec;                      { calculated backscattering spectrum }
      bb_phy       : ^Attr_spec;                      { phytoplankton backscattering coefficient }
      bb_NAP       : ^Attr_spec;                      { NAP backscattering coefficient }
      omega_b      : ^Attr_spec;                      { w_b = bb/(a+bb) or bb/a }
      Stest        : ^Attr_spec;                      { Test spectrum }

      // Spectra for simulation of meltponds
      MP_ro        : Attr_spec;                       { Reflectance of ocean under ice surface (sr^-1)}
      MP_RRo       : Attr_spec;                       { Reflectance of ocean above ice surface (sr^-1) }
      MP_ri        : Attr_spec;                       { Reflectance of ice in ice layer (sr^-1) }
      MP_ri_inf    : Attr_spec;                       { Reflectance of optically thick ice (sr^-1) }
      MP_RRi       : Attr_spec;                       { Reflectance of ice above ice layer (sr^-1) }
      MP_rp        : Attr_spec;                       { Reflectance of pond under water surface (sr^-1) }
      MP_RRp       : Attr_spec;                       { Reflectance of pond above water surface (sr^-1) }
      MP_tau_io    : Attr_spec;                       { Transmission of boundary ice - ocean }
      MP_tau_pi    : Attr_spec;                       { Transmission of boundary pond - ice }
      MP_tau_ap    : Attr_spec;                       { Transmission of boundary air - pond }
      MP_a_i       : Attr_spec;                       { Absorption coefficient of ice layer (m^-1)}
      MP_bb_i      : Attr_spec;                       { Backscattering coefficient of ice layer }
      MP_Kd_i      : Attr_spec;                       { Irradiance extinction coefficient for ice (m^-1) }
      MP_ku_i      : Attr_spec;                       { Radiance extinction coefficient for ice (m^-1) }
      MP_Td_i      : Attr_spec;                       { Irradiance transmission coefficient for ice }
      MP_tu_i      : Attr_spec;                       { Radiance transmission coefficient for ice }
      MP_p_ice     : Attr_spec;                       { Path length ratio in ice }
      MP_lds_ice   : Attr_spec;                       { Relative path length of diffuse radiation in ice }
      MP_Kd_p      : Attr_spec;                       { Irradiance extinction coefficient for melt pond (m^-1) }
      MP_ku_p      : Attr_spec;                       { Radiance extinction coefficient for melt pond (m^-1) }
      MP_Td_p      : Attr_spec;                       { Irradiance transmission coefficient for pond }
      MP_tu_p      : Attr_spec;                       { Radiance transmission coefficient for pond }
      MP_rp_inf    : Attr_spec;                       { Reflectance of optically thick pond (sr^-1) }
      MP_frsi      : Attr_spec;                       { Scaling factor of radiance reflectance of ice (sr^-1) }
      MP_fi        : Attr_spec;                       { Scaling factor of irradiance reflectance of ice }
      MP_ui        : Attr_spec;                       { Gordon's IOP of ice }
      MP_Qi        : Attr_spec;                       { Anisotropy factor of upwelling radiation in ice (sr) }


var   { Parameters required for reconstruction mode }
      acc_N        : integer;                         { Number of spectra in batch mode }
      acc_iter     : LongInt;                         { Number of iterations }
      acc_resid    : double;                          { sum of residuums }
      acc_fill     : double;                          { fill factor }
      acc_fills    : double;                          { sum of fill factors }
      acc_iterM    : LongInt;                         { maximum number of iterations }
      acc_residM   : double;                          { maximum sum of residuums }
      acc_fillM    : double;                          { fill factor }
      acc_fillsM   : double;                          { sum of fill factors }
      acc_fsum     : array[1..3]of double;            { Sum of forward calculated parameters in batch mode }
      acc_fmax     : array[1..3]of double;            { Maximum of forward calculated parameters in batch mode }
      acc_isum     : array[1..M1]of double;           { Sum of inverted parameters in batch mode }
      acc_imax     : array[1..M1]of double;           { Maximum of inverted parameters in batch mode }
      acc_esum     : array[1..M1]of double;           { Sum of relative errors }
      acc_emax     : array[1..M1]of double;           { Maximum of relative errors }

      { Parameters required for program operation }
      spec         : array[1..MaxSpectra]of ^Attr_spec;
      par          : param;                           { Model parameters of inverse mode }
      error_INI    : byte;                            { 0: ok, 1: file not found, 2:error }
      error_file   : byte;                            { 0: ok, 1: y constant, 2: <3 y-values, 3: error in file, 4: file not found }
      error_msg    : String;                          { error message }
      Channel_number : integer;                       { actual number of channels }
      xfile_xu     : single;                          { first x-value of x-file }
      xfile_xo     : single;                          { last x-value of x-file }
      xfile_dx     : single;                          { x-interval of x-file }

var   { Flags }
      flag_Legend       : boolean = TRUE;             { draw legend? }
      flag_clear        : boolean = TRUE;             { clear old plot? }
      flag_del_rsmpl    : boolean = FALSE;            { delete resampled spectra? }
      flag_Fresnel_sun  : boolean = TRUE;             { calculate Fresnel reflectance for sun angle? }
      flag_Background   : boolean = FALSE;            { Run program in background mode? }
      flag_loadFile     : boolean = FALSE;            { measurement imported from file? }
      flag_panel_fw     : boolean = TRUE;             { panel shows fw-values? }
      flag_calc_rho_ds  : boolean = TRUE;             { calculate rho_ds from sun zenith angle? }


{ **************************************************************************************** }
{ ***********             Program internal settings of 2D module               *********** }
{ **************************************************************************************** }

const { Constants of 2D module }
      ENVI_Keys    = 12;                              { Number of supported ENVI header keywords }
      name_progress = '/PROGRESS.TXT';                { File name of progress log file }

      { Constants for screen layout of 2D module }
      img_dX       : integer = 0;                     { x-position of image }
      img_dY       : integer = 0;                     { y-position of image }
      scale_dY     = 50;                              { height of scale and text }
      RGB_left     : integer = 60;                    { x-position of RGB label }
      RGB_top      : integer = 5;                     { y-position of RGB label }
      RGB_width    : integer = 150;                   { width of RGB label }
      RGB_height   : integer = 20;                    { height of RGB label }
      mean_R       : double = 0;                      { mean residuum }

type  { Type definitions of 2D module }
      line_bool    = array of boolean;
      line_byte    = array of byte;                   { data line,  data type #1 }
      line_int16   = array of smallInt;               { data line,  data type #2 }
      line_int32   = array of integer;                { data line,  data type #3 }
      line_single  = array of single;                 { data line,  data type #4 }
      line_word    = array of word;                   { data line,  data type #12 }
      frame_bool   = array of line_bool;
      frame_byte   = array of line_byte;              { data frame, data type #1 }
      frame_int16  = array of line_int16;             { data frame, data type #2 }
      frame_int32  = array of line_int32;             { data frame, data type #3 }
      frame_single = array of line_single;            { data frame, data type #4 }
      frame_word   = array of line_word;              { data frame, data type #12 }
      cube_single  = array of frame_single;           { hyperspectral data cube }

var   { Parameters of 2D module used during runtime }
      HSI_width    : qword;                           { Width of HSI image }
      Np_masked    : qword;                           { Number of masked pixels }
      Np_water     : qword;                           { Number of water pixels to be processed }
      cube_HSI4    : cube_single;                     { data cube of 4 bands (RGB, mask) }
      cube_fitpar  : cube_single;                     { result: fit parameters }

      HSI_byte     : line_byte;
      HSI_int16    : line_int16;
      HSI_int32    : line_int32;
      HSI_single   : line_single;
      HSI_word     : line_word;

      WaterMask    : frame_bool;                      { mask: FALSE = no water, TRUE = water }
      channel_R    : frame_byte;                      { preview: red channel }
      channel_G    : frame_byte;                      { preview: green channel }
      channel_B    : frame_byte;                      { preview: blue channel }
      x_FName      : String;                          { filename of wavelength file }
      x_flag       : boolean;                         { temporary flag_x_file }
      fwhm_flag    : boolean;                         { temporary flag_fwhm }
      bandname     : array[1..MaxChannels]of string;  { band names }
      dpX, dpF     : integer;                         { size of ROI }

      x_Header     : integer;
      x_Xcol       : byte;
      x_Ycol       : byte;
      max_R        : double;                          { maximum signal of red band }
      max_G        : double;                          { maximum signal of green band }
      max_B        : double;                          { maximum signal of blue band }

      lox, rux     : integer;                         { x-coordinates of selected rectangle }
      loy, ruy     : integer;                         { y-coordinates of selected rectangle }
      Output_HSI   : string;
      LUT_R, LUT_G, LUT_B : array[1..2, 0..255]of byte; { look up tables }
      flag_2D_inv  : boolean = FALSE;                 { invert HSI image? }
      flag_preview : boolean = FALSE;                 { preview image exists }
      flag_update_prv : boolean = FALSE;              { update preview image }
      flag_Plot2D  : boolean = TRUE;                  { plot actual spectrum }
      flag_map     : boolean = FALSE;                 { display geographical coordinates }
      flag_extract : boolean = FALSE;                 { spectrum 'spec' was extracted from image }
      flag_avg     : boolean = FALSE;                 { spectra 'spec' are averages of image pixels }
      flag_merk_batch : boolean = FALSE;
      flag_merk_b_Invert : boolean = FALSE;
      flag_merk_b_LoadAll : boolean = FALSE;
      flag_HSI_wv  : boolean = TRUE;                  { Channels of HSI image are wavelength }
      map_N0       : double = 0;                      { coordinate North of first pixel }
      map_E0       : double = 0;                      { coordinate East of first pixel }
      map_dN       : double = 0;                      { pixel size North }
      map_dE       : double = 0;                      { pixel size East }
      map_SIG      : integer = 3;                     { significant digits for coordinate display }
      map_info     : string = '';                     { map info }
      HSI_Stream   : TFileStream;                     { Hyperspectral image file }
      HSI_old      : string = '';                     { Filename of previously loaded image file }
      file_lambda  : string = 'lambda.txt';           { Wavelength file }
      ENVI_Keyword : array[1..ENVI_Keys]of string =   { Keywords of ENVI header file }
              ('samples',
               'lines',
               'bands',
               'header offset',
               'data type',
               'interleave',
               'wavelength units =',
               'wavelength =',
               'fwhm',
               'default bands',
               'map info',
               'band names');

      VIP_no       : integer = 26;                    { very important parameter number }
      VIP_min      : double = 1;                      { very important parameter initialization minimum }
      VIP_max      : double = 6;                      { very important parameter initialization maximum }

implementation
begin
    {$IFDEF private_version} flag_public:=FALSE;
    { $ELSE flag_MP:=FALSE; }
    {$ENDIF}
    end.
