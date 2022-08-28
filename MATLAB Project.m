function varargout = SystemDynamicsSolution(varargin)
% SYSTEMDYNAMICSSOLUTION MATLAB code for SystemDynamicsSolution.fig
%      SYSTEMDYNAMICSSOLUTION, by itself, creates a new SYSTEMDYNAMICSSOLUTION or raises the existing
%      singleton*.
%
%      H = SYSTEMDYNAMICSSOLUTION returns the handle to a new SYSTEMDYNAMICSSOLUTION or the handle to
%      the existing singleton*.
%
%      SYSTEMDYNAMICSSOLUTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYSTEMDYNAMICSSOLUTION.M with the given input arguments.
%
%      SYSTEMDYNAMICSSOLUTION('Property','Value',...) creates a new SYSTEMDYNAMICSSOLUTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SystemDynamicsSolution_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SystemDynamicsSolution_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
 
% Edit the above text to modify the response to help SystemDynamicsSolution
 
% Last Modified by GUIDE v2.5 06-Jun-2020 03:03:28
 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SystemDynamicsSolution_OpeningFcn, ...
                   'gui_OutputFcn',  @SystemDynamicsSolution_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
 
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
 
 
% --- Executes just before SystemDynamicsSolution is made visible.
function SystemDynamicsSolution_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SystemDynamicsSolution (see VARARGIN)
 
% Choose default command line output for SystemDynamicsSolution
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
 
% UIWAIT makes SystemDynamicsSolution wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 
 
% --- Outputs from this function are returned to the command line.
function varargout = SystemDynamicsSolution_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('tag','user_in');
 
% Get default command line output from handles structure
varargout{1} = handles.output;
 
 
% --- Executes on button press in slv.
function slv_Callback(hObject, eventdata, handles)
% hObject    handle to slv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
order=getappdata(0,'choice3');
input_type=getappdata(0,'inpt');
if order==1
    a1=getappdata(0,'a1');
    if a1==0
        msgbox('a1 can''t be equal to 0');
    else
        ao=getappdata(0,'ao')/a1;
        bo=getappdata(0,'bo')/a1;
        b1=getappdata(0,'b1')/a1;
        dt = 0.001;
        t = 0:dt:10;
        A=-ao;
        B=bo-ao*b1;
        C=1;
        D=b1;
        if input_type==1
            u = ones(size(t));
            u(1) = 0;
        elseif input_type==2
            u = zeros(size(t));
            u(1) = 1;
        end
        x = zeros(size(t));
        xd = zeros(size(t));
        y = zeros(size(t));
        for i = 1:length(t)
            if i == 1
                x(i) = 0;
                xd(i) = A*x(i) + B*u(i);
                y(i) = C*x(i) + D*u(i);
            else
                x(i) = x(i-1) + dt*xd(i-1);
                xd(i) = A*x(i) + B*u(i);
                y(i) = C*x(i) + D*u(i);
            end
        end
        A=mat2str(A);
        set(handles.mtrx_A,'String',A);
        set(handles.mtrx_A,'Enable','Off');
        B=mat2str(B);
        set(handles.mtrx_B,'String',B);
        set(handles.mtrx_B,'Enable','Off');
        C=mat2str(C);
        set(handles.mtrx_C,'String',C);
        set(handles.mtrx_C,'Enable','Off');
        D=mat2str(D);
        set(handles.mtrx_D,'String',D);
        set(handles.mtrx_D,'Enable','Off');
        axes(handles.out_y);
        plot(t,y,'r','LineWidth',2);
        xlim([-1 11])
        axes(handles.in_u);
        plot(t,u,'LineWidth',2);
        xlim([-1 11])
        axes(handles.stat_x1);
        plot(t,x,'g','LineWidth',2);
        xlim([-1 11])
    end
elseif order==2
    a2=getappdata(0,'a2');
    if a2==0
        msgbox('a2 can''t be equal to 0');
    else
        ao=getappdata(0,'ao')/a2;
        a1=getappdata(0,'a1')/a2;
        bo=getappdata(0,'bo')/a2;
        b1=getappdata(0,'b1')/a2;
        b2=getappdata(0,'b2')/a2;
        A=zeros(order);
        am=[ao a1];
        bm=[bo b1 b2];
        for i=1:length(A)
            for j=1:length(A)
                if i==1
                    A(i,length(A))=-am(1);
                elseif (i>1) && (j==i-1)
                    A(i,j)=1;
                elseif (i>1) && (j==length(A))
                    A(i,j)=-am(1,i);
                end
            end
        end
        B=zeros(order,1);
        for i=1:length(B)
            B(i,1)=bm(1,i)-am(1,i)*bm(1,length(B)+1);
        end
        C=zeros(1,order);
        C(1,order)=1;
        D=bm(1,order+1);
        dt = 0.001;
        t = 0:dt:10;
        if input_type==1
            u = ones(size(t));
            u(1) = 0;
        elseif input_type==2
            u = zeros(size(t));
            u(1) = 1;
        end
        x = zeros(order,length(t));
        xd = zeros(order,length(t));
        y = zeros(size(t));
        for i = 1:length(t)
            if i == 1
                x(:,i) = 0;                        % For intial values
                xd(:,i) = A*x(:,i) + B*u(i);       % Canonical form
                y(i) = C*x(:,i) + D*u(i);          % Canonical form
            else
                x(:,i) = x(:,i-1) + dt*xd(:,i-1);  % Integration
                xd(:,i) = A*x(:,i) + B*u(i);
                y(i) = C*x(:,i) + D*u(i);
            end
        end
        A=mat2str(A);
        set(handles.mtrx_A,'String',A);
        set(handles.mtrx_A,'Enable','Off');
        B=mat2str(B);
        set(handles.mtrx_B,'String',B);
        set(handles.mtrx_B,'Enable','Off');
        C=mat2str(C);
        set(handles.mtrx_C,'String',C);
        set(handles.mtrx_C,'Enable','Off');
        D=mat2str(D);
        set(handles.mtrx_D,'String',D);
        set(handles.mtrx_D,'Enable','Off');
        axes(handles.out_y);
        plot(t,y,'r','LineWidth',2);
        xlim([-1 11])
        axes(handles.in_u);
        plot(t,u,'LineWidth',2);
        xlim([-1 11])
        x1=zeros(1,length(t));
        for i = 1:length(t)
            x1(1,i)=x(1,i);
        end
        axes(handles.stat_x1);
        plot(t,x1,'g','LineWidth',2);
        xlim([-1 11])
        x2=zeros(1,length(t));
        for i = 1:length(t)
            x2(1,i)=x(2,i);
        end
        axes(handles.stat_x2);
        plot(t,x2,'y','LineWidth',2);
        xlim([-1 11])
    end
elseif order==3
    a3=getappdata(0,'a3');
    if a3==0
        msgbox('a3 can''t be equal to 0');
    else
        ao=getappdata(0,'ao')/a3;
        a1=getappdata(0,'a1')/a3;
        a2=getappdata(0,'a2')/a3;
        bo=getappdata(0,'bo')/a3;
        b1=getappdata(0,'b1')/a3;
        b2=getappdata(0,'b2')/a3;
        b3=getappdata(0,'b3')/a3;
        A=zeros(order);
        am=[ao a1 a2];
        bm=[bo b1 b2 b3];
        for i=1:length(A)
            for j=1:length(A)
                if i==1
                    A(i,length(A))=-am(1);
                elseif (i>1) && (j==i-1)
                    A(i,j)=1;
                elseif (i>1) && (j==length(A))
                    A(i,j)=-am(1,i);
                end
            end
        end
        B=zeros(order,1);
        for i=1:length(B)
            B(i,1)=bm(1,i)-am(1,i)*bm(1,length(B)+1);
        end
        C=zeros(1,order);
        C(1,order)=1;
        D=bm(1,order+1);
        dt = 0.001;
        t = 0:dt:20;
        if input_type==1
            u = ones(size(t));
            u(1) = 0;
        elseif input_type==2
            u = zeros(size(t));
            u(1) = 1;
        end
        x = zeros(order,length(t));
        xd = zeros(order,length(t));
        y = zeros(size(t));
        for i = 1:length(t)
            if i == 1
                x(:,i) = 0;
                xd(:,i) = A*x(:,i) + B*u(i);
                y(i) = C*x(:,i) + D*u(i);
            else
                x(:,i) = x(:,i-1) + dt*xd(:,i-1);
                xd(:,i) = A*x(:,i) + B*u(i);
                y(i) = C*x(:,i) + D*u(i);
            end
        end
        A=mat2str(A);
        set(handles.mtrx_A,'String',A);
        set(handles.mtrx_A,'Enable','Off');
        B=mat2str(B);
        set(handles.mtrx_B,'String',B);
        set(handles.mtrx_B,'Enable','Off');
        C=mat2str(C);
        set(handles.mtrx_C,'String',C);
        set(handles.mtrx_C,'Enable','Off');
        D=mat2str(D);
        set(handles.mtrx_D,'String',D);
        set(handles.mtrx_D,'Enable','Off');
        axes(handles.out_y);
        plot(t,y,'r','LineWidth',2);
        xlim([-1 21])
        axes(handles.in_u);
        plot(t,u,'LineWidth',2);
        xlim([-1 21])
        x1=zeros(1,length(t));
        for i = 1:length(t)
            x1(1,i)=x(1,i);
        end
        axes(handles.stat_x1);
        plot(t,x1,'g','LineWidth',2);
        xlim([-1 21])
        x2=zeros(1,length(t));
        for i = 1:length(t)
            x2(1,i)=x(2,i);
        end
        axes(handles.stat_x2);
        plot(t,x2,'y','LineWidth',2);
        xlim([-1 21])
        x3=zeros(1,length(t));
        for i = 1:length(t)
            x3(1,i)=x(3,i);
        end
        axes(handles.stat_x3);
        plot(t,x3,'c','LineWidth',2);
        xlim([-1 21])
    end
elseif order==4
    a4=getappdata(0,'a4');
    if a4==0
       msgbox('a4 can''t be equal to 0');
    else
        ao=getappdata(0,'ao')/a4;
        a1=getappdata(0,'a1')/a4;
        a2=getappdata(0,'a2')/a4;
        a3=getappdata(0,'a3')/a4;
        bo=getappdata(0,'bo')/a4;
        b1=getappdata(0,'b1')/a4;
        b2=getappdata(0,'b2')/a4;
        b3=getappdata(0,'b3')/a4;
        b4=getappdata(0,'b4')/a4;
        A=zeros(order);
        am=[ao a1 a2 a3];
        bm=[bo b1 b2 b3 b4];
        for i=1:length(A)
            for j=1:length(A)
                if i==1
                    A(i,length(A))=-am(1);
                elseif (i>1) && (j==i-1)
                    A(i,j)=1;
                elseif (i>1) && (j==length(A))
                    A(i,j)=-am(1,i);
                end
            end
        end
        B=zeros(order,1);
        for i=1:length(B)
            B(i,1)=bm(1,i)-am(1,i)*bm(1,length(B)+1);
        end
        C=zeros(1,order);
        C(1,order)=1;
        D=bm(1,order+1);
        dt = 0.001;
        t = 0:dt:20;
        if input_type==1
            u = ones(size(t));
            u(1) = 0;
        elseif input_type==2
            u = zeros(size(t));
            u(1) = 1;
        end
        x = zeros(order,length(t));
        xd = zeros(order,length(t));
        y = zeros(size(t));
        for i = 1:length(t)
            if i == 1
                x(:,i) = 0;
                xd(:,i) = A*x(:,i) + B*u(i);
                y(i) = C*x(:,i) + D*u(i);
            else
                x(:,i) = x(:,i-1) + dt*xd(:,i-1);
                xd(:,i) = A*x(:,i) + B*u(i);
                y(i) = C*x(:,i) + D*u(i);
            end
        end
        A=mat2str(A);
        set(handles.mtrx_A,'String',A);
        set(handles.mtrx_A,'Enable','Off');
        B=mat2str(B);
        set(handles.mtrx_B,'String',B);
        set(handles.mtrx_B,'Enable','Off');
        C=mat2str(C);
        set(handles.mtrx_C,'String',C);
        set(handles.mtrx_C,'Enable','Off');
        D=mat2str(D);
        set(handles.mtrx_D,'String',D);
        set(handles.mtrx_D,'Enable','Off');
        axes(handles.out_y);
        plot(t,y,'r','LineWidth',2);
        xlim([-1 21])
        axes(handles.in_u);
        plot(t,u,'LineWidth',2);
        xlim([-1 21])
        x1=zeros(1,length(t));
        for i = 1:length(t)
            x1(1,i)=x(1,i);
        end
        axes(handles.stat_x1);
        plot(t,x1,'g','LineWidth',2);
        xlim([-1 21])
        x2=zeros(1,length(t));
        for i = 1:length(t)
            x2(1,i)=x(2,i);
        end
        axes(handles.stat_x2);
        plot(t,x2,'y','LineWidth',2);
        xlim([-1 21])
        x3=zeros(1,length(t));
        for i = 1:length(t)
            x3(1,i)=x(3,i);
        end
        axes(handles.stat_x3);
        plot(t,x3,'c','LineWidth',2);
        xlim([-1 21])
        x4=zeros(1,length(t));
        for i = 1:length(t)
            x4(1,i)=x(4,i);
        end
        axes(handles.stat_x4);
        plot(t,x4,'m','LineWidth',2);
        xlim([-1 21])
    end
end
 
 
function mtrx_A_Callback(hObject, eventdata, handles)
% hObject    handle to mtrx_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of mtrx_A as text
%        str2double(get(hObject,'String')) returns contents of mtrx_A as a double
 
 
% --- Executes during object creation, after setting all properties.
function mtrx_A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtrx_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function mtrx_B_Callback(hObject, eventdata, handles)
% hObject    handle to mtrx_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of mtrx_B as text
%        str2double(get(hObject,'String')) returns contents of mtrx_B as a double
 
 
% --- Executes during object creation, after setting all properties.
function mtrx_B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtrx_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function mtrx_C_Callback(hObject, eventdata, handles)
% hObject    handle to mtrx_C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of mtrx_C as text
%        str2double(get(hObject,'String')) returns contents of mtrx_C as a double
 
 
% --- Executes during object creation, after setting all properties.
function mtrx_C_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtrx_C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function mtrx_D_Callback(hObject, eventdata, handles)
% hObject    handle to mtrx_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of mtrx_D as text
%        str2double(get(hObject,'String')) returns contents of mtrx_D as a double
 
 
% --- Executes during object creation, after setting all properties.
function mtrx_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtrx_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
