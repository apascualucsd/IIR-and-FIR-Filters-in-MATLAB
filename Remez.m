fs = 88.2; 
f1 = 20;
f2 = 24;
r=0.1;
A_dB = -90;
dev = [(10^(r/20)-1)/(10^(r/20)+1) 10^(A_dB/20)]; 
[n_h1, fo_h1, ao_h1, w_h1] = firpmord([f1 f2], [1 0], dev, fs);
h1 = firpm(81, fo_h1, ao_h1, w_h1);

figure(205)
subplot(3,1,1)
plot(h1,'b','linewidth',2)
grid on
axis([-1 50 -0.1 0.5])
title('Impulse Response, FIRPM ')
xlabel('Time Index')
ylabel('Amplitude')

fh=fftshift(20*log10(abs(fft(h1,1024))));

subplot(3,1,2)
plot([-0.5:1/1024:0.5-1/1024]*fs,fh,'b','linewidth',2)
hold on
plot([-20 -20 +20 +20],[-200 0 0 -200],'--r','linewidth',2)  
plot([-30 -24 -24],[-90 -90 -10],'--r','linewidth',2)  
plot([+30 +24 +24],[-90 -90 -20],'--r','linewidth',2) 
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
plot([-20 -20 20 20],[-0.1 -0.05 -0.05 -0.1],'--r','linewidth',2)
plot([-20 -20 20 20],[+0.1 +0.05 +0.05 +0.1],'--r','linewidth',2)
hold off
grid on
axis([-20 +20 -0.05 0.05])
title('In-Band Ripple Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')


subplot(3,2,6)
plot([-0.5:1/1024:0.5-1/1024]*fs,fh,'b','linewidth',2)
hold on
plot([-20 -20 +20 +20],[-200 0 0 -200],'--r','linewidth',2) 
plot([+30 +24 +24],[-90 -90 -20],'--r','linewidth',2) 
hold off
grid on
axis([10 +30 -120 10])
title('Transition BW Detail')
xlabel('Frequency, (kHz)')
ylabel('Log Mag (dB)')
