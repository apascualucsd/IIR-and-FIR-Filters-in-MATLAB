function tony_des_2(action)
global N_
global ws_
global wb_
global wc_
global kk_

if nargin<1

figure(1)
set(1,'name','Two-Path Allpass Filter Design by fred harris, SDSU','numbertitle','off');

responseplot=axes('units','normalized','position',[.05 .4 .9 .55]);

N_=uicontrol('style','edit','units','normalized','position',[0.18 0.1 0.07 0.07],'string','5');
Ntext=uicontrol('style','text','units','normalized','position',[0.04 0.1 0.13 0.065],'string','Prototype Order (Odd)');

ws_=uicontrol('style','edit','units','normalized','position',[0.18 0.17 0.07 0.07],'string','0.300');
wstext=uicontrol('style','text','units','normalized','position',[0.04 0.17 0.13 0.065],'string','Stopband Edge (0.25-0.5)');

wb_=uicontrol('style','edit','units','normalized','position',[0.42 0.17 0.07 0.07],'string','0.250');
wbtext=uicontrol('style','text','units','normalized','position',[0.28 0.17 0.13 0.065],'string','Passband Edge');

wc_=uicontrol('style','edit','units','normalized','position',[0.66 0.17 0.07 0.07],'string','0.000');
wctext=uicontrol('style','text','units','normalized','position',[0.52 0.17 0.13 0.065],'string','Center Frequency');

kk_=uicontrol('style','edit','units','normalized','position',[0.90 0.17 0.07 0.07],'string','2');
wctext=uicontrol('style','text','units','normalized','position',[0.76 0.17 0.13 0.065],'string','Order (even)');

half_=uicontrol('style','push','units','normalized','position',[0.04 0.25 0.21 0.07],'string','Half-Band Low-Pass','callback','tony_des_2(''start1'')');

tlow_=uicontrol('style','push','units','normalized','position',[0.28 0.25 0.21 0.07],'string','Tune Bandwidth','callback','tony_des_2(''start1'')');

tband_=uicontrol('style','push','units','normalized','position',[0.52 0.25 0.21 0.07],'string','Tune Center Freq','callback','tony_des_2(''start1'')');

fordr_=uicontrol('style','push','units','normalized','position',[0.76 0.25 0.21 0.07],'string','Polynomial Degree','callback','tony_des_2(''start1'')');



tprint=uicontrol('style','push','units','normalized','position',[0.30 0.1 0.65 0.05],'string','Print Coefficients','callback','tony_des_2(''start2'')');

readtext=uicontrol('style','text','units','normalized','position',[0.280 0.03 0.65 0.05],'string','(Highlight Parameter Value, Enter Desired Value, Depress Button)');
action='start1';
end

if strcmp(action,'start1')
   coef=0;
end
if strcmp(action,'start2')
   coef=1;
end

      N=str2num(get(N_,'string'));
   if rem(N,2)~=1
      N=N+1;
      N_=uicontrol('style','edit','units','normalized','position',[0.18 0.1 0.07 0.07],'string',N);
   end
   ws=str2num(get(ws_,'string'));
   if ws<0.25
      ws=0.300;
      ws_=uicontrol('style','edit','units','normalized','position',[0.18 0.17 0.07 0.07],'string',ws);
   end
   if ws>0.5 
      ws=0.300;
      ws_=uicontrol('style','edit','units','normalized','position',[0.18 0.17 0.07 0.07],'string',ws);
   end
   wb=str2num(get(wb_,'string'));
   if wb>0.5
      wb=0.25;
      wb_=uicontrol('style','edit','units','normalized','position',[0.42 0.17 0.07 0.07],'string','0.250');
   end
   wc=str2num(get(wc_,'string'));
   if wc>0.5
      wc=0.0;
      wc_=uicontrol('style','edit','units','normalized','position',[0.66 0.17 0.07 0.07],'string','0.000');
   end 
   
   kk=str2num(get(kk_,'string'));
   if rem(kk,2)~=0;
      kk=2;
      kk_=uicontrol('style','edit','units','normalized','position',[0.90 0.17 0.07 0.07],'string','2');
   end 

   if wb==0.25 & wc==0
      mode=1;
   else 
      mode=2;
   end
   
   aa=1;
   if wc==0;
      aa=-aa;
   end
   
[rts1,rts2,coef0,coef1,ff1,ff2]=tonycxx(N,ws,wb,wc,kk,mode);

figure(2)
plot(roots(rts1),'bx','linewidth',2,'markersize',10);
hold on;
plot(roots(rts2),'bx','linewidth',2,'markersize',10);
plot(roots(conv(rts1,fliplr(rts2))-aa*conv(fliplr(rts1),rts2)),'bo','linewidth',2,'markersize',8)
plot(exp(j*2*pi*[0:.01:1]),'r','linewidth',2);
plot([-1.1 1.1],[0 0],'k')
plot([0 0],[-1.1 1.1],'k')

hold off;
grid
axis([-1.2 1.2 -1.2 1.2]);
axis('square')
title('Roots of Two-Path Filter (Sum of Paths)')

figure(1)
plot(0:4/4096:.5-4/4096,20*log10(abs(ff1+0.0000001)),'linewidth',1.5);
hold
plot(0:4/4096:.5-4/4096,20*log10(abs(ff2+0.0000001)),'r--','linewidth',1.5);
axis([0 .5 -100 10]);

hold

grid;
title('Magnitude Response of Two Path Filter');
xlabel('Normalized Frequency (f/fs)');
ylabel('Log Magnitude (dB)');

% write out coefficients
if coef==1
    disp(' ')
    disp('Denominator Polynomials, path-0') 
        if wc==0
        disp('   (a0 Z^2  +  a1 Z^1  +  a2)')
        else
        disp('   (a0 Z^4  +  a1 Z^3  +  a2 Z^2  +  a3 Z^1  +  a4)') 
end
   disp(' ')
   disp(coef0)
   disp(' ')
   
    disp('Denominator Polynomials, path-1') 
    if wc==0
    disp('(b0 Z^2  +  b1 Z^1  +  b2)')
    else
    disp('(b0 Z^4  +  b1 Z^3  +  b2 Z^2  +  b3 Z^1  +  b4)') 
end
   disp(' ')   
   disp(coef1)
end

d1_top=[1.000000000000000                   0   0.048107731416794];
d2_top=[1.000000000000000                   0   0.342999823886247];
d3_top=[1.000000000000000                   0   0.660449413422730];
d4_top=[1.000000000000000                   0   0.877258630930767];

d0_bot=[1.000000000000000                   0];
d1_bot=[1.000000000000000                   0   0.175479332448430];
d2_bot=[1.000000000000000                   0   0.512332816787186];
d3_bot=[1.000000000000000                   0   0.780693586946028];
d4_bot=[1.000000000000000                   0   0.959929140336011];


x0=[1 zeros(1,1000)];
ytp1=filter(fliplr(d1_top),d1_top,x0);
ytp2=filter(fliplr(d2_top),d2_top,ytp1);
ytp3=filter(fliplr(d3_top),d3_top,ytp2);
ytp4=filter(fliplr(d4_top),d4_top,ytp3);

ybt0=filter(fliplr(d0_bot),d0_bot,x0);
ybt1=filter(fliplr(d1_bot),d1_bot,ybt0);
ybt2=filter(fliplr(d2_bot),d2_bot,ybt1);
ybt3=filter(fliplr(d3_bot),d3_bot,ybt2);
ybt4=filter(fliplr(d4_bot),d4_bot,ybt3);
h3=(ytp4+ybt4)/2;

figure(201)
subplot(3,1,1)
plot(h3,'b','linewidth',2)
grid on
axis([-1 50 -0.1 0.5])
title('Impulse Response, Tony_des ')
xlabel('Time Index')
ylabel('Amplitude')

fh=fftshift(20*log10(abs(fft(h3,1024))));
fs=88.2;

subplot(3,1,2)
plot([-0.5:1/1024:0.5-1/1024]*fs,fh,'b','linewidth',2)
hold on
plot([-20 -20 +20 +20],[-200 0 0 -200],'--r','linewidth',2) %box 
plot([-30 -24 -24],[-90 -90 -10],'--r','linewidth',2) %left L 
plot([+30 +24 +24],[-90 -90 -20],'--r','linewidth',2) %right L
plot([21 21 -3],[-90 -90 30000],'--r','linewidth',2)
plot([-21 -21 -3],[-90 -90 30000],'--r','linewidth',2)
hold off
grid on
axis([-30 +30 -120 10])
title('Frequency Response')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')

subplot(3,2,5)
plot([-0.5:1/1024:0.5-1/1024]*fs,fh,'b','linewidth',2)
hold on
plot([-20 -20 20 20],[-0.1 -0.00005 -0.00005 -0.1],'--r','linewidth',2) %first box is the length, second is the position, [ | _ _ | ] 
plot([-20 -20 20 20],[+0.1 +0.00005 +0.00005 +0.1],'--r','linewidth',2)
hold off
grid on
axis([-10 +10 -0.0003 0.0003])
title('In-Band Ripple Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')

subplot(3,2,6)
plot([-0.5:1/1024:0.5-1/1024]*fs,fh,'b','linewidth',2)
hold on
plot([-20 -20 +20 +20],[-200 0 0 -200],'--r','linewidth',2) %box 
plot([+30 +24 +24],[-90 -90 -20],'--r','linewidth',2) %right L
hold off
grid on
axis([10 +30 -120 10])
title('Transition BW Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')
