unit Farbe;
{ Version vom 9.2.2020 }

{$mode delphi}

interface

uses  defaults, schoen_, fw_calc, Classes, SysUtils, FileUtil, Forms,
      Controls, Graphics, types, Dialogs, ExtCtrls, StdCtrls, LCLIntf, LCLType;

type

{ TRGB }

  TRGB = class(TForm)
          ColorXY  : TImage;
          Caption_x: TLabel;
          Caption_y: TLabel;
          horseshoe: TImage;
          Caption_contrast: TLabel;
          Caption_WASI: TLabel;
          Caption_hsv: TLabel;
          procedure FormCreate(Sender: TObject; DX, DY: word; flag_legend: boolean);
          procedure Preview(h,v: word; R,G,B: byte);
          procedure SavePanel;
          procedure SaveWindow;
          procedure ScaleColorXY(DX, DY: integer);
          procedure ScaleColorXY_old(DX, DY: integer);
          procedure Plot_xy(size:byte);
          procedure PlotHorseshoeColors;
          procedure calcShoeEdge;
          procedure LabelHorseshoe;
          procedure PlotShoeEdge;
          procedure SaveShoe;
          procedure TruecolorPanel_fromRrs(DX, DY : integer);
          procedure Write_Schuhrand(ku, ko : integer);
          procedure Write_Schuhrand_ticks(ku, ko : integer);
        private
        public
        end;

const eye_lmin : integer = 380;                  { human eye: shortest visible wavelength (nm) }
      eye_lmax : integer = 780;                  { human eye: longest visible wavelength (nm) }
      Text_h   : integer   = 15;
      Shoe_v0  : integer   = 300;                { Vertical size of chromaticity diagram (pixels) }
      Border_h : integer = 30;                   { Horizontal border of chromaticity diagram (pixels) }
      Border_v : integer = 30;                   { Vertical border of chromaticity diagram (pixels) }
      RGB_FileText : string = '';                { Clarifying text of output files }

var   RGB           : TRGB;
      ShoeEdge      : array[1..3]of Attr_spec;
      CIExyz        : array[1..3]of Attr_spec;
      CIEl          : array[1..MaxChannels]of integer;  { Wavelength conversion table for CIE }
      Shoe_h        : integer;
      Shoe_v        : integer;
      tri_X, tri_Y, tri_Z : double;              { trichromatic coordinates X, Y, Z }
      chroma_x      : double;                    { chromaticity coordinate x }
      chroma_y      : double;                    { chromaticity coordinate y }
      chroma_z      : double;                    { chromaticity coordinate z }
      chroma_R      : byte;                      { chromaticity coordinate Red }
      chroma_G      : byte;                      { chromaticity coordinate Green }
      chroma_B      : byte;                      { chromaticity coordinate Blue }
      chroma_H      : double;                    { chromaticity coordinate hue }
      chroma_S      : double;                    { chromaticity coordinate saturation }
      chroma_V      : double;                    { chromaticity coordinate value }
      mXYZ          : array[1..3,1..3]of double; { Matrix converting XYZ to RGB colors }


procedure Import_spectral_locus;
procedure Import_CIExyz;
procedure assign_CIE_wavelengths;
procedure chroma(flag_normalize, flag_c_adapt: boolean; size: byte);
procedure chromatic_adaptation;
procedure set_mXYZ;
procedure set_CMF;

implementation

uses privates, math, misc;

{$R *.lfm}

{ **************************************************************************** }
{ ****************           Outdated functions               **************** }
{ **************************************************************************** }

function x31_simple(l:double):double;
{ x-component of the color matching curve of the human eye for the
  CIE 1931 standard observer with 2° field of view. Analytic approximation:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1, e2 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-0.5*sqr((l-595.8)/33.33);
        e2:=-0.5*sqr((l-446.8)/19.44);
        x31_simple:=1.065*exp(e1)+0.366*exp(e2);
        end
    else x31_simple:=0;
    end;

function y31_simple(l:double):double;
{ y-component of the color matching curve of the human eye for the
  CIE 1931 standard observer with 2° field of view. Analytic approximation:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-0.5*sqr((ln(l)-ln(556.3))/0.075);
        y31_simple:=1.041*exp(e1);
        end
    else y31_simple:=0;
    end;

function z31_simple(l:double):double;
{ z-component of the color matching curve of the human eye for the
  CIE 1931 standard observer with 2° field of view. Analytic approximation:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-0.5*sqr((ln(l)-ln(449.8))/0.051);
        z31_simple:=1.839*exp(e1);
        end
    else z31_simple:=0;
    end;

function x64(l:double):double;
{ x-component of the color matching curve of the human eye for the
  CIE 1964 standard observer with 10° field of view. Analytic approximation:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1, e2 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-1250*sqr(ln((l+570.1)/1014));
        e2:=-234*sqr(ln((1338-l)/743.5));
        x64:=0.398*exp(e1)+1.132*exp(e2);
        end
    else x64:=0;
    end;

function y64(l:double):double;
{ y-component of the color matching curve of the human eye for the
  CIE 1964 standard observer with 10° field of view. Analytic approximation:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-0.5*sqr((l-556.1)/46.14);
        y64:=1.011*exp(e1);
        end
    else y64:=0;
    end;

function z64(l:double):double;
{ z-component of the color matching curve of the human eye for the
  CIE 1964 standard observer with 10° field of view. Analytic approximation:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-32*sqr(ln((l-265.8)/180.4));
        z64:=2.060*exp(e1);
        end
    else z64:=0;
    end;

function Heaviside(x:double):double;
begin
    if x<0 then Heaviside:=0 else Heaviside:=1;
    end;

function selector(x,y,z:double):double;
{ Selector function. See Wyman et al. 2013}
begin
    selector:=y*(1-Heaviside(x))+z*Heaviside(x);
    end;

function x31(l:double):double;
{ x-component of the color matching curve of the human eye for the
  CIE 1931 standard observer with 2° field of view. Analytic approximation
  using a multi-lobe, piecewise Gaussian Fit according to:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1, e2, e3 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-0.5*sqr((l-442.0)*selector(l-442.0, 0.0624, 0.0374));
        e2:=-0.5*sqr((l-599.8)*selector(l-599.8, 0.0264, 0.0323));
        e3:=-0.5*sqr((l-501.1)*selector(l-501.1, 0.0490, 0.0382));
        x31:=0.362*exp(e1)+1.056*exp(e2)-0.065*exp(e3);
        end
    else x31:=0;
    end;

function y31(l:double):double;
{ y-component of the color matching curve of the human eye for the
  CIE 1931 standard observer with 2° field of view. Analytic approximation
  using a multi-lobe, piecewise Gaussian Fit according to:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1, e2 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-0.5*sqr((l-568.8)*selector(l-568.8, 0.0213, 0.0247));
        e2:=-0.5*sqr((l-530.9)*selector(l-530.9, 0.0613, 0.0322));
        y31:=0.821*exp(e1)+0.286*exp(e2);
        end
    else y31:=0;
    end;

function z31(l:double):double;
{ z-component of the color matching curve of the human eye for the
  CIE 1931 standard observer with 2° field of view. Analytic approximation
  using a multi-lobe, piecewise Gaussian Fit according to:
  Wyman C, Sloan PP, Shirley P (2013): Simple Analytic Approximations to the
  CIE XYZ Color Matching Functions. J. Computer Graphics Techniques 2: 1-11. }
var e1, e2 : double;
begin
    if (l>=eye_lmin) and (l<=eye_lmax) then begin
        e1:=-0.5*sqr((l-437.0)*selector(l-437.0, 0.0845, 0.0278));
        e2:=-0.5*sqr((l-459.0)*selector(l-459.0, 0.0385, 0.0725));
        z31:=1.217*exp(e1)+0.681*exp(e2);
        end
    else z31:=0;
    end;

procedure set_CMF;
var k : integer;
begin
    for k:=1 to Channel_number do begin
        CMF_r^.y[k]:=x31(x^.y[k]);
        CMF_g^.y[k]:=y31(x^.y[k]);
        CMF_b^.y[k]:=z31(x^.y[k]);
        end;
    end;

procedure set_mXYZ_10;
{ Set values of matrix converting XYZ to sRGB colors for 10° observer.
  https://colorcalculations.wordpress.com/rgb-color-spaces/#RGBspaces }
begin
    mXYZ[1,1]:=3.239886;
    mXYZ[1,2]:=-1.536869;
    mXYZ[1,3]:=-0.498444;
    mXYZ[2,1]:=-0.967675;
    mXYZ[2,2]:=1.872930;
    mXYZ[2,3]:=0.041488;
    mXYZ[3,1]:=0.056595;
    mXYZ[3,2]:=-0.207515;
    mXYZ[3,3]:=1.075305;
    end;

procedure set_mXYZ_Adobe;
{ Set values of matrix converting XYZ to Adobe RGB colors for D65 light source.
  http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html }
begin
    mXYZ[1,1]:=2.0413690;
    mXYZ[1,2]:=-0.5649464;
    mXYZ[1,3]:=-0.3446944;
    mXYZ[2,1]:=-0.9692660;
    mXYZ[2,2]:=1.8760108;
    mXYZ[2,3]:=0.0415560;
    mXYZ[3,1]:=0.0134474;
    mXYZ[3,2]:=-0.1183897;
    mXYZ[3,3]:=1.0154096;
    end;

procedure TRGB.Write_Schuhrand(ku, ko : integer);
{ This function is only needed once for calculating the outer boundary of the
  chromaticity diagram. This boundary is now imported from file. }
var   datei      : textFile;
      k          : integer;
begin
    AssignFile(datei, DIR_saveFwd+'\Spectral_locus.txt');
    {$i-} rewrite(datei);
    if ioresult=0 then begin
        writeln(datei, 'This file was generated by the program WASI');
        writeln(datei, vers);
        writeln(datei);
        writeln(datei, 'Wavelengths of the spectral locus (nm) for the CMFs');
        writeln(datei, '   ', CMF_r^.FName);
        writeln(datei, '   ', CMF_g^.FName);
        writeln(datei, '   ', CMF_b^.FName);
        writeln(datei);
        writeln(datei, 'Lambda', #9, 'x', #9, 'y');
        for k:=ku to ko do
            writeln(datei, schoen(ShoeEdge[1].y[k],1), #9,
                           schoen(ShoeEdge[2].y[k],5), #9,
                           schoen(ShoeEdge[3].y[k],5));
        writeln(datei, schoen(ShoeEdge[1].y[ku],1), #9,
                       schoen(ShoeEdge[2].y[ku],5), #9,
                       schoen(ShoeEdge[3].y[ku],5));
        end;
    CloseFile(datei);
    {$i+}
    end;

procedure TRGB.Write_Schuhrand_ticks(ku, ko : integer);
{ This function is only needed once for calculating the outer boundary of the
  chromaticity diagram at certain wavelengths for labeling a plot. }
var   datei      : textFile;
      k          : integer;
      e          : integer;
begin
    AssignFile(datei, DIR_saveFwd+'\Spectral_locus_ticks.txt');
    {$i-} rewrite(datei);
    if ioresult=0 then begin
        writeln(datei, 'This file was generated by the program WASI');
        writeln(datei, vers);
        writeln(datei);
        writeln(datei, 'Wavelengths of the spectral locus (nm) for the CMFs');
        writeln(datei, '   ', CMF_r^.FName);
        writeln(datei, '   ', CMF_g^.FName);
        writeln(datei, '   ', CMF_b^.FName);
        writeln(datei);
        writeln(datei, 'Lambda', #9, 'x', #9, 'y');
        for k:=ku to ko do begin
            e:=round(ShoeEdge[1].y[k]);
            if (e=380) or (e=460) or (e=480) or (e=490) or (e=500) or (e=520)
            or (e=540) or (e=560) or (e=580) or (e=600) or (e=620)
            or (e=700) then
            writeln(datei, schoen(ShoeEdge[1].y[k],1), #9,
                           schoen(ShoeEdge[2].y[k],5), #9,
                           schoen(ShoeEdge[3].y[k],5));
            end;
        end;
    CloseFile(datei);
    {$i+}
    end;

{ **************************************************************************** }
{ ******************           Color simulation               **************** }
{ **************************************************************************** }

procedure interpolate_1nm(var Sin, Sout : Attr_spec);
{ Interpolate input spectrum Sin to 1 nm sampling interval and return it as
  spectrum Sout. }
var ch          : integer;  // band numbers of input spectrum
    k           : integer;  // band numbers of output spectrum
    d           : integer;
    dl_z        : double;
    dl_n        : double;
begin
    if x^.y[2]-x^.y[1]=1 then  // Current spectral resolution is 1 nm
        for k:=1 to Channel_number-1 do Sout.y[k]:=Sin.y[k]
    else begin                 // Current spectral resolution is not 1 nm
        for k:=2 to eye_lmax-eye_lmin+1 do begin
            if x^.y[CIEl[k]]-(eye_lmin+k-1)<0 then d:=-1 else d:=0;
            dl_z:=eye_lmin+k-1-x^.y[CIEl[k-d]];
            dl_n:=x^.y[CIEl[k]+1-d]-x^.y[CIEl[k]-d];
            if abs(dl_n)<nenner_min then dl_n:=nenner_min;
            Sout.y[k]:=Sin.y[CIEl[k-d]]+dl_z/dl_n*
                (Sin.y[CIEl[k]+1-d]-Sin.y[CIEl[k]-d]);
            end;
        Sout.y[1]:=Sout.y[2];
        end;
    end;

procedure chroma(flag_normalize, flag_c_adapt: boolean; size: byte);
{ Calculate chromaticity coordinates x, y for radiance spectrum Lu^.y[k].
  If flag_normalize = TRUE, radiance is normalized to downwelling irradiance.
  If flag_c_adapt = TRUE, XYZ is chromatically adapted. }
var N        : double;    // Normalization factor
    R, G, B  : double;    // Red, green, blue values
    min, max : double;    // Minimum and maximum of R, G, B
    nenner   : double;
    k        : integer;
    L1nm     : Attr_spec; // Radiance spectrum with sampling interval of 1 nm
    E1nm     : Attr_spec; // Irradiance spectrum with sampling interval of 1 nm

begin
    // Interpolate input spectra to 1 nm sampling interval
    interpolate_1nm(Lu^, L1nm);
    if flag_normalize then interpolate_1nm(Ed^, E1nm);

    // Determine normalization factor N.
    // The irradiance is weighted with the photopic luminosity function
    // V-Lambda which is equal to CMF_g^.y[k].
    if flag_normalize then begin
        N:=0;
        for k:=1 to eye_lmax-eye_lmin+1 do
            N:=N + E1nm.y[k]*CIExyz[2].y[k];
        N:=N/pi();    // adjust units
        end
    else N:=1;

    // Calculate the XYZ tristimulus
    // https://colorcalculations.wordpress.com/reflectance-to-xyz/
    tri_X:=0;
    tri_Y:=0;
    tri_Z:=0;
    if abs(N)>Nenner_min then for k:=1 to eye_lmax-eye_lmin+1 do begin
        tri_X:=tri_X + L1nm.y[k]*CIExyz[1].y[k]/N;
        tri_Y:=tri_Y + L1nm.y[k]*CIExyz[2].y[k]/N;
        tri_Z:=tri_Z + L1nm.y[k]*CIExyz[3].y[k]/N;
        end;

    // Chromatic adaptation from D65 to D50
    // Change tri_X, tri_Y, tri_Z
    if flag_c_adapt then chromatic_adaptation;

    // Calculate chromaticity coordinates R, G, B
    R:=mXYZ[1,1]*tri_X + mXYZ[1,2]*tri_Y + mXYZ[1,3]*tri_Z;
    G:=mXYZ[2,1]*tri_X + mXYZ[2,2]*tri_Y + mXYZ[2,3]*tri_Z;
    B:=mXYZ[3,1]*tri_X + mXYZ[3,2]*tri_Y + mXYZ[3,3]*tri_Z;

    if R<0 then R:=0;
    if G<0 then G:=0;
    if B<0 then B:=0;


    // Convert to sRGB color space
    // https://colorcalculations.wordpress.com/xyz-to-rgb/
    if R<0.0031308 then R:=12.92*R else R:=1.055*power(R, 1/2.4)-0.055;
    if G<0.0031308 then G:=12.92*G else G:=1.055*power(G, 1/2.4)-0.055;
    if B<0.0031308 then B:=12.92*B else B:=1.055*power(B, 1/2.4)-0.055;

    // Determine minimum and maximum of R, G, B
    min:=R; if G<min then min:=G; if B<min then min:=B;
    max:=R; if G>max then max:=G; if B>max then max:=B;

    // Calculate hue (Foley/van Dam)
    // https://de.wikipedia.org/wiki/HSV-Farbraum
    if max=min then chroma_H:=0 else
    if max=R   then chroma_H:=60*(G-B)/(max-min) else
    if max=G   then chroma_H:=60*(2+(B-R)/(max-min)) else
                    chroma_H:=60*(4+(R-G)/(max-min));
    if chroma_H<0 then chroma_H:=chroma_H+360;

    // Calculate saturation (Foley/van Dam)
    // https://de.wikipedia.org/wiki/HSV-Farbraum
    if max=min then chroma_S:=0 else chroma_S:=(max-min)/max;

    // Calculate value (Foley/van Dam)
    // https://de.wikipedia.org/wiki/HSV-Farbraum
    chroma_V:=max;

    // Apply contrast from 2D module
    R:=contrast*R;
    G:=contrast*G;
    B:=contrast*B;

    // Convert RGB range from 0..1 to 0..255
    if R>1 then R:=1;
    if G>1 then G:=1;
    if B>1 then B:=1;

    chroma_R:=round(255*R);
    chroma_G:=round(255*G);
    chroma_B:=round(255*B);

    // Calculate chromaticity coordinates x, y, z
    nenner:=tri_X + tri_Y + tri_Z;
    if abs(nenner)>nenner_min then begin
        chroma_x:=tri_X/nenner;
        chroma_y:=tri_Y/nenner;
        chroma_z:=tri_Z/nenner;
        end
    else begin
        chroma_x:=0;
        chroma_y:=0;
        chroma_z:=0;
        end;

    // Plot a circle with diameter "size" to the chromaticity diagram
    if size>0 then RGB.Plot_xy(size);
    end;

procedure chroma_old(flag_normalize, flag_c_adapt: boolean; size: byte);
{ Calculate chromaticity coordinates x, y for radiance spectrum Lu^.y[k].
  If flag_normalize = TRUE, radiance is normalized to downwelling irradiance.
  If flag_c_adapt = TRUE, XYZ is chromatically adapted. }
var N        : double;    // Normalization factor
    R, G, B  : double;    // Red, green, blue values
    min, max : double;    // Minimum and maximum of R, G, B
    nenner   : double;
    k        : integer;

begin
    // Determine normalization factor N.
    // The irradiance is weighted with the photopic luminosity function
    // V-Lambda which is equal to CMF_g^.y[k].
    if flag_normalize then begin
        N:=0;
        for k:=1 to Channel_number-1 do
            N:=N + Ed^.y[k]*CMF_g^.y[k]*(x^.y[k+1]-x^.y[k]);
        N:=N/pi();    // adjust units
        end
    else N:=1;

    // Calculate the XYZ tristimulus
    // https://colorcalculations.wordpress.com/reflectance-to-xyz/
    tri_X:=0;
    tri_Y:=0;
    tri_Z:=0;
    if abs(N)>Nenner_min then for k:=1 to Channel_number-1 do begin
        tri_X:=tri_X + Lu^.y[k]*CMF_r^.y[k]*(x^.y[k+1]-x^.y[k])/N;
        tri_Y:=tri_Y + Lu^.y[k]*CMF_g^.y[k]*(x^.y[k+1]-x^.y[k])/N;
        tri_Z:=tri_Z + Lu^.y[k]*CMF_b^.y[k]*(x^.y[k+1]-x^.y[k])/N;
        end;

    // Chromatic adaptation from D65 to D50
    // Change tri_X, tri_Y, tri_Z
    if flag_c_adapt then chromatic_adaptation;

    // Calculate chromaticity coordinates R, G, B
    R:=mXYZ[1,1]*tri_X + mXYZ[1,2]*tri_Y + mXYZ[1,3]*tri_Z;
    G:=mXYZ[2,1]*tri_X + mXYZ[2,2]*tri_Y + mXYZ[2,3]*tri_Z;
    B:=mXYZ[3,1]*tri_X + mXYZ[3,2]*tri_Y + mXYZ[3,3]*tri_Z;

    if R<0 then R:=0;
    if G<0 then G:=0;
    if B<0 then B:=0;


    // Convert to sRGB color space
    // https://colorcalculations.wordpress.com/xyz-to-rgb/
    if R<0.0031308 then R:=12.92*R else R:=1.055*power(R, 1/2.4)-0.055;
    if G<0.0031308 then G:=12.92*G else G:=1.055*power(G, 1/2.4)-0.055;
    if B<0.0031308 then B:=12.92*B else B:=1.055*power(B, 1/2.4)-0.055;

    // Determine minimum and maximum of R, G, B
    min:=R; if G<min then min:=G; if B<min then min:=B;
    max:=R; if G>max then max:=G; if B>max then max:=B;

    // Calculate hue (Foley/van Dam)
    // https://de.wikipedia.org/wiki/HSV-Farbraum
    if max=min then chroma_H:=0 else
    if max=R   then chroma_H:=60*(G-B)/(max-min) else
    if max=G   then chroma_H:=60*(2+(B-R)/(max-min)) else
                    chroma_H:=60*(4+(R-G)/(max-min));
    if chroma_H<0 then chroma_H:=chroma_H+360;

    // Calculate saturation (Foley/van Dam)
    // https://de.wikipedia.org/wiki/HSV-Farbraum
    if max=min then chroma_S:=0 else chroma_S:=(max-min)/max;

    // Calculate value (Foley/van Dam)
    // https://de.wikipedia.org/wiki/HSV-Farbraum
    chroma_V:=max;

    // Apply contrast from 2D module
    R:=contrast*R;
    G:=contrast*G;
    B:=contrast*B;

    // Convert RGB range from 0..1 to 0..255
    if R>1 then R:=1;
    if G>1 then G:=1;
    if B>1 then B:=1;

    chroma_R:=round(255*R);
    chroma_G:=round(255*G);
    chroma_B:=round(255*B);

    // Calculate chromaticity coordinates x, y, z
    nenner:=tri_X + tri_Y + tri_Z;
    if abs(nenner)>nenner_min then begin
        chroma_x:=tri_X/nenner;
        chroma_y:=tri_Y/nenner;
        chroma_z:=tri_Z/nenner;
        end
    else begin
        chroma_x:=0;
        chroma_y:=0;
        chroma_z:=0;
        end;

    // Plot a circle with diameter "size" to the chromaticity diagram
    if size>0 then RGB.Plot_xy(size);
    end;

procedure set_mXYZ;
{ Set values of matrix converting XYZ to sRGB colors for D65 light source.
  http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html }
begin
    mXYZ[1,1]:=3.2404542;
    mXYZ[1,2]:=-1.5371385;
    mXYZ[1,3]:=-0.4985314;
    mXYZ[2,1]:=-0.9692660;
    mXYZ[2,2]:=1.8760108;
    mXYZ[2,3]:=0.0415560;
    mXYZ[3,1]:=0.0556434;
    mXYZ[3,2]:=-0.2040259;
    mXYZ[3,3]:=1.0572252;
    end;

procedure chromatic_adaptation;
{ Chromatic adaptation from D65 to D50. }
var mX, mY, mZ : double;
begin
    mX:=tri_X; mY:=tri_Y; mZ:=tri_Z;

    // http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
    // tri_X:=1.0144665*mX;
    // tri_Z:=0.7578869*mZ;

    // http://color.org/chardata/rgb/sRGB.pdf
    tri_X:=1.047844353856414*mX  + 0.022898981050086*mY - 0.050206647741605*mZ;
    tri_Y:=0.029549007606644*mX  + 0.990508028941971*mY - 0.017074711360960*mZ;
    tri_Z:=-0.029549007606644*mX + 0.015072338237051*mY + 0.751717835079977*mZ;
    if tri_X<0 then tri_X:=0;
    if tri_Y<0 then tri_Y:=0;
    if tri_Z<0 then tri_Z:=0;
    end;

procedure TRGB.ScaleColorXY_old(DX, DY: integer);
var pic : TPicture;
begin
    pic:=TPicture.create;
    pic.bitmap.Assign(ColorXY.Picture);
    ColorXY.stretch:=TRUE;
    ColorXY.AutoSize:=TRUE;
    ColorXY.proportional:=FALSE;
    ColorXY.Canvas.StretchDraw(Rect(0, 0, 100, 100), pic.bitmap);
    pic.free;
    end;

procedure TRGB.ScaleColorXY(DX, DY: integer);
{ Try to add line "SetStretchBltMode(Canvas.Handle, HALFTONE);"
  before you call Canvas.StretchDraw. Then stretching should be done
  with kind of linear interpolation and result should look much better.  }
var size : integer;
    bmp  : TBitmap;     // Bitmap of screenshot image
    Ausschnitt : TRect;       // Selected area for screenshot
var DstRect, SrcRect: TRect;
    dest : TRect;
begin
    Ausschnitt.Left   := 0;
    Ausschnitt.Right  := DX-1;
    Ausschnitt.Top    := 0;
    Ausschnitt.Bottom := DY-1;
(*
    Form1.Canvas.CopyRect(MyOther,Bitmap.Canvas,MyRect);

    bmp.Canvas.CopyRect(Rect(0,0,DX,DY), Self.Canvas, Ausschnitt);

    size:=100*DesignTimePPI div 96;
    ColorXY.Canvas.StretchDraw(Rect(0, 0, size, size), bmp);
*)
    Dest := Rect(0, 0, size, size);
    bmp.Canvas.CopyRect(Dest, ColorXY.Canvas, Rect(0, 0, DX-1, DY-1));

    ColorXY.Canvas.StretchDraw(Rect(0, 0, size, size), bmp);

    ColorXY.AutoSize:=TRUE;
    ColorXY.stretch:=TRUE;
    ColorXY.proportional:=FALSE;
    ColorXY.BorderSpacing.Left:=4*DesignTimePPI div 96;
    ColorXY.BorderSpacing.Top:=4*DesignTimePPI div 96;
    ColorXY.Constraints.MaxWidth:=size;
    ColorXY.Constraints.MaxHeight:=size;
    ColorXY.Constraints.MinWidth:=size;
    ColorXY.Constraints.MinHeight:=size;
    end;

procedure TRGB.FormCreate(Sender: TObject; DX, DY: word; flag_legend: boolean);
{ Create window for color plate and horseshoe. Initialize GUI parameters. }
var TDim   : TSize;
begin
    // Define horizontal and vertical extent of border for labeling
    Canvas.Font.Charset:=GREEK_CHARSET;
    Canvas.Font.size:=9;
    Canvas.Font.Name := 'MS Sans Serif';
    TDim:=Canvas.TextExtent('0.8');
    Border_h:=4*TDim.cx div 3 + 8;
    Border_v:=4*TDim.cy div 3 + 8;
    Text_h:=TDim.cy;
    Shoe_v:=Shoe_v0*DesignTimePPI div 96;

    Shoe_h:=round(Shoe_v*8/9);
    if DX>Shoe_h then Width:=Border_h+DX+4
                 else Width:=Border_h+Shoe_h+4;
    Height :=Border_v+DY*DesignTimePPI div 96+4+4*Text_h+Shoe_v;

    // Define text parameters and coordinates
    Canvas.Pen.Color := clBlack;
    Caption_contrast.Left:=2;
    Caption_contrast.Top:=DY*DesignTimePPI div 96+2;
    Caption_x.Left:=2;
    Caption_x.Top:=DY*DesignTimePPI div 96+2+Text_h;
    Caption_y.Left:=2;
    Caption_y.Top:=DY*DesignTimePPI div 96+2+2*Text_h;
    Caption_hsv.Left:=2;
    Caption_hsv.Top:=DY*DesignTimePPI div 96+2+3*Text_h;

    // Write text
    Caption_hsv.Caption:='';
    if flag_legend then begin
        Caption_x.Caption:='x: '+par.name[Par1_Type]+'='+
                     schoen(Par1_Min,2)+'-'+schoen(Par1_Max,2);
        Caption_y.Caption:='y: '+par.name[Par2_Type]+'='+
                     schoen(Par2_Min,2)+'-'+schoen(Par2_Max,2);
        end
    else begin
        Caption_x.Caption:='';
        Caption_y.Caption:='';
        end;
    Caption_contrast.Caption:='Contrast: ' + schoen(contrast, 2);

    Caption_WASI.Left:=RGB.Width-Caption_WASI.Width-8;

    ColorXY.Width:=DX;
    ColorXY.Height:=DY;
    ColorXY.align:=alTop;

    horseshoe.Left  :=2;
    horseshoe.Top   :=DY*DesignTimePPI div 96+2+4*Text_h;
    horseshoe.Width :=Border_h+Shoe_h;
    horseshoe.Height:=Border_v+Shoe_v;
    end;

procedure TRGB.Preview(h,v: word; R,G,B: byte);
{ Plot pixel (h,v) of color panel ColorXY in colors (R,G,B). }
begin
    ColorXY.Canvas.pixels[h,v] := R + G shl 8 + B shl 16;
    end;

procedure TRGB.SavePanel;
{ Save color panel 'ColorXY' to file. }
begin
    ColorXY.Picture.SaveToFile(DIR_saveFwd+'\Panel_'+RGB_FileText+'.png');
    end;

procedure TRGB.SaveWindow;
{ Save window with color panel 'ColorXY' and chromaticity diagram to file. }
var pic : TPicture;
begin
    pic:=TPicture.create;
    pic.bitmap.Assign(RGB.GetFormImage);
    pic.SaveToFile(DIR_saveFwd+'\Window_'+RGB_FileText+'.png');
    pic.free;
    end;

procedure TRGB.SaveShoe;
{ Save chromaticity diagram 'Horseshoe' to file. }
begin
    Horseshoe.Picture.SaveToFile(DIR_saveFwd+'\Horseshoe_'+RGB_FileText+'.png');
    end;

procedure TRGB.Plot_xy(size:byte);
{ Plot a circle with diameter "size" and color (chroma_R, chroma_G, chroma_B)
  to coordinates (chroma_x, chroma_y)of the chromaticity diagram. }
var h, v : integer;
    c    : TColor;
begin
if chroma_y>0 then begin
    h:=Border_h+round(Shoe_h*chroma_x/0.8);
    v:=round(Shoe_v*chroma_y/0.9);
    c:=chroma_R + chroma_G shl 8 + chroma_B shl 16;
    if size<=1 then begin
        if flag_CIE_dots_black then
            Horseshoe.Canvas.pixels[h,Shoe_v-v]:=clBlack
        else
            Horseshoe.Canvas.pixels[h,Shoe_v-v]:=c
        end
    else begin
        Horseshoe.Canvas.Brush.Color:=c;
        Horseshoe.Canvas.Pen.Color  :=clBlack;
        Horseshoe.Canvas.Ellipse(h-size, Shoe_v-v-size, h+size, Shoe_v-v+size);
        end;
    end;
    end;

procedure TRGB.PlotHorseshoeColors;
{ Fill xy-plane with RGB colors. }
var dx, dy   : double;
    xx, yy   : double;
    h, v     : integer;
    R, G, B  : double;    // Red, green, blue values
    min, max : double;    // Minimum and maximum of R, G, B
    contr    : double;    // Contrast

begin
    dx:=0.8/Shoe_h;
    dy:=0.9/Shoe_v;
    xx:=0; h:=0;
    repeat
        yy:=0; v:=0;
        repeat
            // Calculate X, Z from Y, x, y
            tri_Y:=1;
            if abs(yy)<nenner_min then tri_X:=0 else tri_X:=xx*tri_Y/yy;
            if abs(yy)<nenner_min then tri_Z:=0 else tri_Z:=(1-xx-yy)*tri_Y/yy;
            if tri_Z<0 then tri_Z:=0;

            // Chromatic adaptation from D65 to D50
            // chromatic_adaptation;

            // Calculate chromaticity coordinates R, G, B
            R:=mXYZ[1,1]*tri_X + mXYZ[1,2]*tri_Y + mXYZ[1,3]*tri_Z;
            G:=mXYZ[2,1]*tri_X + mXYZ[2,2]*tri_Y + mXYZ[2,3]*tri_Z;
            B:=mXYZ[3,1]*tri_X + mXYZ[3,2]*tri_Y + mXYZ[3,3]*tri_Z;

            if R<0 then R:=0;
            if G<0 then G:=0;
            if B<0 then B:=0;

            // Convert to sRGB
            // https://colorcalculations.wordpress.com/xyz-to-rgb/
            if R<0.0031308 then R:=12.92*R else R:=1.055*power(R, 1/2.4)-0.055;
            if G<0.0031308 then G:=12.92*G else G:=1.055*power(G, 1/2.4)-0.055;
            if B<0.0031308 then B:=12.92*B else B:=1.055*power(B, 1/2.4)-0.055;

            // Determine minimum and maximum of R, G, B
            min:=R; if G<min then min:=G; if B<min then min:=B;
            max:=R; if G>max then max:=G; if B>max then max:=B;

            // Automatic contrast
            if max>nenner_min then begin
                contr:=1/max;
                min:=contr*min;
                max:=1;
                end
            else contr:=1;

            R:=contr*R;
            G:=contr*G;
            B:=contr*B;

            chroma_R:=round(255*R);
            chroma_G:=round(255*G);
            chroma_B:=round(255*B);

            Horseshoe.Canvas.pixels[Border_h+h,Shoe_v-v]:=
                chroma_R + chroma_G shl 8 + chroma_B shl 16;
            yy:=yy+dy;
            inc(v);
        until (yy>0.9) or (v>Shoe_v);
        xx:=xx+dx;
        inc(h);
    until (xx>0.8) or (h>Shoe_h);
    end;

procedure TRGB.calcShoeEdge;
{ Calculate spectral locus curve. }
var k, j   : integer;
    Lu_old : Attr_spec;
begin
    Lu_old:=Lu^;
    for k:=1 to channel_number do begin
        for j:=2 to channel_number-1 do Lu^.y[j]:=0;
        Lu^.y[k]:=10000;
        Lu^.y[k-1]:=0.1;
        Lu^.y[k+1]:=0.1;
        chroma(FALSE,FALSE,0);
        ShoeEdge[1].y[k]:=x^.y[k];
        ShoeEdge[2].y[k]:=chroma_x;
        ShoeEdge[3].y[k]:=chroma_y;
        end;
    Lu^:=Lu_old;
    end;

procedure Import_spectral_locus;
{ Import spectral locus curve with 1 nm resolution from file. }
var  datei : text;
     i     : integer;
begin
    {$i-}
    assignFile(datei, s_locus^.Fname);
    reset(datei);
    if ioresult<>0 then
        MessageBox(0, pchar(s_locus^.Fname), 'WARNING: Spectral locus file not found', MB_OK)
    else begin
        for i:=1 to s_locus^.Header do readln(datei);
        i:=1;
        repeat
            readln(datei, ShoeEdge[1].y[i], ShoeEdge[2].y[i], ShoeEdge[3].y[i]);
            inc(i);
        until (ShoeEdge[1].y[i]>=eye_lmax) or (i>MaxChannels) or eof(datei);
        end;
    CloseFile(datei);
    {$i+}
    end;

procedure Import_CIExyz;
{ Import CIE color matching functions with 1 nm resolution from file. }
var  datei : text;
     i     : integer;
     wv    : integer;
begin
    {$i-}
    assignFile(datei, CMF_r^.Fname);
    reset(datei);
    if ioresult<>0 then
        MessageBox(0, pchar(CMF_r^.Fname), 'WARNING: CMF file not found', MB_OK)
    else begin
        for i:=1 to CMF_r^.Header do readln(datei);
        i:=1;
        repeat
            readln(datei, wv, CIExyz[1].y[i], CIExyz[2].y[i], CIExyz[3].y[i]);
            inc(i);
        until (wv>=eye_lmax) or (i>MaxChannels) or eof(datei);
        end;
    CloseFile(datei);
    {$i+}
    end;

procedure assign_CIE_wavelengths;
{ Assign actual wavelengths to bands in 1 nm steps for CIE calculation. }
var k : integer;
begin
    for k:=1 to eye_lmax-eye_lmin+1 do CIEl[k]:=Nachbar(eye_lmin+k-1);
    end;

procedure TRGB.LabelHorseshoe;
{ Label CIE chromaticity diagram. }
const s      = 3;          // Size of equal energy point 'E'
var   h, v   : integer;
      xx, yy : double;
      tx     : string;
      TDim   : TSize;
begin
    // Draw and label equal energy point
    Horseshoe.Canvas.Brush.Color :=clWhite;
    Horseshoe.Canvas.Pen.Color   :=clBlack;
    h:=Border_h+round(Shoe_h*0.33/0.8);
    v:=round(Shoe_v*0.33/0.9);
    Horseshoe.Canvas.Ellipse(h-s, Shoe_v-v-s, h+s, Shoe_v-v+s);
    Horseshoe.canvas.brush.style := bsClear;   // Transparent text background
    Horseshoe.Canvas.TextOut(h + Canvas.TextExtent('E').cx div 2, Shoe_v-v, 'E');

    // Draw sRGB color space
    // Coordinates from http://www.color.org/sRGB.pdf
    Horseshoe.Canvas.Pen.Color:=clWhite;
    h:=Border_h+round(Shoe_h*0.64/0.8);
    v:=round(Shoe_v*0.33/0.9);
    Horseshoe.Canvas.moveto(h,Shoe_v-v);

    h:=Border_h+round(Shoe_h*0.30/0.8);
    v:=round(Shoe_v*0.60/0.9);
    Horseshoe.Canvas.LineTo(h,Shoe_v-v);

    h:=Border_h+round(Shoe_h*0.15/0.8);
    v:=round(Shoe_v*0.06/0.9);
    Horseshoe.Canvas.LineTo(h,Shoe_v-v);

    h:=Border_h+round(Shoe_h*0.64/0.8);
    v:=round(Shoe_v*0.33/0.9);
    Horseshoe.Canvas.LineTo(h,Shoe_v-v);

    // Draw frame
    Horseshoe.Canvas.Pen.Color := clGray;
    Horseshoe.Canvas.Brush.Style := bsClear;  // Transparent rectangle
    Horseshoe.Canvas.Rectangle (Border_h, 4, Border_h+Shoe_h-4, Shoe_v);

    // Label diagram
    Canvas.Pen.Color := clGray;
    tx:='CIE 1931 chromaticity diagram';
    TDim:=Horseshoe.Canvas.TextExtent(tx);
    Horseshoe.Canvas.TextOut(Border_h+Shoe_h-TDim.cx-16, 4+TDim.cy, tx);
    tx:='triangle: sRGB color space';
    TDim:=Horseshoe.Canvas.TextExtent(tx);
    Horseshoe.Canvas.TextOut(Border_h+Shoe_h-TDim.cx-16, 4+TDim.cy+Text_h, tx);
    tx:='E: equal energy point';
    TDim:=Horseshoe.Canvas.TextExtent(tx);
    Horseshoe.Canvas.TextOut(Border_h+Shoe_h-TDim.cx-16, 4+TDim.cy+2*Text_h, tx);

    // Draw x-axis
    xx:=0;
    repeat
        h:=Border_h+round(Shoe_h*xx/0.8);
        Horseshoe.Canvas.MoveTo(h,Shoe_v);
        Horseshoe.Canvas.LineTo(h,Shoe_v+8);
        tx:=schoen(xx,1);
        TDim:=Horseshoe.Canvas.TextExtent(tx);
        Horseshoe.Canvas.TextOut(h-TDim.cx div 2,Shoe_v+10, tx);
        xx:=xx+0.1;
    until xx>0.7;

    // Draw y-axis
    yy:=0;
    repeat
        v:=round(Shoe_v*yy/0.9)+1;
        Horseshoe.Canvas.MoveTo(Border_h,Shoe_v-v);
        Horseshoe.Canvas.LineTo(Border_h-8,Shoe_v-v);
        tx:=schoen(yy,1);
        TDim:=Horseshoe.Canvas.TextExtent(tx);
        Horseshoe.Canvas.TextOut(Border_h-TDim.cx-10,Shoe_v-v-(TDim.cy div 2), tx);
        yy:=yy+0.1;
    until yy>0.8;

    end;

procedure TRGB.PlotShoeEdge;
{ Plot spectral locus curve and fill surrounding area white. }
var   k, h, v, kxm, kym : integer;
begin
    // Determine start point and end point of purple line.
    // They are not, as could be expected, at eye_lmin and eye_lmax for each CMF.
    // The colors are too similar at the borders of human vision
    // for the uncertainties of the CMFs.
    kxm:=1;
    kym:=1;

    for k:=1 to MaxChannels do begin
        if (ShoeEdge[1].y[k]>580) and (ShoeEdge[2].y[k]>ShoeEdge[2].y[kxm])
            and (ShoeEdge[1].y[k]<=705) then kxm:=k;
        end;

    // Draw curved edge of horseshoe
    Horseshoe.Canvas.Pen.Color := clGray;
    h:=Border_h+round(Shoe_h*ShoeEdge[2].y[kym]/0.8);
    v:=round(Shoe_v*ShoeEdge[3].y[kym]/0.9);
    Horseshoe.Canvas.MoveTo(h,Shoe_v-v);
    for k:=kym+1 to kxm do begin
        h:=Border_h+round(Shoe_h*ShoeEdge[2].y[k]/0.8);
        v:=round(Shoe_v*ShoeEdge[3].y[k]/0.9);
        Horseshoe.Canvas.LineTo(h,Shoe_v-v);
        end;

    // Draw line of purples
    h:=Border_h+round(Shoe_h*ShoeEdge[2].y[kxm]/0.8);
    v:=round(Shoe_v*ShoeEdge[3].y[kxm]/0.9);
    Horseshoe.Canvas.MoveTo(h,Shoe_v-v);
    h:=Border_h+round(Shoe_h*ShoeEdge[2].y[kym]/0.8);
    v:=round(Shoe_v*ShoeEdge[3].y[kym]/0.9);
    Horseshoe.Canvas.LineTo(h,Shoe_v-v);

    // Fill area around horseshoe white
    for h:=0 to Border_h+Shoe_h do Horseshoe.Canvas.pixels[h,0]:=clWhite;
    for v:=0 to Border_v+Shoe_v do begin
        h:=0;
        while (Horseshoe.Canvas.pixels[h,v]<>clGray) and (h<Border_h+Shoe_h) do begin
            Horseshoe.Canvas.pixels[h,v]:=clWhite;
            inc(h);
            end;
        h:=Border_h+Shoe_h;
        while (Horseshoe.Canvas.pixels[h,v]<>clGray) and (h>1+Border_h) do begin
            Horseshoe.Canvas.pixels[h,v]:=clWhite;
            dec(h);
            end;
        end;

    // Label CIE chromaticity diagram
    if flag_CIE_label then LabelHorseshoe;

    // Save coordinates of shoe edge to file
    if flag_CIE_calc_locus then begin
        Write_Schuhrand(kym, kxm);
        Write_Schuhrand_ticks(kym, kxm);
        end;
    end;

procedure TRGB.TruecolorPanel_fromRrs(DX, DY : integer);
{ Create truecolor panel from radiance reflectance spectrum. }
var k, NoX, NoY    : integer;
begin
    if flag_CIE_calc_locus then calcShoeEdge;
//    PlotHorseshoeColors;
//    PlotShoeEdge;
    if spec_type=S_Ed_GC then begin
        for k:=1 to Channel_number do Lu^.y[k]:=spec[1]^.y[k];
        chroma(FALSE,FALSE,4);
        end
        else begin
        calc_Ed_GreggCarder;
        for k:=1 to Channel_number do Lu^.y[k]:=spec[1]^.y[k]*Ed^.y[k];
        chroma(TRUE,TRUE,4);
        end;
    for NoX:=0 to DX-1 do
        for NoY:=0 to DY-1 do
            RGB.Preview(NoX,NoY,chroma_R,chroma_G,chroma_B);

    ScaleColorXY(DX-1, DY-1);

    Caption_x.Caption:='File: ' + ExtractFileName(meas^.FName);
    Caption_y.Caption:='x: ' + schoen(chroma_x,3) + ', y: '+schoen(chroma_y,3);
    Caption_hsv.Caption:='H: ' + schoen(chroma_H, 2) + '°, S: ' + schoen(chroma_S, 2) +
                         ', V: ' + schoen(chroma_V, 2);
    RGB.Repaint;
    RGB.SavePanel;
    RGB.SaveShoe;
    RGB.SaveWindow;
    end;

end.

