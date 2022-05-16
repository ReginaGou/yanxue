Color_QiPanBack=[196,153,97];%背景颜色
Color_ChessLine=[100,100,100];%棋盘的线条色
%获胜连子数
Num_Victory=5;
Dpixel=33;
NumCell=14;%棋盘格的行或列数
Wid_edge=18;
[M_QiPan,xcol_ChessLine,yrow_ChessLine]=QiPan(NumCell,Dpixel,Wid_edge,Color_QiPanBack,Color_ChessLine);
imshow(M_QiPan);
set (gcf,'Position',[600,45,625,625]);
set (gca,'Position',[0,0,1,1]);
hold on,
%棋半径
radius_Chess=15;
M_LuoZi=zeros(NumCell+1,NumCell+1,2);
VictoryB=0;
VictoryW=0;
StateB=1;
StateW=2;
NumChess=0;
for i=1:(NumCell+1)^2
    [x_col_Chess, y_row_Chess]=ginput_pointer(1);
    %获得距离鼠标点击点最近的下棋点的坐标,并保证点击的下棋点在棋盘内
    if x_col_Chess<max(xcol_ChessLine)+Dpixel/2&&x_col_Chess>min(xcol_ChessLine)-Dpixel/2&&y_row_Chess<max(yrow_ChessLine)+Dpixel/2&&y_row_Chess>min(yrow_ChessLine)-Dpixel/2
        for x_i=xcol_ChessLine
            if abs(x_col_Chess-x_i)<Dpixel/2
                x_col_Chess=x_i;
            end
        end
        for y_i=yrow_ChessLine
            if abs(y_row_Chess-y_i)<Dpixel/2
                y_row_Chess=y_i;
            end
        end
    %点击悔棋区（棋盘外的区域）悔棋
    else
        [x_col_LuoZi_old,y_row_LuoZi_old]=find(M_LuoZi(:,:,2)==max(max(M_LuoZi(:,:,2))));
        x_col_Chess_old=(x_col_LuoZi_old-1)*Dpixel+Wid_edge+1;
        y_row_Chess_old=(y_row_LuoZi_old-1)*Dpixel+Wid_edge+1;
        if NumChess>=1
            M_QiPan=Chess(M_QiPan,x_col_Chess_old,y_row_Chess_old,radius_Chess,3,Wid_edge,Dpixel,Color_QiPanBack,Color_ChessLine);
            imshow(M_QiPan);
            NumChess=NumChess-1;
            M_LuoZi(x_col_LuoZi_old,y_row_LuoZi_old,1)=0;
            M_LuoZi(x_col_LuoZi_old,y_row_LuoZi_old,2)=0;
        end
        continue;
    end
    %落子并防止重复在同一个下棋点落子
    x_col_LuoZi=(x_col_Chess-Wid_edge-1)/Dpixel+1;
    y_row_LuoZi=(y_row_Chess-Wid_edge-1)/Dpixel+1;
    if M_LuoZi(x_col_LuoZi,y_row_LuoZi,1)==0
        NumChess=NumChess+1;
        M_LuoZi(x_col_LuoZi,y_row_LuoZi,2)=NumChess;
        if mod(NumChess,2)==1
            M_QiPan=Chess(M_QiPan,x_col_Chess,y_row_Chess,radius_Chess,1,Wid_edge,Dpixel,Color_QiPanBack,Color_ChessLine);
            imshow(M_QiPan);
            M_LuoZi(x_col_LuoZi,y_row_LuoZi,1)=StateB; %落子为黑棋
            VictoryB=Victory_Judge(M_LuoZi,x_col_LuoZi,y_row_LuoZi,StateB);
        elseif mod(NumChess,2)==0
            M_QiPan=Chess(M_QiPan,x_col_Chess,y_row_Chess,radius_Chess,2,Wid_edge,Dpixel,Color_QiPanBack,Color_ChessLine);
            imshow(M_QiPan);
            M_LuoZi(x_col_LuoZi,y_row_LuoZi,1)=StateW; %落子为白棋
            VictoryW=Victory_Judge(M_LuoZi,x_col_LuoZi,y_row_LuoZi,StateW);
        end
    end
    %显示获胜信息
    if VictoryB==1
        %普通对话框
        h=dialog('name','游戏结束','position',[500 350 250 100]);
        uicontrol('parent',h,'style','text','string','黑棋获得胜利！','position',[35 35 200 50],'fontsize',20);
        uicontrol('parent',h,'style','pushbutton','position',[150 11 80 30],'fontsize',15,'string','确定','callback','delete(gcbf)');
        break;
    elseif VictoryW==1
        %普通对话框
        h=dialog('name','游戏结束','position',[500 350 250 100]);
        uicontrol('parent',h,'style','text','string','白棋获得胜利！','position',[35 35 200 50],'fontsize',20);
        uicontrol('parent',h,'style','pushbutton','position',[150 11 80 30],'fontsize',15,'string','确定','callback','delete(gcbf)');
        break;
    end
end
function [M_QiPan, xcol_ChessLine,yrow_ChessLine]=QiPan(NumCell, Dpixel, Wid_edge,Color_QiPanBack,Color_ChessLine)
%此程序为画五子棋盘的程序
%NumCell为棋盘格数
%Dpixel为相邻棋盘线间的像素间隔
%Wid_edge为棋盘边缘的像素宽度
%Color_QiPanBack为棋盘背景颜色
%Color_ChessLine为棋盘线的颜色
%M_QiPan为棋盘矩阵
%xcol_ChessLine为棋盘列线
%yrow_ChessLine为棋盘行线
NumSum=1+Dpixel*NumCell+Wid_edge*2;
xcol_ChessLine=Wid_edge+1:Dpixel:NumSum-Wid_edge;%列
yrow_ChessLine=Wid_edge+1:Dpixel:NumSum-Wid_edge;%行
M_QiPan=uint8(ones(NumSum,NumSum,3));
M_QiPan(:,:,1)=M_QiPan(:,:,1)*Color_QiPanBack(1);
M_QiPan(:,:,2)=M_QiPan(:,:,2)*Color_QiPanBack(2);
M_QiPan(:,:,3)=M_QiPan(:,:,3)*Color_QiPanBack(3);
%画棋盘线
for i=xcol_ChessLine
    M_QiPan(i,Wid_edge+1:NumSum-Wid_edge,:)=ones(NumSum-2*Wid_edge,1)*Color_ChessLine;
end
for j=yrow_ChessLine
    M_QiPan(Wid_edge+1:NumSum-Wid_edge,j,:)=ones(NumSum-2*Wid_edge,1)*Color_ChessLine;
end
%画9个小圆点
radius_Dot=5;
P1=Wid_edge+1+Dpixel*3:Dpixel*(NumCell/2-3):Wid_edge+1+Dpixel*(NumCell-3);
for ti=P1
    for tj=P1
        for Num=ti-radius_Dot:ti+radius_Dot
            for j=tj-radius_Dot:tj+radius_Dot
                if (Num-ti)^2+(j-tj)^2<radius_Dot^2
                    M_QiPan(Num,j,:)=Color_ChessLine;
                end
            end
        end
    end
end
end
 
function M_QiPan=Chess(M_QiPan,x_col_Chess,y_row_Chess,radius_Chess,BorW,Wid_edge,Dpixel,Color_QiPanBack,Color_ChessLine)
%此程序下棋或者悔棋
%M_QiPan为棋盘矩阵
%xcol_ChessLine为棋盘列线
%yrow_ChessLine为棋盘行线
%radius_Chess为棋的像素半径
%BorW为下棋选择，1黑棋，2白棋，3悔棋
%Wid_edge为棋盘矩阵中的棋盘边缘的像素宽度
%Dpixel为棋盘矩阵中的相邻棋盘线间的像素间隔
%Color_QiPanBack为棋盘背景颜色
%Color_ChessLine为棋盘线的颜色
Color_BChess=[54,54,54];
Color_WChess=[255,240,245];
[Wid,~,~]=size(M_QiPan);
for i=x_col_Chess-radius_Chess:x_col_Chess+radius_Chess
    for j=y_row_Chess-radius_Chess:y_row_Chess+radius_Chess
        if (i-x_col_Chess)^2+(j-y_row_Chess)^2<=radius_Chess^2
            if BorW==1%黑棋
                M_QiPan(j,i,:)=Color_BChess;
            elseif BorW==2%白棋
                M_QiPan(j,i,:)=Color_WChess;
            elseif BorW==3%悔棋
                M_QiPan(j,i,:)=Color_QiPanBack;
                %对于不是棋盘边缘的棋子
                if i==x_col_Chess||j==y_row_Chess
                    M_QiPan(j,i,:)=Color_ChessLine;
                end
                %悔棋点是否为小圆点
                if ((i-x_col_Chess)^2+(j-y_row_Chess)^2<5^2)&&...
                    (x_col_Chess==Wid_edge+1+Dpixel*3||x_col_Chess==floor(Wid/2)+1||x_col_Chess==Wid-Wid_edge-Dpixel*3)&&...
                    (y_row_Chess==Wid_edge+1+Dpixel*3||y_row_Chess==floor(Wid/2)+1||y_row_Chess==Wid-Wid_edge-Dpixel*3)            
                    M_QiPan(j,i,:)=Color_ChessLine;
                end
                %对于棋盘边缘的棋子
                if x_col_Chess==Wid_edge+1&&i<x_col_Chess
                    M_QiPan(j,i,:)=Color_QiPanBack;
                elseif x_col_Chess==Wid-Wid_edge&&i>x_col_Chess
                    M_QiPan(j,i,:)=Color_QiPanBack;
                end
                if y_row_Chess==Wid_edge+1&&j<y_row_Chess
                    M_QiPan(j,i,:)=Color_QiPanBack;
                elseif y_row_Chess==Wid-Wid_edge&&j>y_row_Chess
                    M_QiPan(j,i,:)=Color_QiPanBack;
                end
            end
        end
    end
end
end
 
function Victory_flag=Victory_Judge(M_LuoZi,x_col_LuoZi,y_row_LuoZi,State)
%对一方是否获胜的判断函数
%M_LuoZi为下棋点的矩阵
%x_col_LuoZi为下棋列数
%y_row_LuoZi下棋行数
%State为M_LuoZi矩阵某点的下棋状态，黑棋（1）或白棋（2）或无棋（0）,以及每步棋的序号
%NumCell为棋盘格数
%Victory_flag为胜利标志
NumCell=length(M_LuoZi)-1;
Victory_flag=0;
for i=1:NumCell-3
    if M_LuoZi(i,y_row_LuoZi,1)==State&&M_LuoZi(i+1,y_row_LuoZi,1)==State&&M_LuoZi(i+2,y_row_LuoZi,1)==State&&M_LuoZi(i+3,y_row_LuoZi,1)==State&&M_LuoZi(i+4,y_row_LuoZi,1)==State
        Victory_flag=1;
        break;
    end
    if M_LuoZi(x_col_LuoZi,i,1)==State&&M_LuoZi(x_col_LuoZi,i+1,1)==State&&M_LuoZi(x_col_LuoZi,i+2,1)==State&&M_LuoZi(x_col_LuoZi,i+3,1)==State&&M_LuoZi(x_col_LuoZi,i+4,1)==State
        Victory_flag=1;
        break;
    end
    if abs(x_col_LuoZi-y_row_LuoZi)+i<=NumCell-3
        if x_col_LuoZi>=y_row_LuoZi
            if M_LuoZi(abs(x_col_LuoZi-y_row_LuoZi)+i,i,1)==State&&M_LuoZi(abs(x_col_LuoZi-y_row_LuoZi)+i+1,i+1,1)==State&&M_LuoZi(abs(x_col_LuoZi-y_row_LuoZi)+i+2,i+2,1)==State&&M_LuoZi(abs(x_col_LuoZi-y_row_LuoZi)+i+3,i+3,1)==State&&M_LuoZi(abs(x_col_LuoZi-y_row_LuoZi)+i+4,i+4,1)==State
                Victory_flag=1;
                break;
            end
        elseif x_col_LuoZi<y_row_LuoZi
            if M_LuoZi(i,abs(x_col_LuoZi-y_row_LuoZi)+i,1)==State&&M_LuoZi(i+1,abs(x_col_LuoZi-y_row_LuoZi)+i+1,1)==State&&M_LuoZi(i+2,abs(x_col_LuoZi-y_row_LuoZi)+i+2,1)==State&&M_LuoZi(i+3,abs(x_col_LuoZi-y_row_LuoZi)+i+3,1)==State&&M_LuoZi(i+4,abs(x_col_LuoZi-y_row_LuoZi)+i+4,1)==State
                Victory_flag=1;
                break;
            end
        end
    end
    if y_row_LuoZi+x_col_LuoZi<=NumCell+2&&y_row_LuoZi+x_col_LuoZi-i>=5
        if M_LuoZi(y_row_LuoZi+x_col_LuoZi-i,i,1)==State&&M_LuoZi(y_row_LuoZi+x_col_LuoZi-i-1,i+1,1)==State&&M_LuoZi(y_row_LuoZi+x_col_LuoZi-i-2,i+2,1)==State&&M_LuoZi(y_row_LuoZi+x_col_LuoZi-i-3,i+3,1)==State&&M_LuoZi(y_row_LuoZi+x_col_LuoZi-i-4,i+4,1)==State
            Victory_flag=1;
            break;
        end
    elseif y_row_LuoZi+x_col_LuoZi>NumCell+2&&y_row_LuoZi+x_col_LuoZi+i<=NumCell*2-1
        offset=NumCell+2;
        if M_LuoZi(y_row_LuoZi+x_col_LuoZi-offset+i,offset-i,1)==State&&M_LuoZi(y_row_LuoZi+x_col_LuoZi-offset+i+1,offset-i-1,1)==State&&M_LuoZi(y_row_LuoZi+x_col_LuoZi-offset+i+2,offset-i-2,1)==State&&M_LuoZi(y_row_LuoZi+x_col_LuoZi-offset+i+3,offset-i-3,1)==State&&M_LuoZi(y_row_LuoZi+x_col_LuoZi-offset+i+4,offset-i-4,1)==State
            Victory_flag=1;
            break;
        end
    end
end
end
%此函数为库函数的修改，仅将十字光标改为箭头光标，改动位置为第88行
function [out1,out2,out3] = ginput_pointer(arg1)
 
out1 = []; out2 = []; out3 = []; y = [];
c = computer;
if ~strcmp(c(1:2),'PC')
    tp = get(0,'TerminalProtocol');
else
    tp = 'micro';
end
 
if ~strcmp(tp,'none') && ~strcmp(tp,'x') && ~strcmp(tp,'micro')
    if nargout == 1
        if nargin == 1
            out1 = trmginput(arg1);
        else
            out1 = trmginput;
        end
    elseif nargout == 2 || nargout == 0
        if nargin == 1
            [out1,out2] = trmginput(arg1);
        else
            [out1,out2] = trmginput;
        end
        if  nargout == 0
            out1 = [ out1 out2 ];
        end
    elseif nargout == 3
        if nargin == 1
            [out1,out2,out3] = trmginput(arg1);
        else
            [out1,out2,out3] = trmginput;
        end
    end
else
    
    fig = gcf;
    figure(gcf);
    
    if nargin == 0
        how_many = -1;
        b = [];
    else
        how_many = arg1;
        b = [];
        if  ischar(how_many) ...
                || size(how_many,1) ~= 1 || size(how_many,2) ~= 1 ...
                || ~(fix(how_many) == how_many) ...
                || how_many < 0
            error(message('MATLAB:ginput:NeedPositiveInt'))
        end
        if how_many == 0
            warning (message('MATLAB:ginput:InputArgumentZero'));
        end
    end
    
    initialState = setupFcn(fig);
    set(gcf, 'pointer', 'arrow');
    
    c = onCleanup(@() restoreFcn(initialState));
       
    drawnow
    char = 0;
    
    while how_many ~= 0

        waserr = 0;
        try
            keydown = wfbp;
        catch
            waserr = 1;
        end
        if(waserr == 1)
            if(ishghandle(fig))
                cleanup(c);
                error(message('MATLAB:ginput:Interrupted'));
            else
                cleanup(c);
                error(message('MATLAB:ginput:FigureDeletionPause'));
            end
        end

        figchildren = allchild(0);
        if ~isempty(figchildren)
            ptr_fig = figchildren(1);
        else
            error(message('MATLAB:ginput:FigureUnavailable'));
        end

        if(ptr_fig == fig)
            if keydown
                char = get(fig, 'CurrentCharacter');
                button = abs(get(fig, 'CurrentCharacter'));
            else
                button = get(fig, 'SelectionType');
                if strcmp(button,'open')
                    button = 1;
                elseif strcmp(button,'normal')
                    button = 1;
                elseif strcmp(button,'extend')
                    button = 2;
                elseif strcmp(button,'alt')
                    button = 3;
                else
                    error(message('MATLAB:ginput:InvalidSelection'))
                end
            end
            axes_handle = gca;
            drawnow;
            pt = get(axes_handle, 'CurrentPoint');
            
            how_many = how_many - 1;
            
            if(char == 13)
                break;
            end
            
            out1 = [out1;pt(1,1)]; 
            y = [y;pt(1,2)]; 
            b = [b;button];
        end
    end
    
    cleanup(c);
    
    if nargout > 1
        out2 = y;
        if nargout > 2
            out3 = b;
        end
    else
        out1 = [out1 y];
    end
    
end
end
 
 
function key = wfbp
 
fig = gcf;
current_char = []; 
 
waserr = 0;
try
    h=findall(fig,'Type','uimenu','Accelerator','C');   
    set(h,'Accelerator','');                            
    keydown = waitforbuttonpress;
    current_char = double(get(fig,'CurrentCharacter')); 
    if~isempty(current_char) && (keydown == 1)        
        if(current_char == 3)                          
            waserr = 1;                                
        end
    end
    
set(h,'Accelerator','C');                           
catch 
    waserr = 1;
end
drawnow;
if(waserr == 1)
set(h,'Accelerator','C');                         
    error(message('MATLAB:ginput:Interrupted'));
end
if nargout>0, key = keydown; end
 
end
function initialState = setupFcn(fig)
initialState.figureHandle = fig; 
initialState.uisuspendState = uisuspend(fig);
initialState.toolbar = findobj(allchild(fig),'flat','Type','uitoolbar');
if ~isempty(initialState.toolbar)
    initialState.ptButtons = [uigettool(initialState.toolbar,'Plottools.PlottoolsOff'), ...
        uigettool(initialState.toolbar,'Plottools.PlottoolsOn')];
    initialState.ptState = get (initialState.ptButtons,'Enable');
    set (initialState.ptButtons,'Enable','off');
end
oldwarnstate = warning('off', 'MATLAB:hg:Figure:Pointer');
set(fig,'Pointer','fullcrosshair');
warning(oldwarnstate);
set(fig,'WindowButtonMotionFcn',@(o,e) dummy());
initialState.fig_units = get(fig,'Units');
end
function restoreFcn(initialState)
if ishghandle(initialState.figureHandle)
    set(initialState.figureHandle,'Units',initialState.fig_units);
    set(initialState.figureHandle,'WindowButtonMotionFcn','');
        if ~isempty(initialState.toolbar) && ~isempty(initialState.ptButtons)
        set (initialState.ptButtons(1),'Enable',initialState.ptState{1});
        set (initialState.ptButtons(2),'Enable',initialState.ptState{2});
    end
        uirestore(initialState.uisuspendState);
end
end
function dummy()
end
function cleanup(c)
if isvalid(c)
    delete(c);
end
end

