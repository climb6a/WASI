unit Popup_2D_Format;

{$MODE Delphi}

{ Image visualisation and image processing }
{ Version vom 13.5.2020 }

interface

uses
  Windows, LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, math, defaults, misc, invers, privates, farbe,
  gui, SCHOEN_, fw_calc;

type

  { TFormat_2D }

  TFormat_2D = class(TForm)
    Image_in  : TImage;
    SaveDialogFitresults: TSaveDialog;
    Label_min: TLabel;
    Label_max: TLabel;
    Label_Band: TLabel;
    ScrollBar_Bands: TScrollBar;
    Label_Scroll_BB: TLabel;
    Label_Scroll_wB: TLabel;
    Button_ScrollBands: TButton;
    Label_Scroll_BG: TLabel;
    Label_Scroll_BR: TLabel;
    Label_Scroll_wG: TLabel;
    Label_Scroll_wR: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormPaint(Sender: TObject);
    procedure Image_inMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PreviewHSI(wPrv,hPrv: word);
    procedure mark_as_processed(x,f,farbe: word; Sender: TObject);
//    procedure lies_HSI_line(b, z: word);
    procedure load_RGB(Sender: TObject);
//    procedure import_RGB;
    procedure create_truecolor(Sender: TObject);
    procedure create_RGB(xmin, xmax: word);
    procedure create_mask;
    procedure show_scale;
    procedure hide_scale;
    procedure check_bands_preview;
    procedure determine_range_RGB(xmin, xmax: word);
    procedure draw_rectangle(Sender: TObject; xmin,xmax,ymin,ymax: word; farbe: TColor);
    procedure plot_CalVal_data(Sender: TObject);
    procedure Rbottom_using_depth(Sender: TObject);
    procedure Validate_data(Sender: TObject);
    procedure show_coordinates(Sender: TObject; Shift: TShiftState; X,Y: word);
    procedure import_HSI(Sender: TObject);
    procedure HSI_free_memory(Sender: TObject);
//    procedure extract_spektrum_old(var spek: Attr_spec; h, v : word; Sender: TObject);
    procedure extract_spektrum_new(var spek: Attr_spec; h, v : word; Sender: TObject);
    procedure show_spectrum(Sender: TObject);
    procedure average_spectrum(Sender: TObject);
    procedure adjust_x_scales;
    function  set_par(key:integer; CRLF:boolean):boolean;
    procedure Read_Envi_Header(FileName : string);
    procedure Write_Envi_Header_fit(FileName: string);
    procedure Write_Envi_Header_spec(FileName: string; ch: integer);
    procedure Write_Fitresult(Frames: word);
    procedure exchange_ENVI_coordinates;
    procedure save_wavelengths(FileName:string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function  Select_Filename_Output_HSI(Sender: TObject):boolean;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: word);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: word);
    procedure BSQtoBIL(File_BSQ : string);
    procedure set_ranges_avg_2D(f, x: word; out pixmin, pixmax: qword);
    procedure average_fitparameters_2D(f, x, xmin, xmax: word);
    procedure zB_analytical_2D(f, kzB1, kzB2, xmin, xmax: word; Sender: TObject);
    procedure Rb_from_defined_area(Sender: TObject);
    procedure ScrollBar_BandsScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: word);
    procedure Button_ScrollBandsClick(Sender: TObject);
    procedure Explore_bands(Sender: TObject);
    private
      RGB_Scale   : TBitmap;       { bitmap of colour bar }
      TempBitmap  : TBitmap;       { bitmap of image in selected rectangle }
(*      HSI_1       : line_byte;     { hyperspectral image, data type #1 }
      HSI_2       : line_int16;    { hyperspectral image, data type #2 }
      HSI_3       : line_int32;    { hyperspectral image, data type #3 }
      HSI_4       : line_single;   { hyperspectral image, data type #4 }
      HSI_12      : line_word;     { hyperspectral image, data type #12 }    *)
      mouse0      : TPoint;        { Mouse position #0 }
      mouseA      : TPoint;        { Actual mouse position }
      Rahmen      : TRect;         { Rectangle drawn by user to select area }
      mouse_down  : boolean;
      flag_lambda : boolean;
      Zeile       : string;
      ENVI_datei  : textFile;
      ENVI_info   : array[1..ENVI_Keys]of boolean;
    public
      TheGraphic  : TBitmap;
    end;


var    Format_2D  : TFormat_2D;

implementation

uses Frame_Batch, Popup_2D_Info, CEOS;

{$R *.lfm}

procedure TFormat_2D.FormCreate(Sender: TObject);
{ Create window with width w and height h. Initialize GUI parameters. }
begin
    if frame_max=0 then frame_max:=Height_in-1;
    if pixel_max=0 then pixel_max:=Width_in-1;
    BorderStyle:=bsSizeable;   // User is allowed to resize the form }
    DoubleBuffered:=true;      // avoid flickering
    Cursor    :=crCross;
    if flag_LUT and not flag_3bands then img_dY:=scale_dY else img_dY:=0;

    Width :=Width_in  + img_dX;
    Height:=Height_in + img_dY;

    { Problem: Lazarus frequently changes the parameters Width and Height
      at exiting the FormCreate procedure. I could not find out why and where.
      This feature makes the window often too large, i.e., the displayed
      image is surrounded by much empty space. I spent much time trying to
      solve the problem. The only solution I found was restricting the
      maximum width and maximum height using the "Constraints" properties. }

    Constraints.MaxWidth:=
        Width_in + img_dX + 2*borderWidth+GetSystemMetrics(SM_CYVSCROLL);
    Constraints.MaxHeight:=
        Height_in + img_dY + 2*borderWidth+GetSystemMetrics(SM_CXHSCROLL);

    if ((Constraints.MaxWidth>screen.DesktopWidth) or
    (Constraints.MaxHeight>screen.DesktopHeight)) then
        WindowState:=wsFullscreen;

    Image_in.Left   :=img_dX;
    Image_in.Top    :=img_dY;
    Image_in.Width  :=Width_in;
    Image_in.Height :=Height_in;
    Label_band.Left :=RGB_left;
    Image_in.visible:=TRUE;
    flag_2D_inv     :=TRUE;
    mouse_down      :=FALSE;
    flag_avg        :=FALSE;
    flag_extract    :=FALSE;
    TempBitmap      := TBitmap.Create; { Create bitmap of image in selected rectangle }
    TempBitmap.Width  := 1;
    TempBitmap.Height := 1;
    Canvas.Brush.Color := clRed;       { Define color of rectangle }
    Label_min.visible:=FALSE;
    Label_max.visible:=FALSE;
    Label_band.visible:=FALSE;
    TheGraphic:=TBitmap.Create;        { Create image bitmap }
    ScrollBar_Bands.visible:=FALSE;
    Label_Scroll_BB.visible:=FALSE;
    Label_Scroll_BG.visible:=FALSE;
    Label_Scroll_BR.visible:=FALSE;
    Label_Scroll_wB.visible:=FALSE;
    Label_Scroll_wG.visible:=FALSE;
    Label_Scroll_wR.visible:=FALSE;
    Button_ScrollBands.visible:=FALSE;
    Form1.Frame_Batch1.CheckInvert.Caption  :='invert image';
    Form1.Frame_Batch1.CheckBatch.Caption   :='invert area';
    Form1.Frame_Batch1.CheckReadFile.Caption:='invert spectrum';
    flag_merk_b_Invert:=flag_b_Invert;
    flag_merk_batch:=flag_batch;
    flag_merk_b_LoadAll:=flag_b_LoadAll;
    if flag_use_ROI then begin
        Form1.Frame_Batch1.CheckInvert.checked:=FALSE;
        Form1.Frame_Batch1.CheckBatch.checked:=TRUE;
        Form1.Frame_Batch1.CheckReadFile.checked:=FALSE;
        flag_b_invert:=FALSE;
        flag_batch:=TRUE;
        end
    else begin
        Form1.Frame_Batch1.CheckInvert.checked:=TRUE;
        Form1.Frame_Batch1.CheckBatch.checked:=FALSE;
        Form1.Frame_Batch1.CheckReadFile.checked:=FALSE;
        flag_b_invert:=TRUE;
        flag_batch:=FALSE;
        end;
    flag_b_loadAll:=FALSE;
    Form1.Frame_Batch1.CheckBatch.Enabled:=FALSE;
    Form1.Frame_Batch1.CheckReadFile.Enabled:=FALSE;
    Form1.Frame_Batch1.update_parameterlist(Sender); { update GUI parameters }
    end;

procedure TFormat_2D.FormKeyPress(Sender: TObject; var Key: char);
begin
    if Key = ^C then
        if MessageDlg('Abort processing?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
            ABBRUCH:=TRUE;
    end;

procedure TFormat_2D.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    flag_preview:=FALSE;
    flag_show_EEM:=FALSE;
    HSI_old:=HSI_img^.FName;
(*    SetLength(HSI_4, 0); *)
    SetLength(Channel_R, 0);
    SetLength(Channel_G, 0);
    SetLength(Channel_B, 0);
    SetLength(cube_fitpar, 0, 0, 0);
    SetLength(WaterMask, 0, 0);
    flag_2D_inv:=FALSE;
    Form1.ProgressBar1.visible:=FALSE;
    TempBitmap.Width  := 0;
    TempBitmap.Height := 0;
    flag_x_file       := x_flag;
    flag_fwhm         := fwhm_flag;
    x^.FName          := x_FName;
    x^.Header         := x_Header;
    x^.XColumn        := x_Xcol;
    x^.YColumn        := x_Ycol;
    FreeAndNil(TempBitmap); { free up the memory of the bitmap of selected rectangle }
    FreeAndNil(TheGraphic);
    Form1.Frame_Batch1.CheckInvert.Caption:='invert spectra';
    Form1.Frame_Batch1.CheckBatch.Caption:='batch mode';
    Form1.Frame_Batch1.CheckReadFile.Caption:='read from file';
    flag_b_Invert:=flag_merk_b_Invert;
    flag_batch:=flag_merk_batch;
    flag_b_LoadAll:=flag_merk_b_LoadAll;
    Form1.Save_img.visible:=FALSE;
    Form1.Frame_Batch1.CheckBatch.Enabled:=TRUE;
    Form1.Frame_Batch1.CheckReadFile.Enabled:=TRUE;
    HSI_free_memory(Sender);
    Form_2D_Info.Close;
    end;

procedure TFormat_2D.FormPaint(Sender: TObject);
begin
    { Set the origin of the coordinates of the Canvas  }
    SetWindowOrgEx (Canvas.Handle, HorzScrollbar.Position, VertScrollbar.Position, nil);
    Format_2D.Canvas.Draw(img_dX, img_dY, TheGraphic);
    if flag_LUT and not flag_3bands then show_scale;
    end;

procedure TFormat_2D.Image_inMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    show_coordinates(Sender, Shift, X, Y);
    end;

procedure TFormat_2D.PreviewHSI(wPrv,hPrv: word);
{ Preview of hyperspectral image }
var   x, f    : word;
      color   : TColor;
      R, G, B : longword;
begin
    TheGraphic.Width  := wPrv;
    TheGraphic.Height := hPrv;
    TheGraphic.Pixelformat := pf24bit;
    Width:=wPrv;
    Height:=hPrv;
    for f:=0 to hPrv-1 do
    for x:=0 to wPrv-1 do begin
        R:=Channel_R[x,f];
        G:=Channel_G[x,f] shl 8;
        B:=Channel_B[x,f] shl 16;
        color:=R+G+B;
        TheGraphic.Canvas.Pixels[x,f] := color;
        end;
    (*
    if wPrv<2*RGB_width then begin   // adjust window width for small images
        width:=2*RGB_width;
        img_dX:=(width-wPrv) div 3;
        if img_dX<0 then img_dX:=0;
        RGB_left:=img_dX;
        end;
    *)
    Image_in.Left:=img_dX;
    Image_in.Top:=img_dY;
    Label_band.Left:=RGB_left;
    if flag_LUT and not flag_3bands then show_scale else
        if img_dY=scale_dY then hide_scale;
    if flag_truecolor_2D then hide_scale;
    Canvas.Draw(img_dX, img_dY, TheGraphic);
    end;

procedure TFormat_2D.mark_as_processed(x,f,farbe:word; Sender: TObject);
{ Mark pixel that is currently processed in red and last processed pixel in gray.
  The shade of grey represents the result of the parameter 'Par0_Type' specified
  in unit 'Popup_2D_Options' }
begin
    if (x<pixel_max-1) then if WaterMask[x+1,f] then
        TheGraphic.Canvas.Pixels[x+1,f]:=clRed;
    TheGraphic.Canvas.Pixels[x,f] := farbe + farbe shl 8 + farbe shl 16;
    FormPaint(Sender);
    end;


function max255(x:double):byte;
{ Convert data type double to byte. Values > 255 are set to 255. }
var m : byte;
begin
    if abs(x)<255 then m:=round(abs(x)) else m:=255;
    max255:=m;
    end;

procedure TFormat_2D.load_RGB(Sender: TObject);
{ Load channels of RGB image including mask from HSI image for preview. }
var  x, z : word;
     spek : Attr_spec;
begin
    SetLength(cube_HSI4, Width_in, Height_in, 4);
    for z:=0 to Height_in-1 do
        for x:=0 to Width_in-1 do begin
            extract_spektrum_new(spek, x, z, Sender);
            cube_HSI4[x,z,3]:=spek.y[band_mask];
            cube_HSI4[x,z,2]:=spek.y[band_B];
            if flag_3bands then begin
                cube_HSI4[x,z,1]:=spek.y[band_G];
                cube_HSI4[x,z,0]:=spek.y[band_R];
                end
            else begin
                cube_HSI4[x,z,1]:=spek.y[band_B];
                cube_HSI4[x,z,0]:=spek.y[band_B];
                end;
            end;
    create_mask;
    Format_2D.autosize:=FALSE;
    end;

(*
procedure TFormat_2D.import_RGB;
{ Import channels of RGB image including mask from HSI image for preview. }
var x, z : word;
begin
    HSI_Stream:=TFileStream.Create(HSI_img^.FName, fmOpenRead);
    HSI_width:=(HSI_Stream.Size-HSI_Header) div (Height_in*Channels_in);
    SetLength(HSI_4, Width_in);

    { Import data used for RGB preview }
    SetLength(cube_HSI4, Width_in, Height_in, 4);
    for z:=0 to Height_in-1 do begin
        lies_HSI_line(band_B, z);
        for x:=0 to Width_in-1 do cube_HSI4[x,z,2]:=HSI_4[x];
        if flag_3bands then begin
            lies_HSI_line(band_G, z);
            for x:=0 to Width_in-1 do cube_HSI4[x,z,1]:=HSI_4[x];
            lies_HSI_line(band_R, z);
            for x:=0 to Width_in-1 do cube_HSI4[x,z,0]:=HSI_4[x];
            end
        else begin
            for x:=0 to Width_in-1 do cube_HSI4[x,z,1]:=cube_HSI4[x,z,2];
            for x:=0 to Width_in-1 do cube_HSI4[x,z,0]:=cube_HSI4[x,z,2];
            end;
        lies_HSI_line(band_mask, z);
        for x:=0 to Width_in-1 do cube_HSI4[x,z,3]:=HSI_4[x];
        end;

    create_mask;
    Format_2D.autosize:=FALSE;
    HSI_Stream.Free;                                          { close HSI file } 
    end;
*)

procedure TFormat_2D.create_truecolor(Sender: TObject);
{ Use all channels of a multispectral or hyperspectral image for conversion
  to a RGB image using Color Matching Functions (CMFs) of the human eye.
  NOTE: The resulting colors can be incorrect for multispectral images as
  the resampled CMFs may not fill the spectral gaps of multispectral sensors
  sufficiently. A possible solution is: interpolate the spectra and apply
  subsequently spectrally higher resolved CMFs. This is not implemented. }
var x, z, c : word;
begin
    // Simulate downwelling irradiance
    calc_Ed_GreggCarder;

    // Set array dimensions
    SetLength(Channel_R, Width_in, Height_in);
    SetLength(Channel_G, Width_in, Height_in);
    SetLength(Channel_B, Width_in, Height_in);
    SetLength(cube_HSI4, Width_in, Height_in, 4);

    // Calculate color matching functions if they are not yet imported
    if flag_public then begin set_mXYZ; Import_CIExyz; end;
    assign_CIE_wavelengths;

    // Apply truecolor conversion to all pixels
    for z:=0 to Height_in-1 do
        for x:=0 to Width_in-1 do begin

            // Extract spectrum of pixel (x, z)
            extract_spektrum_new(HSI_img^, x, z, Sender);

            // Convert reflectance to radiance
            spec[1]^:=HSI_img^;
            for c:=1 to Channels_in do Lu^.y[c]:=spec[1]^.y[c]*Ed^.y[c];

            // Calculate chromaticity coordinates using Lu^.y[c]
            chroma(true,false,0);

            // Create truecolor image
            Channel_R[x,z]:=chroma_R;
            Channel_G[x,z]:=chroma_G;
            Channel_B[x,z]:=chroma_B;

            // Create RGB image from three channels
            // This is necessary because mask algorithm checks for zeros
            // in these bands
            cube_HSI4[x,z,0]:=HSI_img^.y[band_R];
            cube_HSI4[x,z,1]:=HSI_img^.y[band_G];
            cube_HSI4[x,z,2]:=HSI_img^.y[band_B];

            // Set value of band used for masking
            cube_HSI4[x,z,3]:=HSI_img^.y[band_mask];
            end;

    // Create mask
    create_mask;

    // Apply mask to truecolor image
    for z:=0 to Height_in-1 do
    for x:=0 to Width_in-1 do
        if WaterMask[x,z]=FALSE then begin
            Channel_R[x,z]:=GetRValue(clMaskImg);
            Channel_G[x,z]:=GetGValue(clMaskImg);
            Channel_B[x,z]:=GetBValue(clMaskImg);
            end;
    end;

procedure TFormat_2D.determine_range_RGB(xmin, xmax: word);
{ Determine maximum values of preview channels. }
var x, f          : word;
    m_R, m_G, m_B : single;
    flag_first    : boolean;
begin
    flag_first:=TRUE;
    if xmax>Width_in-1 then xmax:=Width_in-1;
    for f:=0 to Height_in-1 do
    for x:=xmin to xmax do
        if WaterMask[x,f] then if                   // select water pixels
        ((frame_min=0) and (frame_max=0) and (pixel_min=0) and (pixel_max=0)) or  // all water pixels
        (not flag_scale_ROI) or
        ((f>=frame_min) and (f<=frame_max) and (x>=pixel_min) and (x<=pixel_max)) // selected area
        then begin
            if flag_first then begin   // initialize using first valid pixel
                m_R:=cube_HSI4[x,f,2];
                m_G:=cube_HSI4[x,f,1];
                m_B:=cube_HSI4[x,f,0];
                flag_first:=FALSE;
                end;
            if abs(cube_HSI4[x,f,0])>m_B then m_B:=cube_HSI4[x,f,0];
            if abs(cube_HSI4[x,f,1])>m_G then m_G:=cube_HSI4[x,f,1];
            if abs(cube_HSI4[x,f,2])>m_R then m_R:=cube_HSI4[x,f,2];
            end;

    { Check maximum of red, green, blue bands to avoid division by zero }
    if abs(m_R)>nenner_min then max_R:=m_R;
    if abs(m_G)>nenner_min then max_G:=m_G;
    if abs(m_B)>nenner_min then max_B:=m_B;

    if abs(max_R)<nenner_min then max_R:=nenner_min;
    if abs(max_G)<nenner_min then max_G:=nenner_min;
    if abs(max_B)<nenner_min then max_B:=nenner_min;
    end;


procedure TFormat_2D.create_RGB(xmin, xmax: word);
var r      : byte;
    h, v   : word;
    dp     : double;
begin
    { Define bands for 1-channel preview.
      Reference band = band_B }
    if not flag_3bands then begin
        band_R:=band_B;
        band_G:=band_B;
        end;

    { Set array dimensions }
    SetLength(Channel_R, Width_in, Height_in);
    SetLength(Channel_G, Width_in, Height_in);
    SetLength(Channel_B, Width_in, Height_in);

    { Determine ranges of preview channels }
    if xmin=xmax then begin xmin:=0; xmax:=Width-1; end;
    determine_range_RGB(xmin, xmax);

    { Set ranges of all bands to maximum range }
    if flag_JoinBands then begin
        if max_R<max_G then max_R:=max_G;
        if max_R<max_B then max_R:=max_B;
        if max_G<max_R then max_G:=max_R;
        if max_G<max_B then max_G:=max_B;
        if max_B<max_R then max_B:=max_R;
        if max_B<max_G then max_B:=max_G;
        end;

    { Define Look-up table }
    if (not flag_3bands) and flag_LUT then import_LUT(2)
    else for r:=0 to 255 do begin
        LUT_R[2,r]:=r;
        LUT_G[2,r]:=r;
        LUT_B[2,r]:=r;
        end;

    { Convert floating band values to 8-bit integers }
     for v:=0 to Height_in-1 do
     for h:=0 to Width_in-1 do begin
         if WaterMask[h,v]=TRUE then begin
             if flag_3bands then begin  // display 3 bands
                 Channel_R[h,v]:=max255(255*contrast*(cube_HSI4[h,v,0]-thresh_below)/(max_R-thresh_below));
                 Channel_G[h,v]:=max255(255*contrast*(cube_HSI4[h,v,1]-thresh_below)/(max_G-thresh_below));
                 Channel_B[h,v]:=max255(255*contrast*(cube_HSI4[h,v,2]-thresh_below)/(max_B-thresh_below));
                 end
             else begin                 // display 1 band
                 dp:=Par0_Max-Par0_Min;
                 if abs(dp)<nenner_min then dp:=1;
                 Channel_R[h,v]:=max255(255*contrast*(cube_HSI4[h,v,0]-Par0_Min)/dp);
                 if dp<0 then if Channel_R[h,v]=255 then Channel_R[h,v]:=0;
                 Channel_G[h,v]:=Channel_R[h,v];
                 Channel_B[h,v]:=Channel_R[h,v];
                 end;
             if flag_LUT and not flag_3bands then begin // use LUT for 1 band
                 Channel_R[h,v]:=LUT_R[2, Channel_R[h,v]];
                 Channel_G[h,v]:=LUT_G[2, Channel_G[h,v]];
                 Channel_B[h,v]:=LUT_B[2, Channel_B[h,v]];
                 end;
              end
         else begin
             if (flag_CEOS) and (not flag_public) then begin
                 dp:=Par0_Max-Par0_Min;
                 if abs(dp)<nenner_min then dp:=1;
                 Channel_R[h,v]:=max255(255*contrast*(cube_HSI4[h,v,0]-Par0_Min)/dp);
                 if dp<0 then if Channel_R[h,v]=255 then Channel_R[h,v]:=0;
                 Channel_G[h,v]:=Channel_R[h,v];
                 Channel_B[h,v]:=Channel_R[h,v];
                 end
             else begin
                 Channel_R[h,v]:=GetRValue(clMaskImg);
                 Channel_G[h,v]:=GetGValue(clMaskImg);
                 Channel_B[h,v]:=GetBValue(clMaskImg);
                 end;
             end;
         end;

    end;


(*
procedure TFormat_2D.lies_HSI_line(b, z: word);
{ Import a single line 'z' of band 'b' of hyperspectral image to stream 'HSI_4'.
  Note: first line z has index 0, first band b has index 1. }
var i     : int64;
    pos64 : int64;
begin
    if interleave_in=0 then            // 0 = BIL
        pos64:=z*Channels_in + (b-1)
    else                               // 1 = BSQ
        pos64:=(b-1)*Height_in + z;
    pos64:=HSI_Header + pos64 * HSI_width;

    HSI_Stream.Seek(pos64, soBeginning);
    if Datentyp=1 then begin         // 8-bit  byte
        SetLength(HSI_1, Width_in);
        HSI_Stream.Read(HSI_1[0], HSI_width);
        for i:=0 to Width_in-1 do HSI_4[i]:=HSI_1[i];
        end
    else if Datentyp=2 then begin    // 16-bit signed integer
        SetLength(HSI_2, Width_in);
        HSI_Stream.Read(HSI_2[0], HSI_width);
        for i:=0 to Width_in-1 do HSI_4[i]:=HSI_2[i];
        end
    else if Datentyp=3 then begin    // 32-bit signed long integer
        SetLength(HSI_3, Width_in);
        HSI_Stream.Read(HSI_3[0], HSI_width);
        for i:=0 to Width_in-1 do HSI_4[i]:=HSI_3[i];
        end
    else if Datentyp=4 then begin    // 32-bit floating point
        SetLength(HSI_4, Width_in);
        HSI_Stream.Read(HSI_4[0], HSI_width);
        end
    else if Datentyp=12 then begin   // 16-bit unsigned integer
        SetLength(HSI_12, Width_in);
        HSI_Stream.Read(HSI_12[0], HSI_width);
        for i:=0 to Width_in-1 do HSI_4[i]:=HSI_12[i];
        end;
    if (y_scale<>1) and (y_scale>nenner_min) then
        for i:=0 to Width_in-1 do HSI_4[i]:=HSI_4[i]/y_scale;
    end;
*)

procedure TFormat_2D.check_bands_preview;
{ Check settings of bands used for preview for consistency. }
begin
    if Channels_in=1 then flag_3bands:=FALSE;
    if Band_R>Channels_in then begin
        Band_R:=Channels_in;
        Band_G:=Channels_in div 2;
        if Channels_in>=2 then Band_B:=2 else Band_B:=1;
        end;
    if Band_mask>Channels_in then band_mask:=Band_G;
    if Band_R<1 then Band_R:=1;
    if Band_G<1 then Band_G:=1;
    if Band_B<1 then Band_B:=1;
    end;

procedure TFormat_2D.show_scale;
{ Display LUT color bar }
const  HFont      = 18;
var h, v    : word;
    color   : TColor;
    R, G, B : longword;

begin
    RGB_Scale:=TBitmap.Create; { Bitmap-Objekt erstellen }
    try
    with RGB_Scale do begin

        // Increase window width if width of scale including text
        // is larger than image width
        if (3*RGB_left + RGB_width) > Constraints.MaxWidth then begin
            img_dX:=RGB_left;
            Constraints.MaxWidth:=3*RGB_left + RGB_width;
            end;

        Image_in.Left    :=img_dX;
        Image_in.Top     :=img_dY;
        RGB_Scale.Width  := RGB_width;
        RGB_Scale.Height := RGB_height;
        RGB_Scale.Pixelformat := pf24bit;
        for h:=0 to RGB_Scale.Width-1 do begin
            R:=max255(255*h*contrast/RGB_Scale.Width);
            G:=LUT_G[2,R] shl 8;
            B:=LUT_B[2,R] shl 16;
            R:=LUT_R[2,R];
            for v:=0 to RGB_Scale.Height-1 do begin
                color:=R+G+B;
                RGB_Scale.Canvas.Pixels[h,v] := color;
                end;
            end;
        Format_2D.Canvas.Draw(RGB_left, RGB_top, RGB_Scale);
        end;
    finally
        RGB_Scale.free;
    end;

    Label_min.Alignment :=taRightJustify;
    Label_min.width :=50;
    Label_min.Top   :=RGB_top + round(0.25*HFont);
    Label_max.Top   :=RGB_top + round(0.25*HFont);
    Label_band.Top  :=RGB_top + HFont + 4;
    Label_min.Left  :=RGB_left-Label_min.width-5;
    Label_max.Left  :=RGB_left+RGB_width+5;
    Label_min.Caption:=schoen(Par0_Min,1);
    Label_max.Caption:=schoen(Par0_Max,1);
    Label_min.visible:=TRUE;
    Label_max.visible:=TRUE;
    Label_min.Font.size:=11;
    Label_max.Font.size:=11;
    Label_band.Font.size:=11;

    Label_band.AutoSize :=FALSE;
    Label_band.Alignment :=taCenter;
    if bandname[band_B]='' then Label_band.Caption:='Band ' + inttostr(band_B)
                   else Label_band.Caption:=bandname[band_B];
    if (bandname[band_B]='') and (Channels_in=1) then Label_band.Caption:='';
    Label_band.Height:=16;

    Label_band.Left:=RGB_left;
    Label_band.Width:=RGB_width;
    Label_band.visible:=TRUE;

    end;



procedure TFormat_2D.hide_scale;
{ Hide LUT color bar }
var h, v : word;
begin
    Label_min.visible:=FALSE;
    Label_max.visible:=FALSE;
    Label_band.visible:=FALSE;

    RGB_Scale:=TBitmap.Create; { Bitmap-Objekt erstellen }
    try
    with RGB_Scale do begin
        RGB_Scale.Width  := RGB_width;
        RGB_Scale.Height := RGB_height;
        RGB_Scale.Pixelformat := pf24bit;
        for h:=0 to RGB_Scale.Width-1 do
        for v:=0 to RGB_Scale.Height-1 do
            RGB_Scale.Canvas.Pixels[h,v] := Format_2D.Color;
        Format_2D.Canvas.Draw (RGB_left, RGB_top, RGB_Scale);
        end;
    finally
        RGB_Scale.free;
    end;
    end;

function liesX(var datei: TextFile; var code: integer; CRLF:boolean):single;
{ Read numerical values from text file, ignore characters different from
  '0'..'9' and '.' }
var cc   : char;
    st   : string;
    xx   : single;
begin
    repeat
        read(datei, cc);
    until (cc in ['0'..'9','.']) or eoln(datei) or eof(datei);
    st:=cc;
    repeat
        read(datei, cc);
        st:=st+cc;
    until (not (cc in ['0'..'9','.'])) or eoln(datei) or eof(datei);
    val(copy(st, 1, length(st)-1), xx, code);
    if eoln(datei) then readlnS(datei,st,CRLF);
    if code=0 then liesX:=xx else liesX:=-1;
    end;

function extractX(var Z: string; var code: integer):single;
{ Extract numerical value from string Z, ignore characters different from
  '0'..'9' and '.' }
var x : single;
    b : integer;
begin
    { Remove leading non-numerical characters from string 'Z' }
    b:=0;
    if length(Z)>0 then begin
        repeat inc(b); until (Z[b] in ['0'..'9','.']) or (b>length(Z));
        Z:=copy(Z, b, length(Z)-b+1);
        end;
    { Determine number of leading numerical characters in string 'Z' }
    b:=0;
    if length(Z)>0 then
        repeat inc(b); until not (Z[b] in ['0'..'9','.']) or (b>length(Z));
    { Extract first numerical value 'x' from string 'Z' }
    x:=-1;
    if b>1 then val(copy(Z, 1, b-1), x, code) else code:=1;
    { Remove numerical characters of first numerical value from string 'Z' }
    Z:=copy(Z, b, length(Z)-b+1);
    if code=0 then extractX:=x else extractX:=-1;
    end;

procedure TFormat_2D.save_wavelengths(FileName:string);
{ Save center wavelengths and bandwiths to file. }
var  path       : string;
     LambdaFile : string;
     datei      : textFile;
     i          : word;
begin
    path:= path_exe + path_resampl;
    if not DirectoryExists(path) then
        if not ForceDirectories(path) then begin
            MessageBox(0, PChar(path), 'ERROR: Could not create directory ',
            MB_ICONSTOP+MB_OK);
            halt;
        end;
    LambdaFile:=path + file_lambda;
    AssignFile(datei, LambdaFile);
    {$i-} rewrite(datei);
    if ioresult=0 then begin  {$i+ }
        writeln(datei, 'This file was created by WASI-2D');
        writeln(datei, vers);
        writeln(datei);
        writeln(datei, 'Input image: ', FileName);
        if flag_fwhm then begin
            writeln(datei, 'band', #9, 'wavel.', #9, 'FWHM');
            for i:=1 to Channel_number do
                writeln(datei, i, #9, schoen(xx^.y[i],4), #9, schoen(FWHM^.y[i],3));
            end
        else begin
            writeln(datei, 'band', #9, 'wavelength');
            for i:=1 to Channel_number do
                writeln(datei, i, #9, schoen(xx^.y[i],4), #9, schoen(FWHM0,3));
            end;
        writeln(datei); { empty line at file end required for lies_spectrum }
        CloseFile(datei);
        end;
    end;

procedure TFormat_2D.adjust_x_scales;
{ Adjust wavelength scale using 'x_scale'. If necessary, correct 'x_scale'.
  Show warning message if something unexpected happens. }
var i        : word;
    warning  : string;
    previous : boolean;
begin
    previous:=HSI_img^.FName=HSI_old;
    for i:=1 to Channel_number do begin
        xx^.y[i]:=x_scale*xx^.y[i];
        FWHM^.y[i]:=x_scale*FWHM^.y[i];
        end;
    { Check plausibility of wavelength scale }
    if (xx^.y[1]>MinX) and (xx^.y[1]<MaxX) then flag_lambda:=TRUE
    else if (xx^.y[1]/x_scale>MinX) and (xx^.y[1]/x_scale<MaxX) then begin
        { x_scale was wrong }
        for i:=1 to Channels_in do begin
            xx^.y[i]  :=xx^.y[i]/x_scale;
            FWHM^.y[i]:=FWHM^.y[i]/x_scale;
            end;
        x_scale:=1; { x_scale is corrected }
        flag_lambda:=TRUE;
        warning:='Wrong x scale was corrected. ' +
                 'Check x scale and y scale in "Options - 2D".';
        if (not flag_background) and (not previous) then
            MessageBox(0, pchar(warning), 'WARNING', MB_OK);
        end
    else begin
        flag_lambda:=FALSE;
        warning:='Wavelengths of ENVI header are outside valid range, ' +
                 'thus wavelengths are taken from file ' +  file_lambda +
                 '. Check "Options - 2D - x scale".';
        if (not flag_background) and (not previous) then
            MessageBox(0, pchar(warning), 'WARNING', MB_OK);
        end;
    if ENVI_info[8]=FALSE then begin
        warning:='Could not read wavelengths from ENVI header, ' +
                 'thus wavelengths are taken from "Options - Data format"';
        if (not flag_background) and (not previous) then
            MessageBox(0, pchar(warning), 'WARNING', MB_OK);
        end;
    if ENVI_info[9]=FALSE then begin
        warning:='Could not read bandwidths from ENVI header, ' +
                 'thus bandwidths are taken from "Options - Data format"';
        if (not flag_background) and (not previous) then
            MessageBox(0, pchar(warning), 'WARNING', MB_OK);
        end;

    end;

function TFormat_2D.set_par(key:integer; CRLF:boolean):boolean;
{ Set image parameters using infos of Envi headerfile. }
var i, b         : integer;
    dummy_int    : integer;
    code         : integer;
    map_rot      : double;    { Rotation angle of image in degree }
begin
    FormatSettings.DecimalSeparator := '.';
    set_par:=FALSE;
    { Search for "=" sign }
    b:=1; repeat inc(b); until (Zeile[b]='=') or (b>length(Zeile));
    case key of
        1: begin { samples }
               val(copy(Zeile, b+1, length(Zeile)-b), dummy_int, code);
               if (code=0) and (dummy_int>1) then begin
                   Width_in:=dummy_int;
                   set_par:=TRUE;
                   end;
               end;
        2: begin { lines }
               val(copy(Zeile, b+1, length(Zeile)-b), dummy_int, code);
               if (code=0) and (dummy_int>1) then begin
                   Height_in:=dummy_int;
                   set_par:=TRUE;
                   end;
               end;
        3: begin { bands }
               val(copy(Zeile, b+1, length(Zeile)-b), dummy_int, code);
               if (code=0) and (dummy_int>=1) then begin
                   Channels_in:=dummy_int;
                   Channel_number:=Channels_in;
                   check_bands_preview;
                   set_par:=TRUE;
                   end;
               end;
        4: begin { header offset }
               val(copy(Zeile, b+1, length(Zeile)-b), dummy_int, code);
               if (code=0) then begin
                   HSI_header:=dummy_int;
                   set_par:=TRUE;
                   end;
               end;
        5: begin { data type }
               val(copy(Zeile, b+1, length(Zeile)-b), dummy_int, code);
               if (code=0) and (dummy_int>=1)
                           and ((dummy_int<=4) or (dummy_int=12))
                           then begin
                               Datentyp:=dummy_int;
                               set_par:=TRUE;
                               end;
               end;
        6: begin { interleave }
               Zeile:=AnsiLowerCase(copy(Zeile, b+1, length(Zeile)-b));
               if pos('bil', Zeile)<>0 then begin interleave_in:=0; set_par:=TRUE; end;
               if pos('bsq', Zeile)<>0 then begin interleave_in:=1; set_par:=TRUE; end;
               if pos('bip', Zeile)<>0 then begin interleave_in:=2; set_par:=TRUE; end;
               end;
        7: begin { wavelength units }
               if Pos('nanometers', Zeile)<>0  then begin x_scale:=1; set_par:=TRUE; end;
               if Pos('micrometers', Zeile)<>0 then begin x_scale:=1000; set_par:=TRUE; end;
               end;
        8: begin { wavelength = }
               i:=1;
               Zeile:=AnsiLowerCase(copy(Zeile, b+1, length(Zeile)-b));
               if pos('.', Zeile)<>0 then { line with keyword contains lambda values }
                   repeat
                       xx^.y[i]:=extractX(Zeile, code);
                       if code=0 then inc(i);
                   until (length(Zeile)<2) or (code<>0) or (i>Channels_in);
               {$i-}
               if (i<3) or (Zeile<>'}') then repeat  // no valid lambda values
                   xx^.y[i]:=liesX(ENVI_datei, code, CRLF);
                   inc(i);
               until i>Channels_in;
               Channel_number:=Channels_in;
               set_par:=TRUE;
               {$i+}
               end;
        9: begin { fwhm }
               i:=1;
               Zeile:=AnsiLowerCase(copy(Zeile, b+1, length(Zeile)-b));
               if pos('.', Zeile)<>0 then { line with keyword contains FWHM values }
                   repeat
                       FWHM^.y[i]:=extractX(Zeile, code);
                       if code=0 then inc(i);
                   until (length(Zeile)<2) or (code<>0) or (i>Channels_in);
               {$i-}
               if (i<3) or (Zeile<>'}') then repeat  // no valid FWHM values
                   FWHM^.y[i]:=liesX(ENVI_datei, code, CRLF);
                   inc(i);
               until i>Channels_in;
               Channel_number:=Channels_in;
               flag_fwhm:=TRUE;
               set_par:=TRUE;
               {$i+}
               end;
        10: begin { default bands }
               { Red band }
               Zeile:=copy(Zeile, b+1, length(Zeile)-b);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9']) or (b>length(Zeile));
               i:=b-1; repeat inc(i); until not (Zeile[i] in ['0'..'9']) or (i>length(Zeile));
               val(copy(Zeile, b, i-b+1), dummy_int, code);
               if (dummy_int>0) and (dummy_int<Channels_in) then begin
                   Band_R:=dummy_int;
                   set_par:=TRUE;
                   end;

               { Green band }
               Zeile:=copy(Zeile, i+1, length(Zeile)-i);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9']) or (b>length(Zeile));
               i:=b; repeat inc(i); until not (Zeile[i] in ['0'..'9']) or (i>length(Zeile));
               val(copy(Zeile, b, i-b+1), dummy_int, code);
               if (dummy_int>0) and (dummy_int<Channels_in) then begin
                   Band_G:=dummy_int;
                   set_par:=TRUE;
                   end;

               { Blue band }
               Zeile:=copy(Zeile, i+1, length(Zeile)-i);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9']) or (b>length(Zeile));
               i:=b; repeat inc(i); until not (Zeile[i] in ['0'..'9']) or (i>length(Zeile));
               val(copy(Zeile, b, i-b+1), dummy_int, code);
               if (dummy_int>0) and (dummy_int<Channels_in) then begin
                   Band_B:=dummy_int;
                   set_par:=TRUE;
                   end;
               end;
        11: begin { map info }
               flag_map:=TRUE;
               set_par:=TRUE;
               map_info:=Zeile;

               { x tie point; not used }
               Zeile:=copy(Zeile, b+1, length(Zeile)-b);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9']) or (b>length(Zeile));
               Zeile:=copy(Zeile, b, length(Zeile)-b+1);
               b:=0; repeat inc(b); until not (Zeile[b] in ['0'..'9','.','+','-','e','E']) or (b>length(Zeile));
               map_dN:=StrToFloat(copy(Zeile, 1, b-1));

               { y tie point; not used }
               Zeile:=copy(Zeile, b+1, length(Zeile)-b);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9']) or (b>length(Zeile));
               Zeile:=copy(Zeile, b, length(Zeile)-b+1);
               b:=0; repeat inc(b); until not (Zeile[b] in ['0'..'9','.','+','-','e','E']) or (b>length(Zeile));
               map_dN:=StrToFloat(copy(Zeile, 1, b-1));

               { map_E0 = coordinate East of first pixel }
               Zeile:=copy(Zeile, b+1, length(Zeile)-b);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9','-']) or (b>length(Zeile));
               Zeile:=copy(Zeile, b, length(Zeile)-b+1);
               b:=0; repeat inc(b); until not (Zeile[b] in ['0'..'9','.','+','-','e','E']) or (b>length(Zeile));
               map_E0:=StrToFloat(copy(Zeile, 1, b-1));

               { map_N0 = coordinate North of first pixel }
               Zeile:=copy(Zeile, b+1, length(Zeile)-b);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9','-']) or (b>length(Zeile));
               Zeile:=copy(Zeile, b, length(Zeile)-b+1);
               b:=0; repeat inc(b); until not (Zeile[b] in ['0'..'9','.','+','-','e','E']) or (b>length(Zeile));
               map_N0:=StrToFloat(copy(Zeile, 1, b-1));

               { map_dE = pixel size East }
               Zeile:=copy(Zeile, b+1, length(Zeile)-b);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9']) or (b>length(Zeile));
               Zeile:=copy(Zeile, b, length(Zeile)-b+1);
               b:=0; repeat inc(b); until not (Zeile[b] in ['0'..'9','.','+','-','e','E']) or (b>length(Zeile));
               map_dE:=StrToFloat(copy(Zeile, 1, b-1));
               if abs(map_dN)<nenner_min then begin
                   map_dE:=1;
                   flag_map:=FALSE;
                   end;

               { map_dN = pixel size North }
               Zeile:=copy(Zeile, b+1, length(Zeile)-b);
               b:=0; repeat inc(b); until (Zeile[b] in ['0'..'9']) or (b>length(Zeile));
               Zeile:=copy(Zeile, b, length(Zeile)-b+1);
               b:=0; repeat inc(b); until not (Zeile[b] in ['0'..'9','.','+','-','e','E']) or (b>length(Zeile));
               map_dN:=StrToFloat(copy(Zeile, 1, b-1));
               if abs(map_dN)<nenner_min then begin
                   map_dN:=1;
                   flag_map:=FALSE;
                   end;

               { map_rot = rotation angle of image }
               b:= Pos('rotation=', Zeile);
               if b>0 then begin
                   Zeile:=copy(Zeile, b+length('rotation='), length(Zeile)-b-length('rotation='));
                   b:=0; repeat inc(b); until not (Zeile[b] in ['0'..'9','.','+','-','e','E']) or (b>length(Zeile));
                   map_rot:=StrToFloat(copy(Zeile, 1, b-1));   // rotation angle in degree
                   map_sinr:=sin(pi*map_rot/180);              // sinus of map_rot
                   map_cosr:=cos(pi*map_rot/180);              // cosinus of map_rot
                   end
               else map_rot:=0;

               { Number of significant digits }
               map_SIG:=1 + max(round(ln(abs(map_N0/map_dN))/ln(10)),
                        round(ln(abs(map_E0/map_dE))/ln(10)));
               end;
        12: begin { band names }
               readlnS(ENVI_datei, Zeile, CRLF);
               b:=1; repeat inc(b); until (Zeile[b]<>' ') or (b>length(Zeile));
               Zeile:=copy(Zeile, b, length(Zeile)-b);
               i:=0;
               b:=1;
               repeat
                   if (Zeile[b]<>' ') and (Zeile[b]<>#9) and (Zeile[b]<>',') then
                       bandname[i+1]:=bandname[i+1]+Zeile[b];
                   if (Zeile[b]=',') then inc(i);
                   inc(b);
               until (i>=Channel_Number) or (b>=length(Zeile));
               set_par:=TRUE;
               end;
        end;
    end;

procedure TFormat_2D.Read_Envi_Header(FileName : string);
{ Read Envi headerfile of image 'FileName' }
var   Headerfile : string;         { name of Envi headerfile }
      key        : integer;        { index of Envi keyword }
      path_out   : ShortString;    { path of resampled spectra }
      k, ch      : word;           { index of channels }
      flag_CRLF  : boolean;        { format of Envi headerfile; TRUE: Windows }
      oldExt     : string[4];
begin
    flag_lambda:=FALSE;
    flag_fwhm:=FALSE;
    for k:=1 to MaxChannels do bandname[k]:='';
    oldExt:=AnsiUpperCase(ExtractFileExt(FileName));
    Headerfile:= ChangeFileExt(FileName, '.hdr');
    for k:=1 to ENVI_Keys do ENVI_info[k]:=FALSE;
    flag_CRLF:=ASCII_is_Windows(Headerfile);
    AssignFile(ENVI_datei, Headerfile);
    {$i-} reset(ENVI_datei);
    if ioresult=0 then begin  {$i+ }
        while not eof(ENVI_datei) do begin
            readlnS(ENVI_datei, Zeile, flag_CRLF);
            Zeile:=AnsiLowerCase(Zeile);
            for key:=1 to ENVI_Keys do
                if pos(ENVI_Keyword[key], Zeile)<>0 then
                    ENVI_info[key]:=set_par(key, flag_CRLF);
            end;
        CloseFile(ENVI_datei);
        if (oldExt<>'.FIT') and flag_HSI_wv then adjust_x_scales;
        if flag_lambda then begin
            save_wavelengths(FileName);
            path_out:=path_exe + path_resampl;
            flag_x_file:=TRUE;
            x^.Fname:=path_out + file_lambda;
            x^.Header:=5;
            x^.XColumn:=2;
            x^.YColumn:=3;  { FWHM }
            if flag_fwhm then begin
                lies_spektrum(x^,  x^.Fname, x^.XColumn, x^.YColumn, x^.Header, ch, false);
                xfile_xu:=xx^.y[1];
                xfile_xo:=xx^.y[ch];
                xfile_dx:=xx^.y[2]-xx^.y[1];
                for k:=1 to ch do FWHM^.y[k]:=x^.y[k];
                for k:=1 to ch do x^.y[k]:=xx^.y[k];
                resample_database(path_out);
                load_resampled_spectra(path_out, Channels_in);
                end
            else read_spectra;
            if flag_Y_exp then berechne_aY(S.actual);
            berechne_bbMie;
            set_borders;
            Nspectra:=0;
            flag_x_file:=TRUE;
            end;
        end;
    end;

procedure Write_Envi_Band_Names(var datei: textfile);
{  The bands of cube_fitpar contain the following information:
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
  cube_fitpar[10] = dL = NEdR / abs(1st derivative of Rrs)
  cube_fitpar[11] = zero or number of averaged files
}
begin
    write(datei, 'Rrs, Rrs_N, |delta_Rrs|, |delta_Rrs_N|, |dRrs_dL|, ');
    write(datei, '|dRrs_dL_N|, |d2Rrs_dL2|, |d2Rrs_dL2_N|, ');
    writeln(datei, 'dRrs_dL_zero, d2Rrs_dL2_zero, dL, N }');
    end;

procedure Write_Envi_Fitp_Names(var datei: textfile);
var p        : integer;
    name_out : array[1..M1]of string;
begin
    for p:=1 to M1 do name_out[p]:=par.name[p];
    // Change parameter name to file name from database
    for p:=0 to 5 do
        name_out[1+p]  := 'C_' + ExtractFileName(ChangeFileExt(aP[p]^.FName, ''));
    for p:=0 to 5 do
        name_out[30+p]  := 'fA_' + ExtractFileName(ChangeFileExt(albedo[p].FName, ''));

    write(datei, '  ');
    for p:=1 to M1 do if (par.fit[p]=1) then write(datei, name_out[p], ', ');
    writeln(datei, 'Resid, SAngle, NIter }');
    end;

procedure TFormat_2D.Write_Envi_Header_fit(FileName : string);
{ Write Envi Header of fit parameter image. }

{ Comment from 22 April 2020:
  I tried to write processor information such as "Intel i7 7th Generation"
  to the header file, but could not find the relevant system parameters.
  Someone has written a unit uSMBIOS for that purpose, but calling its
  function LProcessorInfo.ProcessorFamilyStr creates a runtime error.
  Due to lack of time I stopped my attempt. Here are the relevant links:
  https://theroadtodelphi.com/2013/03/27/getting-processor-info-using-object-pascal-delphi-fpc-and-the-tsmbios/
  https://github.com/RRUZ/tsmbios/blob/master/Common/uSMBIOS.pas
  https://github.com/RRUZ/tsmbios/blob/master/Samples%20Lazarus/Table%204%20Processor%20Information/ProcessorInformation.lpr }
var   datei      : textFile;
      Headerfile : string;
      memory     : TMemoryStatus;
begin
    memory.dwLength := SizeOf(memory);
    GlobalMemoryStatus(memory);
    set_parameter_names;
    Headerfile:= ChangeFileExt(FileName, '.hdr');
    AssignFile(datei, Headerfile);
    {$i-} rewrite(datei);
    if ioresult=0 then begin  {$i+ }
        writeln(datei, 'ENVI');
        writeln(datei, 'description = {');
        writeln(datei, '  This file was generated by the program WASI-2D');
        writeln(datei, '  ', vers);
        writeln(datei, '  Input file:       ', HSI_img^.FName);
        writeln(datei, '  Input pixels:     ', Width_in*Height_in);
        writeln(datei, '  Processed pixels: ', Np_water);
        writeln(datei, '  Masked pixels   : ', Np_masked);
        writeln(datei, '  Computer name:    ', SysUtils.GetEnvironmentVariable('COMPUTERNAME'));
        writeln(datei, '  RAM:              ' + schoen(memory.dwTotalPhys/1024/1024/1024,1) + ' GB');
        writeln(datei, '  Processors:       ', SysUtils.GetEnvironmentVariable('NUMBER_OF_PROCESSORS'));
        writeln(datei, '   " architecture:  ', SysUtils.GetEnvironmentVariable('PROCESSOR_ARCHITECTURE'));
        writeln(datei, '  CPU time:         ', schoen(TimeCalc, 3), ' sec = ',
                          schoen(TimeCalc/60, 2), ' min = ',
                          schoen(TimeCalc/3600, 3), ' h }');
        if flag_use_ROI and flag_cut_ROI then begin
            writeln(datei, ENVI_Keyword[1], ' = ', dpX);      { samples }
            writeln(datei, ENVI_Keyword[2], ' = ', dpF);      { lines }
            end
        else begin
            writeln(datei, ENVI_Keyword[1], ' = ', Width_in); { samples }
            writeln(datei, ENVI_Keyword[2], ' = ', Height_in);{ lines }
            end;
        writeln(datei, ENVI_Keyword[3], ' = ', Channels_out); { bands }
        writeln(datei, ENVI_Keyword[4], ' = ', 0);            { header offset = 0 }
        writeln(datei, ENVI_Keyword[5], ' = ', 4);            { data type = 4}
        if interleave_out=0 then writeln(datei, ENVI_Keyword[6], ' = bil')  { interleave }
        else if interleave_out=1 then writeln(datei, ENVI_Keyword[6], ' = bsq')  { interleave }
        else if interleave_out=2 then writeln(datei, ENVI_Keyword[6], ' = bip');  { interleave }
        writeln(datei, ENVI_Keyword[12], ' = {');             { band names}
        if (flag_CEOS and not flag_public) then Write_Envi_Band_Names(datei)
                     else Write_Envi_Fitp_Names(datei);
        if length(map_info)>1 then writeln(datei, map_info);   { map info }
        CloseFile(datei);
        end;
    end;

procedure TFormat_2D.Write_Envi_Header_spec(FileName: string; ch: integer);
{ Write Envi Header of multispectral image. }
var   datei      : textFile;
      Headerfile : string;
      k          : integer;
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
        writeln(datei, '  Input file: ', HSI_img^.FName);
        writeln(datei, '  Input pixels:     ', Width_in*Height_in);
        writeln(datei, '  Water pixels:     ', Np_water);
        writeln(datei, '  Masked pixels:    ', Np_masked);
        writeln(datei, '  Computer name:    ', SysUtils.GetEnvironmentVariable('COMPUTERNAME'));
        writeln(datei, '  Processor:        ', SysUtils.GetEnvironmentVariable('PROCESSOR_IDENTIFIER'));
        writeln(datei, '  CPU time:         ', schoen(TimeCalc, 3), ' sec = ',
                          schoen(TimeCalc/60, 2), ' min   }');
        if flag_use_ROI and flag_cut_ROI then begin
            writeln(datei, ENVI_Keyword[1], ' = ', dpX);      { samples }
            writeln(datei, ENVI_Keyword[2], ' = ', dpF);      { lines }
            end
        else begin
            writeln(datei, ENVI_Keyword[1], ' = ', Width_in); { samples }
            writeln(datei, ENVI_Keyword[2], ' = ', Height_in);{ lines }
            end;
        writeln(datei, ENVI_Keyword[3], ' = ', Channels_out); { bands }
        writeln(datei, ENVI_Keyword[4], ' = ', 0);            { header offset = 0 }
        writeln(datei, ENVI_Keyword[5], ' = ', 4);            { data type = 4}
        if interleave_out=0 then writeln(datei, ENVI_Keyword[6], ' = bil')  { interleave }
        else if interleave_out=1 then writeln(datei, ENVI_Keyword[6], ' = bsq')  { interleave }
        else if interleave_out=2 then writeln(datei, ENVI_Keyword[6], ' = bip');  { interleave }
        writeln(datei, ENVI_Keyword[7], ' nm');               { wavelength units }
        writeln(datei, ENVI_Keyword[8], ' {');                { wavelength }
        write(datei, '  ');
        for k:=1 to ch do begin
            write(datei, schoen(x^.y[k],5), ', ' );
            if (k mod 10)=0 then begin writeln(datei); write(datei, '  '); end;
            end;
        writeln(datei, ' }');
        writeln(datei, ENVI_Keyword[9], ' = {');              { FWHM }
        write(datei, '  ');
        for k:=1 to ch do begin
            write(datei, schoen(FWHM^.y[k],5), ', ' );
            if (k mod 10)=0 then begin writeln(datei); write(datei, '  '); end;
            end;
        writeln(datei, ' }');
        if length(map_info)>1 then writeln(datei, map_info);   { map info }
        CloseFile(datei);
        end;
    end;


procedure TFormat_2D.Write_Fitresult(Frames: word);
{ Save result of inverse modeling to file. }
var  Stream    : TFileStream;
     f, c, x   : word;
     Nx, Nf    : word;
begin
    Nx:=Width_in-1; Nf:=Frames;
    if flag_use_ROI and flag_cut_ROI then begin
        Nx:=dpX-1;
        Nf:=dpF-1;
        end;
    Stream := TFileStream.Create(Output_HSI, fmCreate);
    try
        if interleave_out=0 then  { BIL }
            for f:=0 to Nf do
            for c:=0 to Channels_out-1 do
            for x:=0 to Nx do
                Stream.Write(cube_fitpar[x,f,c], 4);
        if interleave_out=1 then  { BSQ }
            for c:=0 to Channels_out-1 do
            for f:=0 to Nf do
            for x:=0 to Nx do
                Stream.Write(cube_fitpar[x,f,c], 4);
        if interleave_out=1 then  { BIP }
            for f:=0 to Nf do
            for x:=0 to Nx do
            for c:=0 to Channels_out-1 do
                Stream.Write(cube_fitpar[x,f,c], 4);
    finally
        Stream.Free;
        end;
    end;


procedure TFormat_2D.exchange_ENVI_coordinates;
{ Exchange in the "map_info" string of the ENVI header file the coordinates of
  the first image pixel by the coordinates of the first ROI pixel.
  The coordinate transformation for rotated images is explained in the comment
  of the procedure show_coordinates. }
var b, b1, b2 : integer;
    Zeile     : string;
begin
    Zeile:=map_info;
    { Search for "=" sign }
    b:=1; repeat inc(b); until (Zeile[b]=',') or (b>length(Zeile));  // first comma
    repeat inc(b); until (Zeile[b]=',') or (b>length(Zeile));        // second comma
    repeat inc(b); until (Zeile[b]=',') or (b>length(Zeile));        // third comma
    b1:=b-1;                     // length of string before coordinates of first pixel
    repeat inc(b); until (Zeile[b]=',') or (b>length(Zeile));        // fourth comma
    repeat inc(b); until (Zeile[b]=',') or (b>length(Zeile));        // fifth comma
    b2:=b;                     // length of string after coordinates of first pixel
    map_info:=copy(Zeile, 0, b1) + ', '
        + FloatToStrF(map_E0 + map_cosr*pixel_min*map_dE
        + map_sinr*frame_min*map_dN, ffFixed, 8, 3)
        + ', '
        + FloatToStrF(map_N0 + map_sinr*pixel_min*map_dE
        - map_cosr*frame_min*map_dN, ffFixed, 8, 3)
        + copy(Zeile, b2, length(Zeile)-(b2-b1));
    end;


procedure TFormat_2D.import_HSI(Sender: TObject);
var  HSI_Stream : TFileStream;
     Len        : int64;
begin
    HSI_Stream:=TFileStream.Create(HSI_img^.FName, fmOpenRead or fmShareDenyWrite);
    try
        HSI_Stream.Seek(0, soBeginning);
        Len:=HSI_Stream.size;
        if Datentyp=1 then begin   // 8-bit  byte
            SetLength(HSI_byte, Len);
            HSI_Stream.Read(HSI_byte[0], Len);
            end else
        if Datentyp=2 then begin  // 16-bit signed integer
            SetLength(HSI_int16, Len);
            HSI_Stream.Read(HSI_int16[0], Len);
            end else
        if Datentyp=3 then begin  // 32-bit signed long integer
            SetLength(HSI_int32, Len);
            HSI_Stream.Read(HSI_int32[0], Len);
            end else
        if Datentyp=4 then begin  // 32-bit floating point
            SetLength(HSI_single, Len);
            HSI_Stream.Read(HSI_single[0], Len);
            end else
        if Datentyp=12 then begin  // 16-bit word
            SetLength(HSI_word, Len);
            HSI_Stream.Read(HSI_word[0], Len);
            end;
    finally
        HSI_Stream.free;
        end;
    end;

procedure TFormat_2D.HSI_free_memory(Sender: TObject);
begin
    SetLength(HSI_byte, 0);
    SetLength(HSI_int16, 0);
    SetLength(HSI_int32, 0);
    SetLength(HSI_single, 0);
    SetLength(HSI_word, 0);
    end;

procedure TFormat_2D.extract_spektrum_new(var spek: Attr_spec; h, v : word; Sender: TObject);
{ Read spectrum from position (h, v) of hyperspectral image.
  The indices h, v start at zero.  }
(*
var  in_byte   : byte;          { data type #1 }
     in_int16  : smallInt;      { data type #2 }
     in_int32  : integer;       { data type #3 }
     in_single : single;        { data type #4 }
     in_word   : word;          { data type #12 }
*)
var  Len       : byte;          { length of data type }
     x         : double;        { data value }
     b         : word;          { band number }
     pos64     : int64;         { position in file }
begin
    (*
    in_byte:=0;      // initialize in_byte
    in_int16:=0;     // initialize in_int16
    in_int32:=0;     // initialize in_int32
    in_single:=0;    // initialize in_single
    in_word:=0;      // initialize in_word
    *)
    Len:=0;          // initialize Len
    x:=0;            // initialize x

    if Datentyp=1 then Len:=1 else
    if Datentyp=2 then Len:=2 else
    if Datentyp=3 then Len:=4 else
    if Datentyp=4 then Len:=4 else
    if Datentyp=12 then Len:=2;

    for b:=0 to Channels_in-1 do begin
        if interleave_in=0 then       { 0 = BIL }
            pos64:=HSI_Header + v*Channels_in*Width_in + b*Width_in + h
        else if interleave_in=1 then  { 1 = BSQ }
            pos64:=HSI_Header + b*Width_in*Height_in + v*Width_in + h
        else                          { 2 = BIP }
            pos64:=HSI_Header + v*Channels_in*Width_in + h*Channels_in + b;

//        pos64:=HSI_Header + pos64*Len;
        if Datentyp=1 then begin
            x:=HSI_byte[pos64];
            end
        else if Datentyp=2 then begin
            x:=HSI_int16[pos64];
            if x<-32768 then x:=0;
            end
        else if Datentyp=3 then begin
            x:=HSI_int32[pos64];
            end
        else if Datentyp=4 then begin
            x:=HSI_single[pos64];
            end
        else if Datentyp=12 then begin
            x:=HSI_word[pos64];
            end;

        if (y_scale<>1) and (y_scale>nenner_min) then spek.y[b+1]:=x/y_scale
            else spek.y[b+1]:=x;
        end;

    flag_extract:=TRUE;    { spectrum 'spec' was extracted from image }
    end;

(*
var  Len   : byte;          // length of data type
     pos64 : int64;         // position in HSI array
begin
    if Datentyp=1 then begin
        Len:=1;
        HSI_Stream.Read(in_byte, Len);
        x:=in_byte;
        end
    else if Datentyp=2 then begin
        Len:=2;

        HSI_Stream.Read(in_int16, Len);
        if in_int16>-32768 then x:=in_int16;
        end
    else if Datentyp=3 then begin
        Len:=4;
        HSI_Stream.Read(in_int32, Len);
        x:=in_int32;
        end
    else if Datentyp=4 then begin
        Len:=4;
        HSI_Stream.Read(in_single, Len);
        x:=in_single;
        end
    else if Datentyp=12 then begin
        Len:=2;
        HSI_Stream.Read(in_word, Len);
        x:=in_word;
        end;

    end;
*)

(*
procedure TFormat_2D.extract_spektrum_old(var spek: Attr_spec; h, v : word; Sender: TObject);
{ Read spectrum from position (h, v) of hyperspectral image.
  The indices h, v start at zero.  }

{ Note: There is a 32-bit variant and a 64-bit variant of the function 'seek'.
  The offset parameter selects the variant: if the offset is of type integer
  (e.g. soFromBeginning), the 32-bit variant is used. If the offset is of type
  TSeekOrigin (e.g. soBeginning), the 64-bit variant is used.
  I spent much time to find out why imported files were erroneous when the
  file size was above 2 GByte. Error source was the 'seek' function. The
  problem could be solved by exchanging the argument 'soFromBeginning' with
  'soBeginning'. }

var  in_byte   : byte;          { data type #1 }
     in_int16  : smallInt;      { data type #2 }
     in_int32  : integer;       { data type #3 }
     in_single : single;        { data type #4 }
     in_word   : word;          { data type #12 }
     Len       : byte;          { length of data type }
     x         : double;        { data value }
     b         : word;          { band number }
     pos64     : int64;         { position in file }
begin
    HSI_Stream:=TFileStream.Create(HSI_img^.FName, fmOpenRead);

    in_byte:=0;      // initialize in_byte
    in_int16:=0;     // initialize in_int16
    in_int32:=0;     // initialize in_int32
    in_single:=0;    // initialize in_single
    in_word:=0;      // initialize in_word
    Len:=0;          // initialize Len
    x:=0;            // initialize x

    if Datentyp=1 then Len:=1 else
    if Datentyp=2 then Len:=2 else
    if Datentyp=3 then Len:=4 else
    if Datentyp=4 then Len:=4 else
    if Datentyp=12 then Len:=2;

    for b:=0 to Channels_in-1 do begin
        if interleave_in=0 then { 0 = BIL, 1 = BSQ }
            pos64:=v*Channels_in*Width_in + b*Width_in + h
        else
            pos64:=b*Width_in*Height_in + v*Width_in + h;
        pos64:=HSI_Header + pos64*Len;
        HSI_Stream.Seek(pos64, soBeginning);
        if Datentyp=1 then begin
            HSI_Stream.Read(in_byte, Len);
            x:=in_byte;
            end
        else if Datentyp=2 then begin
            HSI_Stream.Read(in_int16, Len);
            if in_int16>-32768 then x:=in_int16;
            end
        else if Datentyp=3 then begin
            HSI_Stream.Read(in_int32, Len);
            x:=in_int32;
            end
        else if Datentyp=4 then begin
            HSI_Stream.Read(in_single, Len);
            x:=in_single;
            end
        else if Datentyp=12 then begin
            HSI_Stream.Read(in_word, Len);
            x:=in_word;
            end;

        if (y_scale<>1) and (y_scale>nenner_min) then spek.y[b+1]:=x/y_scale
            else spek.y[b+1]:=x;
        end;

    HSI_Stream.Free;       { close HSI file }
    flag_extract:=TRUE;    { spectrum 'spec' was extracted from image }
    end;
*)

procedure TFormat_2D.create_mask;
{ Create mask }
var x, z : word;
begin
    check_bands_preview;
    SetLength(WaterMask, Width_in, Height_in);
    if pixel_max<=pixel_min then pixel_max:=Width_in;
    if frame_max<=frame_min then frame_max:=Height_in;
    Np_masked:=0;    // Number of masked pixels (no water)
    Np_water:=0;     // Number of water pixels to be processed
    for z:=0 to Height_in-1 do begin
        for x:=0 to Width_in-1 do
            if (cube_HSI4[x,z,3]<=thresh_above) and (cube_HSI4[x,z,3]>=thresh_below)
            // if 3 bands are shown,
            // at least one the preview channels must be > 0
            and (((abs(cube_HSI4[x,z,0])>0) or (abs(cube_HSI4[x,z,1])>0) or (abs(cube_HSI4[x,z,2])>0))
            or not flag_3bands)
            then begin
                WaterMask[x,z]:=TRUE;             // TRUE: water
                if (x>=pixel_min) and (x<=pixel_max) and
                   (z>=frame_min) and (z<=frame_max) then inc(Np_water);
                end
            else begin
                WaterMask[x,z]:=FALSE;             // FALSE: no water
                if (x>=pixel_min) and (x<=pixel_max) and
                   (z>=frame_min) and (z<=frame_max) then inc(Np_masked);
                end;
        end;
    end;

procedure TFormat_2D.show_spectrum(Sender: TObject);
begin
    mouseA:=ScreenToClient(Mouse.CursorPos);
    if (mouseA.X>=img_dX) and (mouseA.X<Width_in+img_dX) and
       (mouseA.Y>=img_dY) and (mouseA.Y<Height_in+img_dY) then begin
        spec[1]^.FName:=Format_2D.Caption;
        pixel_min:=mouseA.X-img_dX;
        frame_min:=mouseA.Y-img_dY;
        extract_spektrum_new(HSI_img^, pixel_min, frame_min, Sender);

        Form1.Frame_Batch1.CheckReadFile.Enabled:=TRUE;
        Form1.Frame_Batch1.CheckReadFile.checked:=TRUE;
        flag_b_invert:=FALSE;
        flag_batch:=FALSE;
        flag_b_loadAll:=TRUE;
        Form1.Frame_Batch1.update_parameterlist(Sender);

        with Form1 do begin
            S_actual:=1;
            NSpectra:=1;
            spec[S_actual]^:=HSI_img^;
            ActualFile:=YFilename(HSI_img^.FName);
            if (not flag_public) and flag_Rbottom then estimate_bottom_reflectance(2);
            if flag_autoscale then scale;
            farben1;
            zeichne(Sender, FALSE);
            end;
        end;
    end;


procedure TFormat_2D.average_spectrum(Sender: TObject);
{ Calculate mean and standard deviation for all spectra within a
  user defined rectangle. }
var c, h, v : word;
    N       : int64;
    mean    : spektrum;
    mean2   : spektrum;
    flag_merk : boolean;
    mCursor : TCursor;
begin
    if (lox>=0) and (lox<Width_in) and (loy>=0) and (loy<Height_in) then begin
        mCursor:=Screen.Cursor;
        Screen.Cursor:=crHourGlass;
        spec[1]^.FName:=Format_2D.Caption;
        if rux>=Width_in  then rux:=Width_in-1;
        if ruy>=Height_in then ruy:=Height_in-1;

        { Define rectangle for inverse modeling }
        frame_min:=loy;
        frame_max:=ruy;
        pixel_min:=lox;
        pixel_max:=rux;

        N:=0;
        for c:=0 to Channels_in-1 do begin
            mean[c+1] :=0;
            mean2[c+1]:=0;
            end;
        for h:=lox to rux do
        for v:=loy to ruy do begin
            extract_spektrum_new(HSI_img^, h, v, Sender);
            for c:=0 to Channels_in-1 do if WaterMask[h,v] then begin
                mean[c+1] :=mean[c+1]+HSI_img^.y[c+1];
                mean2[c+1]:=mean2[c+1]+sqr(HSI_img^.y[c+1]);
                if c=0 then inc(N);
                end;
            end;
        if N<1 then N:=1;
        for c:=0 to Channels_in-1 do begin
            HSI_img^.y[c+1]:=mean[c+1]/N;  { mean }
            spec[2]^.y[c+1]:=mean2[c+1]/N-sqr(mean[c+1]/N); { variance }
            if spec[2]^.y[c+1]>0 then spec[2]^.y[c+1]:=sqrt(spec[2]^.y[c+1])
                                 else spec[2]^.y[c+1]:=0;   { stddev }
            end;

        with Form1 do begin
            spec[1]^:=HSI_img^;
            ActualFile:=YFilename(HSI_img^.FName);
            S_actual:=1;
            NSpectra:=2;
            farbS[2]:=clRed;
            spec[1]^.ParText:='Mean';
            spec[2]^.ParText:='Stddev';
            if (not flag_public) and flag_Rbottom  and (NSpectra<3) then
                estimate_bottom_reflectance(3);
            if flag_autoscale then scale;
            flag_merk:=flag_batch;
            flag_batch:=FALSE; { damit Legende gezeichnet wird }
            farben1;
            zeichne(Sender, TRUE);
            flag_batch:=flag_merk;
            end;
        flag_avg:=TRUE;  { spectra 'spec' are averages of image pixels }
        Form1.Frame_Batch1.CheckBatch.Enabled:=TRUE;
        Form1.Frame_Batch1.CheckBatch.checked:=TRUE;
        flag_b_invert:=FALSE;
        flag_batch:=TRUE;
        flag_b_loadAll:=FALSE;
        Form1.Frame_Batch1.update_parameterlist(Sender);
        Screen.Cursor:=mCursor;
        end;
    end;


procedure TFormat_2D.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var  MousePos: TPoint;
begin
    flag_avg:=FALSE;
    GetCursorPos(MousePos);
    case Key of
        VK_LEFT:  SetCursorPos(MousePos.X-1, MousePos.Y);
        VK_RIGHT: SetCursorPos(MousePos.X+1, MousePos.Y);
        VK_UP:    SetCursorPos(MousePos.X, MousePos.Y-1);
        VK_DOWN:  SetCursorPos(MousePos.X, MousePos.Y+1);
        VK_F1:    Rb_from_defined_area(Sender);
        end;
    show_spectrum(Sender);
    end;



function TFormat_2D.Select_Filename_Output_HSI(Sender: TObject):boolean;
{ Select filename of output fit image. }
var  s        : string;
     dir_out  : string;
     scenario : string;
begin
    { Add scenario to file name }
    scenario:='';
    if flag_Martina then begin
        scenario:= Dialogs.InputBox('Add scenario description to file name', 'Scenario:', #0);
        if scenario<>#0 then scenario:=scenario + '_';
        end;
    { Suggest output file name }
    s:=ChangeFileExt(ExtractFileName(HSI_img^.FName), '_');
    s:=scenario+s+IntToStr(Em)+'p.fit';      // Em = number of fit parameters }
    Output_HSI:=s;
    dir_out:=ExtractFileDir(HSI_img^.FName);

    SaveDialogFitresults.Title:='Save image of fitparameters';
    if DirectoryExists(dir_out+'\fit\') then dir_out:=dir_out+'\fit\'
    else if CreateDir(dir_out+'\fit\')  then dir_out:=dir_out+'\fit\';
    SaveDialogFitresults.InitialDir:=dir_out;
    SaveDialogFitresults.Filter:='*.fit|*.fit|(*.*)|*.*|';
    SaveDialogFitresults.Filename:=s;
    if flag_background or SaveDialogFitresults.Execute then begin
         Output_HSI:=SaveDialogFitresults.FileName;
         if flag_background then Output_HSI:=dir_out+Output_HSI;
         Select_Filename_Output_HSI:=TRUE;
         end
    else Select_Filename_Output_HSI:=FALSE;;
    if ExtractFileExt(Output_HSI)='' then Output_HSI:=Output_HSI+'.fit';
    end;


procedure TFormat_2D.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: word);
begin
    mouse0:=ScreenToClient(Mouse.CursorPos);
    mouseA:=mouse0;
    mouse_down:=TRUE;
    BitBlt(TempBitmap.Canvas.Handle,0,0,1,1,
           Canvas.Handle, mouse0.X, mouse0.Y, SRCCOPY);
    end;

function min_int(a,b:integer):integer;
begin
    if a<=b then min_int:=a else min_int:=b;
    end;

procedure TFormat_2D.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: word);
begin
    if (TempBitmap.Width>1) or (TempBitmap.Height>1) then begin
        average_spectrum(Sender);                // calculate mean and sigma
        show_coordinates(Sender, Shift, X, Y);   // show mean and sigma
        Form_2D_Info.BringToFront;               // bring info window to front
        if (not flag_public) and flag_Rbottom then begin
            Rbottom_using_depth(Sender);
            if flag_autoscale then scale;
            Form1.farben1;
            Form1.zeichne(Sender, TRUE);
            end;
        end;
    mouse_down:=FALSE;
    flag_avg:=FALSE;
    end;

procedure TFormat_2D.draw_rectangle(Sender: TObject; xmin,xmax,ymin,ymax: word;
    farbe: TColor);
{ Draw rectangle }
var i : word;
begin
    for i:=xmin to xmax do TheGraphic.Canvas.Pixels[i,ymin] := farbe;
    for i:=xmin to xmax do TheGraphic.Canvas.Pixels[i,ymax] := farbe;
    for i:=ymin to ymax do TheGraphic.Canvas.Pixels[xmin,i] := farbe;
    for i:=ymin to ymax do TheGraphic.Canvas.Pixels[xmax,i] := farbe;
    end;

procedure TFormat_2D.plot_CalVal_data(Sender: TObject);
{ Plot data set imported from file 'CalVal'. }
var i, x, y : integer;
    farbe   : integer;
    dp      : single;
    h, v    : integer;
begin
    if (map_dN>0) and (map_dE>0) then for i:=1 to ValSet.N do begin
        TheGraphic.Canvas.Pen.Color := clBlack;
        TheGraphic.Canvas.Brush.Style := bsSolid;
        { Calculate image pixel coordinates corresponding to geographic position
          (map_E, map_N) of data set number i. }
         if map_sinr=0 then begin // image is oriented North-South
             x:=round((ValSet.map_E[i]-map_E0) / map_dE);
             y:=round((map_N0-ValSet.map_N[i]) / map_dN);
             end
         else begin               // image is rotated
             x:=round((map_sinr*(ValSet.map_N[i]-map_N0)+
                map_cosr*(ValSet.map_E[i]-map_E0))/map_dE);
             y:=round((map_sinr*(ValSet.map_E[i]-map_E0)+
                map_cosr*(-ValSet.map_N[i]+map_N0))/ map_dN);
             end;

        { Define pixel colour according to parameter value map_p.
          This colour scheme is useful to compare fit results with in-situ data. }
        dp:=Par0_Max-Par0_Min;
        if abs(dp)<nenner_min then dp:=1;
        farbe:=max255(255*contrast*(ValSet.map_p[i]-Par0_Min)/dp);
        if dp<0 then if farbe=255 then farbe:=0;
        farbe:=LUT_R[2,farbe] + LUT_G[2,farbe] shl 8 + LUT_B[2,farbe] shl 16;
        if flag_3bands then farbe:=clValData;
        TheGraphic.Canvas.Brush.Color := farbe;
        TheGraphic.Canvas.Ellipse(x-Val_dotsize, y-Val_dotsize, x+Val_dotsize, y+Val_dotsize);
        end;
    FormPaint(Sender);  { Refresh image preview }
    end;

procedure TFormat_2D.Rbottom_using_depth(Sender: TObject);
{  Calculate mean and standard deviation of bottom reflectance
   in user-defined area by using imported data of bottom depth. }
var z       : integer;
    pix_x   : integer;
    pix_y   : integer;
    FileExt : string[4];
    datei   : TextFile;
    sum     : spektrum;
    sum2    : spektrum;
    k       : integer;
    NN      : integer;
    zB_merk : double;
    zB_sum  : double;
    zB_sum2 : double;
begin
    FileExt:=Uppercase(ExtractFileExt(HSI_img^.FName));
    if (FileExt<>'.FIT') and (map_dN>0) and (map_dE>0) then with ValSet do begin
        for k:=1 to Channels_in do sum[k]:=0;
        for k:=1 to Channels_in do sum2[k]:=0;
        NN:=0;
        zB_sum:=0;
        zB_sum2:=0;
        zB_merk:=zB.actual;
        for z:=1 to N do begin
            { Calculate image pixel coordinates corresponding to geographic position
              (map_E, map_N) of data set number i. }
            if map_sinr=0 then begin // image oriented North-South
                pix_x:=round((ValSet.map_E[z]-map_E0) / map_dE);
                pix_y:=round((map_N0-ValSet.map_N[z]) / map_dN);
                end
            else begin  // image rotated
                pix_x:=round((map_sinr*(ValSet.map_N[z]-map_N0)+
                   map_cosr*(ValSet.map_E[z]-map_E0))/map_dE);
                pix_y:=round((map_sinr*(ValSet.map_E[z]-map_E0)+
                   map_cosr*(-ValSet.map_N[z]+map_N0))/ map_dN);
                end;

            { Consider only user-defined area and non-masked pixels }
            if (pix_x>=pixel_min) and (pix_x<=pixel_max) and
               (pix_y>=frame_min) and (pix_y<=frame_max) and WaterMask[pix_x,pix_y] then begin
                inc(NN);
                zB.actual:=abs(ValSet.map_p[z])+par.c[45]; { simulte z offset }
                zB_sum   :=zB_sum+zB.actual;
                zB_sum2  :=zB_sum2+sqr(zB.actual);
                extract_spektrum_new(HSI_img^, pix_x, pix_y, Sender);
                spec[1]^:=HSI_img^;
                estimate_bottom_reflectance(3);
                for k:=1 to Channels_in do sum[k]:=sum[k]+spec[3]^.y[k];
                for k:=1 to Channels_in do sum2[k]:=sum2[k]+sqr(spec[3]^.y[k]);
                end;
            end;
        if NN>0 then begin
            AssignFile(datei, ChangeFileExt(FName, '.Rb'));
            {$i-} rewrite(datei);
            writeln(datei, 'This file was generated by the program WASI');
            writeln(datei, vers);
            writeln(datei);
            writeln(datei, 'HSI image:   ', HSI_img^.FName);
            writeln(datei, 'CalVal file: ', FName);
            writeln(datei, 'N:           ', NN);
            writeln(datei, 'zB:          ', schoen(zB_sum/NN,3), ' +/- ',
                schoen(sqrt(abs(zB_sum2/NN - sqr(zB_sum/NN))), 3), ' m');
            writeln(datei);
            writeln(datei, 'nm', #9, 'R mean', #9, 'R sigma');
            for k:=1 to Channels_in do
                writeln(datei, schoen(x^.y[k],4), #9, schoen(sum[k]/NN, 4), #9,
                        schoen(sqrt(abs(sum2[k]/NN - sqr(sum[k]/NN))), 4));
            CloseFile(datei);
            {$i+}
            end;
        zB.actual:=zB_merk;
        end;
    end;

procedure TFormat_2D.Rb_from_defined_area(Sender: TObject);
{  Calculate mean and standard deviation of bottom reflectance
   in area defined in PRIVATE.INI by using imported data of bottom depth. }
begin
    if (not flag_public) and flag_Rbottom then begin
        { Display the selected area. }
        if (frame_min>0) or (frame_max<Width_in-1) or
           (pixel_min>0) or (pixel_max<Height_in-1) then begin
               draw_rectangle(Sender, pixel_min,pixel_max,frame_min,frame_max, clWhite);
               FormPaint(Sender);
               end;
        Rbottom_using_depth(Sender);
        if flag_autoscale then scale;
        Form1.farben1;
        Form1.zeichne(Sender, TRUE);
        end;
    end;

procedure TFormat_2D.Validate_data(Sender: TObject);
{ Export fit parameters together with measured data from file 'ValSet'
  for the locations specified in the file 'ValSet'. }
const SIG = 4;   { Significant digits }
var z, x, y : integer;
    FileExt : string[4];
    p       : string;        // Caption of third column of file 'ValSet'
    c       : integer;
    null    : integer;
    datei   : TextFile;
    valid   : boolean;
begin
    FileExt:=Uppercase(ExtractFileExt(HSI_img^.FName));
    if ((FileExt='.FIT') or (Channels_in<=3)) and (map_dN>0) and (map_dE>0) then with ValSet do begin

        // Determine caption 'p' of third column of file 'ValSet'
        c:=0;
        repeat inc(c); until (caption[c]=#9) or (c>length(caption));
        repeat inc(c); until (caption[c]=#9) or (c>length(caption));
        p:=copy(caption, c+1, length(caption)-c+1);
        c:=0; repeat inc(c); until (p[c]=#9) or (c>length(p));
        p:=copy(p, 1, c-1);
        if length(p)>0 then p:='_'+p;

        AssignFile(datei, ChangeFileExt(HSI_img^.FName, p+'.val'));
        {$i-} rewrite(datei);
        writeln(datei, 'This file was generated by the program WASI');
        writeln(datei, vers);
        writeln(datei);
        writeln(datei, 'Fitparameter file: ', HSI_img^.FName);
        writeln(datei, 'Validation file:   ', FName);
        writeln(datei);
        write(datei, 'Image-E', #9, 'Image-N', #9);
        if length(caption)>8 then write(datei, caption, #9)   // header info from ValSet
        else write(datei, 'Val-E', #9, 'Val-N', #9, 'Val-par', #9);
        for c:=1 to Channels_in do write(datei, bandname[c], #9);
        writeln(datei);
        for z:=1 to N do begin
            { Calculate image pixel coordinates corresponding to geographic position
             (map_E, map_N) of data set number i. }
            if map_sinr=0 then begin // image oriented North-South
                x:=round((ValSet.map_E[z]-map_E0) / map_dE);
                y:=round((map_N0-ValSet.map_N[z]) / map_dN);
                end
            else begin  // image rotated
                x:=round((map_sinr*(ValSet.map_N[z]-map_N0)+
                   map_cosr*(ValSet.map_E[z]-map_E0))/map_dE);
                y:=round((map_sinr*(ValSet.map_E[z]-map_E0)+
                   map_cosr*(-ValSet.map_N[z]+map_N0))/ map_dN);
                end;

            if (x>0) and (x<Width_in) and (y>0) and (y<Height_in) then begin
                extract_spektrum_new(HSI_img^, x, y, Sender);
                spec[1]^:=HSI_img^;
                null:=0;
                for c:=1 to Channels_in-3 do
                    if abs(spec[1]^.y[c])<nenner_min then inc(null);
                valid:= null<Channels_in-3;
                if valid and (spec[1]^.y[Channels_in]>=0) then begin  { NIter >=0 }
                    write(datei, schoen(map_E0 + map_cosr*x*map_dE +
                          map_sinr*y*map_dN, map_SIG), #9,
                          schoen(map_N0 + map_sinr*x*map_dE -
                          map_cosr*y*map_dN, map_SIG), #9);
                    write(datei, schoen(map_E[z], map_SIG), #9,
                             schoen(map_N[z], map_SIG), #9,
                             schoen(map_p[z],SIG), #9);
                    for c:=1 to Channels_in-1 do
                        write(datei, schoen(spec[1]^.y[c]*y_scale,SIG), #9);
                    writeln(datei, schoen(spec[1]^.y[Channels_in]*y_scale,2));
                    end;
                end;
            end;
        CloseFile(datei);
        {$i+}
        end;
    end;


procedure TFormat_2D.show_coordinates(Sender: TObject; Shift: TShiftState;
  X, Y: word);
{ Display coordinates of mouse pointer and values of the bands
  selected for preview.

  New 30.4.2020:
  The geographic coordinates of a rotated image are calculated using the transformation

  x' = x0 + cos(a)*Nx*dx - sin(a)*Ny*dy
  y' = y0 + sin(a)*Nx*dx + cos(a)*Ny*dy

  a is the rotation angle.
  (x0, y0) is the geographic coordinate of the first image pixel.
  (Nx, Ny) are the pixel numbers in x- and y-direction.
  (dx, dy) are the differences between two pixels of the input image in
  (x, y) direction in units of geographic coordinates.
  As the first pixel is top left while the coordinate system origin is bottom left,
  it is dx ≥ 0 and dy ≤ 0 for all pixels. This reverses the sign for the y-terms
  in pixel coordinates and leads to the following program code:

   map_E = map_E0 + map_cosr*pixel_x*map_dE + map_sinr*pixel_y*map_dN
   map_N = map_N0 + map_sinr*pixel_x*map_dE - map_cosr*pixel_y*map_dN

   WASI uses the following symbols: cos(a) = map_cosr, sin(a) = map_sinr,
   x0 = map_E0, y0 = map_N0, dx = map_dE, dy = map_dN, Nx = pixel_x, Ny = pixel_y.
   The parameters a, x0, y0, dx and dy are imported from the ENVI hdr file.
   The implementation of the equation was validated by comparing the edge
   coordinates of a rotated image in ENVI. }
var pixel_x, pixel_y : word;
begin
    if mouse_down then { restore original image }
        BitBlt(Canvas.Handle, lox+img_dX-HorzScrollBar.Position,
              loy+img_dY-VertScrollBar.Position, TempBitmap.Width,
              TempBitmap.Height, TempBitmap.Canvas.Handle,0,0,SRCCOPY);
    mouseA:=ScreenToClient(Mouse.CursorPos);
    if (mouseA.X>=img_dX) and (mouseA.X<=Width_in-1+img_dX) and
       (mouseA.Y>=img_dY) and (mouseA.Y<=Height_in-1+img_dY) then begin
       Form_2D_Info.visible:=TRUE;
       pixel_x:=mouseA.X-img_dX;
       pixel_y:=mouseA.Y-img_dY;

       if flag_avg then { Spectrum is average of several pixels }
           if flag_3bands then begin
               Form_2D_Info.List_Statistics.Rows[1].CommaText :=
                   inttostr(band_B) + ' ' + schoen(HSI_img^.y[band_B],2) + ' '
                   + schoen(spec[2]^.y[band_B],3);
               Form_2D_Info.List_Statistics.Rows[2].CommaText :=
                   inttostr(band_G) + ' ' + schoen(HSI_img^.y[band_G],2) + ' '
                   + schoen(spec[2]^.y[band_G],3);
               Form_2D_Info.List_Statistics.Rows[3].CommaText :=
                   inttostr(band_R) + ' ' + schoen(HSI_img^.y[band_R],2) + ' '
                   + schoen(spec[2]^.y[band_R],3);
               Form_2D_Info.List_Statistics.visible:=TRUE;
               Form_2D_Info.ShowStatistics(Sender);  // adjust column widths
               end
           else begin
               Form_2D_Info.List_Statistics.Rows[1].CommaText :=
                   inttostr(band_B) + ' ' + schoen(HSI_img^.y[band_B],3) + ' '
                   + schoen(spec[2]^.y[band_B],3);
               Form_2D_Info.List_Statistics.visible:=TRUE;
               Form_2D_Info.ShowStatistics(Sender);  // adjust column widths
               end
       else begin    { Spectrum is from a single pixel }
           Form_2D_Info.List_Statistics.visible:=FALSE;  // mean, sigma obsolete
           if flag_map then begin // show geographical coordinates
               Form_2D_Info.List_LatLong.Rows[1].CommaText :=
                   schoen(map_N0+map_sinr*pixel_x*map_dE-map_cosr*pixel_y*map_dN,map_SIG) + ', ' +
                   schoen(map_E0+map_cosr*pixel_x*map_dE+map_sinr*pixel_y*map_dN,map_SIG);
               if flag_show_EEM then
(*                   Label_xy.Caption:=      // EEM matrix
                   'ex = ' + schoen(map_E0+pixel_x*map_dE,map_SIG) + ' nm, ' +
                   'em = ' + schoen(map_N0+pixel_y*map_dN,map_SIG) + ' nm';        *)
               Form_2D_Info.List_LatLong.Rows[1].CommaText :=
                   'nm ' +
                   schoen(map_E0+map_cosr*pixel_x*map_dE+map_sinr*pixel_y*map_dN,map_SIG) + ' '
                   + schoen(map_N0+map_sinr*pixel_x*map_dE-map_cosr*pixel_y*map_dN,map_SIG);

               end
               else          // show pixel coordinates (x, y)
                   Form_2D_Info.List_LatLong.Rows[1].CommaText :=
                       inttostr(pixel_x) + ' ' + inttostr(pixel_y);

           if flag_3bands and ((pixel_x>0) and (pixel_x<=Width_in)
               and (pixel_y>0) and (pixel_y<=Height_in)) then begin
               Form_2D_Info.List_PixInfo.Rows[1].CommaText :=
                   inttostr(band_B) + ' ' + schoen(cube_HSI4[pixel_x,pixel_y,2],3);
               Form_2D_Info.List_PixInfo.Rows[2].CommaText :=
                   inttostr(band_G) + ' ' + schoen(cube_HSI4[pixel_x,pixel_y,1],3);
               Form_2D_Info.List_PixInfo.Rows[3].CommaText :=
                   inttostr(band_R) + ' ' + schoen(cube_HSI4[pixel_x,pixel_y,0],3);

               end
           else if (pixel_x>0) and (pixel_x<=Width_in)
               and (pixel_y>0) and (pixel_y<=Height_in) then
                   Form_2D_Info.List_PixInfo.Rows[1].CommaText :=
                       inttostr(band_B) + ' ' + schoen(cube_HSI4[pixel_x,pixel_y,2],3);
           end;
        if mouse_down then begin
            { save marked image temporally }
            lox:=min_int(mouseA.X, mouse0.X)-img_dX;
            loy:=min_int(mouseA.Y, mouse0.Y)-img_dY;
            TempBitmap.Width  := 1+abs(mouseA.X-mouse0.X);
            TempBitmap.Height := 1+abs(mouseA.Y-mouse0.Y);
            rux:=lox+TempBitmap.Width;
            ruy:=loy+TempBitmap.Height;
            BitBlt(TempBitmap.Canvas.Handle,0,0,TempBitmap.Width, TempBitmap.Height,
                   Canvas.Handle, lox+img_dX-HorzScrollBar.Position,
                   loy+img_dY-VertScrollBar.Position, SRCCOPY);
            Rahmen:=Rect(lox+img_dX-HorzScrollBar.Position,
                loy+img_dY-VertScrollBar.Position, rux+img_dX-HorzScrollBar.Position,
                ruy+img_dY-VertScrollBar.Position);

            Canvas.FrameRect(Rahmen);
            end;
        end;
    end;

procedure TFormat_2D.BSQtoBIL(File_BSQ : string);
{ Convert BSQ file format to BIL file format. }
var Stream_BSQ : TFileStream;
    Stream_BIL : TFileStream;
    File_BIL   : string;
    b, z       : word;
    Length     : int64;
    Line       : array of byte;
begin
    File_BIL := ChangeFileExt(File_BSQ, '.bil');
    if flag_ENVI then Format_2D.Read_Envi_Header(File_BSQ);
    Stream_BSQ := TFileStream.Create(File_BSQ, fmOpenRead);
    Stream_BIL := TFileStream.Create(File_BIL, fmCreate);
    Length:=(Stream_BSQ.Size-HSI_Header) div (Height_in*Channels_in);
    SetLength(Line, Length);
    for z:=0 to Height_in-1 do begin
        { skip file header and previous image lines }
        Stream_BSQ.Seek(HSI_Header+z*Length, soBeginning);
        { import and export each channel }
        for b:=1 to Channels_in do begin
            Stream_BSQ.Read(Line[0], Length);
            Stream_BIL.Write(Line[0], Length);
            if b<Channels_in then Stream_BSQ.Seek(Length*(Height_in-1), soCurrent);  { next channel }
            end;
        end;
    Stream_BSQ.Free;
    Stream_BIL.Free;
    end;

procedure TFormat_2D.set_ranges_avg_2D(f, x: word; out pixmin, pixmax: qword);
{ Set range of pixels used for averaging fit parameters.
  f = frame number, x = pixel number }
var xx, N_masked : word;
begin
    if N_avg>1 then pixmin:=x-1-(N_avg-3) div 3 else pixmin:=x-1;
    if N_avg>1 then pixmax:=x+1+(N_avg-4) div 3 else pixmax:=x-1;

    while (pixmin<0) do begin          // Left border
        inc(pixmin);
        if pixmax<pixel_max then inc(pixmax);
        end;
    while (pixmax>pixel_max) do begin  // Right border
        dec(pixmax);
        if pixmin>0 then dec(pixmin);
        end;

    { Increase range due to masked pixels. }
    N_masked:=0;
    if f>1 then for xx:=pixmin to pixmax-1 do if WaterMask[xx,f-1] then inc(N_masked);
    for xx:=pixmin to pixmax do if WaterMask[xx,f] then inc(N_masked);
    if f>1 then N_masked:=N_masked div 2;
    if pixmax+N_masked<=frame_max then pixmax:=pixmax+N_masked
                                  else pixmin:=pixmin-N_masked;

    { Make sure that pixmin and pixmax are within frame coordinates }
    if pixmin<0 then pixmin:=0;
    if pixmax>pixel_max then pixmax:=pixel_max;
    end;

procedure TFormat_2D.average_fitparameters_2D(f, x, xmin, xmax: word);
{ Average previously calculated fit parameters. Masked pixels are ignored. }
{ Dimensions of array mask: [0..Width_in-1, 0..Height_in-1] }
var i, p   : word;
    xx, N  : word;
    mean   : double;  // mean fitparameter
begin
    if f>Height_in-1 then f:=Height_in-1;
    if f<1 then f:=1;
    if xmax>Width_in-1 then xmax:=Width_in-1;
    if x>xmax then x:=xmax;
    if xmin<pixel_min then xmin:=pixel_min;
    if x<xmin then x:=xmin;
    if x<1 then x:=1;

    // Average all fitparameters
    i:=0;
    for p:=1 to M1 do if (par.fit[p]=1) then begin
        inc(i);
        mean:=0;
        N:=0;
        if f>=1+frame_min then for xx:=xmin to xmax do
            if Watermask[xx,f-1] and ((mean_R=0) or
            (cube_fitpar[xx-pixel_min,f-1-frame_min,Em]<2*mean_R)) then begin
                mean:=mean+cube_fitpar[xx-pixel_min,f-1-frame_min,i-1];
                inc(N);
                end;
        for xx:=xmin to x-1 do if WaterMask[xx,f] and ((mean_R=0) or
        (cube_fitpar[xx-pixel_min,f-frame_min,Em]<2*mean_R)) then begin
            mean:=mean+cube_fitpar[xx-pixel_min,f-frame_min,i-1];
            inc(N);
            end;
        if N>0 then par.c[p]:=mean/N;
        end;

    // Average residuum
    mean_R:=0;
    N:=0;
    if f>=1+frame_min then for xx:=xmin to xmax do if WaterMask[xx,f-1] then begin
        mean_R:=mean_R+cube_fitpar[xx-pixel_min,f-1-frame_min,Em];
        inc(N);
        end;
    for xx:=xmin to x-1 do if WaterMask[xx,f] then begin
        mean_R:=mean_R+cube_fitpar[xx-pixel_min,f-frame_min,Em];
        inc(N);
        end;
    if N>0 then mean_R:=mean_R/N;
    end;

procedure TFormat_2D.zB_analytical_2D(f, kzB1, kzB2, xmin, xmax: word; Sender: TObject);
{ Determine zB start value analytically. }
var k, zz, xx  : word;
    kIRu, kIRo : word;          // Test 14.8.2018
begin
    set_parameters_inverse;
    for k:=kzB1 to kzB2 do spec[2]^.y[k]:=0;

    kIRu:=Nachbar(850-20);
    kIRo:=Nachbar(850+20);
    refl_IR:=0;
    for k:=kIRu to kIRo do
        refl_IR:=refl_IR + spec[S_actual]^.y[k];
    refl_IR:=refl_IR/(kIRo-kIRu+1);

    zz:=0;
    for xx:=xmin to xmax do if WaterMask[xx,f] then begin
        extract_spektrum_new(spec[1]^, xx, f, Sender);
        for k:=kzB1 to kzB2 do spec[2]^.y[k]:=spec[2]^.y[k]+spec[1]^.y[k];
        inc(zz);
        end;
    if zz>0 then for k:=kzB1 to kzB2 do spec[1]^.y[k]:=spec[2]^.y[k]/zz;
    calc_initial_zB(1, kzB1, kzB2);
    end;

procedure TFormat_2D.Explore_bands(Sender: TObject);
{ Activate GUI elements to explore bands. }
begin
    // 22.8.2018    if VertScrollBar.Range>Screen.Height-100 then Height:=Screen.Height-100
    // 22.8.2018        else Height:=VertScrollBar.Range;
    Height:=Height+3*RGB_height;
    ScrollBar_Bands.visible:=TRUE;
    Label_Scroll_BB.visible:=TRUE;
    Label_Scroll_BG.visible:=TRUE;
    Label_Scroll_BR.visible:=TRUE;
    Label_Scroll_wB.visible:=TRUE;
    Label_Scroll_wG.visible:=TRUE;
    Label_Scroll_wR.visible:=TRUE;
    Button_ScrollBands.visible:=TRUE;
    Label_min.visible:=FALSE;
    Label_max.visible:=FALSE;
    if Channels_in>40 then ScrollBar_Bands.Width:=Channels_in;
    ScrollBar_Bands.Left :=(width-ScrollBar_Bands.width) div 2;
    Label_Scroll_BB.Left:=ScrollBar_Bands.Left-35;
    Label_Scroll_BG.Left:=ScrollBar_Bands.Left-35;
    Label_Scroll_BR.Left:=ScrollBar_Bands.Left-35;
    Label_Scroll_wB.Left:=ScrollBar_Bands.Left+ScrollBar_Bands.width+10;
    Label_Scroll_wG.Left:=ScrollBar_Bands.Left+ScrollBar_Bands.width+10;
    Label_Scroll_wR.Left:=ScrollBar_Bands.Left+ScrollBar_Bands.width+10;
    Button_ScrollBands.Left:=Label_Scroll_wB.Left+60;
    ScrollBar_Bands.Position:=band_B;
    ScrollBar_Bands.Top:=ClientHeight - 2*RGB_height;
    Label_Scroll_BB.Top:=ClientHeight - 3*RGB_height + 4;
    Label_Scroll_BG.Top:=ClientHeight - 2*RGB_height;
    Label_Scroll_BR.Top:=ClientHeight - RGB_height - 4;
    Label_Scroll_wB.Top:=Label_Scroll_BB.Top;
    Label_Scroll_wG.Top:=Label_Scroll_BG.Top;
    Label_Scroll_wR.Top:=Label_Scroll_BR.Top;
    Button_ScrollBands.Top:=Label_Scroll_BG.Top;
    ScrollBar_Bands.Min:=1;
    ScrollBar_Bands.Max:=Channels_in;
    bg:=band_G-band_B;    // difference between blue and green band
    br:=band_R-band_B;    // difference between blue and red band
    band_G:=band_B+bg;
    band_R:=band_B+br;
    Label_Scroll_BB.Caption:=inttoStr(band_B);
    Label_Scroll_BG.Caption:='Bands   '+inttoStr(band_G);
    Label_Scroll_BR.Caption:=inttoStr(band_R);
    Label_Scroll_wB.Caption :=inttoStr(round(x^.Y[band_b]))+' nm';
    Label_Scroll_wG.Caption :=inttoStr(round(x^.Y[band_g]))+' nm';
    Label_Scroll_wR.Caption :=inttoStr(round(x^.Y[band_r]))+' nm';
    end;

procedure TFormat_2D.ScrollBar_BandsScroll(Sender: TObject;
    ScrollCode: TScrollCode; var ScrollPos: word);
{ Change bands of preview image. The scroll bar position 'ScrollPos' sets the blue
  band. If single band preview is chosen, the red and green bands are also set to
  'ScrollPos'. Otherwise, the green band is set to 'ScrollPos + bg' and the red band
  to 'ScrollPos + br' with 'bg' the original distance between blue and green band,
  and 'br' the original distance between blue and red band. }
var dbg, dbr : word;            // band distances
begin
    dbg:=0;                     // initialize distance between blue and green band
    dbr:=0;                     // initialize distance between blue and red band
    if flag_3bands then begin   // if preview of 3 different bands is selected
        dbg:=bg;                // ... set distance between blue and green band
        dbr:=br;                // ... set distance between blue and red band
        end;
    band_B:=ScrollPos;          // change blue band
    band_G:=band_B+dbg;         // adjust green band
    band_R:=band_B+dbr;         // adjust red band

    { Asssure that the selected bands are within the available bands }
    if band_B<1 then band_B:=1 else if band_B>Channels_in then band_B:=Channels_in;
    if band_G<1 then band_G:=1 else if band_G>Channels_in then band_G:=Channels_in;
    if band_R<1 then band_R:=1 else if band_R>Channels_in then band_R:=Channels_in;

    { Set text labels of band numbers and wavelengths }
    Label_Scroll_BB.Caption :=inttoStr(band_B);
    Label_Scroll_BB.update;
    Label_Scroll_BG.Caption :='Bands   '+ inttoStr(band_G);
    Label_Scroll_BG.update;
    Label_Scroll_BR.Caption :=inttoStr(band_R);
    Label_Scroll_BR.update;
    Label_Scroll_wB.Caption :=inttoStr(round(x^.Y[band_b]))+' nm';
    Label_Scroll_wB.update;
    Label_Scroll_wG.Caption :=inttoStr(round(x^.Y[band_g]))+' nm';
    Label_Scroll_wG.update;
    Label_Scroll_wR.Caption :=inttoStr(round(x^.Y[band_r]))+' nm';
    Label_Scroll_wR.update;

    { Import the selected bands and display them }
 (*   import_RGB;                 // import the selected bands    *)
 //   load_RGB(Sender);
    create_RGB(0, Height_in-1);       // create RGB image
    PreviewHSI(Width_in, Height_in);  // show new RGB image on screen

    { Return scroll bar position for usage in procedure 'Button_ScrollBandsClick' }
    ScrollBar_Bands.Position:=ScrollPos;
    end;

procedure TFormat_2D.Button_ScrollBandsClick(Sender: TObject);
var scrollP, d : word;
begin
    scrollP:=2;
    if flag_3bands then d:=br else d:=0;
    repeat
        ScrollBar_BandsScroll(Sender, scLineDown, scrollP);
        scrollP:=scrollP+2;
        sleep(100); 
    until (scrollP+d > Channels_in);
    end;

end.

