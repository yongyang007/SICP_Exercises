证明$Fib(n)$是最接近$\phi^n/\sqrt{5}$的整数，其中$\phi=(1+\sqrt{5})/2$，
$$$
\begin{equation}
Fib(n)=
\begin{cases}
0, &n=0\\
1, &n=1\\
Fib(n-1)+Fib(n-2)
\end{cases}
\end{equation}
$$$
证明：
设 $\gamma = (1-\sqrt{5})/2$
则
$Fib(0)=(\phi^0-\gamma^0)/\sqrt{5}$
$Fib(1)=(\phi^1-\gamma^1)/\sqrt{5}$
假设 $m\in[0,n-1]$ 时， $Fib(m)=(\phi^m-\gamma^m)/\sqrt{5}$
$$$\begin{split}
Fib(n)&=Fib(n-1)+Fib(n-2)\\
&=[(\phi^{n-1}+\phi^{n-2})-(\gamma^{n-1}+\gamma^{n-2})]/\sqrt{5}
\end{split}\\
\ \\
\begin{split}
\phi^{n-1}+\phi^{n-2}&=\phi^{n-2}\cdot(\phi+1)\\
&=\phi^{n-2}\cdot(3+\sqrt{5})/2\\
&=\phi^{n-2}\cdot(6+2\sqrt{5})/4\\
&=\phi^{n-2}\cdot[(1+\sqrt{5})/2]^2\\
&=\phi^{n-2}\cdot\phi^2\\
&=\phi^n
\end{split}$$$
同理可证 $\gamma^{n-1}+\gamma^{n-2}=\gamma^n$
$\therefore\ Fib(n)=(\phi^n-\gamma^n)/\sqrt{5},\ n\in N$
$Fib(n)$为整数，与它相邻的另两个整数为$(\phi^n-\gamma^n)/\sqrt{5}+1$和 $(\phi^n-\gamma^n)/\sqrt{5}-1$
这三个数与$\phi^n/\sqrt{5}$的差分别为 $\gamma^n/\sqrt{5},\ \gamma^n/\sqrt{5}-1,\ \gamma^n/\sqrt{5}+1$
$\because\ |\gamma|=|(1-\sqrt{5})/2|<1$
$\therefore\ |\gamma^n/\sqrt{5}|$ 单调递减
又 $\because\ |\gamma^0/\sqrt{5}|<0.5$
$\ \ \ \therefore|\gamma^n/\sqrt{5}|<0.5$
则 $|\gamma^n/\sqrt{5}|<|\gamma^n/\sqrt{5}+1|$
且 $|\gamma^n/\sqrt{5}|<|\gamma^n/\sqrt{5}-1|$
$\therefore\ Fib(n)$是最接近$\phi^n/\sqrt{5}$的整数
