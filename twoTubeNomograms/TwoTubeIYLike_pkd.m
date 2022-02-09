% TwoTubeIYLike.m   and subfunctions/DateTime 03-Feb-2011 2011 2 3 15 21 19.80
%#-h- filespacked.txt                                                                                       
%#/Users/tnearey/TmnTeach/TmnTeachWinter2011/Ling512Wi2011/Matlab512/SourceFilterMatlabDevel/TwoTubeIYLike.m
%#/Users/tnearey/NeareyMLTools/GraphTools/closefigs.m                                                       
%#/Users/tnearey/NeareyMLTools/GraphTools/font.m                                                            
%#/Users/tnearey/NeareyMLTools/filetools/askyn.m                                                            
%#/Users/tnearey/NeareyMLTools/filetools/questdlgSpecial.m                                                  
%#/Users/tnearey/NeareyMLTools/tnguitools/getrealinrange.m                                                  
% The OSI  "MIT License"
% Unless otherwise noted, the accompanying software is: 
% Copyright (c) 2011 Terrance M Nearey
% See http://www.opensource.org/licenses/mit-license.php

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

%#-h- TwoTubeIYLike.m                                                                                                                   
%  Saved from /Users/tnearey/TmnTeach/TmnTeachWinter2011/Ling512Wi2011/Matlab512/SourceFilterMatlabDevel/TwoTubeIYLike.m 2011/2/3 15:21

function TwoTubeIYLike () % 2 par model IY-Like WWWWnnnn configurtion                                                                   
% Version 2.0 corrected by Corey Telfer                                                                                                 
% Version 2.1 Jan 2011 TMN Cleaned up and enabled stepping graphics                                                                     
closefigs                                                                                                                               
close all                                                                                                                               
clear all                                                                                                                               
done=0;                                                                                                                                 
c=34400; % cmsec                                                                                                                        
L_total= 16;                                                                                                                            
Lb = 8.0;% 8 cm                                                                                                                         
% Plot the tube system and the resonances`                                                                                              
Rf=.6; % radius front for drawing                                                                                                       
Rb= 1.2; % cm                                                                                                                           
figure(2);                                                                                                                              
clf                                                                                                                                     
kmenu=menu('Automatic (final nomogram) or by hand','Auto', 'Step', 'By-Hand');                                                          
auto=kmenu<3;                                                                                                                           
step= kmenu==2;                                                                                                                         
if step                                                                                                                                 
    msgbox(' Click graph to increase back tube length. Right click to switch to auto')                                                  
end                                                                                                                                     
                                                                                                                                        
maxplot=500;                                                                                                                            
backres=zeros(maxplot,3);                                                                                                               
frontres=backres;                                                                                                                       
helmres=zeros(maxplot,1);                                                                                                               
nplot=0;                                                                                                                                
LbAuto=[.1:.1:15.9]; %#ok<*NBRAK>                                                                                                       
while ~done                                                                                                                             
    figure(1);                                                                                                                          
    nplot=nplot+1;                                                                                                                      
    if auto                                                                                                                             
        Lb=LbAuto(nplot);                                                                                                               
        if nplot==length(LbAuto),                                                                                                       
            done=1;                                                                                                                     
        end                                                                                                                             
    end                                                                                                                                 
    clf                                                                                                                                 
    Lf=L_total-Lb;                                                                                                                      
    x=[0,0,Lb,Lb,L_total];                                                                                                              
    ybot=[0,-Rb/2,-Rb/2,-Rf/2,-Rf/2];                                                                                                   
    ytop=-ybot;                                                                                                                         
    plot(x,ytop); hold on;                                                                                                              
    plot(x,ybot);                                                                                                                       
    set(gca,'xlim', [-1, 17])                                                                                                           
    set(gca,'ylim', [-2*Rb, 2*Rb])                                                                                                      
    title([' c = ', num2str(c), 'cm/s', 'Length total= ', num2str(L_total) ,' cm'])                                                     
    xlabel('Distance from closed end (cm)')                                                                                             
    f1back=c/(2*Lb);                                                                                                                    
    f1front= c/(2*Lf);                                                                                                                  
    f2back=2*f1back;                                                                                                                    
    f3back=3*f1back;                                                                                                                    
    f2front=2*f1front;                                                                                                                  
    f3front=3*f1front;                                                                                                                  
    A=pi*Rf^2;                                                                                                                          
    V=pi*Rb^2*Lb;                                                                                                                       
    %	fc = c/(2pi) sqrt(A/[V*Lf]),                                                                                                      
    f1helm= c/(2*pi)*sqrt(A/[V*Lf]);                                                                                                    
    backtitle=sprintf('Lb = %4.2f\n R1back %6.1f\n R2back %6.1f\n R3back %6.1f\n',Lb, f1back,f2back,f3back);                            
    fronttitle=sprintf('Lf = %4.2f\n R1front %6.1f\n R2front %6.1f\n R3front %6.1f\n',Lf, f1front,f2front, f3front);                    
    helmtitle1=sprintf('Radius of back tube (Rb) = %4.2f cm; Radius of front tube (Rf) = %4.2f cm\n', Rb, Rf);                          
    helmtitle2=sprintf('Vol = pi*Rb^2*Lb = %4.2f  A = pi*Rf^2 =,%4.2f,  RHemlholtz = %6.1f ', V, A, f1helm);                            
    helmtitle=[helmtitle1,helmtitle2];                                                                                                  
    text(0,-2,backtitle)                                                                                                                
    text(8,-2, fronttitle)                                                                                                              
    text(0,2,helmtitle);                                                                                                                
    drawnow                                                                                                                             
    figure(gcf)                                                                                                                         
    if ~auto                                                                                                                            
        kmenu=menu('Add to nomogram', 'yes','no');                                                                                      
        if kmenu==1                                                                                                                     
            figure(2)                                                                                                                   
            plot(Lb,[f1back,f2back,f3back],'x')                                                                                         
            hold on                                                                                                                     
            plot(Lb,[f1front,f2front,f3front],'o')                                                                                      
            title(' Back resonances x, front o')                                                                                        
            set(gca,'xlim', [-1, 17])                                                                                                   
            set(gca,'ylim', [0, 5000])                                                                                                  
        end                                                                                                                             
        kmenu=menu('More', 'yes', 'no');                                                                                                
        if kmenu==1                                                                                                                     
            Lb=getrealinrange('Length of back tube', Lb ,0,L_total);                                                                    
        else                                                                                                                            
            done=1;                                                                                                                     
        end                                                                                                                             
        % accumulate nomograms                                                                                                          
    end                                                                                                                                 
    xnplot(nplot)=Lb; %#ok<SAGROW>                                                                                                      
    backres(nplot,:)=[f1back,f2back,f3back];                                                                                            
    frontres(nplot,:)=[f1front,f2front,f3front];                                                                                        
    helmres(nplot)=f1helm;                                                                                                              
    if step                                                                                                                             
        [xx,yy,cc]=ginput(1);                                                                                                           
        if cc>1                                                                                                                         
            step=0;                                                                                                                     
        end                                                                                                                             
                                                                                                                                        
    end                                                                                                                                 
                                                                                                                                        
end                                                                                                                                     
                                                                                                                                        
% plot final nomogram;                                                                                                                  
[xnplot,isrt]=sort(xnplot);                                                                                                             
backres=backres(isrt,:);                                                                                                                
frontres=frontres(isrt,:);                                                                                                              
figure(3)                                                                                                                               
clf                                                                                                                                     
for ires=1:3                                                                                                                            
    plot(xnplot,backres(:,ires),'k', 'linewidth', 2)                                                                                    
    hold on                                                                                                                             
    plot(xnplot,frontres(:,ires),'k--','linewidth',2)                                                                                   
end                                                                                                                                     
plot(xnplot,helmres(isrt),'.','markersize',5)                                                                                           
set(gca,'Ylim', [0,5000])                                                                                                               
grid on                                                                                                                                 
font (14)                                                                                                                               
set(gca,'xlim',[-.5,16.5]);                                                                                                             
xlabel('Two tube [i]- like model: Length of back  tube (cm)','FontSize',14)                                                             
                                                                                                                                        
ylabel('Frequency (Hz)','FontSize',14)                                                                                                  
title([' c = ', num2str(c), 'cm/s', 'Length total= ', num2str(L_total) ,' cm'],'FontSize',14)                                           
                                                                                                                                        
end % function twoTubeIYLike                                                                                                            
%#-h- closefigs.m                                                                
%  Saved from /Users/tnearey/NeareyMLTools/GraphTools/closefigs.m 2011/2/3 15:21

function closefigs(figH)                                                         
% close figures cleanly by fixing CloseRequestFcn                                
% see also fig.m figinput.m                                                      
if nargin==0                                                                     
    figH=[];                                                                     
end                                                                              
if isempty(figH)                                                                 
figH=get(0,'children');                                                          
end                                                                              
for i=1:length(figH)                                                             
    set(figH(i),'CloseRequestFcn','closereq');                                   
    close(figH(i));                                                              
end     
end % close figs
%#-h- font.m                                                                
%  Saved from /Users/tnearey/NeareyMLTools/GraphTools/font.m 2011/2/3 15:21

function font(size);                                                        
%===================cut here==============                                  
% font: set font size                                                       
% Usage: font(size);                                                        
set(findobj('Type','axes'),'FontSize',size);                                
set(findobj('Type','text'),'FontSize',size);                                
%===================cut here==============                                  
%set(gca,'FontSize',size);                                                  
%set(get(gca,'Title'),'FontSize',size);                                     
%set(get(gca,'Xlabel'),'FontSize',size);                                    
%set(get(gca,'Ylabel'),'FontSize',size);                                    
end                                                                         
%#-h- askyn.m                                                               
%  Saved from /Users/tnearey/NeareyMLTools/filetools/askyn.m 2011/2/3 15:21

function [theBool,theAns]=askyn(questiontext)                               
% Ask yes or no -- expect Yes as default answer                             
% function [theBool,theAns]=askyn(questiontext)                             
% Ask yes or no -- expect Yes as default answer                             
% 1 if yes, 0 if no                                                         
% function [theBool,theAns]=askyn(questiontext)                             
% function =askyn                                                           
% INPUT                                                                     
% 1) questiontext  --   Text to display                                     
% OUTPUT                                                                    
% 1) theBool  --   1 or zero (true or false) for yes or no empty if canceled
% 2) theAns  --   'Yes" or 'No'                                             
% if canceled, keyboard is invoked.                                         
%%%%%%%%%% GenDefaultArgs ARGCHECKS %%%%%%%%%%%%%%%%                        
if nargin< 1 || isempty(questiontext)                                       
questiontext = 'Answer yes or no'; % default                                
end                                                                         
%%%%%%%%%%%% END  GenDefaultArgs  ARGCHECKS %%%%%%%%%%%%%%                  
%%%%%%%%%% GenDefaultOutputs ARGCHECKS %%%%%%%%%%%%%%%%                     
if nargout>= 1 % (theBool)                                                  
theBool = 0; % default                                                      
end                                                                         
if nargout>= 2 % (theAns)                                                   
theAns = ''; % default                                                      
end                                                                         
%%%%%%%%%%%% END  GenDefaultAOutputs  ARGCHECKS %%%%%%%%%%%%%%              
%% *** SEE ALSO ***                                                         
% Copyright (c) T M Nearey 2009                                             
% Version 1.1 28-Jun-2009                                                   
                                                                            
if nargin==0                                                                
    questiontext='Want it?';                                                
end                                                                         
try                                                                         
ButtonName=questdlgSpecial(questiontext);                                   
catch                                                                       
    ButtonName=questdlg(questiontext);                                      
end                                                                         
if isequal(ButtonName,'Yes')                                                
    theBool=1==1;                                                           
elseif isequal(ButtonName,'Cancel')                                         
    theBool=[];                                                             
    disp('Keyboarding ...')                                                 
    keyboard                                                                
else                                                                        
    theBool=1>1;                                                            
end                                                                         
theAns=ButtonName;                                                          
end % function                                                              
%#-h- questdlgSpecial.m                                                                                           
%  Saved from /Users/tnearey/NeareyMLTools/filetools/questdlgSpecial.m 2011/2/3 15:21
                            
function ButtonName=questdlgSpecial(Question,Title,Btn1,Btn2,Btn3,Default)                                        
%QUESTDLG Question dialog box.                                                                                    
%  ButtonName=QUESTDLG(Question) creates a modal dialog box that                                                  
%  automatically wraps the cell array or string (vector or matrix)                                                
%  Question to fit an appropriately sized window.  The name of the                                                
%  button that is pressed is returned in ButtonName.  The Title of                                                
%  the figure may be specified by adding a second string argument.                                                
%  Question will be interpreted as a normal string.                                                               
%                                                                                                                 
%  QUESTDLG uses WAITFOR to suspend execution until the user responds.                                            
%                                                                                                                 
%  The default set of buttons names for QUESTDLG are 'Yes','No' and                                               
%  'Cancel'.  The default answer for the above calling syntax is 'Yes'.                                           
%  This can be changed by adding a third argument which specifies the                                             
%  default Button.  i.e. ButtonName=questdlgSpecial(Question,Title,'No').                                         
%                                                                                                                 
%  Up to 3 custom button names may be specified by entering                                                       
%  the button string name(s) as additional arguments to the function                                              
%  call.  If custom ButtonName's are entered, the default ButtonName                                              
%  must be specified by adding an extra argument DEFAULT, i.e.                                                    
%                                                                                                                 
%    ButtonName=questdlgSpecial(Question,Title,Btn1,Btn2,DEFAULT);                                                
%                                                                                                                 
%  where DEFAULT=Btn1.  This makes Btn1 the default answer. If the                                                
%  DEFAULT string does not match any of the button string names, a                                                
%  warning message is displayed.                                                                                  
%                                                                                                                 
%  To use TeX interpretation for the Question string, a data                                                      
%  structure must be used for the last argument, i.e.                                                             
%                                                                                                                 
%    ButtonName=questdlgSpecial(Question,Title,Btn1,Btn2,OPTIONS);                                                
%                                                                                                                 
%  The OPTIONS structure must include the fields Default and Interpreter.                                         
%  Interpreter may be 'none' or 'tex' and Default is the default button                                           
%  name to be used.                                                                                               
%                                                                                                                 
%  If the dialog is closed without a valid selection, the return value                                            
%  is empty.                                                                                                      
%                                                                                                                 
%  Example:                                                                                                       
%                                                                                                                 
%  ButtonName=questdlgSpecial('What is your wish?', ...                                                           
%                      'Genie Question', ...                                                                      
%                      'Food','Clothing','Money','Money');                                                        
%                                                                                                                 
%                                                                                                                 
%  switch ButtonName,                                                                                             
%    case 'Food',                                                                                                 
%     disp('Food is delivered');                                                                                  
%    case 'Clothing',                                                                                             
%     disp('The Emperor''s  new clothes have arrived.')                                                           
%     case 'Money',                                                                                               
%      disp('A ton of money falls out the sky.');                                                                 
%  end % switch                                                                                                   
%                                                                                                                 
%  See also TEXTWRAP, INPUTDLG.                                                                                   
                                                                                                                  
%  Author: L. Dean                                                                                                
%  Copyright 1984-2002 The MathWorks, Inc.                                                                        
%  $Revision: 5.55 $                                                                                              
% HACKED TMN....                                                                                                  
persistent DefaultValid;                                                                                          
if nargin==0                                                                                                      
    questdlgSpecial('Testing questdlgSpecial')                                                                    
    return                                                                                                        
end                                                                                                               
if nargin<1,error('Too few arguments for QUESTDLG');end                                                           
                                                                                                                  
Interpreter='none';                                                                                               
if ~iscell(Question),Question=cellstr(Question);end                                                               
                                                                                                                  
if strcmp(Question{1},'#FigKeyPressFcn'),                                                                         
    QuestFig=get(0,'CurrentFigure');                                                                              
    AsciiVal= abs(get(QuestFig,'CurrentCharacter'));                                                              
    if ~isempty(AsciiVal),                                                                                        
        if AsciiVal==32 | AsciiVal==13,                                                                           
            % Check if the default string matches any button string.                                              
            % If not then dont resune till the user selects a valid input.                                        
            if(~DefaultValid)                                                                                     
	        warnstate = warning('backtrace','off');                                                                  
                warning('MATLAB:QUESTDLG:stringMismatch','Default string does not match any button string name.');
		warning(warnstate);                                                                                             
                return;                                                                                           
            end                                                                                                   
            set(QuestFig,'UserData',1);                                                                           
            uiresume(QuestFig);                                                                                   
        end %if AsciiVal                                                                                          
    end %if ~isempty                                                                                              
    return                                                                                                        
end                                                                                                               
%%%%%%%%%%%%%%%%%%%%%                                                                                             
%%% General Info. %%%                                                                                             
%%%%%%%%%%%%%%%%%%%%%                                                                                             
Black      =[0       0        0      ]/255;                                                                       
LightGray  =[192     192      192    ]/255;                                                                       
LightGray2 =[160     160      164    ]/255;                                                                       
MediumGray =[128     128      128    ]/255;                                                                       
White      =[255     255      255    ]/255;                                                                       
                                                                                                                  
%%%%%%%%%%%%%%%%%%%%                                                                                              
%%% Nargin Check %%%                                                                                              
%%%%%%%%%%%%%%%%%%%%                                                                                              
if nargout>1,error('Wrong number of output arguments for QUESTDLG');end                                           
if nargin==1,Title=' ';end                                                                                        
if nargin<=2, Default='Yes';end                                                                                   
if nargin==3, Default=Btn1;end                                                                                    
if nargin<=3, Btn1='Yes'; Btn2='No'; Btn3='Cancel';NumButtons=3;end                                               
if nargin==4, Default=Btn2;Btn2=[];Btn3=[];NumButtons=1;end                                                       
if nargin==5, Default=Btn3;Btn3=[];NumButtons=2;end                                                               
if nargin==6, NumButtons=3;end                                                                                    
if nargin>6, error('Too many input arguments');NumButtons=3;end                                                   
                                                                                                                  
if isstruct(Default),                                                                                             
  Interpreter=Default.Interpreter;                                                                                
  Default=Default.Default;                                                                                        
end                                                                                                               
                                                                                                                  
                                                                                                                  
%%%%%%%%%%%%%%%%%%%%%%%                                                                                           
%%% Create QuestFig %%%                                                                                           
%%%%%%%%%%%%%%%%%%%%%%%                                                                                           
FigPos=get(0,'DefaultFigurePosition');                                                                            
FigWidth=190;FigHeight=50;                                                                                        
if isempty(gcbf)                                                                                                  
    ScreenUnits=get(0,'Units');                                                                                   
    set(0,'Units','points');                                                                                      
    ScreenSize=get(0,'ScreenSize');                                                                               
    set(0,'Units',ScreenUnits);                                                                                   
                                                                                                                  
    %FigPos(1)=1/2*(ScreenSize(3)-FigWidth); % HACKED TMN                                                         
     FigPos(1)=1/16*(ScreenSize(1)+FigWidth);                                                                     
     %FigPos(2)=2/3*(ScreenSize(4)-FigHeight); % HACKED TMN                                                       
                                                                                                                  
    FigPos(2)=15/16*(ScreenSize(4)-FigHeight);                                                                    
                                                                                                                  
else                                                                                                              
    GCBFOldUnits = get(gcbf,'Units');                                                                             
    set(gcbf,'Units','points');                                                                                   
    GCBFPos = get(gcbf,'Position');                                                                               
    set(gcbf,'Units',GCBFOldUnits);                                                                               
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...                                              
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];                                                
end                                                                                                               
FigPos(3:4)=[FigWidth FigHeight];                                                                                 
QuestFig=dialog(                                               ...                                                
               'Visible'         ,'off'                      , ...                                                
               'Name'            ,Title                      , ...                                                
               'Pointer'         ,'arrow'                    , ...                                                
               'Units'           ,'points'                   , ...                                                
               'Position'        ,FigPos                     , ...                                                
               'KeyPressFcn'     ,'questdlgSpecial #FigKeyPressFcn;', ...                                         
               'UserData'        ,0                          , ...                                                
               'IntegerHandle'   ,'off'                      , ...                                                
               'WindowStyle'     ,'normal'                   , ...                                                
               'HandleVisibility','callback'                 , ...                                                
               'Tag'             ,Title                        ...                                                
               );                                                                                                 
                                                                                                                  
%%%%%%%%%%%%%%%%%%%%%                                                                                             
%%% Set Positions %%%                                                                                             
%%%%%%%%%%%%%%%%%%%%%                                                                                             
%DefOffset=3;                                                                                                     
DefOffset=7;                                                                                                      
                                                                                                                  
%IconWidth=32;                                                                                                    
IconWidth=36;                                                                                                     
%IconHeight=32;                                                                                                   
IconHeight=37;                                                                                                    
IconXOffset=DefOffset;                                                                                            
IconYOffset=FigHeight-DefOffset-IconHeight;                                                                       
IconCMap=[Black;get(QuestFig,'Color')];                                                                           
                                                                                                                  
DefBtnWidth=40;                                                                                                   
BtnHeight=20;                                                                                                     
BtnYOffset=DefOffset;                                                                                             
BtnFontSize=get(0,'FactoryUIControlFontSize');                                                                    
BtnFontName=get(0,'FactoryUIControlFontName');                                                                    
                                                                                                                  
BtnWidth=DefBtnWidth;                                                                                             
                                                                                                                  
ExtControl=uicontrol(QuestFig   , ...                                                                             
                     'Style'    ,'pushbutton', ...                                                                
                     'String'   ,' '         , ...                                                                
                     'FontUnits','points'    , ...                                                                
                     'FontSize' ,BtnFontSize , ...                                                                
                     'FontName' ,BtnFontName   ...                                                                
                     );                                                                                           
                                                                                                                  
set(ExtControl,'String',Btn1);                                                                                    
BtnExtent=get(ExtControl,'Extent');                                                                               
BtnWidth=max(BtnWidth,BtnExtent(3)+8);                                                                            
if NumButtons > 1                                                                                                 
  set(ExtControl,'String',Btn2);                                                                                  
  BtnExtent=get(ExtControl,'Extent');                                                                             
  BtnWidth=max(BtnWidth,BtnExtent(3)+8);                                                                          
  if NumButtons > 2                                                                                               
    set(ExtControl,'String',Btn3);                                                                                
    BtnExtent=get(ExtControl,'Extent');                                                                           
    BtnWidth=max(BtnWidth,BtnExtent(3)+8);                                                                        
  end                                                                                                             
end                                                                                                               
                                                                                                                  
delete(ExtControl);                                                                                               
                                                                                                                  
MsgTxtXOffset=IconXOffset+IconWidth;                                                                              
                                                                                                                  
FigWidth=max(FigWidth,MsgTxtXOffset+NumButtons*(BtnWidth+2*DefOffset));                                           
FigPos(3)=FigWidth;                                                                                               
set(QuestFig,'Position',FigPos);                                                                                  
                                                                                                                  
BtnXOffset=zeros(NumButtons,1);                                                                                   
                                                                                                                  
if NumButtons==1,                                                                                                 
  BtnXOffset=(FigWidth-BtnWidth)/2;                                                                               
elseif NumButtons==2,                                                                                             
  BtnXOffset=[MsgTxtXOffset                                                                                       
              FigWidth-DefOffset-BtnWidth];                                                                       
elseif NumButtons==3,                                                                                             
  BtnXOffset=[MsgTxtXOffset                                                                                       
              0                                                                                                   
              FigWidth-DefOffset-BtnWidth];                                                                       
  BtnXOffset(2)=(BtnXOffset(1)+BtnXOffset(3))/2;                                                                  
end                                                                                                               
                                                                                                                  
MsgTxtYOffset=DefOffset+BtnYOffset+BtnHeight;                                                                     
MsgTxtWidth=FigWidth-DefOffset-MsgTxtXOffset-IconWidth;                                                           
MsgTxtHeight=FigHeight-DefOffset-MsgTxtYOffset;                                                                   
MsgTxtForeClr=Black;                                                                                              
MsgTxtBackClr=get(QuestFig,'Color');                                                                              
                                                                                                                  
CBString='uiresume(gcf)';                                                                                         
                                                                                                                  
% Checks to see if the Default string passed does match one of the                                                
% strings on the buttons in the dialog. If not, throw a warning.                                                  
DefaultValid = 0;                                                                                                 
ButtonString=Btn1;                                                                                                
ButtonTag='Btn1';                                                                                                 
BtnHandle(1)=uicontrol(QuestFig            , ...                                                                  
			'Style'              ,'pushbutton', ...                                                                        
			'Units'              ,'points'    , ...                                                                        
			'Position'           ,[ BtnXOffset(1) BtnYOffset  ...                                                          
		                                BtnWidth       BtnHeight   ...                                                  
		                              ]           , ...                                                                 
			'CallBack'           ,CBString    , ...                                                                        
			'String'             ,ButtonString, ...                                                                        
			'HorizontalAlignment','center'    , ...                                                                        
			'FontUnits'          ,'points'    , ...                                                                        
			'FontSize'           ,BtnFontSize , ...                                                                        
			'FontName'           ,BtnFontName , ...                                                                        
			'Tag'                ,ButtonTag     ...                                                                        
			);                                                                                                             
if strcmp(ButtonString, Default)                                                                                  
    DefaultValid = 1;                                                                                             
    set(BtnHandle(1),'FontWeight','bold');                                                                        
end                                                                                                               
                                                                                                                  
if NumButtons > 1                                                                                                 
  ButtonString=Btn2;                                                                                              
  ButtonTag='Btn2';                                                                                               
  BtnHandle(2)=uicontrol(QuestFig            , ...                                                                
			  'Style'              ,'pushbutton', ...                                                                      
			  'Units'              ,'points'    , ...                                                                      
			  'Position'           ,[ BtnXOffset(2) BtnYOffset  ...                                                        
		                                  BtnWidth       BtnHeight   ...                                                
		                                ]           , ...                                                               
			  'CallBack'           ,CBString    , ...                                                                      
			  'String'             ,ButtonString, ...                                                                      
			  'HorizontalAlignment','center'    , ...                                                                      
			  'FontUnits'          ,'points'    , ...                                                                      
			  'FontSize'           ,BtnFontSize , ...                                                                      
			  'FontName'           ,BtnFontName , ...                                                                      
			  'Tag'                ,ButtonTag     ...                                                                      
			  );                                                                                                           
  if strcmp(ButtonString, Default)                                                                                
      DefaultValid = 1;                                                                                           
      set(BtnHandle(2),'FontWeight','bold');                                                                      
  end                                                                                                             
                                                                                                                  
  if NumButtons > 2                                                                                               
    ButtonString=Btn3;                                                                                            
    ButtonTag='Btn3';                                                                                             
    BtnHandle(3)=uicontrol(QuestFig            , ...                                                              
			    'Style'              ,'pushbutton', ...                                                                    
			    'Units'              ,'points'    , ...                                                                    
			    'Position'           ,[ BtnXOffset(3) BtnYOffset  ...                                                      
                                		    BtnWidth       BtnHeight   ...                                              
		                                  ]           , ...                                                             
			    'CallBack'           ,CBString    , ...                                                                    
			    'String'             ,ButtonString, ...                                                                    
			    'HorizontalAlignment','center'    , ...                                                                    
			    'FontUnits'          ,'points'    , ...                                                                    
			    'FontSize'           ,BtnFontSize , ...                                                                    
                'FontName'           ,BtnFontName , ...                                                           
			    'Tag'                ,ButtonTag     ...                                                                    
			    );                                                                                                         
    if strcmp(ButtonString, Default)                                                                              
      DefaultValid = 1;                                                                                           
      set(BtnHandle(3),'FontWeight','bold');                                                                      
    end                                                                                                           
  end                                                                                                             
end                                                                                                               
                                                                                                                  
if(DefaultValid == 0)                                                                                             
  warnstate = warning('backtrace','off');                                                                         
  warning('MATLAB:QUESTDLG:stringMismatch','Default string does not match any button string name.');              
  warning(warnstate);                                                                                             
end                                                                                                               
                                                                                                                  
MsgHandle=uicontrol(QuestFig            , ...                                                                     
                   'Style'              ,'text'         , ...                                                     
                   'Units'              ,'points'       , ...                                                     
                   'Position'           ,[MsgTxtXOffset      ...                                                  
                                          MsgTxtYOffset      ...                                                  
                                          0.95*MsgTxtWidth   ...                                                  
                                          MsgTxtHeight       ...                                                  
                                         ]              , ...                                                     
                   'String'             ,{' '}          , ...                                                     
                   'Tag'                ,'Question'     , ...                                                     
                   'HorizontalAlignment','left'         , ...                                                     
                   'FontUnits'          ,'points'       , ...                                                     
                   'FontWeight'         ,'bold'         , ...                                                     
                   'FontSize'           ,BtnFontSize    , ...                                                     
                   'FontName'           ,BtnFontName    , ...                                                     
                   'BackgroundColor'    ,MsgTxtBackClr  , ...                                                     
                   'ForegroundColor'    ,MsgTxtForeClr    ...                                                     
                   );                                                                                             
                                                                                                                  
[WrapString,NewMsgTxtPos]=textwrap(MsgHandle,Question,75);                                                        
                                                                                                                  
NumLines=size(WrapString,1);                                                                                      
                                                                                                                  
% The +2 is to add some slop for the border of the control.                                                       
MsgTxtWidth=max(MsgTxtWidth,NewMsgTxtPos(3)+2);                                                                   
MsgTxtHeight=NewMsgTxtPos(4)+2;                                                                                   
                                                                                                                  
MsgTxtXOffset=IconXOffset+IconWidth+DefOffset;                                                                    
FigWidth=max(NumButtons*(BtnWidth+DefOffset)+DefOffset, ...                                                       
             MsgTxtXOffset+MsgTxtWidth+DefOffset);                                                                
                                                                                                                  
                                                                                                                  
% Center Vertically around icon                                                                                   
if IconHeight>MsgTxtHeight,                                                                                       
  IconYOffset=BtnYOffset+BtnHeight+DefOffset;                                                                     
  MsgTxtYOffset=IconYOffset+(IconHeight-MsgTxtHeight)/2;                                                          
  FigHeight=IconYOffset+IconHeight+DefOffset;                                                                     
% center around text                                                                                              
else,                                                                                                             
  MsgTxtYOffset=BtnYOffset+BtnHeight+DefOffset;                                                                   
  IconYOffset=MsgTxtYOffset+(MsgTxtHeight-IconHeight)/2;                                                          
  FigHeight=MsgTxtYOffset+MsgTxtHeight+DefOffset;                                                                 
end                                                                                                               
                                                                                                                  
if NumButtons==1,                                                                                                 
  BtnXOffset=(FigWidth-BtnWidth)/2;                                                                               
elseif NumButtons==2,                                                                                             
  BtnXOffset=[(FigWidth-DefOffset)/2-BtnWidth                                                                     
              (FigWidth+DefOffset)/2                                                                              
              ];                                                                                                  
                                                                                                                  
elseif NumButtons==3,                                                                                             
  BtnXOffset(2)=(FigWidth-BtnWidth)/2;                                                                            
  BtnXOffset=[BtnXOffset(2)-DefOffset-BtnWidth                                                                    
              BtnXOffset(2)                                                                                       
              BtnXOffset(2)+BtnWidth+DefOffset                                                                    
             ];                                                                                                   
end                                                                                                               
                                                                                                                  
FigPos(3:4)=[FigWidth FigHeight];                                                                                 
                                                                                                                  
set(QuestFig ,'Position',FigPos);                                                                                 
                                                                                                                  
BtnPos=get(BtnHandle,{'Position'});BtnPos=cat(1,BtnPos{:});                                                       
BtnPos(:,1)=BtnXOffset;                                                                                           
BtnPos=num2cell(BtnPos,2);                                                                                        
set(BtnHandle,{'Position'},BtnPos);                                                                               
                                                                                                                  
delete(MsgHandle);                                                                                                
AxesHandle=axes('Parent',QuestFig,'Position',[0 0 1 1],'Visible','off');                                          
                                                                                                                  
MsgHandle=text( ...                                                                                               
    'Parent'              ,AxesHandle                      , ...                                                  
    'Units'               ,'points'                        , ...                                                  
    'FontUnits'           ,'points'                        , ...                                                  
    'FontSize'            ,BtnFontSize                     , ...                                                  
    'FontName'            ,BtnFontName                     , ...                                                  
    'HorizontalAlignment' ,'left'                          , ...                                                  
    'VerticalAlignment'   ,'bottom'                        , ...                                                  
    'HandleVisibility'    ,'callback'                      , ...                                                  
    'Position'            ,[MsgTxtXOffset MsgTxtYOffset 0] , ...                                                  
    'String'              ,WrapString                      , ...                                                  
    'Interpreter'         ,Interpreter                     , ...                                                  
    'Tag'                 ,'Question'                        ...                                                  
    );                                                                                                            
                                                                                                                  
IconAxes=axes(                                      ...                                                           
             'Units'       ,'points'              , ...                                                           
             'Parent'      ,QuestFig              , ...                                                           
             'Position'    ,[IconXOffset IconYOffset  ...                                                         
                             IconWidth IconHeight], ...                                                           
             'NextPlot'    ,'replace'             , ...                                                           
             'Tag'         ,'IconAxes'              ...                                                           
             );                                                                                                   
                                                                                                                  
set(QuestFig ,'NextPlot','add');                                                                                  
                                                                                                                  
load dialogicons.mat                                                                                              
IconData=questIconData;                                                                                           
questIconMap(256,:)=get(QuestFig,'color');                                                                        
IconCMap=questIconMap;                                                                                            
                                                                                                                  
Img=image('CData',IconData,'Parent',IconAxes);                                                                    
set(QuestFig, 'Colormap', IconCMap);                                                                              
set(IconAxes, ...                                                                                                 
   'Visible','off'           , ...                                                                                
   'YDir'   ,'reverse'       , ...                                                                                
   'XLim'   ,get(Img,'XData'), ...                                                                                
   'YLim'   ,get(Img,'YData')  ...                                                                                
   );                                                                                                             
set(findobj(QuestFig),'HandleVisibility','callback');                                                             
set(QuestFig ,'WindowStyle','modal','Visible','on');                                                              
drawnow;                                                                                                          
                                                                                                                  
uiwait(QuestFig);                                                                                                 
                                                                                                                  
TempHide=get(0,'ShowHiddenHandles');                                                                              
set(0,'ShowHiddenHandles','on');                                                                                  
                                                                                                                  
if any(get(0,'Children')==QuestFig),                                                                              
  if get(QuestFig,'UserData'),                                                                                    
    ButtonName=Default;                                                                                           
  else,                                                                                                           
    ButtonName=get(get(QuestFig,'CurrentObject'),'String');                                                       
  end                                                                                                             
  delete(QuestFig);                                                                                               
else                                                                                                              
  ButtonName='';                                                                                                  
end                                                                                                               
                                                                                                                  
set(0,'ShowHiddenHandles',TempHide);                                                                              
end                                                                                                               
%#-h- getrealinrange.m                                                                          
%  Saved from /Users/tnearey/NeareyMLTools/tnguitools/getrealinrange.m 2011/2/3 15:21
          
function x=getrealinrange(promptstr,xdefault,xmin,xmax,shouldappendrange,quickreturn);          
%function x=getrealinrange(promptstr,xdefault,xmin,xmax,shouldappendrange,quickreturn);         
% generic function to force the choice of a real within the range of xmin and xmax              
% INPUT                                                                                         
% promptstr - prompt string                                                                     
% xdefault - default value of x (as string)                                                     
% xmin - minimum acceptable -inf if empty                                                       
% xmax - maximum acceptable +inf if empty                                                       
% shouldappendrange - boolean add range statement to prompt (1 if empty)                        
% quickreturn - special call to check default value                                             
%    xdefault is  default real value                                                            
% OUTPUT                                                                                        
% x - A real number within the range or NaN                                                     
% NOTES                                                                                         
% prompt is a one line prompt string (range will be appended unless shouldappend range is zero).
% if quickreturn is set to 1, then value is returned if xdefault is in range to begin with      
% This is useful mainly to check items that have been entered on other guis                     
% Version 1.1 uses 'eval' to allow arbitrary matlab numeric expressions                         
% Copyright 2001-2002, 2005 T.M. Nearey                                                         
% Version 2.1 allows empty string (returning NaN) to keep from infinite                         
% loop                                                                                          
% *** SEE ALSO *** getstringdlg                                                                 
if nargin==0                                                                                    
     promptstr= 'Enter a real value for x';                                                     
     xdefault=-999;                                                                             
     xmin=0;                                                                                    
     xmax=100;                                                                                  
end                                                                                             
if nargin<5|isempty(shouldappendrange)                                                          
     shouldappendrange=1;                                                                       
end                                                                                             
if nargin<6|isempty(quickreturn)                                                                
     quickreturn=0;                                                                             
end                                                                                             
if nargin<4|isempty(xmax)                                                                       
     xmax=inf;                                                                                  
end                                                                                             
if nargin<3|isempty(xmin)                                                                       
     xmin=-inf;                                                                                 
end                                                                                             
if quickreturn & xdefault>=xmin & xdefault<=xmax,                                               
     x=xdefault;                                                                                
     return                                                                                     
end                                                                                             
ttitle=['Enter a number '];                                                                     
if shouldappendrange                                                                            
     promptstr=[promptstr,' (in the range [ ', num2str(xmin), '...',num2str(xmax),'])'];        
end;                                                                                            
%promptstr                                                                                      
done=0;                                                                                         
default={num2str(xdefault)};                                                                    
inrange=0;                                                                                      
while ~inrange                                                                                  
     tstr=inputdlg({promptstr},ttitle,1,default);                                               
     if isempty(tstr)                                                                           
          x=NaN;                                                                                
     else                                                                                       
          try                                                                                   
               x=str2num(tstr{1});                                                              
               if isempty(x)                                                                    
                    x=NaN;                                                                      
               end                                                                              
          catch                                                                                 
               lasterr                                                                          
               x=NaN;                                                                           
          end % trycatch                                                                        
     end                                                                                        
     inrange=x>=xmin & x<=xmax;                                                                 
     if ~inrange                                                                                
          if  ~askyn({' Program requires a number in range',...                                 
                    ['[ ', num2str(xmin), '...',num2str(xmax),' ]'],...                         
                    'Want to try again?'})                                                      
               x=NaN;                                                                           
               return                                                                           
          end                                                                                   
     end                                                                                        
end                                                                                             
end                                                                                             
