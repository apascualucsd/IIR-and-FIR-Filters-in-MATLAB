fs = 88.2;
f1 = 20;
f2 = 24;
A_dB = 90;
Beta = A_dB/10; %if A_dB < 40 dB have to reduce Beta
N=(fs/(f2-f1))*(A_dB/22); 
M = floor((fs/(f2-f1))*A_dB/22); %For windowed design, A_dB/22
if rem(M,2)==0 %we want N to be an odd integer 
    M=M+1;  
end

MM=(M-1)/2; %Compute end points of array interval, NN
phi=2*pi*(-MM:MM)*(f1+f2)/(2*fs); %compute phase argument of sinc filter
 
h=sin(phi)./phi; %unscaled sinc filter h
h(MM+1)=1; %correct failed 0/0 computation
h0=h.*kaiser(2*MM+1,Beta)'; %Apply window to obtain Stopband Ripple
h1=h0*(f2+f1)/fs; %Scale filter gain f0/fs

figure(201)
subplot(3,1,1)
plot(h1,'b','linewidth',2)
grid on
axis([-1 50 -0.1 0.5])
title('Impulse Response, Kaiser')
xlabel('Time Index')
ylabel('Amplitude')

fh=fftshift(20*log10(abs(fft(h1,1024))));

subplot(3,1,2)
plot([-0.5:1/1024:0.5-1/1024]*fs,fh,'b','linewidth',2)
hold on
plot([-20 -20 +20 +20],[-200 0 0 -200],'--r','linewidth',2) %box 
plot([-30 -25 -25],[-90 -90 -10],'--r','linewidth',2) %left L 
plot([+30 +25 +25],[-90 -90 -20],'--r','linewidth',2) %right L
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
plot([-20 -20 20 20],[-0.1 -0.00025 -0.00025 -0.1],'--r','linewidth',2) %first box is the length, second is the position, [ | _ _ | ] 
plot([-20 -20 20 20],[+0.1 +0.00025 +0.00025 +0.1],'--r','linewidth',2)
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
plot([+30 +25 +25],[-90 -90 -20],'--r','linewidth',2) %right L
hold off
grid on
axis([10 +30 -120 10])
title('Transition BW Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')
