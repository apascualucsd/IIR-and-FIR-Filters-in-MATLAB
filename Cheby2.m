fs = 88.2;
fc = 24/fs;
fe = 20/fs;
ws = fc*2;
wp = fe*2;
A = 90;
[n, wn] = cheb2ord(wp,ws,0.1, A);
[b1,a1] = cheby2(n,A,wn,"low");
[sos1, g1] = tf2sos(b1,a1);
u = [1 zeros(1,199)];
h2 = sosfilt(sos1, u);
h3 = h2*g1;

figure(200)
subplot(3,1,1)
plot(h3,'b','linewidth',2)
grid on
axis([-1 50 -0.1 0.5])
title('Impulse Response, Cheby2 ')
xlabel('Time Index')
ylabel('Amplitude')

fh=fftshift(20*log10(abs(fft(h3,1024))));

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
