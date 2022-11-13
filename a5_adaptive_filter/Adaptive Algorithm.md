# Adaptive Algorithm

## 1	Information of The System

### 1.1	Signal Definition

$s(n)$ is the original signal, $u_1(n)$ is the received noise, $f(n)$ is the impulse response of an unknown system and its frequency response is $H(z)$

### 1.2	Channel Definition

Reference channel: $u_1(n)$

Primary channel: $u_2(n)=s(n)+u_1(n)*f(n)=s(n)+u_1'(n)$

## 2	Problem to Be Solved

The output of the system is the error $e(n)$:
$$
e(n)=u_2(n)-u_1(n)*h(n)=s(n)+u_1'(n)-y(n)
$$
where $h(n)$ is the impulse response of the FIR adaptive filter.
$$
y(n)=\sum\limits_{k=0}^{M-1}h(k)u_1(n-k)
$$
Adapt the MSE criteria, the objective of the problem is to let $\mathbb{E}\left[e^2(n)\right]=\mathbb{E}\left[s^2(n)\right]$.
$$
\begin{align}
\mathbb{E}\left[e^2(n)\right]&=\mathbb{E}\left[e^2(n)\right] \\
&=\mathbb{E}\left\{\left[s(n)+u_1'(n)-y(n)\right]^2\right\} \\
&=\mathbb{E}\left\{s^2(n)+2s(n)\left[u_1'(n)-y(n)\right]+\left[u_1'(n)-y(n)\right]^2\right\}
\end{align}
$$
Since $s(n)$ and $u_1'(n)$ are uncorrelated, the equations above can be simplified as:
$$
\begin{align}
\mathbb{E}\left[e^2(n)\right]&=\mathbb{E}\left[s^2(n)\right]+\mathbb{E}\left\{\left[u_1'(n)-y(n)\right]^2\right\}
\end{align}
$$
Thus, the objective of the problem is to minimize $\mathbb{E}\left\{\left[u_1'(n)-y(n)\right]^2\right\}$, i.e. $\mathbb{E}\left\{\left[u_1(n)*f(n)-y(n)\right]^2\right\}$. Since $\mathbb{E}\left[s^2(n)\right]>0$, the goal is equal to minimize $\mathbb{E}\left[e^2(n)\right]$. According to the MSE criteria, the recursive expression should be:
$$
h(n+1)=h(n)+\mu e(n)u_1(n)
$$
